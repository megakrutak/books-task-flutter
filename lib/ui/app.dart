import 'package:books_app/ui/book_detail_screen/book_detail_screen_route.dart';
import 'package:books_app/ui/main_screen/main_screen_route.dart';
import 'package:books_app/ui/web_screen/web_screen_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'favorites_screen/favorites_screen_route.dart';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RouteConst.initialRoute:
            return MainScreenRoute();
          case RouteConst.favoritesRoute:
            return FavoritesScreenRoute();
          case RouteConst.bookDetailRoute:
            BookDetailScreenArguments args = settings.arguments;
            return BookDetailScreenRoute(args.book);
          case RouteConst.webPreviewRoute:
            WebScreenArguments args = settings.arguments;
            return WebScreenRoute(args.webLink, args.title);
          default:
            return MainScreenRoute();
        }
      },
    );
  }
}

class RouteConst {
  static const initialRoute = "/";
  static const favoritesRoute = "/favorites";
  static const bookDetailRoute = "/bookDetail";
  static const webPreviewRoute = "/webPreview";
}