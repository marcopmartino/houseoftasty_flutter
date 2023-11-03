
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../network/RecipeNetwork.dart';
import '../../utility/Navigation.dart';
import '../../utility/StreamBuilders.dart';
import '../item/Item.dart';
import 'RecipePostDetailsPage.dart';

class PopularPage extends StatefulWidget{
  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage>{


  @override
  Widget build(BuildContext context){


    return Column(
      children: [
        ListViewStreamBuilder(
            stream: RecipeNetwork.getPublicRecipes(),
            itemType: ItemType.RECIPE_POST,
            scale: 1.5,
            expanded: true,
            onTap: (QueryDocumentSnapshot<Object?> recipe) {
              Navigation.navigate(context, RecipePostDetailsPage(recipeId: recipe.id));
            },
            filterFunction: (List<QueryDocumentSnapshot<Object?>> data) {

              // Ordina per numero di like descrescente
              data.sort((a,b) => b['likeCounter'].toString().compareTo(a['likeCounter'].toString()));

              return data;
            }
        ),
      ]
    );
  }
}