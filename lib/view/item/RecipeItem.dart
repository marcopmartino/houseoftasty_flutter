import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/utility/Extensions.dart';

import '../../utility/AppColors.dart';
import '../../utility/ImageLoader.dart';
import '../widget/TextWidgets.dart';
import 'Item.dart';

class RecipeItem extends Item {
  RecipeItem({super.itemData});
  RecipeItem.list({super.itemDataList});

  @override
  Widget build(BuildContext context) {
    final Map datetime = (itemData != null ?(itemData!['timestampCreazione'] as Timestamp).toDateTime() :
      (itemDataList!['timestampCreazione'] as Timestamp).toDateTime());
    final formattedDate = datetime['date'];
    final formattedTime = datetime['time'];


    return Card(
            color: AppColors.darkSandBrown,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      child: ImageLoader.firebaseRecipeStorageImage(
                          (itemData != null ?(itemData!.id.toString()) :
                          (itemDataList!['id']))
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0), // Spaziatura esterna
                  child: TitleWidget(
                      (itemData != null ?(itemData!['titolo']) : (itemDataList!['titolo'])),
                      fontSize: 18,
                      textColor: AppColors.tawnyBrown)
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 8), // Spaziatura esterna
                  child: TextWidget('Creata in data $formattedDate alle $formattedTime'),
                ),
              ],
            )
        );
  }
}