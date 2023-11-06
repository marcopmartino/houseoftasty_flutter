import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/ProductNetwork.dart';
import 'package:houseoftasty/network/RecipeNetwork.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';
import 'package:houseoftasty/view/page/RecipePostDetailsPage.dart';
import 'package:houseoftasty/view/widget/TextWidgets.dart';
import 'package:intl/intl.dart';

import '../../utility/AppColors.dart';
import '../../utility/AppFontWeight.dart';
import '../../utility/ImageLoader.dart';
import '../../utility/ListViewBuilders.dart';
import '../../utility/Navigation.dart';
import '../item/Item.dart';
import '../widget/CustomScaffold.dart';
import 'ProductFormPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return CustomScaffold.withDrawer(
      title: 'House of Tasty',
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.5,
                child: ImageLoader.asset('logo_big.png'),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                  color: AppColors.caramelBrown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextWidget('Prodotti in scadenza', fontSize: 22, fontWeight: AppFontWeight.extraBold, textColor: AppColors.sandBrown),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0 ,16),
                        child: QueryStreamBuilder(
                          stream: ProductNetwork.getCurrentUserProducts(),
                          builder: (BuildContext context, QuerySnapshot<Object?> data) {
                            List<QueryDocumentSnapshot<Object?>> docs = data.docs;
                            if (docs.isEmpty) {
                              return TextWidget('Nessun prodotto in scadenza', fontSize: 18, fontWeight: AppFontWeight.semiBold, textColor: AppColors.sandBrown);
                            } else {
                              List<QueryDocumentSnapshot<Object?>> expiringProducts = List.empty(growable: true);
                              for (QueryDocumentSnapshot<Object?> product in docs) {
                                String scadenza = product['scadenza'];
                                print(scadenza);
                                if (scadenza != '--/--/----') {
                                  DateTime dataScadenza = dateFormat.parse(scadenza);
                                  int timeDifference = dataScadenza.difference(DateTime.now()).inMilliseconds;
                                  int hours = (((timeDifference ~/ 1000) ~/ 60) ~/ 60);
                                  print('Ore di differenza: $hours');
                                  if (hours >= -23 && hours <= 48) {
                                    continue;
                                  } else if (hours <= -24) {
                                    expiringProducts.add(product);
                                  }
                                }
                              }
                              if (expiringProducts.isEmpty) {
                                return TextWidget('Nessun prodotto in scadenza', fontSize: 18, fontWeight: AppFontWeight.semiBold, textColor: AppColors.sandBrown);
                              } else {
                                return ListViewBuilder(
                                  data: expiringProducts,
                                  itemType: ItemType.PRODUCT,
                                  scale: 1.0,
                                  shrinkWrap: true,
                                  scrollPhysics: NeverScrollableScrollPhysics(),
                                  onTap: (QueryDocumentSnapshot<Object?> product) {
                                    Navigation.navigate(context, ProductFormPage.edit(productId: product.id));
                                  }
                              );
                              }
                            }
                          },
                        ),
                      ),
                      TextWidget('Ciao, cosa cucini oggi?', fontSize: 22, fontWeight: AppFontWeight.extraBold, textColor: AppColors.sandBrown),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                        child: QueryStreamBuilder(
                          stream: RecipeNetwork.getPublicRecipes(),
                          builder: (BuildContext context, QuerySnapshot<Object?> data) {
                            List<QueryDocumentSnapshot<Object?>> docs = data.docs;
                            if (docs.isEmpty) {
                              return TextWidget('Nessuna ricetta da mostrare', fontSize: 18, fontWeight: AppFontWeight.semiBold, textColor: AppColors.sandBrown);
                            } else {
                              List<QueryDocumentSnapshot<Object?>> recentRecipes = List.empty(growable: true);
                              // Ordina per timestamp decrescente (dal più recente)
                              docs.sort((a,b) => b['timestampPubblicazione'].toString().compareTo(a['timestampPubblicazione'].toString()));

                              int index = 0; int size = docs.length;
                              while (index < 4 && index < size) {
                                recentRecipes.add(docs[index]);
                                index++;
                              }

                              return ListViewBuilder(
                                  data: recentRecipes,
                                  itemType: ItemType.RECIPE_HOME_PREVIEW,
                                  scale: 1.5,
                                  shrinkWrap: true,
                                  scrollPhysics: NeverScrollableScrollPhysics(),
                                  onTap: (QueryDocumentSnapshot<Object?> recipe) {
                                    Navigation.navigate(context, RecipePostDetailsPage(recipeId: recipe.id));
                                  }
                              );
                            }
                          }
                        ),
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
    );
  }
}