import 'dart:io';

import 'package:books_app/ui/web_screen/web_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';

class _TestHttpOverrides extends HttpOverrides {}

void main() {
  group("Book details screen tests", () {
    setUp(() {
      HttpOverrides.global = _TestHttpOverrides();
    });

    testWidgets("Load web link with title test", (WidgetTester tester) async {
      var link = "https://my.site";

      var widget = MaterialApp(
          home: WebScreen(
        webLink: link,
        title: "Title1",
      ));
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text("Title1"), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is WebView && widget.initialUrl == link),
          findsOneWidget);
    });

    testWidgets("Load web link with empty title test", (WidgetTester tester) async {
      var link = "https://my.site";

      var widget = MaterialApp(
          home: WebScreen(
            webLink: link,
          ));
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text(link), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is WebView && widget.initialUrl == link),
          findsOneWidget);
    });
  });
}


