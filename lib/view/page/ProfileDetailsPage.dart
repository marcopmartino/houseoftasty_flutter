import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/ProfileNetwork.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';
import 'package:houseoftasty/view/page/ProfileEditPage.dart';
import 'package:houseoftasty/view/widget/CustomEdgeInsets.dart';

import '../../utility/AppColors.dart';
import '../../utility/ImageLoader.dart';
import '../../utility/Navigation.dart';
import '../../view/widget/CustomScaffold.dart';
import '../widget/FloatingButtons.dart';
import '../widget/TextWidgets.dart';

class ProfileDetailsPage extends StatefulWidget {

  static const String route = 'profileDetails';

  static const String title = 'Profilo';

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPage();
}

class _ProfileDetailsPage extends State<ProfileDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: ProfileDetailsPage.title,
        body: DocumentStreamBuilder(
            stream: ProfileNetwork.getProfileInfo(),
            builder: (BuildContext builder, DocumentSnapshot<Object?> data) {


              return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Immagine
                        Container(
                          margin: EdgeInsets.only(left:125, right: 125, top: 30, bottom: 30),
                          width: 150,
                          height: 150,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: data['boolImmagine']?ImageLoader.currentUserImage():Image.asset('assets/images/icon_profile.png')
                          ),

                        ), //Immagine profilo

                        Container(
                            width: double.infinity,
                            height: 30,
                            alignment: AlignmentDirectional.center,
                            color: AppColors.caramelBrown,
                            child: TitleWidget.formButton('Dettagli profilo', fontSize: 15)
                        ), //Divider 'Dettagli profilo'


                        // Sezione Username
                        Padding(
                            padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                            child: TitleWidget('Username', fontSize: 18)
                        ),
                        Padding(
                            padding: CustomEdgeInsets.only(left:16, right:16), // Spaziatura esterna
                            child: TextWidget(data['username'], fontSize: 14)
                        ),

                        // Sezione email
                        Padding(
                            padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                            child: TitleWidget('Email', fontSize: 18)
                        ),
                        Padding(
                          padding: CustomEdgeInsets.only(left:16, right:16),  // Spaziatura esterna
                          child: TextWidget(data['email'], fontSize: 14)
                        ),

                        // Sezione nome
                        Padding(
                            padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                            child: TitleWidget('Nome', fontSize: 18)
                        ),
                        Padding(
                          padding: CustomEdgeInsets.only(left:16, right:16),  // Spaziatura esterna
                          child: TextWidget(data['nome'], fontSize: 14)
                        ),

                        // Sezione cognome
                        Padding(
                            padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                            child: TitleWidget('Cognome', fontSize: 18)
                        ),
                        Padding(
                            padding: CustomEdgeInsets.only(left:16, right:16, bottom:16),  // Spaziatura esterna
                            child: TextWidget(data['cognome'], fontSize: 14)
                        ),

                        Container(
                            width: double.infinity,
                            height: 30,
                            alignment: AlignmentDirectional.center,
                            color: AppColors.caramelBrown,
                            child: TitleWidget.formButton('Statistiche', fontSize: 15)
                        ), //Divider 'Statistiche'

                        // Sezione visualizzazioni profilo
                        Padding(
                            padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                            child: TitleWidget('Visualizzazioni profilo', fontSize: 18)
                        ),
                        Padding(
                            padding: CustomEdgeInsets.only(left:16, right:16), // Spaziatura esterna
                            child: TextWidget('123', fontSize: 14)
                        ),

                        // Sezione ricette pubblicate
                        Padding(
                            padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                            child: TitleWidget('Ricette pubblicate', fontSize: 18)
                        ),
                        Padding(
                            padding: CustomEdgeInsets.only(left:16, right:16),  // Spaziatura esterna
                            child: TextWidget('123', fontSize: 14)
                        ),

                        // Sezione totale visualizzazioni ricette
                        Padding(
                            padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                            child: TitleWidget('Totale visualizzazioni ricette', fontSize: 18)
                        ),
                        Padding(
                            padding: CustomEdgeInsets.only(left:16, right:16),  // Spaziatura esterna
                            child: TextWidget('123', fontSize: 14)
                        ),

                        // Sezione totale mi piace ricette
                        Padding(
                            padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                            child: TitleWidget('Totale mi piace ricette', fontSize: 18)
                        ),
                        Padding(
                            padding: CustomEdgeInsets.only(left:16, right:16, bottom:16),  // Spaziatura esterna
                            child: TextWidget('123', fontSize: 14)
                        ),

                        // Sezione totale commenti ricette
                        Padding(
                            padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                            child: TitleWidget('Totale commenti ricette', fontSize: 18)
                        ),
                        Padding(
                            padding: CustomEdgeInsets.only(left:16, right:16),  // Spaziatura esterna
                            child: TextWidget('123', fontSize: 14)
                        ),

                        // Sezione totale download ricette
                        Padding(
                            padding: CustomEdgeInsets.exceptBottom(16), // Spaziatura esterna
                            child: TitleWidget('Totale download ricette', fontSize: 18)
                        ),
                        Padding(
                            padding: CustomEdgeInsets.only(left:16, right:16, bottom:16),  // Spaziatura esterna
                            child: TextWidget('123', fontSize: 14)
                        ),
                      ]
                  )
              );
            }),
        floatingActionButton: FloatingActionButtons.edit(
            onPressed: () => Navigation.navigate(context, ProfileEditPage())
        )
    );
  }
}