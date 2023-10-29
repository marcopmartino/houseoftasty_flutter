import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/ProfileNetwork.dart';
import 'package:houseoftasty/network/RecipeNetwork.dart';
import 'package:houseoftasty/utility/Extensions.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';
import 'package:houseoftasty/view/page/ProfileDetailsPage.dart';
import 'package:houseoftasty/view/widget/CustomEdgeInsets.dart';

import '../../utility/AppColors.dart';
import '../../utility/ImageLoader.dart';
import '../../utility/Navigation.dart';
import '../../view/widget/CustomScaffold.dart';
import '../item/Item.dart';
import '../widget/FloatingButtons.dart';
import '../widget/TextWidgets.dart';
import 'ProfileEditPage.dart';
import 'RecipeDetailsPage.dart';
import 'RecipeFormPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const String route = 'profile';

  static const String title = 'Il tuo profilo';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: ProfilePage.title,
        body: DocumentStreamBuilder(
            stream: ProfileNetwork.getProfileInfo(),
            builder: (BuildContext builder, DocumentSnapshot<Object?> data) {

              return SingleChildScrollView(
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
                                  child: data['boolImmagine']?ImageLoader.currentUserImage():Image.asset('assets/images/icon_profile.png')
                              ),

                            ),
                            onTap: () => Navigation.navigate(context, ProfileDetailsPage())
                        ), // Immagine profilo

                        Container(
                          alignment: AlignmentDirectional.center,
                          child: Padding(
                              padding: CustomEdgeInsets.all(20), // Spaziatura esterna
                              child: TitleWidget(data['username'], fontSize: 25)
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
                          stream: RecipeNetwork.getCurrentUserRecipesPublish(),
                          itemType: ItemType.RECIPE,
                          scale: 1.5,
                          onTap: (String recipeId) {
                            Navigation.navigate(context, RecipeDetailsPage(recipeId: recipeId));
                          }
                        ) // Lista ricette pubblicate
                      ]
                  )
              );
            }),
    );
  }
}