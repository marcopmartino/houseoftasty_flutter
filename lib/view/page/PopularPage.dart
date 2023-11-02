
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/view/page/RecipeDetailsPage.dart';

import '../../network/RecipeNetwork.dart';
import '../../utility/ListViewBuilder.dart';
import '../../utility/Navigation.dart';
import '../../utility/StreamBuilders.dart';

import '../item/Item.dart';
import '../widget/CustomDecoration.dart';

class PopularPage extends StatefulWidget{
  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage>{


  @override
  Widget build(BuildContext context){


    return Column(
      children: [
        Expanded(
            child: PopularListViewStreamBuilder(
                    stream: RecipeNetwork.getRecipePublish(),
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