import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/RecipeNetwork.dart';
import 'package:houseoftasty/utility/Extensions.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';
import 'package:houseoftasty/view/widget/CustomEdgeInsets.dart';

import '../../utility/AppColors.dart';
import '../../utility/ImageLoader.dart';
import '../../utility/Navigation.dart';
import '../../view/widget/CustomScaffold.dart';
import '../widget/FloatingButtons.dart';
import '../widget/TextWidgets.dart';
import 'RecipeFormPage.dart';

class RecipeDetailsPage extends StatefulWidget {
  const RecipeDetailsPage({super.key, required this.recipeId});

  static const String route = 'recipeDetails';

  static const String title = 'Dettagli Ricetta';
  final String recipeId;

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: RecipeDetailsPage.title,
      body: DocumentStreamBuilder(
        stream: RecipeNetwork.getRecipeDetails(widget.recipeId),
        builder: (BuildContext builder, DocumentSnapshot<Object?> data) {

          // Estraggo data e ora dal Timestamp di Firestore
          final Map datetime = (data['timestampCreazione'] as Timestamp).toDateTime();
          final formattedDate = datetime['date'];
          final formattedTime = datetime['time'];

          // Determino lo stato della ricetta
          String recipeStatus;
          if (data['boolPubblicata']) {
            if (data['boolPostPrivato']) {
              recipeStatus = 'Ricetta pubblicata (post privato)';
            } else {
              recipeStatus = 'Ricetta pubblicata';
            }
          } else {
            recipeStatus = 'Ricetta non pubblicata';
          }

          Divider divider = const Divider(
            height: 2,
            thickness: 2,
            indent: 0,
            endIndent: 0,
            color: Colors.white,
          );

          return SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Immagine
                    SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: ImageLoader.firebaseRecipeStorageImage(data.id.toString())
                    ),

                    // Sezione titolo e informazioni principali
                    Padding(
                        padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                        child: TitleWidget(data['titolo'], fontSize: 20)
                    ),
                    Padding(
                      padding: CustomEdgeInsets.symmetric(horizontal:16), // Spaziatura esterna
                      child: TextWidget('Creata in data $formattedDate alle $formattedTime'),
                    ),
                    Padding(
                      padding: CustomEdgeInsets.exceptTop(16), // Spaziatura esterna
                      child: TextWidget(recipeStatus, fontSize: 15),
                    ),
                    divider,

                    // Sezione ingredienti
                    Padding(
                      padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleWidget('Ingredienti'),
                          Wrap(
                            spacing: 8,
                            children: [
                              Icon(Icons.people, color: AppColors.caramelBrown),
                              TextWidget(data['numPersone'].toString(), fontSize: 18)
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: CustomEdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: TextWidget(data['ingredienti'].toString().replaceAll(', ', '\n'))
                    ),
                    divider,

                    // Sezione
                    Padding(
                      padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleWidget('Preparazione'),
                          Wrap(
                            spacing: 8,
                            children: [
                              Icon(Icons.timelapse, color: AppColors.caramelBrown),
                              TextWidget(IntExtended.preparationTime(minutes: data['tempoPreparazione']), fontSize: 18)
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: CustomEdgeInsets.fromLTRB(16, 8, 16, 64),
                        child: TextWidget(data['preparazione'])
                    ),
                  ]
              )
          );
        }),
      floatingActionButton: FloatingActionButtons.edit(
        onPressed: () => Navigation.navigate(context, RecipeFormPage.edit(recipeId: widget.recipeId))
      )
    );
  }
}