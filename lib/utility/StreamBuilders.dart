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

  ListViewStreamBuilder({required super.stream, scroll, onTap, itemType = ItemType.NONE, scale = 1}) :
    super(builder: (BuildContext context, QuerySnapshot<Object?> data) {
        return ListViewBuilder(
            data: data,
            scroll:scroll,
            itemType: itemType,
            scale: scale,
            onTap: (String itemId) => onTap(itemId),
        );
  });
}

class SearchListViewStreamBuilder extends QueryStreamBuilder {

  SearchListViewStreamBuilder({required super.stream, required value, scroll, onTap, itemType = ItemType.NONE, scale = 1}) :
        super(builder: (BuildContext context, QuerySnapshot<Object?> temp) {

          List data = [];
          for(final (index, doc) in temp.docs.indexed){
            if((doc.data() as Map)['titolo'].toString().contains(value)) {
              data.add(doc.data());
              data.last['id'] = doc.id;
            }
          }

          return ListViewBuilder.search(
            dataMap: data,
            scroll:scroll,
            itemType: itemType,
            scale: scale,
            onTap: (String itemId) => onTap(itemId),
          );
      });
}

class PopularListViewStreamBuilder extends QueryStreamBuilder {

  PopularListViewStreamBuilder({required super.stream, scroll, onTap, itemType = ItemType.NONE, scale = 1}) :
        super(builder: (BuildContext context, QuerySnapshot<Object?> temp) {

        List data = [];
        for(final (index, doc) in temp.docs.indexed){
          data.add(doc.data());
          data.last['id'] = doc.id;
        }

        data.sort((a,b) => b['likeCounter'].toString().compareTo(a['likeCounter'].toString()));

        return ListViewBuilder.search(
          dataMap: data,
          scroll:scroll,
          itemType: itemType,
          scale: scale,
          onTap: (String itemId) => onTap(itemId),
        );
      });
}

class NewestListViewStreamBuilder extends QueryStreamBuilder {

  NewestListViewStreamBuilder({required super.stream, scroll, onTap, itemType = ItemType.NONE, scale = 1}) :
        super(builder: (BuildContext context, QuerySnapshot<Object?> temp) {

        List data = [];
        for(final (index, doc) in temp.docs.indexed){
          data.add(doc.data());
          data.last['id'] = doc.id;
        }

        data.sort((a,b) => b['timestampPubblicazione'].toString().compareTo(a['timestampPubblicazione'].toString()));

        return ListViewBuilder.search(
          dataMap: data,
          scroll:scroll,
          itemType: itemType,
          scale: scale,
          onTap: (String itemId) => onTap(itemId),
        );
      });
}
