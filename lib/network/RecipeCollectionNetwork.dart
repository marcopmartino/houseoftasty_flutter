import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:houseoftasty/utility/Extensions.dart';

import '../model/RecipeCollection.dart';

class RecipeCollectionNetwork {
  static CollectionReference get _recipeCollectionsReference =>
      FirebaseFirestore.instance.collection('users')
          .doc(FirebaseAuth.instance.currentUserId!).collection('collections');

  static Stream<QuerySnapshot<Object?>> getCurrentUserRecipeCollections() {
    return _recipeCollectionsReference.snapshots();
  }

  static Future<QuerySnapshot<Object?>> getCurrentUserRecipeCollectionsOnce() {
    return _recipeCollectionsReference.get();
  }

  static Stream<DocumentSnapshot<Object?>> getRecipeCollectionDetails(String recipeCollectionId) {
    return _recipeCollectionsReference.doc(recipeCollectionId).snapshots();
  }

  static Future<String> addRecipeCollection(Map<String, dynamic> recipe) async {
    DocumentReference docRef = await _recipeCollectionsReference.add(recipe);
    return docRef.id;
  }

  static Future updateRecipeCollection(RecipeCollection recipeCollection) async {
    await _recipeCollectionsReference.doc(recipeCollection.id).update(recipeCollection.toDocumentMap());
  }

  static Future deleteRecipeCollection(String recipeCollectionId) async {
    await _recipeCollectionsReference.doc(recipeCollectionId).delete();
  }

  static Future removeFromRecipeCollection(String recipeCollectionId, String recipeId) async {
    await _recipeCollectionsReference.doc(recipeCollectionId).update({
      'listaRicette': FieldValue.arrayRemove([recipeId])
    });
  }

  static Future removeFromRecipeCollections(String recipeId) async {
    getCurrentUserRecipeCollectionsOnce().then((snapshot) {
      List<QueryDocumentSnapshot> documents = snapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        removeFromRecipeCollection(document.id, recipeId);
      }
    });
  }

}