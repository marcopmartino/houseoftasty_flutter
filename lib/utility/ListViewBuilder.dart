import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../view/item/ProductItem.dart';
import '../view/widget/CustomEdgeInsets.dart';
import '../view/item/RecipeItem.dart';
import '../view/item/Item.dart';

class ListViewBuilder extends StatelessWidget {
  final QuerySnapshot<Object?> data;
  final Function(String) onTap;
  final ItemType itemType;
  final double scale;

  const ListViewBuilder({super.key, required this.data, required this.onTap, this.itemType = ItemType.NONE, this.scale = 1});

  Item _getListItem(QueryDocumentSnapshot<Object?> itemData) {
    switch(itemType.name) {
      case 'RECIPE':
          return RecipeItem(itemData: itemData);
      case 'PRODUCT':
          return ProductItem(itemData: itemData);
      default:
          return Item(itemData: itemData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: data.size,
          itemBuilder: (context, index) {
            final itemData = data.docs[index];
            return Container(
              margin: CustomEdgeInsets.list(data.size, index, scale: scale),
              // Spaziatura esterna
              width: double.infinity,
              child: InkWell(
                onTap: () => onTap(itemData.id.toString()),
                child: _getListItem(itemData)
              ),
            );
          },
        )
    );
  }

}