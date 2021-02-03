import 'package:books_app/data/book.dart';
import 'package:books_app/data/books_list.dart';
import 'package:books_app/model/books/repository/books_api.dart';
import 'package:books_app/model/entity_converter.dart';

abstract class IBooksRepository {
  Future<BooksList> searchBooks(String query, int maxResults, int startIndex);
}

class BooksRepository implements IBooksRepository {

  BooksRepository(this.remoteDataSource);

  final IBooksRemoteDataSource remoteDataSource;

  @override
  Future<BooksList> searchBooks(String query, int maxResults, int startIndex) async {
    var volumes = await remoteDataSource.searchVolumes(query, maxResults, startIndex);
    return BooksConverter().convert(volumes);
  }
}


class FakeBooksRepository implements IBooksRepository {
  @override
  Future<BooksList> searchBooks(String query, int maxResults, int startIndex) async {
    if (query.isEmpty) {
      return Future.delayed(
          Duration(seconds: 2), () => BooksList(totalItems: 0, items: []));
    }

    List<Book> books = [0, 1, 2, 3, 4, 5]
        .map((index) => Book(
            id: index.toString(),
            title: "Title $index",
            authors: ["Author1", "Author2"],
            description: "dfgdf",
            infoLink: "http://books.google.ru/books?id=z60yAAAAIAAJ&dq=%D0%B0%D1%80%D0%B0%D0%BF&hl=&source=gbs_api",
            thumbnailLink:
                "http://books.google.com/books/content?id=XLVnCAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"))
        .toList();

    var booksList = BooksList(totalItems: 10, items: books);

    return Future.delayed(Duration(seconds: 2), () => booksList);
  }
}
