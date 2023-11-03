
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../network/RecipeNetwork.dart';
import '../../utility/Navigation.dart';
import '../../utility/StreamBuilders.dart';
import '../item/Item.dart';
import 'RecipePostDetailsPage.dart';

class NewestPage extends StatefulWidget{
  @override
  State<NewestPage> createState() => _NewestPageState();
}

class _NewestPageState extends State<NewestPage>{


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

                // Ordina per timestamp decrescente (dal più recente)
                data.sort((a,b) => b['timestampPubblicazione'].toString().compareTo(a['timestampPubblicazione'].toString()));

                return data;
              }
          ),
        ]
    );
  }
}