import 'package:books_app/data/book.dart';
import 'package:books_app/model/favorites/repository/favorites_repo.dart';
import 'package:books_app/ui/app.dart';
import 'package:books_app/ui/favorites_screen/favorites_wm.dart';
import 'package:books_app/ui/web_screen/web_screen_route.dart';
import 'package:flutter/widgets.dart' as Widgets;
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

class BookDetailWm extends WidgetModel {
  BookDetailWm(WidgetModelDependencies baseDependencies, this.favoritesRepo,
      this._book, this.navigator)
      : super(baseDependencies);

  final Book _book;
  final Widgets.NavigatorState navigator;
  final IFavoritesRepository favoritesRepo;

  final bookState = EntityStreamedState<Book>(EntityState.content());
  final bookFavoritesState = StreamedState<bool>(false);
  final addToFavoritesAction = Action<Book>();
  final removeFromFavoritesAction = Action<Book>();
  final openWebPreviewAction = Action<Book>();

  @override
  void onLoad() {
    super.onLoad();
    bookState.content(_book);
    _checkBookInFavorites(_book);
  }

  @override
  void onBind() {
    super.onBind();

    subscribe(
        openWebPreviewAction.stream, (Book book) => _routeToWebView(book));

    subscribe(
        addToFavoritesAction.stream, (Book book) => _addToFavorites(book));

    subscribe(removeFromFavoritesAction.stream,
        (Book book) => _removeFromFavorites(book));
  }

  _routeToWebView(Book book) {
    var webLink = book.buyLink ?? book.infoLink;
    var title = book.title ?? webLink;

    navigator.pushNamed(RouteConst.webPreviewRoute,
        arguments: WebScreenArguments(webLink, title));
  }

  _addToFavorites(Book book) async {
    bookFavoritesState.accept(true);
    try {
      await favoritesRepo.addBook(book);
      FavoritesWm.favoritesReporter.accept();
    } catch (e) {
      handleError(e);
    }
  }

  _removeFromFavorites(Book book) async {
    bookFavoritesState.accept(false);
    try {
      await favoritesRepo.removeBook(book);
      FavoritesWm.favoritesReporter.accept();
    } catch (e) {
      handleError(e);
    }
  }

  _checkBookInFavorites(Book book) async {
    var isFavorite = await favoritesRepo.contains(book);
    bookFavoritesState.accept(isFavorite);
  }
}
