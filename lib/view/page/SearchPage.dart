
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../network/RecipeNetwork.dart';
import '../../utility/Navigation.dart';
import '../../utility/StreamBuilders.dart';
import '../item/Item.dart';
import '../widget/CustomDecoration.dart';
import 'RecipePostDetailsPage.dart';

class SearchPage extends StatefulWidget{
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{

  final _searchController = TextEditingController();

  var _searchValue = '';

  @override
  Widget build(BuildContext context){


    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 16),
          child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.black),
              decoration: CustomDecoration.searchInputDecoration('', 'Inserire il nome di una ricetta'),
              onChanged: (text) {
                setState(() {
                  _searchValue = _searchController.text;
                });
              }
          ),
        ),
        _searchValue.isNotEmpty ?
        ListViewStreamBuilder(
            stream: RecipeNetwork.getPublicRecipes(),
            itemType: ItemType.RECIPE_POST,
            scale: 1.5,
            expanded: true,
            onTap: (QueryDocumentSnapshot<Object?> recipe) {
              Navigation.navigate(context, RecipePostDetailsPage(recipeId: recipe.id));
            },
          filterFunction: (List<QueryDocumentSnapshot<Object?>> data) {
            List<QueryDocumentSnapshot<Object?>> filteredData = List.empty(growable: true);
            for (QueryDocumentSnapshot<Object?> document in data) {
              if (document['titolo'].toString().contains(_searchValue)) {
                filteredData.add(document);
              }
            }
            return filteredData;
          }
        ) : Container(),

      ]
    );
  }
}