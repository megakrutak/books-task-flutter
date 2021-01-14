import 'package:books_app/data/book.dart';
import 'package:books_app/model/favorites/repository/favorites_repo.dart';
import 'package:books_app/ui/book_detail_screen/book_detail_screen.dart';
import 'package:books_app/utils/navigation/INavigationRouter.dart';
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:provider/provider.dart';

import 'book_detail_wm.dart';

class BookDetailScreenRoute extends MaterialPageRoute {
  BookDetailScreenRoute(Book book)
      : assert(book != null),
        super(builder: (context) {
          return BookDetailScreen(widgetModelBuilder: (context) => BookDetailWm(
              context.read<WidgetModelDependencies>(),
              context.read<IFavoritesRepository>(),
              book,
              NavigationRouter.getInstance(context)
              ));
        });
}

class BookDetailScreenArguments {
  BookDetailScreenArguments(this.book);

  final Book book;
}
