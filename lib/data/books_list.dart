import 'package:equatable/equatable.dart';

import 'book.dart';

class BooksList extends Equatable {
  const BooksList({this.totalItems, this.items});

  final int totalItems;
  final List<Book> items;

  @override
  List<Object> get props => [totalItems, items];

  @override
  String toString() => {
    'totalItems': totalItems,
    'items': items.toString()
  }.toString();


}