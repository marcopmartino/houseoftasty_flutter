import 'package:flutter/material.dart';
import 'package:houseoftasty/view/item/Item.dart';

import '../../network/RecipeCollectionNetwork.dart';
import '../../utility/StreamBuilders.dart';
import '../../utility/Navigation.dart';
import '../../view/widget/CustomScaffold.dart';
import '../widget/FloatingButtons.dart';
import 'RecipeCollectionDetails.dart';
import 'RecipeCollectionFormPage.dart';

class RecipeCollectionsPage extends StatefulWidget {
  const RecipeCollectionsPage({super.key});

  static const String title = 'Raccolte';
  static const String route = '/recipeCollections';

  @override
  State<RecipeCollectionsPage> createState() => _RecipeCollectionsState();
}

class _RecipeCollectionsState extends State<RecipeCollectionsPage> {

  @override
  Widget build(BuildContext context) {

    return CustomScaffold.withDrawer(
        title: RecipeCollectionsPage.title,
        body:
        ListViewStreamBuilder(
            stream: RecipeCollectionNetwork.getCurrentUserRecipeCollections(),
            itemType: ItemType.RECIPE_COLLECTION,
            scale: 0.0,
            onTap: (String recipeCollectionId) {
              Navigation.navigate(context, RecipeCollectionDetailsPage(recipeCollectionId: recipeCollectionId));
            }
        ),
        floatingActionButton: FloatingActionButtons.add(
            onPressed: () => Navigation.navigate(context, RecipeCollectionFormPage())
        )
    );
  }
}