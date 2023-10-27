import 'package:flutter/cupertino.dart';

class CustomEdgeInsets extends EdgeInsets {
  CustomEdgeInsets.all(super.value) : super.all();
  CustomEdgeInsets.fromLTRB(super.left, super.top, super.right, super.bottom) : super.fromLTRB();
  CustomEdgeInsets.only({super.left, super.top, super.right, super.bottom}) : super.only();
  CustomEdgeInsets.symmetric({super.horizontal, super.vertical}) : super.symmetric();

  // Rende gli elementi della lista equidistanti tra di loro e dal contenitore
  static EdgeInsets list(int size, int index, {double scale = 1}) {
    final double full = 8 * scale;
    final double half = full / 2;
    if (size == 1) {
      return EdgeInsets.all(full);
    } else if (index == 0) {
      return EdgeInsets.fromLTRB(full, full, full, half);
    } else if (index == size-1) {
      return EdgeInsets.fromLTRB(full, half, full, full);
    } else {
      return EdgeInsets.symmetric(horizontal: full, vertical: half);
    }
  }

  static EdgeInsets exceptTop(double padding) {
    return EdgeInsets.fromLTRB(padding, 0, padding, padding);
  }

  static EdgeInsets exceptBottom(double padding) {
    return EdgeInsets.fromLTRB(padding, padding, padding, 0);
  }

  static EdgeInsets exceptLeft(double padding) {
    return EdgeInsets.fromLTRB(0, padding, padding, padding);
  }

  static EdgeInsets exceptRight(double padding) {
    return EdgeInsets.fromLTRB(16, 16, 0, 16);
  }

}