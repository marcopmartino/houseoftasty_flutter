import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/RecipeNetwork.dart';
import 'package:houseoftasty/utility/AppFontWeight.dart';
import 'package:houseoftasty/utility/Extensions.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';
import '../../model/Recipe.dart';
import '../../utility/AppColors.dart';
import '../../utility/Navigation.dart';
import '../../utility/Validator.dart';
import '../../view/widget/CustomScaffold.dart';
import '../widget/CustomButtons.dart';
import '../widget/CustomEdgeInsets.dart';
import '../widget/TextWidgets.dart';

class RecipeFormPage extends StatefulWidget {
  RecipeFormPage({super.key}) {
    newRecipe = true;
  }

  static const String route = 'recipeForm';

  RecipeFormPage.edit({super.key, required this.recipeId}) {
    newRecipe = false;
  }

  late final String? recipeId;
  late final bool newRecipe;

  @override
  State<RecipeFormPage> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeFormPage> {


  final _formKey = GlobalKey<FormState>();



  final _titoloTextController = TextEditingController();
  final _ingredientiTextController = TextEditingController();
  final _numPersoneTextController = TextEditingController();
  final _preparazioneTextController = TextEditingController();
  final _tempoPreparazioneTextController = TextEditingController();

  bool _pubblicataSwitchValue = false;
  bool _postPrivatoSwitchValue = false;

  bool _isProcessing = false;
  bool _initializationCompleted = false;

  late DocumentSnapshot<Object?> _oldData;

  @override
  Widget build(BuildContext context) {
    String title = widget.newRecipe ? 'Nuova Ricetta' : 'Modifica Ricetta';
    if (_isProcessing) {
      return CustomScaffold(
          title: title,
          body: Center(
              child: CircularProgressIndicator(
                  color: AppColors.tawnyBrown
              )
          )
      );
    } else if (widget.newRecipe) {
      return CustomScaffold(
          title: title,
          body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  formBody(),
                  createButton(context),
                ])
        )
      );
    } else if (_initializationCompleted) {
      return CustomScaffold(
          title: title,
          body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  formBody(),
                  editButton(context),
                  deleteButton(context),
                ])
        )
      );
    } else {
      return CustomScaffold(
        title: title,
        body: DocumentStreamBuilder(
            stream: RecipeNetwork.getRecipeDetails(widget.recipeId!),
            builder: (BuildContext builder, DocumentSnapshot<Object?> data) {

              _titoloTextController.text = data['titolo'];
              _ingredientiTextController.text = data['ingredienti'];
              _numPersoneTextController.text = data['numPersone'].toString();
              _preparazioneTextController.text = data['preparazione'];
              _tempoPreparazioneTextController.text = data['tempoPreparazione'].toString();
              _pubblicataSwitchValue = data['boolPubblicata'] as bool;
              _postPrivatoSwitchValue = data['boolPostPrivato'] as bool;
              _initializationCompleted = true;

              _oldData = data;

              return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        formBody(),
                        editButton(context),
                        deleteButton(context),
                      ])
              );
            }),
      );
    }
  }

  Widget formBody() {
    return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Titolo
                Padding(
                  padding: CustomEdgeInsets.fromLTRB(32, 40, 32, 24),
                  child: TextFormFieldWidget(
                    controller: _titoloTextController,
                    validator: (value) => Validator.validateRequired(value: value),
                    label: 'Titolo',
                    hint:'Inserire il titolo della ricetta'
                  ),
                ),

                // Ingredienti
                Padding(
                  padding: CustomEdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: TextFormFieldWidget.multiline(
                        controller: _ingredientiTextController,
                        validator: (value) => Validator.validateRequired(value: value),
                        label: 'Ingredienti',
                        hint:'Elencare ingredienti separati da virgole'
                  ),
                ),

                // Porzione
                Padding(
                  padding: CustomEdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: TextFormFieldWidget.numeric(
                              controller: _numPersoneTextController,
                              validator: (value) => Validator.validateRequired(value: value),
                              label: 'Porzione',
                              hint:'es. 2'
                          ),
                        ),
                        Padding(
                            padding: CustomEdgeInsets.only(left: 16),
                            child: SizedBox(
                              width: 100,
                              child: TextWidget('persone', fontWeight: AppFontWeight.medium),
                            )
                        )
                      ]
                  ),
                ),

                // Preparazione
                Padding(
                  padding: CustomEdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: TextFormFieldWidget.multiline(
                      controller: _preparazioneTextController,
                      validator: (value) => Validator.validateRequired(value: value),
                      label: 'Preparazione',
                      hint: 'Procedura di preparazione'
                  ),
                ),

                // Tempo di preparazione
                Padding(
                  padding: CustomEdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormFieldWidget.numeric(
                              controller: _tempoPreparazioneTextController,
                              validator: (value) => Validator.validateRequired(value: value),
                              label: 'Tempo di preparazione',
                              hint:'es. 45'
                          ),
                        ),
                        Padding(
                            padding: CustomEdgeInsets.only(left: 16),
                            child: SizedBox(
                              width: 100,
                              child: TextWidget('minuti', fontWeight: AppFontWeight.medium),
                            )
                        )
                      ]
                  ),
                ),

                // Switch Pubblicata
                Padding(
                  padding: CustomEdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: CustomEdgeInsets.only(left: 16, right: 12),
                          child: TextWidget('Ricetta pubblicata:', fontWeight: AppFontWeight.semiBold, textColor: AppColors.caramelBrown),

                        ),
                        Switch(
                          activeColor: AppColors.tawnyBrown,
                          value: _pubblicataSwitchValue,
                          onChanged: (bool value) {
                            setState(() {
                              _pubblicataSwitchValue = value;
                              if (!value) {
                                _postPrivatoSwitchValue = false;
                              }
                            });
                          },
                        ),
                      ]
                  ),
                ),


                // Switch PostPrivato
                if (_pubblicataSwitchValue)
                Padding(
                  padding: CustomEdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: CustomEdgeInsets.only(left: 16, right: 4),
                          child: TextWidget('Post ricetta privato:', fontWeight: AppFontWeight.semiBold, textColor: AppColors.caramelBrown),

                        ),
                        Switch(
                          activeColor: AppColors.tawnyBrown,
                          value: _postPrivatoSwitchValue,
                          onChanged: (bool value) {
                            setState(() {
                              _postPrivatoSwitchValue = value;
                            });

                          }
                        ),
                      ]
                  ),
                ),
              ],
            )
    );
  }

  // Button per crare una nuova ricetta
  Widget createButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(32),
        child: CustomButtons.submit(
            'Crea Ricetta',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isProcessing = true;
                });

                String documentId = await RecipeNetwork.addRecipe(
                    Recipe(
                      idCreatore: FirebaseAuth.instance.currentUserId!,
                      titolo: _titoloTextController.text,
                      ingredienti: _ingredientiTextController.text,
                      numPersone: _numPersoneTextController.text.toInt(),
                      preparazione: _preparazioneTextController.text,
                      tempoPreparazione: _tempoPreparazioneTextController.text.toInt(),
                      boolPubblicata: _pubblicataSwitchValue,
                      boolPostPrivato: _postPrivatoSwitchValue,
                    ).toDocumentMap());

                // Aggiorno l'immagine

                // Navigo
                Navigation.back(context);
              }
            }

        )
    );
  }


  // Button per salvare le modifiche alla ricetta
  Widget editButton(BuildContext context) {
    return Padding(
        padding: CustomEdgeInsets.all(32),
        child: CustomButtons.submit(
            'Salva Modifiche',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isProcessing = true;
                });

                // Aggiorno la ricetta
                Recipe recipe;

                if (_pubblicataSwitchValue) {
                  recipe = Recipe(
                    id: _oldData.id,
                    idCreatore: _oldData['idCreatore'],
                    titolo: _titoloTextController.text,
                    ingredienti: _ingredientiTextController.text,
                    numPersone: _numPersoneTextController.text.toInt(),
                    preparazione: _preparazioneTextController.text,
                    tempoPreparazione: _tempoPreparazioneTextController.text.toInt(),
                    boolPubblicata: true,
                    boolPostPrivato: _postPrivatoSwitchValue,
                    timestampCreazione: _oldData['timestampCreazione'],
                    timestampPubblicazione: _oldData['boolPubblicata'] ? _oldData['timestampPubblicazione'] : Timestamp.now(),
                    views: _oldData['views'],
                    downloads: _oldData['downloads'],
                    downloadCounter:  _oldData['downloadCounter'],
                    likes: _oldData['likes'],
                    likeCounter:  _oldData['likeCounter'],
                    commentCounter:  _oldData['commentCounter'],
                  );
                } else {
                  recipe = Recipe(
                    id: _oldData.id,
                    idCreatore: FirebaseAuth.instance.currentUserId!,
                    titolo: _titoloTextController.text,
                    ingredienti: _ingredientiTextController.text,
                    numPersone: _numPersoneTextController.text.toInt(),
                    preparazione: _preparazioneTextController.text,
                    tempoPreparazione: _tempoPreparazioneTextController.text.toInt(),
                    timestampCreazione: _oldData['timestampCreazione'],
                  );
                }

                RecipeNetwork.updateRecipe(recipe);

                // Aggiorno l'immagine

                // Navigo
                Navigation.back(context);
              }
            }

        )
    );
  }

  // Button per eliminare la ricetta
  Widget deleteButton(BuildContext context) {
    return Padding(
        padding: CustomEdgeInsets.exceptTop(32),
        child: CustomButtons.delete(
            'Elimina Ricetta',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isProcessing = true;
                });

                // Elimino la ricetta
                RecipeNetwork.deleteRecipe(_oldData.id);

                // Elimino l'immagine

                // Navigo
                Navigation.backUntil(context, '/cookbook');
              }
            }

        )
    );
  }

}