import 'package:books_app/data/book.dart';
import 'package:books_app/model/favorites/repository/favorites_repo.dart';
import 'package:books_app/ui/app.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_wm.dart';
import 'package:books_app/ui/favorites_screen/favorites_wm.dart';
import 'package:books_app/ui/web_screen/web_screen_route.dart';
import 'package:books_app/utils/navigation/INavigationRouter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mwwm/mwwm.dart';

class FakeNavigationRouter extends Mock implements INavigationRouter {}

class FakeFavoritesRepo extends Mock implements IFavoritesRepository {}

void main() {
  WidgetModelDependencies deps;
  INavigationRouter navRouter;
  Book book;
  IFavoritesRepository favRepo;

  group("BookDetailWm tests", () {
    setUp(() {
      deps = WidgetModelDependencies();
      navRouter = FakeNavigationRouter();
      favRepo = FakeFavoritesRepo();
      book = Book(
          id: "id1",
          title: "Title1",
          authors: ["authors"],
          description: "description",
          thumbnailLink:
              "http://books.google.com/books/content?id=XLVnCAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
          infoLink:
              "http://books.google.ru/books?id=z60yAAAAIAAJ&dq=%D0%B0%D1%80%D0%B0%D0%BF&hl=&source=gbs_api");
    });

    test("on load test", () async {
      when(favRepo.contains(any)).thenAnswer((realInvocation) => Future.delayed(
          Duration(milliseconds: 100), () => Future.value(true)));

      var wm = BookDetailWm(deps, favRepo, book, navRouter);
      wm.onLoad();

      verify(favRepo.contains(book)).called(1);
      expect(wm.bookState.value.data, book);
      expect(wm.bookFavoritesState.stream, emitsInOrder([false, true]));
    });

    test("add to favorites action test", () async {
      when(favRepo.contains(any)).thenAnswer((realInvocation) => Future.delayed(
          Duration(milliseconds: 100), () => Future.value(false)));

      when(favRepo.addBook(any)).thenAnswer((realInvocation) =>
          Future.delayed(Duration(milliseconds: 100), () => Future.value()));

      var wm = BookDetailWm(deps, favRepo, book, navRouter);
      wm.onLoad();
      wm.onBind();

      wm.addToFavoritesAction(book);

      await untilCalled(favRepo.addBook(book));
      verify(favRepo.addBook(book)).called(1);
      expect(wm.bookFavoritesState.stream, emits(true));

      expect(FavoritesWm.favoritesReporter.stream, emits(null));
    });

    test("remove from favorites action test", () async {
      when(favRepo.contains(any)).thenAnswer((realInvocation) => Future.delayed(
          Duration(milliseconds: 100), () => Future.value(true)));

      when(favRepo.removeBook(any)).thenAnswer((realInvocation) =>
          Future.delayed(Duration(milliseconds: 100), () => Future.value()));

      var wm = BookDetailWm(deps, favRepo, book, navRouter);
      wm.onLoad();
      wm.onBind();

      wm.removeFromFavoritesAction(book);

      await untilCalled(favRepo.removeBook(book));
      verify(favRepo.removeBook(book)).called(1);
      expect(wm.bookFavoritesState.stream, emits(false));

      expect(FavoritesWm.favoritesReporter.stream, emits(null));
    });

    test("open web preview screen action test", () async {
      when(favRepo.contains(any)).thenAnswer((realInvocation) => Future.delayed(
          Duration(milliseconds: 100), () => Future.value(false)));

      var wm = BookDetailWm(deps, favRepo, book, navRouter);
      wm.onLoad();
      wm.onBind();

      wm.openWebPreviewAction(book);

      await untilCalled(
          navRouter.pushNamed(any, arguments: anyNamed("arguments")));

      WebScreenArguments args = verify(navRouter.pushNamed(
              RouteConst.webPreviewRoute,
              arguments: captureAnyNamed("arguments")))
          .captured[0];

      expect(args.webLink, book.infoLink);
      expect(args.title, "Title1");
    });
  });
}
