import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/utility/AppFontWeight.dart';
import 'package:houseoftasty/utility/Extensions.dart';

import '../../network/ProfileNetwork.dart';
import '../../utility/AppColors.dart';
import '../../utility/ImageLoader.dart';
import '../../utility/StreamBuilders.dart';
import '../widget/TextWidgets.dart';
import 'Item.dart';

class CommentItem extends Item {
  CommentItem({required super.itemData});

  @override
  Widget build(BuildContext context) {
    final String idCreatore = itemData['userId'];

    final String timePassed = (itemData['timestamp'] as Timestamp).timeDiffToString();

    Widget commentItem(String itemTitle) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Container(
                          decoration: BoxDecoration(color: AppColors.caramelBrown),
                          child: ImageLoader.firebaseProfileStorageImage(idCreatore),
                        )
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 88,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubtitleWidget(itemTitle, fontSize: 18, fontWeight: AppFontWeight.bold),
                              TextWidget(timePassed, fontSize: 18)
                            ],
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: TextWidget(itemData['text']),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 2,
            thickness: 2,
            indent: 0,
            endIndent: 0,
            color: AppColors.tawnyBrown,
          )
        ],
      );
    }

    if (idCreatore == FirebaseAuth.instance.currentUserId) {
      return commentItem('Tu');
    } else {
      return DocumentStreamBuilder(
          stream: ProfileNetwork.getUserInfo(idCreatore),
          builder: (BuildContext builder, DocumentSnapshot<Object?> data) {
            return commentItem('${data['username']}');
          }
      );
    }

  }
}