import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/RecipeCollectionNetwork.dart';
import 'package:houseoftasty/network/RecipeNetwork.dart';
import 'package:houseoftasty/utility/Extensions.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';
import 'package:houseoftasty/view/item/Item.dart';
import 'package:houseoftasty/view/page/ProfilePage.dart';
import 'package:houseoftasty/view/page/RecipeDetailsPage.dart';
import 'package:houseoftasty/view/widget/CustomEdgeInsets.dart';
import 'package:houseoftasty/model/Comment.dart';

import '../../network/ProfileNetwork.dart';
import '../../utility/AppColors.dart';
import '../../utility/AppFontWeight.dart';
import '../../utility/ImageLoader.dart';
import '../../utility/Navigation.dart';
import '../../utility/Validator.dart';
import '../../view/widget/CustomScaffold.dart';
import '../widget/TextWidgets.dart';

class RecipePostDetailsPage extends StatefulWidget {
  const RecipePostDetailsPage({super.key, required this.recipeId});

  static const String title = RecipeDetailsPage.title;

  final String recipeId;

  @override
  State<RecipePostDetailsPage> createState() => _RecipePostDetailsState();
}

class _RecipePostDetailsState extends State<RecipePostDetailsPage> {


  // Stringhe
  late String _recipeSubtitle;
  late String idCreatore;
  String currentUserId = FirebaseAuth.instance.currentUserId!;

  // Booleani
  bool _isCurrentUserRecipe = false;
  bool _privatePost = false;
  bool _initializationCompleted = false;
  bool _incrementationCompleted = false;
  bool _isSaved = false;
  bool _isLiked = false;

  // Contatori
  late int _viewCounter = 0;
  late int _likeCounter = 0;
  late int _downloadCounter = 0;
  late int _commentCounter = 0;

  // Icone
  IconData likeIcon = CupertinoIcons.heart_fill;
  IconData downloadIcon = CupertinoIcons.star_fill;
  Color likeIconColor = AppColors.caramelBrown;
  Color downloadIconColor = AppColors.caramelBrown;

  // Snapshot della ricetta
  late DocumentSnapshot<Object?> _recipeData;

  // Keys e Controllers
  final _formKey = GlobalKey<FormState>();
  final _commentSectionTitleKey = GlobalKey();
  final _commentoTextController = TextEditingController();

  // Divisore tra le sezioni della vista
  Divider divider = const Divider(
    height: 2,
    thickness: 2,
    indent: 0,
    endIndent: 0,
    color: Colors.white,
  );

  void toggleLike() {
    setState(() {
      if (_isLiked) {
        RecipeNetwork.removeLike(widget.recipeId, idCreatore);
        _likeCounter--;
        setNotLikedIcon();
      } else {
        RecipeNetwork.addLike(widget.recipeId, idCreatore);
        _likeCounter++;
        setLikedIcon();
      }

      _isLiked = !_isLiked;
    });
  }

  void setLikedIcon() {
    likeIcon = CupertinoIcons.heart_fill;
    likeIconColor = AppColors.heartRed;
  }

  void setNotLikedIcon() {
    likeIcon = CupertinoIcons.heart;
    likeIconColor = AppColors.caramelBrown;
  }

  void toggleDownload() {
    setState(() {
      if (_isSaved) {
        RecipeNetwork.removeDownload(widget.recipeId, idCreatore);
        _downloadCounter--;
        setNotSavedIcon();
        RecipeCollectionNetwork.removeRecipeFromSaveCollection(widget.recipeId);
      } else {
        RecipeNetwork.addDownload(widget.recipeId, idCreatore);
        _downloadCounter++;
        setSavedIcon();
        RecipeCollectionNetwork.addRecipeToSaveCollection(widget.recipeId);
      }

      _isSaved = !_isSaved;
    });

  }

  void setSavedIcon() {
    downloadIcon = CupertinoIcons.star_fill;
    downloadIconColor = CupertinoColors.systemYellow;
  }

