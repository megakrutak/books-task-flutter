import 'dart:io';

import 'package:books_app/data/book.dart';
import 'package:books_app/data/books_list.dart';
import 'package:books_app/model/books/repository/books_repo.dart';
import 'package:books_app/model/favorites/repository/favorites_repo.dart';
import 'package:books_app/ui/app.dart';
import 'package:books_app/ui/main_screen/main_screen.dart';
import 'package:books_app/ui/main_screen/main_wm.dart';
import 'package:books_app/ui/widgets/book_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mwwm/mwwm.dart';

void main() {
  WidgetModelDependencies deps;
  MockNavigatorObserver navigatorObserver;

  setUp(() {
    deps = WidgetModelDependencies();
    navigatorObserver = MockNavigatorObserver();
    HttpOverrides.global = _TestHttpOverrides();
  });

  group("Main screen test", () {

    testWidgets("App bar search button test", (WidgetTester tester) async {
      var widget = MaterialApp(home: MainScreen(widgetModelBuilder: (context) {
        return MainWm(deps, FakeBooksRepo(), Navigator.of(context));
      }));

      await tester.pumpWidget(widget);

      expect(find.text("Books"), findsOneWidget);
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      tester.testTextInput.enterText("book to search");
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      var progress = find
          .byWidgetPredicate((widget) => widget is CircularProgressIndicator);
      expect(progress, findsOneWidget);
      await tester.pumpAndSettle();
      expect(progress, findsNothing);

      var books =
          find.byWidgetPredicate((widget) => widget is BookListItemWidget);
      expect(books, findsNWidgets(2));

      expect(find.text("Title1"), findsOneWidget);
      expect(find.text("Title2"), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets("App bar favorites button test", (WidgetTester tester) async {
      var widget = MaterialApp(
          home: MainScreen(widgetModelBuilder: (context) {
            return MainWm(deps, FakeBooksRepo(), Navigator.of(context));
          }),
          navigatorObservers: [navigatorObserver],
          onGenerateRoute: (settings) {
            if (settings.name == RouteConst.favoritesRoute) {
              return MaterialPageRoute(
                  builder: (_) => Center(child: Text("Favorites")));
            }
            return null;
          });

      await tester.pumpWidget(widget);
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();
      var pushRouteCount =
          verify(navigatorObserver.didPush(any, any)).callCount;

      expect(2, pushRouteCount);
      expect(find.text("Favorites"), findsOneWidget);
    });
  });
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class _TestHttpOverrides extends HttpOverrides {}

class FakeBooksRepo extends Mock implements IBooksRepository {
  @override
  Future<BooksList> searchBooks(String query) async {
    var books = BooksList(
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

    return Future.delayed(
        Duration(milliseconds: 100), () => Future.value(books));
  }
}

class FakeFavoritesRepo extends Mock implements IFavoritesRepository {
  @override
  Future<List<Book>> getBooks() {
    return Future.value([]);
  }

  @override
  Future<bool> contains(book) {
    return Future.value(false);
  }

  @override
  Future removeBook(book) {
    return Future.value();
  }

  @override
  Future addBook(Book book) {
    return Future.value();
  }
}
