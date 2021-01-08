import 'package:books_app/data/book.dart';
import 'package:books_app/ui/favorites_screen/favorites_wm.dart';
import 'package:books_app/ui/widgets/book_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

class FavoritesScreen extends CoreMwwmWidget {
  FavoritesScreen({
    @required WidgetModelBuilder widgetModelBuilder,
  })  : assert(widgetModelBuilder != null),
        super(widgetModelBuilder: widgetModelBuilder);

  @override
  State<StatefulWidget> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends WidgetState<FavoritesWm> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: EntityStateBuilder<List<Book>>(
        streamedState: wm.favoritesState,
        loadingChild: Center(child: CircularProgressIndicator()),
        child: (_, books) => _buildFavorites(books),
      ),
    );
  }

  Widget _buildFavorites(List<Book> books) {
    if (books.isEmpty)
      return Center(child: Text("Empty list..."));

    return ListView.separated(
        separatorBuilder: (context, index) => Divider(height: 4),
        itemCount: books.length,
        itemBuilder: (_, index) {
          var book = books[index];
          return Dismissible(
            key: Key(book.id),
            onDismissed: (_) {
              print("dismissed $index");
            },
            background: Container(color: Colors.red),
            child: BookListItemWidget(book: book),
          );
        });
  }
}
