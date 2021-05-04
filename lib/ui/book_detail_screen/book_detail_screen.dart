import 'package:books_app/data/book.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_wm.dart';
import 'package:books_app/ui/widgets/book_cover_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

class BookDetailScreen extends CoreMwwmWidget {
  BookDetailScreen({@required WidgetModelBuilder widgetModelBuilder})
      : assert(widgetModelBuilder != null),
        super(widgetModelBuilder: widgetModelBuilder);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends WidgetState<BookDetailWm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Book details"),
          backgroundColor: Colors.deepPurpleAccent),
      body: EntityStateBuilder(
        streamedState: wm.bookState,
        child: (context, book) => _buildBody(context, book),
      ),
    );
  }

  Widget _buildBookCover(Book book) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
            tag: book.id,
            child: BookCoverWidget(
                width: 150, height: 200, imageLink: book.thumbnailLink)),
      ],
    );
  }

  Widget _buildButtonsBar(BuildContext context, Book book) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      IconButton(
          iconSize: 32,
          icon: Icon(
            Icons.shop,
            color: Colors.green,
          ),
          onPressed: () {
            if (book.infoLink != null) {
              wm.openWebPreviewAction(book);
            }
          }),
      SizedBox(width: 8),
      StreamedStateBuilder(
          streamedState: wm.bookFavoritesState,
          builder: (context, isFavorite) =>
              _buildFavoriteButton(context, book, isFavorite)),
    ]);
  }

  Widget _buildBody(BuildContext context, Book book) {
    var theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            _buildBookCover(book),
            SizedBox(height: 32),
            _buildButtonsBar(context, book),
            SizedBox(height: 8),
            Center(child: Text(book.title ?? "", style: theme.textTheme.headline5)),
            SizedBox(height: 16),
            RichText(
                text: TextSpan(
                    text: "Author: ",
                    style: theme.textTheme.bodyText1
                        .copyWith(color: Colors.grey.shade700),
                    children: [
                  TextSpan(
                      text: book.authors.join(", "),
                      style: theme.textTheme.bodyText1
                          .copyWith(fontWeight: FontWeight.bold))
                ])),
            SizedBox(height: 16),
            Text(book.description ?? "",
                style: theme.textTheme.bodyText1, textAlign: TextAlign.justify)
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(
      BuildContext context, Book book, bool isFavorite) {
    var iconSize = 32.0;
    var icon = Icons.favorite;

    if (isFavorite) {
      return IconButton(
          iconSize: iconSize,
          icon: Icon(icon, color: Colors.red),
          onPressed: () => wm.removeFromFavoritesAction(book));
    }

    return IconButton(
        iconSize: iconSize,
        icon: Icon(icon, color: Colors.grey),
        onPressed: () => wm.addToFavoritesAction(book));
  }
}
