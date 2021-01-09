import 'package:books_app/data/book.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_screen.dart';
import 'package:flutter/material.dart';

class BookDetailScreenRoute extends MaterialPageRoute {
  BookDetailScreenRoute(Book book)
      : assert(book != null),
        super(builder: (context) {
          return BookDetailScreen(book: book);
        });
}

class BookDetailScreenArguments {
  BookDetailScreenArguments(this.book);

  final Book book;
}
