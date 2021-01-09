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
    return EntityStateBuilder(
        streamedState: wm.booksState,
        loadingChild: Center(child: CircularProgressIndicator()),
        child: (context, booksList) => _buildBooksList(booksList));
  }

  Widget _buildBooksList(BooksList booksList) {
    if (booksList.totalItems == null) {
      return _buildInitialContainer("");
    }

    if (booksList.totalItems == 0 || booksList.items.isEmpty) {
      return _buildInitialContainer("No books found");
    }

    return ListView.separated(
        separatorBuilder: (context, index) => Divider(height: 4),
        itemCount: booksList.items.length,
        itemBuilder: (_, index) {
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
}
