import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/Product.dart';

class ProductNetwork{
  static CollectionReference products = FirebaseFirestore.instance.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid).collection('products');

  static Stream<QuerySnapshot<Object?>> productsSnapshot = products.snapshots();

  static Future<Object?> addProduct({
    required String nome,
    required String quantita,
    required String misura,
    required String scadenza}) async {

    final Map<String,dynamic> product = {
      'nome': nome,
      'quantita': quantita,
      'misura': misura,
      'scadenza': scadenza
    };

    products.add(product).catchError((e){
      return e;
    });

    return null;
  }

  static Future<Object?> editProduct({
    required String id,
    required String nome,
    required String quantita,
    required String misura,
    required String scadenza}) async {

    final Map<String,dynamic> product = {
        'nome': nome,
        'quantita': quantita,
        'misura': misura,
        'scadenza': scadenza
    };

    products.doc(id).update(product).catchError((e){
      return e;
    });

    return null;
  }

  static Future<Object?> deleteProduct({
    required String id}) async {

    products.doc(id).delete().catchError((e){
      return e;
    });

    return null;
  }

  static Future<List<Product>> getProductByUserId() async {
    List<Product> product = [];

    await products.get().then((QuerySnapshot query){
      for (var doc in query.docs) {
        product.add(doc as Product);
      }
    });

    return product;
  }

  static Future<Product> getProductById(String productId) async{
    late Product product;

    await products.doc(productId).get().then((DocumentSnapshot doc){
      product = Product(
          id: productId,
          nome: doc['nome'],
          quantita: doc['quantita'],
          misura: doc['misura'],
          scadenza: doc['scadenza']
      );
    });

    return product;
  }
}