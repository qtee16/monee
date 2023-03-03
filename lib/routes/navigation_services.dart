import 'package:flutter/material.dart';

class NavigationService {
  factory NavigationService() {
    _this ??= NavigationService._getInstance();
    return _this!;
  }

  static NavigationService? _this;
  NavigationService._getInstance();

  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    if(_navigationKey.currentState!.canPop()) {
      _navigationKey.currentState!.pop();
    }
  }

  bool canPop() {
    return _navigationKey.currentState!.canPop();
  }

  void popUtils(String routeName) {
    return _navigationKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }

  Future<dynamic> pushNamed(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNameAndRemoveUntil(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
  }

  Future<dynamic> popAndPushNamed(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!
        .popAndPushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName, String removeRouteName, {dynamic arguments}) {
    return _navigationKey.currentState!
        .pushNamedAndRemoveUntil(routeName, ModalRoute.withName(removeRouteName));
  }

  // Future<dynamic> popsAndPushNamed(String routeName, {dynamic arguments}) async {
  //   if(_navigationKey.currentState.canPop()) {
  //     _navigationKey.currentState.pop();
  //   }
  //   return _navigationKey.currentState.popAndPushNamed(routeName, arguments: arguments);
  // }
  // Future<dynamic> popAndPushReplacementNamed(String routeName, {dynamic arguments}) async {
  //   if(_navigationKey.currentState.canPop()) {
  //     _navigationKey.currentState.pop();
  //   }
  //   return _navigationKey.currentState.pushReplacementNamed(routeName, arguments: arguments);
  // }
}
