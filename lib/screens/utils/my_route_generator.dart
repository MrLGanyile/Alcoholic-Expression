import 'package:flutter/material.dart';

import '../users/groups_screen.dart';
import 'helpers.dart';

class MyRouteGenerator {
  static const id = 'MyRouteGenerator';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as dynamic;
    log(id, msg: "Pushed ${settings.name}(${args ?? ''})");
    switch (settings.name) {
      case GroupsScreen.id:
        return _route(const GroupsScreen());
      default:
        return _errorRoute(settings.name);
    }
  }

  static MaterialPageRoute _route(Widget widget) =>
      MaterialPageRoute(builder: (context) => widget);

  static Route<dynamic> _errorRoute(String? name) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('ROUTE \n\n$name\n\nNOT FOUND'),
        ),
      ),
    );
  }
}
