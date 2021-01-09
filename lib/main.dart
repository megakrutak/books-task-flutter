import 'package:books_app/model/books/repository/books_repo.dart';
import 'package:books_app/model/favorites/repository/favorites_repo.dart';
import 'package:books_app/ui/app.dart';
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
        create: (context) => FakeFavoritesRepository(),
      ),
      Provider<IBooksRepository>(create: (context) => FakeBooksRepository())
    ],
    child: MyApp(),
  ));
}

class DefaultErrorHandler implements ErrorHandler {
  @override
  void handleError(Object e) {
    debugPrint(e.toString());
  }
}
