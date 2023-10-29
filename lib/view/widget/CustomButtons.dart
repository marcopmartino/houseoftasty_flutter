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

  static submitSmall(String text, {required void Function() onPressed}) {
    return ElevatedButton(
        style: CustomDecoration.submitSmallButtonDecoration(),
        onPressed: () => onPressed(),
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'BalooBhai',
            color: Colors.white,
          ),
        )
    );
  }

  static delete(String text, {required void Function() onPressed}) {
    return ElevatedButton(
        style: CustomDecoration.deleteButtonDecoration(),
        onPressed: () => onPressed(),
        child: TitleWidget.formButton(text)
    );
  }

  static deleteSmall(String text, {required void Function() onPressed}) {
    return ElevatedButton(
        style: CustomDecoration.deleteSmallButtonDecoration(),
        onPressed: () => onPressed(),
        child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: 15,
            fontFamily: 'BalooBhai',
            color: Colors.white,
          ),
        )
    );
  }
}