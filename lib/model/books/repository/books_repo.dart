import 'package:books_app/data/book.dart';
import 'package:books_app/data/books_list.dart';

abstract class IBooksRepository {
  Future<BooksList> searchBooks(String query);
}

class FakeBooksRepository implements IBooksRepository {
  @override
  Future<BooksList> searchBooks(String query) async {
    List<Book> books = [0, 1, 2, 3, 4, 5]
        .map((index) => Book(
            id: index.toString(),
            title: "Title $index",
            authors: ["Author1", "Author2"],
            description: "Description",
            thumbnailLink:
                "http://books.google.com/books/content?id=XLVnCAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"))
        .toList();

    var booksList = BooksList(totalItems: 10, items: books);

    return Future.delayed(Duration(seconds: 3), () => booksList);
  }
}
