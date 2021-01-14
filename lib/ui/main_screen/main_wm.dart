import 'package:books_app/data/book.dart';
import 'package:books_app/data/books_list.dart';
import 'package:books_app/model/books/repository/books_repo.dart';
import 'package:books_app/ui/app.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_screen_route.dart';
import 'package:books_app/utils/navigation/INavigationRouter.dart';
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

class MainWm extends WidgetModel {
  MainWm(WidgetModelDependencies baseDependencies, this.booksRepo,
      this._navigationRouter)
      : super(baseDependencies);

  final IBooksRepository booksRepo;
  final booksState =
      EntityStreamedState<BooksList>(EntityState.content(BooksList()));
  final searchBookAction = Action<String>();
  final openBookDetailAction = Action<Book>();
  final openFavoritesAction = Action();
  final INavigationRouter _navigationRouter;
  final titleState = StreamedState<String>("Books");

  @override
  void onBind() {
    super.onBind();

    subscribe(searchBookAction.stream, (String query) => _searchBooks(query));

    subscribe(
        openBookDetailAction.stream, (Book book) => _routeToBookDetail(book));

    subscribe(openFavoritesAction.stream,
        (_) => _navigationRouter.pushNamed(RouteConst.favoritesRoute));
  }

  Future _searchBooks(String query) async {
    titleState.accept(query);
    booksState.loading();
    try {
      var booksList = await booksRepo.searchBooks(query);
      booksState.content(booksList);
    } catch (e) {
      handleError(e);
      booksState.error(e);
    }
  }

  _routeToBookDetail(Book book) {
    _navigationRouter.pushNamed(RouteConst.bookDetailRoute,
        arguments: BookDetailScreenArguments(book));
  }
}
