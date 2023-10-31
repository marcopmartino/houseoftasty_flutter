import 'package:flutter/material.dart';

import '../../utility/AppColors.dart';
import '../../utility/AppFontWeight.dart';
import '../widget/TextWidgets.dart';
import 'Item.dart';

class RecipeCollectionFormItem extends Item {
  RecipeCollectionFormItem({required super.itemData});

  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.caramelBrown),
            borderRadius: BorderRadius.circular(5)
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(itemData['titolo'],
                  fontSize: 18,
                  fontWeight: AppFontWeight.medium,
              ),
              Icon(Icons.remove, color: AppColors.caramelBrown)
            ]
        )
    );
  }
}