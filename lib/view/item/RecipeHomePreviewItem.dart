import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/ProfileNetwork.dart';
import 'package:houseoftasty/utility/Extensions.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';

import '../../utility/AppColors.dart';
import '../widget/TextWidgets.dart';
import 'Item.dart';

class RecipeHomePreviewItem extends Item {
  RecipeHomePreviewItem({required super.itemData});

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
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child:
                          // Visualizzazioni
                          IconTextWidget(
                              text: itemData['views'].toString(),
                              icon: Icons.remove_red_eye,
                              iconSize: 30,
                              fontSize: 16,
                              innerPadding: 8
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child:
                          // Like
                          IconTextWidget(
                              text: itemData['likeCounter'].toString(),
                              icon: CupertinoIcons.heart_fill,
                              iconSize: 30,
                              fontSize: 16,
                              innerPadding: 8
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child:
                          // Commenti
                          IconTextWidget(
                              text: itemData['commentCounter'].toString(),
                              icon: Icons.comment,
                              iconSize: 30,
                              fontSize: 16,
                              innerPadding: 8
                          )
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child:
                          // Salvati
                          IconTextWidget(
                              text: itemData['downloadCounter'].toString(),
                              icon: CupertinoIcons.star_fill,
                              iconSize: 30,
                              fontSize: 16,
                              innerPadding: 8
                          )
                        ),
                      ]
                  ),
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