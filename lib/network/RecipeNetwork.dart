
import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houseoftasty/network/RecipeCollectionNetwork.dart';
import 'package:houseoftasty/utility/Extensions.dart';

import '../model/Recipe.dart';
import '../model/Comment.dart';

class RecipeNetwork {

  static CollectionReference get _recipesReference =>
      FirebaseFirestore.instance.collection('recipes');

  static Stream<QuerySnapshot<Object?>> getCurrentUserRecipes() {
    return DeviceInfo.getQueryStream((userOrDeviceId) =>
        _recipesReference.where('idCreatore', isEqualTo: userOrDeviceId).snapshots());
  }

  static Future<QuerySnapshot<Object?>> getCurrentUserRecipesOnce() async {
    return _recipesReference.where('idCreatore',
        isEqualTo: await DeviceInfo.getCurrentUserIdOrDeviceId()).get();
  }

  static Stream<QuerySnapshot<Object?>> getCurrentUserPublishedRecipes() {
    return DeviceInfo.getQueryStream((userOrDeviceId) =>
        _recipesReference
            .where('idCreatore', isEqualTo: userOrDeviceId)
            .where('boolPubblicata', isEqualTo: true).snapshots());
  }

  static Stream<QuerySnapshot<Object?>> getRecipesByIdList(List<String> recipeIds) {
    return DeviceInfo.getQueryStream((userOrDeviceId) =>
        _recipesReference.where(FieldPath.documentId, whereIn: recipeIds).snapshots());
  }

  static Future<QuerySnapshot<Object?>> getRecipesByIdListOnce(List<String> recipeIds) {
    return _recipesReference.where(FieldPath.documentId, whereIn: recipeIds).get();
  }

  static Future<QuerySnapshot<Object?>> getRecipesNotInIdListOnce(List<String> recipeIds) async {
    if (recipeIds.isEmpty) {
      return getCurrentUserRecipesOnce();
    } else {
      return _recipesReference
          .where('idCreatore', isEqualTo: await DeviceInfo.getCurrentUserIdOrDeviceId())
          .where(FieldPath.documentId, whereNotIn: recipeIds)
          .get();
    }

  }

  static Stream<DocumentSnapshot<Object?>> getRecipeDetails(String recipeId) {
    return _recipesReference.doc(recipeId).snapshots();
  }

  static Future<DocumentSnapshot<Object?>> getRecipeDetailsOnce(String recipeId) {
    return _recipesReference.doc(recipeId).get();
  }

  static Stream<QuerySnapshot<Object?>> getPublicRecipes() {
    return DeviceInfo.getQueryStream((userOrDeviceId) =>
        _recipesReference.where(
            Filter.and(
                Filter('boolPostPrivato', isEqualTo: false),
                Filter('boolPubblicata', isEqualTo: true),
                Filter('idCreatore', isNotEqualTo: userOrDeviceId)
      )
    ).snapshots());
  }

  static Stream<QuerySnapshot<Object?>> getUserPublicRecipes(String userId) {
    return _recipesReference.where(
        Filter.and(
            Filter('boolPostPrivato', isEqualTo: false),
            Filter('boolPubblicata', isEqualTo: true),
            Filter('idCreatore', isEqualTo: userId)
        )
    ).snapshots();
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
    RecipeCollectionNetwork.removeRecipeFromAllSaveCollections(recipeId);
  }

  static Future incrementViews(String recipeId) async {
    await _recipesReference.doc(recipeId).update({
      'views': FieldValue.increment(1)
    });
  }

  static Future addLike(String recipeId, String userId) async {
    await _recipesReference.doc(recipeId).update({
      'likeCounter': FieldValue.increment(1),
      'likes': FieldValue.arrayUnion([userId])
    });
  }

  static Future removeLike(String recipeId, String userId) async {
    await _recipesReference.doc(recipeId).update({
      'likeCounter': FieldValue.increment(-1),
      'likes': FieldValue.arrayRemove([userId])
    });
  }

  static Future addDownload(String recipeId, String userId) async {
    await _recipesReference.doc(recipeId).update({
      'downloadCounter': FieldValue.increment(1),
      'downloads': FieldValue.arrayUnion([userId])
    });
  }

  static Future removeDownload(String recipeId, String userId) async {
    await _recipesReference.doc(recipeId).update({
      'downloadCounter': FieldValue.increment(-1),
      'downloads': FieldValue.arrayRemove([userId])
    });
  }

  static Stream<QuerySnapshot<Object?>> getComments(String recipeId) {
    return _recipesReference.doc(recipeId).collection('comments').snapshots();
  }

  static Future addComment(String recipeId, Comment comment) async {
    DocumentReference recipeReference = _recipesReference.doc(recipeId);
    await recipeReference.update({'commentCounter': FieldValue.increment(1)});
    await recipeReference.collection('comments').add(comment.toDocumentMap());
  }

  static Future removeComment(String recipeId, String commentId) async {
    DocumentReference recipeReference = _recipesReference.doc(recipeId);
    await recipeReference.update({'commentCounter': FieldValue.increment(-1)});
    await recipeReference.collection('comments').doc(commentId).delete();
  }

}