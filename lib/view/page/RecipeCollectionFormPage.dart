import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/model/RecipeCollection.dart';
import 'package:houseoftasty/network/RecipeCollectionNetwork.dart';
import 'package:houseoftasty/network/RecipeNetwork.dart';
import 'package:houseoftasty/utility/AppFontWeight.dart';
import 'package:houseoftasty/utility/Extensions.dart';
import 'package:houseoftasty/utility/ListViewBuilders.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';
import '../../utility/AppColors.dart';
import '../../utility/Navigation.dart';
import '../../utility/Validator.dart';
import '../../view/widget/CustomScaffold.dart';
import '../item/Item.dart';
import '../widget/CustomButtons.dart';
import '../widget/CustomEdgeInsets.dart';
import '../widget/TextWidgets.dart';
import 'RecipeCollectionsPage.dart';

class RecipeCollectionFormPage extends StatefulWidget {
  RecipeCollectionFormPage({super.key}) {
    newRecipeCollection = true;
  }

  static const String route = 'recipeForm';

  RecipeCollectionFormPage.edit({super.key, required this.recipeCollectionId}) {
    newRecipeCollection = false;
  }

  late final String? recipeCollectionId;
  late final bool newRecipeCollection;

  @override
  State<RecipeCollectionFormPage> createState() => _RecipeCollectionFormState();
}

class _RecipeCollectionFormState extends State<RecipeCollectionFormPage> {


  final _formKey = GlobalKey<FormState>();

  final _nomeTextController = TextEditingController();

  List<String> _recipeIds = List.empty(growable: true);
  int get _recipeIdsSize => _recipeIds.length;

  bool _isProcessing = false;
  bool _initializationCompleted = false;
  bool _showingSelectionPage = false;

  late DocumentSnapshot<Object?> _oldData;

  void startLoadingAnimation() {
    setState(() {
      _isProcessing = true;
    });
  }

  void navigateToSelectionPage() {
    setState(() {
      _showingSelectionPage = true;
    });
  }

  void navigateToFormPage(String? recipeId) {
    setState(() {
      _showingSelectionPage = false;
      if (recipeId != null) {
        addId(recipeId);
      }
    });
  }

  void removeId(recipeId) {
    setState(() {
      _recipeIds.remove(recipeId);
    });
  }

  void addId(recipeId) {
    setState(() {
      _recipeIds.add(recipeId);
    });
  }

