import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/RecipeNetwork.dart';
import 'package:houseoftasty/network/StorageNetwork.dart';
import 'package:houseoftasty/utility/AppFontWeight.dart';
import 'package:houseoftasty/utility/Extensions.dart';
import 'package:houseoftasty/utility/ImageLoader.dart';
import 'package:houseoftasty/utility/OperationType.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/Recipe.dart';
import '../../utility/AppColors.dart';
import '../../utility/Navigation.dart';
import '../../utility/Validator.dart';
import '../../view/widget/CustomScaffold.dart';
import '../widget/CustomButtons.dart';
import '../widget/CustomEdgeInsets.dart';
import '../widget/TextWidgets.dart';
import 'CookbookPage.dart';

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
  bool _boolImmagine = false;

  bool _isProcessing = false;
  bool _initializationCompleted = false;

  late DocumentSnapshot<Object?> _oldData;
  
  Image _defaultImage = ImageLoader.asset('carica_immagine.png');
  File? _imageFile;
  Image? get _image => _imageFile != null ? ImageLoader.path(_imageFile!.path) : _defaultImage;

  OperationType _lastOperation = OperationType.NONE;

  StatefulWidget? getImage() {
    if (_lastOperation == OperationType.NONE && _boolImmagine) {
      return ImageLoader.firebaseRecipeStorageImage(widget.recipeId!);
    } else {
      return _image;
    }
  }

  void removeImage() {
    setState(() {
      _lastOperation = OperationType.REMOVED;
      _imageFile = null;
    });
  }

  void updateImage(PickedFile? pickedFile) {
    if (pickedFile != null) {
      setState(() {
        _lastOperation = OperationType.SELECTED;
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void startLoadingAnimation() {
    setState(() {
      _isProcessing = true;
    });
  }

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
      return CustomScaffold.form(
          title: title,
          body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  formBody(context),
                  createButton(context),
                ])
        )
      );
    } else if (_initializationCompleted) {
      return CustomScaffold.form(
          title: title,
          body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  formBody(context),
                  editButton(context),
                  deleteButton(context),
                ])
        )
      );
    } else {
      return CustomScaffold.form(
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
              _boolImmagine = data['boolImmagine'] as bool;
              _initializationCompleted = true;

              _oldData = data;

              return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        formBody(context),
                        editButton(context),
                        deleteButton(context),
                      ])
              );
            }),
      );
    }
  }

  Widget formBody(BuildContext context) {
    return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Titolo Immagine
                Padding(
                  padding: CustomEdgeInsets.fromLTRB(42, 32, 42, 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextWidget('Immagine',
                      textColor: AppColors.caramelBrown,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  )
                ),

                // Immagine
                Padding(
                  padding: CustomEdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                      width: double.infinity,
                      height: 160,
                      child: GestureDetector(
                          onTap: () {
                            ImageLoader.device(
                                context,
                                callback: (pickedImage) =>
                                    updateImage(pickedImage));
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: AppColors.caramelBrown,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  child:getImage()
                          )
                      ),
                    )
                  )
                ),

                // Button per rimuovere l'immagine
                if (_imageFile != null || (_lastOperation == OperationType.NONE && _boolImmagine))
                  Padding(
                      padding: CustomEdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      child: CustomButtons.delete(
                          'Rimuovi Immagine',
                          onPressed: () async {
                            removeImage();
                          }
                      )
                  ),

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
                          child: TextWidget('Ricetta pubblicata:',
                              fontWeight: AppFontWeight.semiBold,
                              textColor: AppColors.caramelBrown),

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

  // Button per creare una nuova ricetta
  Widget createButton(BuildContext context) {

    void navigateBack() {
      Navigation.back(context);
    }

    return Padding(
        padding: const EdgeInsets.all(32),
        child: CustomButtons.submit(
            'Crea Ricetta',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                startLoadingAnimation();

                // Creo la ricetta
                bool boolImmagine = _lastOperation == OperationType.SELECTED;

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
                      boolImmagine: boolImmagine,
                    ).toDocumentMap());

                // Inserisco l'immagine
                if (boolImmagine) {
                  await StorageNetwork.uploadRecipeImage(file: _imageFile!, filename: documentId);
                }

                // Navigo
                navigateBack();
              }
            }

        )
    );
  }

  // Button per salvare le modifiche alla ricetta
  Widget editButton(BuildContext context) {

    void navigateBack() {
      Navigation.back(context);
    }

    return Padding(
        padding: CustomEdgeInsets.all(32),
        child: CustomButtons.submit(
            'Salva Modifiche',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                startLoadingAnimation();

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
                    boolImmagine: _lastOperation == OperationType.SELECTED || (_lastOperation == OperationType.NONE && _boolImmagine),
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
                    boolImmagine: _lastOperation == OperationType.SELECTED || (_lastOperation == OperationType.NONE && _boolImmagine),
                    timestampCreazione: _oldData['timestampCreazione'],
                  );
                }

                await RecipeNetwork.updateRecipe(recipe);

                // Aggiorno l'immagine
                if (_lastOperation == OperationType.SELECTED) {
                  await StorageNetwork.uploadRecipeImage(file: _imageFile!, filename: _oldData.id);
                } else if (_lastOperation == OperationType.REMOVED && _boolImmagine) {
                  await StorageNetwork.deleteRecipeImage(filename: _oldData.id);
                }

                // Navigo
                navigateBack();
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
              showDialog(context: context, builder: (BuildContext context) {
                void dismissDialog() {
                  Navigation.back(context);
                }

                void navigateToCookbook() {
                  Navigation.backUntil(context, CookbookPage.route);
                }

                return AlertDialog(
                    title: Text('Conferma Eliminazione'),
                    content: Text('Sei sicuro di voler eliminare la ricetta?'),
                    actionsPadding: EdgeInsets.symmetric(horizontal: 16),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: [
                      TextButton(
                          child: Text('Sì',
                              style: TextStyle(color: AppColors.heartRed, fontSize: 18)),
                          onPressed: () async {
                            dismissDialog();
                            startLoadingAnimation();

                            // Elimino la ricetta
                            await RecipeNetwork.deleteRecipe(_oldData.id);

                            // Elimino l'immagine
                            StorageNetwork.deleteRecipeImage(filename: _oldData.id);

                            // Navigo
                            navigateToCookbook();
                          }),
                      TextButton(
                          child: Text('No',
                              style: TextStyle(color: AppColors.tawnyBrown, fontSize: 18)),
                          onPressed: () async {
                            dismissDialog();
                          }),
                    ]);
              });
            }
        )
    );
  }

}