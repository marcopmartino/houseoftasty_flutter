
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/Product.dart';

class ProductNetwork{

  static CollectionReference _products =
    FirebaseFirestore.instance.collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid).collection('products');

  static Stream<QuerySnapshot<Object?>> getProductByUserId() {
    return _products.snapshots();
  }

  static Stream<DocumentSnapshot<Object?>> getProductById(String productId) {
    return _products.doc(productId).snapshots();
  }

  static Future<String> addProduct(Map<String, dynamic> product) async {
    DocumentReference doc = await _products.add(product);
    return doc.id;
  }

  static void updateProduct(Product product) async {
    await _products.doc(product.id).update(product.toMap());
  }

  static void deleteProduct(String productId) async {
    await _products.doc(productId).delete();
  }

 }