  Future<bool> onWillPop() async {
    if (_showingSelectionPage) {
      navigateToFormPage(null);
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = _showingSelectionPage ? 'Aggiungi Ricetta' : (widget.newRecipeCollection ? 'Nuova Raccolta' : 'Modifica Raccolta');

    return WillPopScope(
        onWillPop: () => onWillPop(),
        child: CustomScaffold.form(
            title: title,
            body: scaffoldBody(context)
        )
    );
  }

  Widget scaffoldBody(BuildContext context) {
    if (_isProcessing) {
      // Animazione di caricamento
      return Center(
          child: CircularProgressIndicator(
              color: AppColors.tawnyBrown
          )
      );

    } else if (_showingSelectionPage) {
      // Lista delle ricette che non fanno parte della raccolta
      return FutureListViewBuilder(
          future: RecipeNetwork.getRecipesNotInIdListOnce(_recipeIds),
          itemType: ItemType.RECIPE,
          scale: 1.5,
          onTap: (QueryDocumentSnapshot<Object?> recipe) {
            navigateToFormPage(recipe.id);
          }
      );

    } else if (widget.newRecipeCollection) {
      // Form vuota di creazione di una nuova raccolta
      return SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                formBody(context),
                createButton(context),
              ])
      );

    } else if (_initializationCompleted) {
      // Form con i dati di una raccolta
      return SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                formBody(context),
                editButton(context),
                deleteButton(context),
              ])
      );
      
    } else {
      // Inizializza lo stato e mostra una form con i dati di una raccolta
      return DocumentStreamBuilder(
          stream: RecipeCollectionNetwork.getRecipeCollectionDetails(widget.recipeCollectionId!),
          builder: (BuildContext builder, DocumentSnapshot<Object?> data) {

            _nomeTextController.text = data['nome'];
            _recipeIds = (data['listaRicette'] as List<dynamic>).toStringList();
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
          }
      );
    }
  }

  Widget formBody(BuildContext context) {

    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Nome
            Padding(
              padding: CustomEdgeInsets.fromLTRB(32, 40, 32, 24),
              child: TextFormFieldWidget(
                  controller: _nomeTextController,
                  validator: (value) => Validator.validateRecipeCollectionName(value: value),
                  label: 'Nome',
                  hint:'Inserire il nome della raccolta'
              ),
            ),

            // Titolo della sezione con la lista delle ricette
            Padding(
              padding: CustomEdgeInsets.fromLTRB(32, 16, 32, 0),
              child: SizedBox(
                  width: double.infinity,
                  child: TextWidget('Ricette:',
                      fontSize: 18,
                      fontWeight: AppFontWeight.semiBold,
                      textColor: AppColors.caramelBrown
                  )
              )
            ),

            // Widget per aggiungere una ricetta alla raccolta
            Padding(
                padding: CustomEdgeInsets.fromLTRB(32, 8, 32, 16),
                child: GestureDetector(
                    onTap: () => navigateToSelectionPage(),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.caramelBrown),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget('Aggiungi ricetta',
                                  fontSize: 18,
                                  fontWeight: AppFontWeight.semiBold,
                                  textColor: AppColors.caramelBrown
                              ),
                              Icon(Icons.add, color: AppColors.caramelBrown)
                            ]
                        )
                    )
                )
            ),

            // Lista delle ricette
            _recipeIdsSize != 0 ?
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: FutureListViewBuilder(
                  future: RecipeNetwork.getRecipesByIdListOnce(_recipeIds),
                  scale: 0.0,
                  itemType: ItemType.RECIPE_COLLECTION_FORM,
                  onTap: (QueryDocumentSnapshot<Object?> recipe) {

                    showDialog(context: context, builder: (BuildContext context) {
                      void dismissDialog() {
                        Navigation.back(context);
                      }

                      // Dialog per confermare la rimozione della ricetta
                      return AlertDialog(
                          title: Text('Rimozione Ricetta'),
                          content: Text('Sei sicuro di voler rimuovere la ricetta dalla raccolta?'),
                          actionsPadding: EdgeInsets.symmetric(horizontal: 16),
                          actionsAlignment: MainAxisAlignment.spaceAround,
                          actions: [
                            TextButton(
                                child: Text('Sì',
                                    style: TextStyle(color: AppColors.heartRed, fontSize: 18)),
                                onPressed: () async {
                                  dismissDialog();
                                  setState(() {
                                    removeId(recipe.id);
                                  });

                                }),
                            TextButton(
                                child: Text('No',
                                    style: TextStyle(color: AppColors.tawnyBrown, fontSize: 18)),
                                onPressed: () async {
                                  dismissDialog();
                                }),
                          ]);
                    });
                  },
                )
            ) : Container()
          ] ,
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
            'Crea Raccolta',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                startLoadingAnimation();

                // Creo la raccolta
                await RecipeCollectionNetwork.addRecipeCollection(
                    RecipeCollection(
                      nome: _nomeTextController.text,
                      listaRicette: _recipeIds,
                    ).toDocumentMap());

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
                await RecipeCollectionNetwork.updateRecipeCollection(
                    RecipeCollection(
                      id: _oldData.id,
                      nome: _nomeTextController.text,
                      timestampCreazione: _oldData['timestampCreazione'],
                      listaRicette: _recipeIds
                    )
                );

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
            'Elimina Raccolta',
            onPressed: () async {
              showDialog(context: context, builder: (BuildContext context) {
                void dismissDialog() {
                  Navigation.back(context);
                }

                void navigateToCookbook() {
                  Navigation.backUntil(context, RecipeCollectionsPage.route);
                }

                return AlertDialog(
                    title: Text('Conferma Eliminazione'),
                    content: Text('Sei sicuro di voler eliminare la raccolta?'),
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
                            await RecipeCollectionNetwork.deleteRecipeCollection(_oldData.id);

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