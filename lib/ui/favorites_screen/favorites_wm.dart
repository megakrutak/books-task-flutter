import 'package:books_app/data/book.dart';
import 'package:books_app/model/favorites/repository/favorites_repo.dart';
import 'package:books_app/ui/app.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_screen_route.dart';
import 'package:books_app/utils/navigation/INavigationRouter.dart';
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

class FavoritesWm extends WidgetModel {
  FavoritesWm(WidgetModelDependencies baseDependencies, this.favoritesRepo,
      this._navigationRouter)
      : super(baseDependencies);

  final IFavoritesRepository favoritesRepo;
  final INavigationRouter _navigationRouter;

  final favoritesState = EntityStreamedState<List<Book>>(EntityState.loading());
  final openBookDetail = Action<Book>();
  final dismissAction = Action<Book>();

  static final favoritesReporter = StreamedState<void>();

  @override
  void onLoad() {
    super.onLoad();
    _loadFavorites();
  }

  @override
  void onBind() {
    super.onBind();

    subscribe(
      dismissAction.stream,
      (_) {
        doFuture<void>(_removeFromFavorites(dismissAction.value), (_) {},
            onError: handleError);
      },
    );

    subscribe(openBookDetail.stream, (Book book) => _routeToDetail(book));

    //reload favorites list on value updated
    subscribe(favoritesReporter.stream, (t) => _loadFavorites());
  }

  Future _loadFavorites() async {
    favoritesState.loading();

    try {
      var books = await favoritesRepo.getBooks();
      favoritesState.content(books);
    } catch (e) {
      handleError(e);
      favoritesState.error(e);
    }
  }

  Future _removeFromFavorites(Book book) async {
    try {
      await favoritesRepo.removeBook(book);
      var books = await favoritesRepo.getBooks();
      if (books.isEmpty) {
        favoritesState.content([]);
      }
    } catch (e) {
      handleError(e);
    }
  }

  _routeToDetail(Book book) {
    _navigationRouter.pushNamed(RouteConst.bookDetailRoute,
        arguments: BookDetailScreenArguments(book));
  }
}
