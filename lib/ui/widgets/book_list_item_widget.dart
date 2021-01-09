import 'package:books_app/data/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BookListItemWidget extends StatelessWidget {
  BookListItemWidget({@required this.book, @required this.onTap, Key key})
      : assert(book != null && onTap != null),
        super(key: key);

  final Book book;
  final Function(Book book) onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var imageWidth = 75.0;

    return InkWell(
      onTap: () => onTap(book),
      child: Row(
        children: [
          Hero(
            tag: book.id,
            child: Container(
              height: 100,
              width: imageWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: NetworkImage(book.thumbnailLink),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            width: screenWidth - imageWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headline6.copyWith(fontSize: 18)),
                SizedBox(height: 10),
                Text(book.authors.join(", "), style: theme.textTheme.bodyText2)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
