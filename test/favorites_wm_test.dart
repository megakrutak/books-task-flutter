import 'package:books_app/data/book.dart';
import 'package:books_app/model/favorites/repository/favorites_repo.dart';
import 'package:books_app/ui/app.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_screen_route.dart';
import 'package:books_app/ui/favorites_screen/favorites_wm.dart';
import 'package:books_app/utils/navigation/INavigationRouter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mwwm/mwwm.dart';

class FakeNavigationRouter extends Mock implements INavigationRouter {}

class FakeFavoritesRepo extends Mock implements IFavoritesRepository {}

void main() {
  WidgetModelDependencies deps;
  INavigationRouter navRouter;
  IFavoritesRepository favRepo;
  List<Book> books;

  group("FavoritesWm tests", () {
    setUp(() {
      deps = WidgetModelDependencies();
      navRouter = FakeNavigationRouter();
      favRepo = FakeFavoritesRepo();
      books = List.of([
        Book(
            id: "id1",
            title: "Title1",
            authors: ["authors"],
            description: "description",
            thumbnailLink:
            "http://books.google.com/books/content?id=XLVnCAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
            infoLink:
            "http://books.google.ru/books?id=z60yAAAAIAAJ&dq=%D0%B0%D1%80%D0%B0%D0%BF&hl=&source=gbs_api"),
        Book(
            id: "id2",
            title: "Title2",
            authors: ["author1", "author2"],
            thumbnailLink:
            "http://books.google.com/books/content?id=XLVnCAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
            infoLink:
            "http://books.google.ru/books?id=z60yAAAAIAAJ&dq=%D0%B0%D1%80%D0%B0%D0%BF&hl=&source=gbs_api")
      ]);
    });

    test("on load test", () async {
      when(favRepo.getBooks()).thenAnswer((realInvocation) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value(books));
      });

      var wm = FavoritesWm(deps, favRepo, navRouter);
      wm.onLoad();

      await untilCalled(favRepo.getBooks());
      verify(favRepo.getBooks()).called(1);

      //TODO: test wm.favoritesState.stream emits favorites
    });

    test("dismiss action test", () async {
      when(favRepo.getBooks()).thenAnswer((realInvocation) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value(books));
      });

      when(favRepo.removeBook(any)).thenAnswer((realInvocation) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value());
      });

      var wm = FavoritesWm(deps, favRepo, navRouter);
      wm.onLoad();
      wm.onBind();

      wm.dismissAction(books[0]);

      await untilCalled(favRepo.removeBook(any));
      verify(favRepo.removeBook(books[0])).called(1);
    });

    test("open book detail action test", () async {
      when(favRepo.getBooks()).thenAnswer((realInvocation) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value(books));
      });

      var wm = FavoritesWm(deps, favRepo, navRouter);
      wm.onLoad();
      wm.onBind();

      wm.openBookDetail(books[0]);

      await untilCalled(
          navRouter.pushNamed(any, arguments: anyNamed("arguments")));

      BookDetailScreenArguments args = verify(
          navRouter.pushNamed(RouteConst.bookDetailRoute,
              arguments: captureAnyNamed("arguments")))
          .captured[0];

      expect(args.book, books[0]);
    });
  });
}
