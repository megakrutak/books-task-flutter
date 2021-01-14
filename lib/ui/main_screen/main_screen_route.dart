import 'package:books_app/model/books/repository/books_repo.dart';
import 'package:books_app/ui/main_screen/main_screen.dart';
import 'package:books_app/utils/navigation/INavigationRouter.dart';
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'main_wm.dart';
import 'package:provider/provider.dart';

class MainScreenRoute extends MaterialPageRoute {
  MainScreenRoute()
      : super(
          builder: (context) {
            return MainScreen(
                widgetModelBuilder: (_) => MainWm(
                    context.read<WidgetModelDependencies>(),
                    context.read<IBooksRepository>(),
                    NavigationRouter.getInstance(context)
                    ));
          },
        );
}
