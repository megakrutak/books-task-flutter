import 'package:books_app/data/book.dart';
import 'package:books_app/model/favorites/repository/favorites_repo.dart';
import 'package:books_app/ui/app.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_screen_route.dart';
import 'package:flutter/widgets.dart' as Widgets;
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

class FavoritesWm extends WidgetModel {
  FavoritesWm(WidgetModelDependencies baseDependencies, this.favoritesRepo,
      this.navigator)
      : super(baseDependencies);

  final IFavoritesRepository favoritesRepo;
  final Widgets.NavigatorState navigator;

  final favoritesState = EntityStreamedState<List<Book>>(EntityState.loading());
  final openBookDetail = Action<Book>();
  final dismissAction = Action<Book>();

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
    navigator.pushNamed(RouteConst.bookDetailRoute,
        arguments: BookDetailScreenArguments(book));
  }
}
