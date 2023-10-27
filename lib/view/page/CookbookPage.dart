import 'package:flutter/material.dart';
import 'package:houseoftasty/view/item/Item.dart';
import 'package:houseoftasty/view/page/RecipeFormPage.dart';

import '../../network/RecipeNetwork.dart';
import '../../utility/StreamBuilders.dart';
import '../../utility/Navigation.dart';
import '../../view/widget/CustomScaffold.dart';
import '../widget/FloatingButtons.dart';
import 'RecipeDetailsPage.dart';

class CookbookPage extends StatefulWidget {
  const CookbookPage({super.key});

  static const String title = 'Ricettario';

  static const String route = '/cookbook';

  @override
  State<CookbookPage> createState() => _CookbookState();
}

class _CookbookState extends State<CookbookPage> {

  @override
  Widget build(BuildContext context) {

    return CustomScaffold.withDrawer(
      title: CookbookPage.title,
      body:
      ListViewStreamBuilder(
          stream: RecipeNetwork.getCurrentUserRecipes(),
          itemType: ItemType.RECIPE,
          scale: 1.5,
          onTap: (String recipeId) {
            Navigation.navigate(context, RecipeDetailsPage(recipeId: recipeId));
          }
      ),
        floatingActionButton: FloatingActionButtons.add(
            onPressed: () => Navigation.navigate(context, RecipeFormPage())
        )
    );
  }
}