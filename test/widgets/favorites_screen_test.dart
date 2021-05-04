import 'package:books_app/utils/navigation/INavigationRouter.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:books_app/data/book.dart';
import 'package:books_app/model/favorites/repository/favorites_repo.dart';
import 'package:books_app/ui/app.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_screen_route.dart';
import 'package:books_app/ui/favorites_screen/favorites_screen.dart';
import 'package:books_app/ui/favorites_screen/favorites_wm.dart';
import 'package:books_app/ui/widgets/book_list_item_widget.dart';
import 'package:flutter/material.dart';
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
  List<Book> favoriteBooks;

  group("Favorites screen test", () {
    setUp(() {
      deps = WidgetModelDependencies();
      HttpOverrides.global = _TestHttpOverrides();
      favoriteBooks = List.of([
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

    testWidgets("Load favorites list test", (WidgetTester tester) async {
      var repo = FakeFavoritesRepository();
      when(repo.getBooks()).thenAnswer((_) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value(favoriteBooks));
      });

      var widget =
          MaterialApp(home: FavoritesScreen(widgetModelBuilder: (context) {
        return FavoritesWm(deps, repo, FakeNavigationRouter());
      }));

      await tester.pumpWidget(widget);

      var progress = find
          .byWidgetPredicate((widget) => widget is CircularProgressIndicator);
      expect(progress, findsOneWidget);
      await tester.pumpAndSettle();
      expect(progress, findsNothing);

      var items =
          find.byWidgetPredicate((widget) => widget is BookListItemWidget);
      expect(items, findsNWidgets(2));
      expect(find.text("Title1"), findsOneWidget);
      expect(find.text("Title2"), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets("Load favorites empty list test", (WidgetTester tester) async {
      var repo = FakeFavoritesRepository();
      when(repo.getBooks()).thenAnswer((realInvocation) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value([]));
      });

      var widget =
          MaterialApp(home: FavoritesScreen(widgetModelBuilder: (context) {
        return FavoritesWm(deps, repo, FakeNavigationRouter());
      }));

      await tester.pumpWidget(widget);

      var progress = find
          .byWidgetPredicate((widget) => widget is CircularProgressIndicator);
      expect(progress, findsOneWidget);
      await tester.pumpAndSettle();
      expect(progress, findsNothing);

      var items =
          find.byWidgetPredicate((widget) => widget is BookListItemWidget);
      expect(items, findsNothing);

      expect(find.text("Empty list..."), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets("Tap help button test", (WidgetTester tester) async {
      var repo = FakeFavoritesRepository();
      when(repo.getBooks()).thenAnswer((_) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value(favoriteBooks));
      });

      var widget =
          MaterialApp(home: FavoritesScreen(widgetModelBuilder: (context) {
        return FavoritesWm(deps, repo, FakeNavigationRouter());
      }));

      await tester.pumpWidget(widget);

      expect(find.text("Favorites"), findsOneWidget);

      await tester.tap(find.byIcon(Icons.help));

      await tester.pumpAndSettle();
      var alertDialog = find.text("Instruction");

      expect(alertDialog, findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, "OK"));

      await tester.pumpAndSettle();
      expect(alertDialog, findsNothing);

      await tester.pumpAndSettle();
    });

    testWidgets("Tap item test", (WidgetTester tester) async {
      var repo = FakeFavoritesRepository();
      when(repo.getBooks()).thenAnswer((_) {
        return Future.delayed(
            Duration(milliseconds: 100), () => Future.value(favoriteBooks));
      });

      var routing = MockOnGenerateRoute();

      when(routing.call(any)).thenReturn(
          MaterialPageRoute(builder: (_) => Center(child: Text("details"))));

      var widget = MaterialApp(
          onGenerateRoute: routing,
          home: FavoritesScreen(widgetModelBuilder: (context) {
            return FavoritesWm(deps, repo, NavigationRouter.getInstance(context));
          }));

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BookListItemWidget, "Title2"));
      await tester.pumpAndSettle();

      RouteSettings routeSettings =
          verify(routing.call(captureAny)).captured[0];
      expect(RouteConst.bookDetailRoute, routeSettings.name);
      expect("Title2",
          (routeSettings.arguments as BookDetailScreenArguments).book.title);

      await tester.pumpAndSettle();
    });
  });
}
