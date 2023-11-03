import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/ProfileNetwork.dart';
import 'package:houseoftasty/network/RecipeNetwork.dart';
import 'package:houseoftasty/utility/AppFontWeight.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';
import 'package:houseoftasty/view/page/ProfileDetailsPage.dart';
import 'package:houseoftasty/view/widget/CustomEdgeInsets.dart';

import '../../utility/AppColors.dart';
import '../../utility/ImageLoader.dart';
import '../../utility/Navigation.dart';
import '../../view/widget/CustomScaffold.dart';
import '../item/Item.dart';
import '../widget/TextWidgets.dart';
import 'RecipePostDetailsPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.userId});

  static const String route = 'profile';

  final String? userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    bool currentUser = widget.userId == null;

    return CustomScaffold(
      withDrawer: currentUser,
        title: currentUser ? 'Il tuo profilo' : 'Profilo utente',
        body: DocumentStreamBuilder(
            stream: currentUser ? ProfileNetwork.getCurrentUserInfo() : ProfileNetwork.getUserInfo(widget.userId!),
            builder: (BuildContext builder, DocumentSnapshot<Object?> data) {

              return SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                      mainAxisSize: MainAxisSize.min ,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(left:125, right: 125, top: 30, bottom: 30),
                              width: 150,
                              height: 150,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: data['boolImmagine']?ImageLoader.currentUserImage():Image.asset('assets/images/user_image_default.png')
                              ),

                            ),
                            onTap: () => currentUser ? Navigation.navigate(context, ProfileDetailsPage()) : { }
                        ), // Immagine profilo

                        Container(
                          alignment: AlignmentDirectional.center,
                          child: Padding(
                              padding: CustomEdgeInsets.exceptTop(20), // Spaziatura esterna
                              child: TextWidget(data['username'],
                                  fontSize: 25,
                                  fontWeight: AppFontWeight.semiBold,
                                  textColor: AppColors.caramelBrown)
                          ),
                        ), //Nome profilo

                        Container(
                            width: double.infinity,
                            height: 30,
                            alignment: AlignmentDirectional.center,
                            color: AppColors.caramelBrown,
                            child: TitleWidget.formButton('Ricette pubblicate', fontSize: 15)
                        ), //Divider 'Ricette pubblicate'

                        ListViewStreamBuilder(
                          stream: currentUser ? RecipeNetwork.getCurrentUserPublishedRecipes() : RecipeNetwork.getUserPublicRecipes(widget.userId!),
                          itemType: ItemType.RECIPE_POST,
                          scale: 1.5,
                          shrinkWrap: true,
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          onTap: (QueryDocumentSnapshot<Object?> recipe) {
                            Navigation.navigate(context, RecipePostDetailsPage(recipeId: recipe.id));
                          }
                        ) // Lista ricette pubblicate
                      ]
                  ),
              );
            }),
    );
  }
}