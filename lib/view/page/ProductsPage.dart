import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/view/page/EditProductPage.dart';
import 'package:houseoftasty/utility/AppColors.dart';
import 'package:houseoftasty/view/widget/CustomDecoration.dart';

import 'AddProductPage.dart';
import '../../network/ProductNetwork.dart';

class ProductsPage extends StatefulWidget {

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}


class _ProductsPageState extends State<ProductsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('I miei prodotti'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                      builder: (_) => AddProductPage(),
                    ));
          },
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: ProductNetwork.productsSnapshot,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                color: AppColors.sandBrown,
                child: ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return SizedBox(
                      height: 80,
                      child: GestureDetector(
                        child: Card(
                          margin: EdgeInsets.all(10),
                          elevation: 5,
                          color: AppColors.darkSandBrown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                            child: ListTile(
                              title: Text(
                                "${doc['nome']}",
                                style: TextStyle(
                                  color: AppColors.caramelBrown,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    'Quantità: ',
                                  ), //Quantita Label
                                  Text(
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    "${doc['quantita']}${doc['misura']}",
                                  ), //Quantita Txt
                                  SizedBox(width: 80,),
                                  Text(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w200,
                                    ),
                                    'Scadenza: ',
                                  ), //Scadenza Label
                                  Text(
                                    style: CustomDecoration.checkData(doc['scadenza']),
                                    "${doc['scadenza']}",
                                  ), //Scadenza Txt
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () =>
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (_) => EditProductPage(productId: doc.id),
                              )),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          },
        )
    );
  }

  void onTap(item) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$item is selected'),
    ));
  }
}
