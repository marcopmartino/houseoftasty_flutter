import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../view/item/ProductItem.dart';
import '../view/widget/CustomEdgeInsets.dart';
import '../view/item/RecipeItem.dart';
import '../view/item/Item.dart';

class ListViewBuilder extends StatelessWidget {
  final QuerySnapshot<Object?>? data;
  final List? dataMap;
  final Function(String) onTap;
  final ItemType itemType;
  final double scale;
  final bool? scroll;

  const ListViewBuilder({super.key, this.scroll, this.data, required this.onTap, this.itemType = ItemType.NONE, this.scale = 1, this.dataMap});

  const ListViewBuilder.search({super.key, this.scroll, this.data, required this.onTap, this.itemType = ItemType.NONE, this.scale = 1, this.dataMap});

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
  
  Item _getListItemList(Map<String, dynamic> itemData){
    return RecipeItem.list(itemDataList: itemData);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ListView.builder(
          shrinkWrap: scroll == null ? false : true,
          physics: scroll == null ? null : NeverScrollableScrollPhysics(),
          itemCount: dataMap == null ? data!.size : dataMap!.length,
          itemBuilder: (context, index) {
            final itemData = (dataMap == null ? data!.docs[index] : dataMap!.asMap()[index]);
            return Container(
              margin: CustomEdgeInsets.list(dataMap == null ? data!.size: dataMap!.length, index, scale: scale),
              // Spaziatura esterna
              width: double.infinity,
              child: InkWell(
                onTap: () => onTap(dataMap == null ? itemData.id.toString() : dataMap!.asMap()[index]['id']),
                child: (dataMap == null ? _getListItem(itemData): _getListItemList(dataMap!.asMap()[index]))
              ),
            );
          },
        )
    );
  }

}