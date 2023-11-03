import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/utility/ListViewBuilders.dart';

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

  ListViewStreamBuilder({
    required super.stream,
    required Function(QueryDocumentSnapshot<Object?>) onTap,
    ItemType itemType = ItemType.NONE,
    double scale = 1,
    ScrollPhysics? scrollPhysics,
    bool shrinkWrap = false,
    bool? primaryScrollableWidget,
    bool expanded = false,
    List<QueryDocumentSnapshot<Object?>> Function(List<QueryDocumentSnapshot<Object?>> data)? filterFunction,
  }) : super(builder: (BuildContext context, QuerySnapshot<Object?> data) {

    List<QueryDocumentSnapshot<Object?>> docs = data.docs;

    if (filterFunction != null) {
      docs = filterFunction(docs);
    }

    return ListViewBuilder(
      data: docs,
      itemType: itemType,
      scale: scale,
      onTap: (QueryDocumentSnapshot<Object?> itemData) => onTap(itemData),
      scrollPhysics: scrollPhysics,
      shrinkWrap: shrinkWrap,
      primaryScrollableWidget: primaryScrollableWidget,
      expanded: expanded,
    );
  });
}

//
class DismissibleListViewStreamBuilder extends QueryStreamBuilder {

  DismissibleListViewStreamBuilder({
    required super.stream,
    required Function(QueryDocumentSnapshot<Object?> itemData) onTap,
    ItemType itemType = ItemType.NONE,
    double scale = 1,
    ScrollPhysics? scrollPhysics,
    bool shrinkWrap = false,
    bool? primaryScrollableWidget,
    bool expanded = false,
    List<QueryDocumentSnapshot<Object?>> Function(List<QueryDocumentSnapshot<Object?>> data)? filterFunction,
    bool Function(QueryDocumentSnapshot<Object?> itemData)? dismissPolicy,
    Function(String itemId)? onDismiss,
  }) : super(builder: (BuildContext context, QuerySnapshot<Object?> data) {

    List<QueryDocumentSnapshot<Object?>> docs = data.docs;

    if (filterFunction != null) {
      docs = filterFunction(docs);
    }

    return DismissibleListViewBuilder(
      data: docs,
      itemType: itemType,
      scale: scale,
      onTap: (QueryDocumentSnapshot<Object?> itemData) => onTap(itemData),
      scrollPhysics: scrollPhysics,
      shrinkWrap: shrinkWrap,
      primaryScrollableWidget: primaryScrollableWidget,
      expanded: expanded,
      dismissPolicy: dismissPolicy,
      onDismiss: onDismiss,
    );
  });
}
