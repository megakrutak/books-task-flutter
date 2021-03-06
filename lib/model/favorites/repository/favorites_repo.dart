import 'package:books_app/data/book.dart';
import 'package:books_app/model/database/database_helper.dart';

abstract class IFavoritesRepository {
  Future<List<Book>> getBooks();
  Future addBook(Book book);
  Future removeBook(Book book);
  Future<bool> contains(Book book);
}

class FavoritesRepository implements IFavoritesRepository {
  final DatabaseHelper _dbHelper;

  FavoritesRepository(this._dbHelper);

  @override
  Future addBook(Book book) async {
    return _dbHelper.insert(book.toMap());
  }

  @override
  Future<bool> contains(Book book) async {
    return _dbHelper.contains(book.id);
  }

  @override
  Future<List<Book>> getBooks() async {
    var result = await _dbHelper.queryAllRows();
    return result
        .map((e) => Book(
            id: e[DatabaseHelper.columnId],
            title: e[DatabaseHelper.columnTitle],
            description: e[DatabaseHelper.columnDescription],
            authors: e[DatabaseHelper.columnAuthors].toString().split(", "),
            thumbnailLink: e[DatabaseHelper.columnThumbnailLink],
            infoLink: e[DatabaseHelper.columnInfoLink],
            buyLink: e[DatabaseHelper.columnBuyLink]))
        .toList();
  }

  @override
  Future removeBook(Book book) async {
    return await _dbHelper.delete(book.id);
  }
}

class FakeFavoritesRepository implements IFavoritesRepository {
  Set<Book> books = Set.of([
    Book(
        id: "b1231",
        title: "ZENONIA GUİDES 4 v1.1.6 + Mod (a lot of money) for Android",
        authors: ["Hector Smith", "Author2"],
        description:
            "Now also available in German! The ultimate action RPG has returned, now in stunning HD! If the forces of evil shake the world, the heroes of the time have to leave the fate of the world again on the right track. Come together with Regret, Chael, ECNE, Lu, and many others, the greatest ZENONIA adventure yet! ───────────────────── The best looking ZENONIA® ALLERZEITEN Explore the world in HD, now with spectacular graphics and fantastic animations optimized for high quality displays. DYNAMIC AND FIGHT visceral and become a great fighter – unleash your combo hits and devastating skills with explosive graphics, incredible and enchanting animations. EQUIPPED YOU AND YOU INDIVIDUALLY FOR THE ADVENTURE Skille Skille and upgrade your warrior, rogue, hunter or druid with countless armor, weapons and items.",
        thumbnailLink:
            "http://books.google.com/books/content?id=XLVnCAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
        infoLink:
            "https://play.google.com/store/books/details?id=aqpJDwAAQBAJ&rdid=book-aqpJDwAAQBAJ&rdot=1&source=gbs_api")
  ]);

  @override
  Future addBook(Book book) async {
    return Future.delayed(Duration(seconds: 1), () {
      books.add(book);
    });
  }

  @override
  Future<List<Book>> getBooks() async {
    return Future.delayed(Duration(seconds: 1), () => books.toList());
  }

  @override
  Future removeBook(book) async {
    return Future.delayed(Duration(seconds: 1), () {
      books.removeWhere((element) => element.id == book.id);
    });
  }

  @override
  Future<bool> contains(book) {
    return Future.delayed(
        Duration(milliseconds: 200), () => books.contains(book));
  }
}
