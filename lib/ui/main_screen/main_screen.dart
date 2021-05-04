import 'package:books_app/data/books_list.dart';
import 'package:books_app/ui/widgets/book_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

import 'main_wm.dart';

class MainScreen extends CoreMwwmWidget {
  MainScreen({
    @required WidgetModelBuilder widgetModelBuilder,
  })  : assert(widgetModelBuilder != null),
        super(widgetModelBuilder: widgetModelBuilder);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends WidgetState<MainWm> {
  SearchBar searchBar;

  _MainScreenState() {
    searchBar = _buildSearchBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: searchBar.build(context), body: _buildBody());
  }

  SearchBar _buildSearchBar() {
    return SearchBar(
        inBar: false,
        buildDefaultAppBar: _buildAppBar,
        setState: setState,
        onSubmitted: (query) {
          wm.searchBookAction(query);
        },
        clearOnSubmit: false,
        onCleared: () {},
        onClosed: () {});
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: StreamedStateBuilder(
          streamedState: wm.titleState,
          builder: (context, title) => Text(title)),
      backgroundColor: Colors.deepPurpleAccent,
      actions: [
        searchBar.getSearchAction(context),
        IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => wm.openFavoritesAction()),
        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        StreamedStateBuilder(
            streamedState: wm.booksState,
            builder: (_, booksList) => _buildBooksList(booksList)),
        _buildProgress(),
      ],
    );
  }

  Widget _buildBooksList(BooksList booksList) {
    if (booksList.totalItems == null) {
      return _buildInitialContainer("");
    }

    if (booksList.totalItems == 0 || booksList.items.isEmpty) {
      return _buildInitialContainer("No books found");
    }
    var booksCount = booksList.items.length;
    var showMoreItem = (booksList.totalItems > booksCount);

    return ListView.separated(
        controller: wm.booksScrollController,
        separatorBuilder: (context, index) => Divider(height: 4),
        itemCount: showMoreItem ? booksCount + 1 : booksCount,
        itemBuilder: (_, index) {
          if (index == booksList.items.length) {
            return _buildMoreButton();
          }
          var book = booksList.items[index];
          return BookListItemWidget(
              book: book, onTap: (book) => wm.openBookDetailAction(book));
        });
  }

  Widget _buildInitialContainer(String text) {
    var textStyle =
        Theme.of(context).textTheme.headline6.copyWith(color: Colors.grey);

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 20),
          child: Align(
              child: Text(text, style: textStyle),
              alignment: Alignment.topCenter),
        ),
        Container(
          alignment: Alignment.center,
          child: Icon(Icons.menu_book, color: Colors.grey.shade300, size: 200),
        )
      ],
    );
  }

  Widget _buildMoreButton() {
    return Container(
        height: 50,
        child: StreamedStateBuilder(
            streamedState: wm.moreLoadingProgress,
            builder: (_, progress) {
              if (progress) {
                return Center(
                    child: Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)));
              }

              return TextButton(
                  child: Text("SHOW MORE...",
                      style: TextStyle(color: Colors.deepPurpleAccent)),
                  onPressed: () {
                    wm.loadMoreAction();
                  });
            }));
  }

  Widget _buildProgress() {
    return StreamedStateBuilder(
        streamedState: wm.loadingProgress,
        builder: (_, progress) {
          if (progress) {
            return Opacity(
                opacity: 0.8,
                child: Container(
                    color: Colors.white,
                    child: Center(child: CircularProgressIndicator())));
          }
          return Container();
        });
  }
}