  void setNotSavedIcon() {
    downloadIcon = Icons.star_outline;
    downloadIconColor = AppColors.caramelBrown;
  }

  void createComment() {
    String commentText = _commentoTextController.text.trim();
    if (commentText.isNotEmpty) {
      setState(() {
        FocusManager.instance.primaryFocus?.unfocus(); // Nascondo la tastiera a schermo
        _commentoTextController.text = ''; // Svuoto il campo di testo
        Comment newComment = Comment(
            userId: currentUserId,
            text: commentText
        );
        RecipeNetwork.addComment(widget.recipeId, newComment);
        _commentCounter++;
      });
    }
  }

  void deleteComment(String commentId) {
    setState(() {
      RecipeNetwork.removeComment(widget.recipeId, commentId);
      _commentCounter--;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: RecipePostDetailsPage.title,
        resize: true,
        body: _initializationCompleted ? scaffoldBody() :
     DocumentStreamBuilder(
          stream: RecipeNetwork.getRecipeDetails(widget.recipeId),
          builder: (BuildContext builder, DocumentSnapshot<Object?> data) {

            // Controllo se il creatore della ricetta è l'utente che la sta visualizzando
            idCreatore = data['idCreatore'];
            _isCurrentUserRecipe = idCreatore == currentUserId;

            // Incremento le visualzzazioni
            if (!_isCurrentUserRecipe && !_incrementationCompleted) {
              _incrementationCompleted = true;
              RecipeNetwork.incrementViews(widget.recipeId);
            }

            // Estraggo il dato sulla privatezza del post
            _privatePost = data['boolPostPrivato'] as bool;

            // Estraggo data e ora dal Timestamp di Firestore
            final Map datetime = (data['timestampPubblicazione'] as Timestamp)
                .toDateTime();
            final formattedDate = datetime['date'];
            final formattedTime = datetime['time'];

            // Inizializzo i contatori
            _viewCounter = data['views'] ?? 0;
            _likeCounter = data['likeCounter'] ?? 0;
            _commentCounter = data['commentCounter'] ?? 0;
            _downloadCounter = data['downloadCounter'] ?? 0;

            // Controllo se l'utente ha già messo like o salvato la ricetta
            _isLiked = (data['likes'] as List).contains(idCreatore);
            _isSaved = (data['downloads'] as List).contains(idCreatore);

            // Inizializzo le icone
            if (!_isCurrentUserRecipe) {
              _isLiked ? setLikedIcon() : setNotLikedIcon();
              _isSaved ? setSavedIcon() : setNotSavedIcon();
            }

            // Salvo i dati della ricetta
            _recipeData = data;

            _initializationCompleted = true;

            // Determino quale testo mostrare come sottotitolo della ricetta
            if (_isCurrentUserRecipe) {
              _recipeSubtitle = 'Pubblicata in data $formattedDate alle $formattedTime';
              return scaffoldBody();
            } else {
              return DocumentStreamBuilder(
                  stream: ProfileNetwork.getUserInfo(idCreatore),
                  builder: (BuildContext builder, DocumentSnapshot<Object?> profileData) {
                    _recipeSubtitle = (profileData['username'] + ' - $formattedDate alle $formattedTime');
                    return scaffoldBody();
                  });
            }
          })
        );
  }

  Widget scaffoldBody() {
          return SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Immagine
                    SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: ImageLoader.firebaseRecipeStorageImage(widget.recipeId)
                    ),

                    // Sezione titolo e informazioni principali
                    Padding(
                        padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                        child: TitleWidget(_recipeData['titolo'], fontSize: 20)
                    ),
                    Padding(
                      padding: CustomEdgeInsets.symmetric(horizontal:16), // Spaziatura esterna
                      child: TextWidget(_recipeSubtitle),
                    ),
                    Padding(
                      padding: CustomEdgeInsets.exceptTop(16), // Spaziatura esterna
                      child: _privatePost ? TextWidget('Post privato', fontSize: 15) : Container(),
                    ),
                    divider,

                    // Sezione Statistiche
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
                      child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child:
                              // Visualizzazioni
                              IconTextWidget(
                                  text: _viewCounter.toString(),
                                  icon: Icons.remove_red_eye, iconSize: 40.0, iconColor: AppColors.caramelBrown,
                              ),
                            ),


