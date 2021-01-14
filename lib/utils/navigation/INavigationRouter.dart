
import 'package:flutter/cupertino.dart';

abstract class INavigationRouter {
  Future<T> pushNamed<T extends Object>(String routeName, {Object arguments});
  Future<T> push<T extends Object>(Route<T> route);
  void pop<T extends Object>([T result]);
  bool canPop();
}

class NavigationRouter implements INavigationRouter {

  static NavigationRouter _instance;

  NavigationRouter._(this._navigator);

  final NavigatorState _navigator;

  @override
  Future<T> pushNamed<T extends Object>(String routeName, {Object arguments}) async {
    return _navigator.pushNamed(routeName, arguments: arguments);
  }

  @override
  void pop<T extends Object>([T result]) {
    return _navigator.pop(result);
  }

  @override
  Future<T> push<T extends Object>(Route<T> route) {
    return _navigator.push(route);
  }

  @override
  bool canPop() {
    return _navigator.canPop();
  }

  static NavigationRouter getInstance(BuildContext context) {
    if (_instance == null) {
      _instance = NavigationRouter._(Navigator.of(context));
    }
    return _instance;
  }

}
