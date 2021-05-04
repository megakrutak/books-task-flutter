import 'dart:io';

import 'package:books_app/data/book.dart';
import 'package:books_app/ui/favorites_screen/favorites_wm.dart';
import 'package:books_app/ui/widgets/book_list_item_widget.dart';
import 'package:flutter/cupertino.dart';
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
        actions: [
          IconButton(
              icon: Icon(Icons.help),
              onPressed: () => _showHelpDialog(context)),
        ],
      ),
      body: EntityStateBuilder<List<Book>>(
        streamedState: wm.favoritesState,
        loadingChild: Center(child: CircularProgressIndicator()),
        child: (_, books) => _buildFavorites(books),
      ),
    );
  }

  Widget _buildFavorites(List<Book> books) {
    if (books.isEmpty) {
      return Center(child: Text("Empty list..."));
    }

    return ListView.separated(
        separatorBuilder: (context, index) => Divider(height: 4),
        itemCount: books.length,
        itemBuilder: (_, index) {
          var book = books[index];
          return Dismissible(
            key: Key(book.id),
            onDismissed: (_) => wm.dismissAction(book),
            background: _buildTrashIcon(Alignment.centerLeft),
            secondaryBackground: _buildTrashIcon(Alignment.centerRight),
            child: BookListItemWidget(
                book: book, onTap: (book) => wm.openBookDetail(book)),
          );
        });
  }

  Widget _buildTrashIcon(AlignmentGeometry alignment) {
    return Container(
        color: Colors.red,
        padding: EdgeInsets.all(16),
        child: Icon(Icons.delete_forever, color: Colors.white, size: 48),
        alignment: alignment);
  }

  _showHelpDialog(BuildContext context) {
    var title = Text("Instruction");
    var content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_right_alt, size: 32),
            Icon(Icons.delete_forever, color: Colors.red, size: 48),
          ],
        ),
        SizedBox(height: 16),
        Text("Use swipe to remove items from favorites"),
      ],
    );
    var actions = [
      TextButton(
          onPressed: () => Navigator.of(context).pop(), child: Text("OK"))
    ];

    showDialog(context: context, builder: (context) {
      return (Platform.isIOS)
          ? CupertinoAlertDialog(title: title, content: content, actions: actions)
          : AlertDialog(title: title, content: content, actions: actions);
    });
  }
}
