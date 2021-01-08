import 'package:books_app/data/book.dart';
import 'package:books_app/ui/web_screen/web_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BookDetailScreen extends StatelessWidget {
  BookDetailScreen({@required this.book, Key key})
      : assert(book != null),
        super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
          title: Text("Book details"),
          backgroundColor: Colors.deepPurpleAccent),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 32),
              _buildBookCover(),
              SizedBox(height: 32),
              _buildButtonsBar(context),
              SizedBox(height: 8),
              Text(book.title, style: theme.textTheme.headline5),
              SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text("Author: ",
                    style: theme.textTheme.bodyText1
                        .copyWith(color: Colors.grey.shade700)),
                Text(book.authors.join(", "),
                    style: theme.textTheme.bodyText1
                        .copyWith(fontWeight: FontWeight.bold)),
              ]),
              SizedBox(height: 16),
              Text(book.description,
                  style: theme.textTheme.bodyText1,
                  textAlign: TextAlign.justify)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookCover() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: book.id,
          child: Container(
              height: 200,
              width: 150,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(book.thumbnailLink),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade600, blurRadius: 32)
                  ])),
        ),
      ],
    );
  }

  Widget _buildButtonsBar(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      IconButton(
          iconSize: 32,
          icon: Icon(
            Icons.shop,
            color: Colors.green,
          ),
          onPressed: () {
            if (book.infoLink != null) {
              Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => WebScreen(
                      webLink: book.buyLink ?? book.infoLink,
                      title: book.title)));
            }
          }),
      SizedBox(width: 8),
      IconButton(
          iconSize: 32,
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          onPressed: () {})
    ]);
  }
}
