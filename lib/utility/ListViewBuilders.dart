import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../view/item/ProductItem.dart';
import '../view/item/RecipeCollectionFormItem.dart';
import '../view/widget/CustomEdgeInsets.dart';
import '../view/item/RecipeItem.dart';
import '../view/item/Item.dart';
import '../view/item/RecipeCollectionItem.dart';
import 'AppColors.dart';

class ListViewBuilder extends StatelessWidget {
  final QuerySnapshot<Object?> data;
  final Function(String) onTap;
  final ItemType itemType;
  final double scale;

  const ListViewBuilder({super.key, required this.data, required this.onTap, this.itemType = ItemType.NONE, this.scale = 1});

  Item _getListItem(QueryDocumentSnapshot<Object?> itemData) {
    switch(itemType) {
      case ItemType.RECIPE:
        return RecipeItem(itemData: itemData);
      case ItemType.RECIPE_POST:
        return Item(itemData: itemData);
      case ItemType.RECIPE_COLLECTION:
        return RecipeCollectionItem(itemData: itemData);
      case ItemType.RECIPE_COLLECTION_FORM:
        return RecipeCollectionFormItem(itemData: itemData);
      case ItemType.PRODUCT:
        return ProductItem(itemData: itemData);
      case ItemType.COMMENT:
        return Item(itemData: itemData);
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

class FutureListViewBuilder extends StatelessWidget {
  final Future<QuerySnapshot<Object?>> future;
  final Function(String) onTap;
  final ItemType itemType;
  final double scale;

  const FutureListViewBuilder({super.key, required this.future, required this.onTap, this.itemType = ItemType.NONE, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppColors.tawnyBrown));
        } else {
          return ListViewBuilder(
              data: snapshot.requireData,
              onTap: onTap,
              itemType: itemType,
              scale: scale
          );
        }

      },
    );
  }
}