                            // Like
                            IconTextWidget(
                              text: _likeCounter.toString(),
                              icon: likeIcon, iconSize: 40.0, iconColor: likeIconColor,
                              onIconTap: () {
                                if (!_isCurrentUserRecipe) { toggleLike(); }
                              } ,
                            ),
                          ]
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                        child: Row(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child:
                                // Commenti
                                IconTextWidget(
                                  text: _commentCounter.toString(),
                                  icon: Icons.comment, iconSize: 40.0, iconColor: AppColors.caramelBrown,
                                  onIconTap: () {
                                    Scrollable.ensureVisible(_commentSectionTitleKey.currentContext!);
                                  },
                                )
                            ),

                            // Salvati
                            IconTextWidget(
                                text: _downloadCounter.toString(),
                                icon: downloadIcon, iconSize: 40.0, iconColor: downloadIconColor,
                                onIconTap: () {
                                  if (!_isCurrentUserRecipe) { toggleDownload(); }
                                }
                            )
                          ],
                        )
                    ),
                    divider,

                    // Sezione Ingredienti
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
                              TextWidget(_recipeData['numPersone'].toString(), fontSize: 18)
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: CustomEdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: TextWidget(_recipeData['ingredienti'].toString().replaceAll(', ', '\n'))
                    ),
                    divider,

                    // Sezione Preparazione
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
                              TextWidget(IntExtended.preparationTime(minutes: _recipeData['tempoPreparazione']), fontSize: 18)
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: CustomEdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: TextWidget(_recipeData['preparazione'])
                    ),
                    divider,

                    // Sezione Commenti
                    Padding(
                        key: _commentSectionTitleKey,
                        padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                        child: TitleWidget('Commenti')
                    ),
                    _isCurrentUserRecipe ? Container(padding: EdgeInsets.symmetric(vertical: 8)) :
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: CustomEdgeInsets.only(top: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.symmetric(horizontal: BorderSide(width: 2.0, color: AppColors.caramelBrown))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.25,
                                  child: TextFormFieldWidget.multiline(
                                      controller: _commentoTextController,
                                      validator: (value) => Validator.validateRequired(value: value?.trim()),
                                      decoration: InputDecoration(
                                        floatingLabelAlignment: FloatingLabelAlignment.start,
                                        hintStyle: TextStyle(color: Colors.black12),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        labelStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: AppFontWeight.semiBold,
                                            color: AppColors.caramelBrown
                                        ),
                                        hintText: 'Scrivi un commento',
                                      )
                                  ),
                              ),
                              GestureDetector(
                                child: Icon(Icons.send, color: Colors.black, size: 35),
                                onTap: () {
                                  createComment();
                                },
                              )
                            ],
                          ),
                        )
                      ),
                    ),
                    DismissibleListViewStreamBuilder(
                      stream: RecipeNetwork.getComments(widget.recipeId),
                      scale: 0,
                      itemType: ItemType.COMMENT,
                      shrinkWrap: true,
                      scrollPhysics: NeverScrollableScrollPhysics(),
                      filterFunction: (List<QueryDocumentSnapshot<Object?>> data) {
                        data.sort((a,b) => b['timestamp'].toString().compareTo(a['timestamp'].toString()));
                        return data;
                      },
                      onTap: (QueryDocumentSnapshot<Object?> comment) {
                        String creatorId = comment['userId'];
                        if (currentUserId != creatorId) {
                          Navigation.navigate(context, ProfilePage(userId: creatorId));
                        }
                        },
                      dismissPolicy: (QueryDocumentSnapshot<Object?> itemData) {
                        return itemData['userId'] == currentUserId;
                      },
                      onDismiss: (String commentId) => deleteComment(commentId),
                    )
                  ]
              )
          );
        }
}