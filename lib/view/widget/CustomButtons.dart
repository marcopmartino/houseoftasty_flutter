import 'package:flutter/material.dart';

import 'CustomDecoration.dart';
import 'TextWidgets.dart';

class CustomButtons {

  static submit(String text, {required void Function() onPressed}) {
    return ElevatedButton(
        style: CustomDecoration.submitButtonDecoration(),
        onPressed: () => onPressed(),
        child: TitleWidget.formButton(text)
    );
  }

  static delete(String text, {required void Function() onPressed}) {
    return ElevatedButton(
        style: CustomDecoration.deleteButtonDecoration(),
        onPressed: () => onPressed(),
        child: TitleWidget.formButton(text)
    );
  }
}