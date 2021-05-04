import 'dart:io';

import 'package:books_app/data/book.dart';
import 'package:books_app/model/favorites/repository/favorites_repo.dart';
import 'package:books_app/ui/app.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_screen.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_wm.dart';
import 'package:books_app/ui/web_screen/web_screen_route.dart';
import 'package:books_app/ui/widgets/book_cover_widget.dart';
import 'package:books_app/utils/navigation/INavigationRouter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mwwm/mwwm.dart';

class _TestHttpOverrides extends HttpOverrides {}

class FakeFavoritesRepository extends Mock implements IFavoritesRepository {}

class MockOnGenerateRoute extends Mock {
  Route<dynamic> call(RouteSettings settings);
}

class FakeNavigationRouter extends Mock implements INavigationRouter {}


void main() {
  WidgetModelDependencies deps;
  Book book;

  group("Book details screen tests", () {
    setUp(() {
      HttpOverrides.global = _TestHttpOverrides();
      deps = WidgetModelDependencies();
      book = Book(
          id: "id1",
          title: "Title1",
          authors: ["author1", "author2"],
          description: "Description1",
          thumbnailLink:
              "http://books.google.com/books/content?id=XLVnCAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
          infoLink:
              "http://books.google.ru/books?id=z60yAAAAIAAJ&dq=%D0%B0%D1%80%D0%B0%D0%BF&hl=&source=gbs_api");
    });

    testWidgets("Load book details test", (WidgetTester tester) async {
      var repo = FakeFavoritesRepository();

      when(repo.getBooks()).thenAnswer((_) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value([]));
      });

      when(repo.contains(any)).thenAnswer((_) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value(false));
      });

      var widget = MaterialApp(
          home: BookDetailScreen(
              widgetModelBuilder: (context) =>
                  BookDetailWm(deps, repo, book, FakeNavigationRouter())));

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text("Book details"), findsOneWidget);
      expect(find.text("Title1"), findsOneWidget);
      expect(find.text("Description1"), findsOneWidget);

      expect(find.byWidgetPredicate((widget) {
        return widget is RichText &&
            widget.text.toPlainText() == "Author: author1, author2";
      }), findsOneWidget);

      expect(find.byWidgetPredicate((widget) {
        return widget is BookCoverWidget &&
            widget.imageLink == book.thumbnailLink;
      }), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets("Add to favorites button test", (WidgetTester tester) async {
      var repo = FakeFavoritesRepository();

      when(repo.getBooks()).thenAnswer((_) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value([]));
      });

      when(repo.contains(any)).thenAnswer((_) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value(false));
      });

      var widget = MaterialApp(
          home: BookDetailScreen(
              widgetModelBuilder: (context) =>
                  BookDetailWm(deps, repo, book, FakeNavigationRouter())));

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      var favButton = find.widgetWithIcon(IconButton, Icons.favorite);
      var favButtonWidget = tester.firstWidget(favButton) as IconButton;

      expect(favButton, findsOneWidget);
      expect(false, (favButtonWidget.icon as Icon).color == Colors.red);

      await tester.tap(favButton);
      await tester.pump();

      var favButtonAfterTap = find.widgetWithIcon(IconButton, Icons.favorite);
      var favButtonWidgetAfterTap = tester.firstWidget(favButton) as IconButton;

      expect(favButtonAfterTap, findsOneWidget);
      expect((favButtonWidgetAfterTap.icon as Icon).color == Colors.red, true);

      verify(repo.contains(book)).called(1);
      verify(repo.addBook(book)).called(1);

      await tester.pumpAndSettle();
    });

    testWidgets("Remove from favorites button test",
        (WidgetTester tester) async {
      var repo = FakeFavoritesRepository();

      when(repo.getBooks()).thenAnswer((_) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value([book]));
      });

      when(repo.contains(book)).thenAnswer((_) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value(true));
      });

      var widget = MaterialApp(
          home: BookDetailScreen(
              widgetModelBuilder: (context) =>
                  BookDetailWm(deps, repo, book, FakeNavigationRouter())));

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      var favButton = find.widgetWithIcon(IconButton, Icons.favorite);
      var favButtonWidget = tester.firstWidget(favButton) as IconButton;

      expect(favButton, findsOneWidget);
      expect(true, (favButtonWidget.icon as Icon).color == Colors.red);

      await tester.tap(favButton);
      await tester.pump();

      var favButtonAfterTap = find.widgetWithIcon(IconButton, Icons.favorite);
      var favButtonWidgetAfterTap = tester.firstWidget(favButton) as IconButton;

      expect(favButtonAfterTap, findsOneWidget);
      expect((favButtonWidgetAfterTap.icon as Icon).color == Colors.red, false);

      verify(repo.contains(book)).called(1);
      verify(repo.removeBook(book)).called(1);

      await tester.pumpAndSettle();
    });

    testWidgets("Tap preview button test", (WidgetTester tester) async {
      var repo = FakeFavoritesRepository();

      when(repo.getBooks()).thenAnswer((_) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value([]));
      });

      when(repo.contains(book)).thenAnswer((_) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value(false));
      });

      var router = MockOnGenerateRoute();
      when(router.call(any))
          .thenReturn(MaterialPageRoute(builder: (_) => Text("webview")));

      var widget = MaterialApp(
          onGenerateRoute: router,
          home: BookDetailScreen(
              widgetModelBuilder: (context) =>
                  BookDetailWm(deps, repo, book, NavigationRouter.getInstance(context))));

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      var previewButton = find.widgetWithIcon(IconButton, Icons.shop);
      expect(previewButton, findsOneWidget);
      await tester.tap(previewButton);
      await tester.pumpAndSettle();

      RouteSettings settings = verify(router.call(captureAny)).captured[0];
      expect(settings.name, RouteConst.webPreviewRoute, );
      expect((settings.arguments as WebScreenArguments).webLink, book.infoLink);
    });
  });
}
