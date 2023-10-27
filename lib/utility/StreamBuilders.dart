import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/utility/ListViewBuilder.dart';

import '../view/item/Item.dart';
import 'AppColors.dart';

// StreamBuilder per singoli Document
class DocumentStreamBuilder extends StreamBuilder<DocumentSnapshot> {

  DocumentStreamBuilder({required super.stream, required Function(BuildContext, DocumentSnapshot<Object?>) builder}) :
        super(builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Errore - Riprova più tardi'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppColors.tawnyBrown));
        }

        final DocumentSnapshot<Object?> data = snapshot.requireData;

        return builder(context, data);
      });
}

// StreamBuilder per Collection intere
class QueryStreamBuilder extends StreamBuilder<QuerySnapshot> {

  QueryStreamBuilder({required super.stream, required Function(BuildContext, QuerySnapshot<Object?>) builder}) :
        super(builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Errore - Riprova più tardi'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppColors.tawnyBrown));
        }

        final QuerySnapshot<Object?> data = snapshot.requireData;

        return builder(context, data);
      });


}

// QueryStreamBuilder che si occupa anche di creare la view della lista
class ListViewStreamBuilder extends QueryStreamBuilder {

  ListViewStreamBuilder({required super.stream, onTap, itemType = ItemType.NONE, scale = 1}) :
    super(builder: (BuildContext context, QuerySnapshot<Object?> data) {
        return ListViewBuilder(
            data: data,
            itemType: itemType,
            scale: scale,
            onTap: (String itemId) => onTap(itemId)
        );
  });
}
