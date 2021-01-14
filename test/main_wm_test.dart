import 'package:books_app/data/book.dart';
import 'package:books_app/data/books_list.dart';
import 'package:books_app/model/books/repository/books_repo.dart';
import 'package:books_app/ui/app.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_screen_route.dart';
import 'package:books_app/ui/main_screen/main_wm.dart';
import 'package:books_app/utils/navigation/INavigationRouter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mwwm/mwwm.dart';

class FakeBooksRepo extends Mock implements IBooksRepository {}

class FakeNavigationRouter extends Mock implements INavigationRouter {}

void main() {
  WidgetModelDependencies deps;
  BooksList books;
  INavigationRouter navigationRouter;

  group("MainWm tests", () {
    setUp(() {
      navigationRouter = FakeNavigationRouter();
      deps = WidgetModelDependencies();
      books = BooksList(
          totalItems: 20,
          items: List.of([
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
          ]));
    });

    test("search book action test", () async {
      var repo = FakeBooksRepo();
      when(repo.searchBooks(any)).thenAnswer((realInvocation) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value(books));
      });
      var wm = MainWm(deps, repo, navigationRouter);
      wm.onBind();

      wm.searchBookAction("query");

      await untilCalled(repo.searchBooks(any));
      verify(repo.searchBooks("query")).called(1);
    });

    test("open book detail action test", () async {
      var repo = FakeBooksRepo();
      when(repo.searchBooks(any)).thenAnswer((realInvocation) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value(books));
      });
      var wm = MainWm(deps, repo, navigationRouter);
      wm.onBind();

      wm.openBookDetailAction(books.items[0]);

      await untilCalled(
          navigationRouter.pushNamed(any, arguments: anyNamed("arguments")));

      BookDetailScreenArguments args = verify(navigationRouter.pushNamed(
              RouteConst.bookDetailRoute,
              arguments: captureAnyNamed("arguments")))
          .captured[0];

      expect(args.book, books.items[0]);
    });

    test("open book detail action test", () async {
      var repo = FakeBooksRepo();
      when(repo.searchBooks(any)).thenAnswer((realInvocation) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value(books));
      });
      var wm = MainWm(deps, repo, navigationRouter);
      wm.onBind();

      wm.openFavoritesAction();

      await untilCalled(
          navigationRouter.pushNamed(any));

      verify(navigationRouter.pushNamed(RouteConst.favoritesRoute)).called(1);
    });

  });
}
