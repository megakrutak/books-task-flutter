import 'package:books_app/data/book.dart';
import 'package:books_app/data/books_list.dart';
import 'package:books_app/model/books/repository/books_repo.dart';
import 'package:books_app/ui/app.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_screen_route.dart';
import 'package:books_app/utils/navigation/INavigationRouter.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart' as Widgets;
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

class MainWm extends WidgetModel {
  MainWm(WidgetModelDependencies baseDependencies, this.booksRepo,
      this._navigationRouter, {this.maxResults = 10})
      : super(baseDependencies);

  int _startIndex = 0;
  String _query = "";
  final maxResults;
  BooksList _booksList = BooksList();

  final IBooksRepository booksRepo;
  final booksState = StreamedState<BooksList>(BooksList());
  final loadingProgress = StreamedState<bool>(false);
  final moreLoadingProgress = StreamedState<bool>(false);

  final searchBookAction = Action<String>();
  final openBookDetailAction = Action<Book>();
  final openFavoritesAction = Action();
  final INavigationRouter _navigationRouter;
  final titleState = StreamedState<String>("Books");
  final loadMoreAction = Action();
  final booksScrollController = Widgets.ScrollController();

  @override
  void onBind() {
    super.onBind();

    subscribe(searchBookAction.stream, (String query) => _searchBooks(query));

    subscribe(
        openBookDetailAction.stream, (Book book) => _routeToBookDetail(book));

    subscribe(openFavoritesAction.stream,
        (_) => _navigationRouter.pushNamed(RouteConst.favoritesRoute));

    subscribe(loadMoreAction.stream, (_) => _loadMore());
  }

  Future _searchBooks(String query, {int startIndex = 0}) async {
    _startIndex = startIndex;
    _query = query;

    titleState.accept(query);
    if (_startIndex == 0) {
      loadingProgress.accept(true);
    }
    try {
      var result = await booksRepo.searchBooks(query, maxResults, _startIndex);
      _updateBooksList(result, _startIndex);

      booksState.accept(_booksList);
    } catch (e) {
      print(e);
      handleError(e);
    }

    if (_startIndex == 0) {
      loadingProgress.accept(false);

      if (booksScrollController.hasClients) {
        booksScrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn);
      }
    }
  }

  _routeToBookDetail(Book book) {
    _navigationRouter.pushNamed(RouteConst.bookDetailRoute,
        arguments: BookDetailScreenArguments(book));
  }

  _loadMore() async {
    moreLoadingProgress.accept(true);
    await _searchBooks(_query, startIndex: _startIndex + maxResults);

    if (booksScrollController.hasClients) {
      booksScrollController.animateTo(
          booksScrollController.position.maxScrollExtent + 300,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn);
    }

    moreLoadingProgress.accept(false);
  }

  _updateBooksList(BooksList result, int startIndex) {
    if (startIndex > 0) {
      var totalItems = _booksList.totalItems + result.totalItems;
      var items = _booksList.items;
      items.addAll(result.items);
      _booksList = BooksList(totalItems: totalItems, items: items);
    } else {
      _booksList = result;
    }
  }
}
