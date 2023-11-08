
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houseoftasty/utility/Extensions.dart';

import '../Model/Product.dart';

class ProductNetwork{

  static Future<CollectionReference<Object?>> get _products async =>
    FirebaseFirestore.instance.collection('users')
      .doc(await DeviceInfo.getCurrentUserIdOrDeviceId()).collection('products');

  static Stream<QuerySnapshot<Object?>> getCurrentUserProducts() {
    return DeviceInfo.getQueryStream((userOrDeviceId) =>
        FirebaseFirestore.instance.collection('users')
            .doc(userOrDeviceId).collection('products').snapshots()
    );
  }

  static Future<QuerySnapshot<Object?>> getCurrentUserProductsOnce() async {
    var id = await DeviceInfo.getCurrentUserIdOrDeviceId();
    return FirebaseFirestore.instance.collection('users')
            .doc(id).collection('products').get();
  }

  static Stream<DocumentSnapshot<Object?>> getProductById(String productId) {
    return DeviceInfo.getDocumentStream((userOrDeviceId) =>
        FirebaseFirestore.instance.collection('users')
            .doc(userOrDeviceId).collection('products').doc(productId).snapshots()
    );
  }

  static Future<String> addProduct(Map<String, dynamic> product) async {
    DocumentReference doc = await (await _products).add(product);
    return doc.id;
  }

  static void updateProduct(Product product) async {
    await (await _products).doc(product.id).update(product.toMap());
  }

  static void deleteProduct(String productId) async {
    await (await _products).doc(productId).delete();
  }
 }