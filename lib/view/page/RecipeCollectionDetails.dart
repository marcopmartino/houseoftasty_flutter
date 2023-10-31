import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/RecipeCollectionNetwork.dart';
import 'package:houseoftasty/utility/Extensions.dart';
import 'package:houseoftasty/view/item/Item.dart';
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
    return DocumentStreamBuilder(
        stream: RecipeCollectionNetwork.getRecipeCollectionDetails(widget.recipeCollectionId),
        builder: (BuildContext context, DocumentSnapshot<Object?> data) {
          _recipeCollectionName = data['nome'];
          _recipeIds = (data['listaRicette'] as List<dynamic>).toStringList();
          String title = '$_recipeCollectionName ($_recipeIdsSize)';
          FloatingActionButton? fab =
            widget.recipeCollectionId == 'saveCollection' ? null :
            FloatingActionButtons.edit(
              onPressed: () => Navigation.navigate(context, RecipeCollectionFormPage.edit(recipeCollectionId: widget.recipeCollectionId))
          );
          return _recipeIdsSize != 0 ? CustomScaffold(
              title: title,
              body: ListViewStreamBuilder(
                  stream: RecipeNetwork.getRecipesByIdList(_recipeIds),
                  itemType: ItemType.RECIPE,
                  scale: 1.5,
                  onTap: (String recipeId) {
                    Navigation.navigate(context, RecipeDetailsPage(recipeId: recipeId));
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