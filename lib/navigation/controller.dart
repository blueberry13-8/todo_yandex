import 'package:flutter/cupertino.dart';

class NavigationController {
  static final NavigationController _controller =
      NavigationController._internal();

  factory NavigationController() {
    return _controller;
  }

  NavigationController._internal();

  final GlobalKey<NavigatorState> _key = GlobalKey();

  GlobalKey<NavigatorState> get key => _key;

  Future? pushNamed(String page, {Object? arguments}) {
    return _key.currentState?.pushNamed(page, arguments: arguments);
  }

  void pop([Object? result]) {
    _key.currentState?.pop(result);
  }
}
