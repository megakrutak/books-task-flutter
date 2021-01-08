import 'package:books_app/model/favorites/repository/favorites_repo.dart';
import 'package:books_app/ui/favorites_screen/favorites_screen.dart';
import 'package:books_app/ui/favorites_screen/favorites_wm.dart';
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:provider/provider.dart';

class FavoritesRoute extends MaterialPageRoute {
  FavoritesRoute()
      : super(
            builder: (context) => FavoritesScreen(
                widgetModelBuilder: (_) => FavoritesWm(
                    context.read<WidgetModelDependencies>(),
                    context.read<IFavoritesRepository>())));
}
