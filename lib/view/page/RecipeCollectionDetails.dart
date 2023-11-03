import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/RecipeCollectionNetwork.dart';
import 'package:houseoftasty/utility/Extensions.dart';
import 'package:houseoftasty/view/item/Item.dart';
import 'package:houseoftasty/view/page/RecipePostDetailsPage.dart';
import '../../network/RecipeNetwork.dart';
import '../../utility/StreamBuilders.dart';
import '../../utility/Navigation.dart';
import '../../view/widget/CustomScaffold.dart';
import '../widget/FloatingButtons.dart';
import 'RecipeCollectionFormPage.dart';
import 'RecipeDetailsPage.dart';

class RecipeCollectionDetailsPage extends StatefulWidget {

  const RecipeCollectionDetailsPage({super.key, required this.recipeCollectionId});

  final String recipeCollectionId;

  @override
  State<RecipeCollectionDetailsPage> createState() => _RecipeCollectionDetailsState();
}

class _RecipeCollectionDetailsState extends State<RecipeCollectionDetailsPage> {

  late String _recipeCollectionName;
  late List<String> _recipeIds;
  int get _recipeIdsSize => _recipeIds.length;


  @override
  Widget build(BuildContext context) {
    bool isSaveCollection = widget.recipeCollectionId == 'saveCollection';

    return DocumentStreamBuilder(
        stream: RecipeCollectionNetwork.getRecipeCollectionDetails(widget.recipeCollectionId),
        builder: (BuildContext context, DocumentSnapshot<Object?> data) {
          _recipeCollectionName = data['nome'];
          _recipeIds = (data['listaRicette'] as List<dynamic>).toStringList();
          String title = '$_recipeCollectionName ($_recipeIdsSize)';
          FloatingActionButton? fab =
            isSaveCollection ? null :
            FloatingActionButtons.edit(
              onPressed: () => Navigation.navigate(context, RecipeCollectionFormPage.edit(recipeCollectionId: widget.recipeCollectionId))
          );
          return _recipeIdsSize != 0 ? CustomScaffold(
              title: title,
              body: ListViewStreamBuilder(
                  stream: RecipeNetwork.getRecipesByIdList(_recipeIds),
                  itemType: isSaveCollection ? ItemType.RECIPE_POST : ItemType.RECIPE,
                  scale: 1.5,
                  onTap: (QueryDocumentSnapshot<Object?> recipe) {
                    Navigation.navigate(context, isSaveCollection ? RecipePostDetailsPage(recipeId: recipe.id) : RecipeDetailsPage(recipeId: recipe.id));
                  }
              ),
              floatingActionButton: fab
          ) : CustomScaffold(
              title: title,
              body: Container(),
              floatingActionButton: fab
          );
        }
    );
  }
}