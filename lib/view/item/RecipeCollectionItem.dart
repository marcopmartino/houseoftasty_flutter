import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/utility/Extensions.dart';

import '../../utility/AppColors.dart';
import '../../utility/ImageLoader.dart';
import '../widget/TextWidgets.dart';
import 'Item.dart';

class RecipeCollectionItem extends Item {
  RecipeCollectionItem({required super.itemData});

  @override
  Widget build(BuildContext context) {

    final recipeIds = itemData['listaRicette'];
    final numRecipes = recipeIds.length;

    final String recipeCollectionSubtitle;
    if (itemData.id == 'saveCollection') {
      recipeCollectionSubtitle = 'Generata automaticamente';
    } else {
      final Map datetime = (itemData['timestampCreazione'] as Timestamp).toDateTime();
      final formattedDate = datetime['date'];
      final formattedTime = datetime['time'];
      recipeCollectionSubtitle = 'Creata in data $formattedDate alle $formattedTime';
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.caramelBrown),
                        child: ImageLoader.recipeCollectionImage(recipeIds),
                      )
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: TitleWidget(itemData['nome'] + ' ($numRecipes)', fontSize: 18, textColor: AppColors.caramelBrown)
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextWidget(recipeCollectionSubtitle),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          height: 2,
          thickness: 2,
          indent: 0,
          endIndent: 0,
          color: Colors.white,
        )
      ],
    );
  }
}