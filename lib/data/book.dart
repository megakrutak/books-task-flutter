import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Book extends Equatable {
  const Book(
      {@required this.id,
      @required this.title,
      this.description,
      @required this.authors,
      @required this.thumbnailLink,
      @required this.infoLink,
      this.buyLink});

  final String id;
  final String title;
  final String description;
  final List<String> authors;
  final String thumbnailLink;
  final String infoLink;
  final String buyLink;

  @override
  String toString() => {
    'id': id,
    'title': title,
    'description': description,
    'authors': authors.toString(),
    'thumbnailLink': thumbnailLink.toString(),
    'infoLink': infoLink.toString(),
    'buyLink': buyLink.toString()
  }.toString();

  @override
  List<Object> get props => [id, title, description, authors, thumbnailLink, infoLink, buyLink];
}
