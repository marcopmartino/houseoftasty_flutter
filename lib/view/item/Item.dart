import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  final QueryDocumentSnapshot<Object?>? itemData;
  final Map<String, dynamic>? itemDataList;


  const Item({super.key, this.itemData, this.itemDataList});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(itemData.toString()));
  }

}

enum ItemType {
  NONE, RECIPE, RECIPE_POST, RECIPE_COLLECTION, RECIPE_COLLECTION_FORM, PRODUCT, COMMENT
}