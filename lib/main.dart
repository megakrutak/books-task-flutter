import 'package:books_app/model/books/repository/books_api.dart';
import 'package:books_app/model/books/repository/books_repo.dart';
import 'package:books_app/model/database/database_helper.dart';
import 'package:books_app/model/favorites/repository/favorites_repo.dart';
import 'package:books_app/ui/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:mwwm/mwwm.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider(
        create: (context) =>
            WidgetModelDependencies(errorHandler: DefaultErrorHandler()),
      ),
      Provider<IFavoritesRepository>(
        create: (context) =>
            FavoritesRepository(DatabaseHelper.instance),
      ),
      Provider<Dio>(
        create: (context) => Dio(),
      ),
      Provider<IBooksRemoteDataSource>(
        create: (context) => BooksRemoteDataSource(context.read()),
      ),
      Provider<IBooksRepository>(
          create: (context) => BooksRepository(context.read())),
    ],
    child: BooksApp(),
  ));
}

class DefaultErrorHandler implements ErrorHandler {
  @override
  void handleError(Object e) {
    debugPrint(e.toString());
  }
}
