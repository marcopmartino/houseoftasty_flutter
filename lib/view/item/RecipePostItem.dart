import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/ProfileNetwork.dart';
import 'package:houseoftasty/utility/Extensions.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';

import '../../utility/AppColors.dart';
import '../../utility/ImageLoader.dart';
import '../widget/TextWidgets.dart';
import 'Item.dart';

class RecipePostItem extends Item {
  RecipePostItem({required super.itemData});

  @override
  Widget build(BuildContext context) {
    final String idCreatore = itemData['idCreatore'].toString();

    final Map datetime = (itemData['timestampPubblicazione'] as Timestamp).toDateTime();
    final formattedDate = datetime['date'];
    final formattedTime = datetime['time'];

    Widget recipeItem(String itemSubtitle) {
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
                      child: ImageLoader.firebaseRecipeStorageImage(itemData.id.toString())
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 0), // Spaziatura esterna
                    child: TitleWidget(itemData['titolo'], fontSize: 18, textColor: AppColors.tawnyBrown)
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 8), // Spaziatura esterna
                  child: TextWidget(itemSubtitle),
                ),

                // Statistiche
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.75,
                          child:
                          // Visualizzazioni
                          IconTextWidget(text: itemData['views'].toString(), icon: Icons.remove_red_eye),
                        ),

                        // Like
                        IconTextWidget(text: itemData['likeCounter'].toString(), icon: CupertinoIcons.heart_fill),
                      ]
                  ),
                ),

                Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
                    child: Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 2.75,
                            child:
                            // Commenti
                            IconTextWidget(text: itemData['commentCounter'].toString(), icon: Icons.comment)
                        ),

                        // Salvati
                        IconTextWidget(text: itemData['downloadCounter'].toString(), icon: CupertinoIcons.star_fill)
                      ],
                    )
                ),
              ]
          )
      );
    }

    if (idCreatore == FirebaseAuth.instance.currentUserId) {
      return recipeItem('Pubblicata in data $formattedDate alle $formattedTime');
    } else {
      return DocumentStreamBuilder(
          stream: ProfileNetwork.getUserInfo(idCreatore),
          builder: (BuildContext builder, DocumentSnapshot<Object?> data) {
            return recipeItem('${data['username']} - $formattedDate alle $formattedTime');
          }
      );
    }
  }
}