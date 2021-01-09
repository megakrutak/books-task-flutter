import 'package:books_app/ui/web_screen/web_screen.dart';
import 'package:flutter/material.dart';

class WebScreenRoute extends MaterialPageRoute {
  WebScreenRoute(String webLink, String title)
      : super(
          fullscreenDialog: true,
          builder: (context) {
            return WebScreen(webLink: webLink, title: title);
          },
        );
}

class WebScreenArguments {
  WebScreenArguments(this.webLink, this.title);
  final String webLink;
  final String title;
}
