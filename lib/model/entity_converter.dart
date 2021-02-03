import 'package:books_app/data/book.dart';
import 'package:books_app/data/books_list.dart';
import 'package:books_app/model/books/dto/volume_dto.dart';
import 'package:books_app/model/books/dto/volumes_dto.dart';

abstract class IEntityConverter<F, T> {
  T convert(F from);
}

class BookConverter extends IEntityConverter<VolumeDto, Book> {
  @override
  Book convert(VolumeDto from) {
    var imageLinks = from.volumeInfo.imageLinks;

    return Book(
        id: from.id,
        title: from.volumeInfo.title,
        description: from.volumeInfo.description,
        authors: from.volumeInfo.authors,
        infoLink: from.volumeInfo.infoLink,
        thumbnailLink: imageLinks != null ? imageLinks.smallThumbnail : null,
        buyLink: from.saleInfo.buyLink);
  }
}

class BooksConverter extends IEntityConverter<VolumesDto, BooksList> {
  final BookConverter _bookConverter = BookConverter();

  @override
  BooksList convert(VolumesDto from) {
    return BooksList(
        totalItems: from.totalItems,
        items: from.items.map((item) => _bookConverter.convert(item)).toList());
  }
}
