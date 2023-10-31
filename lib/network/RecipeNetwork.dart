
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:houseoftasty/network/RecipeCollectionNetwork.dart';
import 'package:houseoftasty/utility/Extensions.dart';

import '../model/Recipe.dart';

class RecipeNetwork {
  static CollectionReference get _recipesReference =>
      FirebaseFirestore.instance.collection('recipes');

  static Stream<QuerySnapshot<Object?>> getCurrentUserRecipes() {
    return _recipesReference.where('idCreatore',
        isEqualTo: FirebaseAuth.instance.currentUserId).snapshots();
  }

  static Future<QuerySnapshot<Object?>> getCurrentUserRecipesOnce() {
    return _recipesReference.where('idCreatore',
        isEqualTo: FirebaseAuth.instance.currentUserId).get();
  }

  static Stream<QuerySnapshot<Object?>> getCurrentUserPublishedRecipes() {
    return _recipesReference.where('idCreatore',
        isEqualTo: FirebaseAuth.instance.currentUserId).where('boolPubblicata', isEqualTo: true).snapshots();
  }

  static Stream<QuerySnapshot<Object?>> getRecipesByIdList(List<String> recipeIds) {
    return _recipesReference.where(FieldPath.documentId, whereIn: recipeIds).snapshots();
  }

  static Future<QuerySnapshot<Object?>> getRecipesByIdListOnce(List<String> recipeIds) {
    return _recipesReference.where(FieldPath.documentId, whereIn: recipeIds).get();
  }

  static Future<QuerySnapshot<Object?>> getRecipesNotInIdListOnce(List<String> recipeIds) {
    if (recipeIds.isEmpty) {
      return getCurrentUserRecipesOnce();
    } else {
      return _recipesReference
          .where('idCreatore', isEqualTo: FirebaseAuth.instance.currentUserId)
          .where(FieldPath.documentId, whereNotIn: recipeIds)
          .get();
    }

  }

  static Stream<DocumentSnapshot<Object?>> getRecipeDetails(String recipeId) {
    return _recipesReference.doc(recipeId).snapshots();
  }

  static Future<String> addRecipe(Map<String, dynamic> recipe) async {
    DocumentReference docRef = await _recipesReference.add(recipe);
    return docRef.id;
  }

  static Future updateRecipe(Recipe recipe) async {
    await _recipesReference.doc(recipe.id).update(recipe.toDocumentMap());
  }

  static Future deleteRecipe(String recipeId) async {
    await _recipesReference.doc(recipeId).delete();
    await RecipeCollectionNetwork.removeFromRecipeCollections(recipeId);
  }

}