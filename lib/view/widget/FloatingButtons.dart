
import 'package:flutter/material.dart';

import '../../utility/AppColors.dart';

class FloatingActionButtons {
  static FloatingActionButton edit({required Function() onPressed}) {
    return FloatingActionButton(
        onPressed: () => onPressed(),
        backgroundColor: AppColors.tawnyBrown,
        child: Icon(Icons.edit)
    );
  }

  static FloatingActionButton add({required Function() onPressed}) {
    return FloatingActionButton(
        onPressed: () => onPressed(),
        backgroundColor: AppColors.tawnyBrown,
        child: Icon(Icons.add)
    );
  }
}