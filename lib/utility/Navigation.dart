import 'package:flutter/material.dart';

class Navigation {

  static navigate(BuildContext context, Widget view, {String? route}) {
    Navigator.of(context).push(
        MaterialPageRoute(
            settings: RouteSettings(name: route),
            builder: (context) => view
    ));
  }

  static replace(BuildContext context, Widget view, {String? route}) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            settings: RouteSettings(name: route),
            builder: (context) => view
    ));
  }

  static back(BuildContext context) {
    Navigator.of(context).pop();
  }

  static backUntil(BuildContext context, String route) {
    Navigator.of(context).popUntil(ModalRoute.withName(route));
  }
}