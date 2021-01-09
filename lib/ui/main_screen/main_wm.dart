import 'package:books_app/data/book.dart';
import 'package:books_app/data/books_list.dart';
import 'package:books_app/model/books/repository/books_repo.dart';
import 'package:books_app/ui/app.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_screen_route.dart';
import 'package:flutter/widgets.dart' as Widgets;
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

class MainWm extends WidgetModel {
  MainWm(
      WidgetModelDependencies baseDependencies, this.booksRepo, this.navigator)
      : super(baseDependencies);

  final IBooksRepository booksRepo;
  final booksState =
      EntityStreamedState<BooksList>(EntityState.content(BooksList()));
  final searchBookAction = Action<String>();
  final openBookDetailAction = Action<Book>();
  final openFavoritesAction = Action();
  final Widgets.NavigatorState navigator;
  final titleState = StreamedState<String>("Books");

  @override
  void onBind() {
    super.onBind();

    subscribe(searchBookAction.stream, (String query) => _searchBooks(query));

    subscribe(
        openBookDetailAction.stream, (Book book) => _routeToBookDetail(book));

    subscribe(openFavoritesAction.stream,
        (_) => navigator.pushNamed(RouteConst.favoritesRoute));
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
    navigator.pushNamed(RouteConst.bookDetailRoute,
        arguments: BookDetailScreenArguments(book));
  }
}
