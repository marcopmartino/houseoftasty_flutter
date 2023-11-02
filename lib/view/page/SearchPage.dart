
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/view/page/RecipeDetailsPage.dart';

import '../../network/RecipeNetwork.dart';
import '../../utility/Navigation.dart';
import '../../utility/StreamBuilders.dart';

import '../item/Item.dart';
import '../widget/CustomDecoration.dart';

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
        Expanded(
            child: SearchListViewStreamBuilder(
                    stream: RecipeNetwork.getRecipePublish(),
                    value: _searchValue,
                    itemType: ItemType.RECIPE,
                    scale: 1.5,
                    onTap: (String recipeId) {
                      Navigation.navigate(context, RecipeDetailsPage(recipeId: recipeId));
                    }
            ),
        )
      ]
    );
  }
}