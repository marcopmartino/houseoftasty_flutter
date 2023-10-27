
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:houseoftasty/utility/Extensions.dart';

import '../model/Recipe.dart';

class RecipeNetwork {
  static CollectionReference get _recipesReference =>
      FirebaseFirestore.instance.collection('recipes');

  static Stream<QuerySnapshot<Object?>> getCurrentUserRecipes() {
    return _recipesReference.where('idCreatore',
        isEqualTo: FirebaseAuth.instance.currentUserId).snapshots();
  }

  static Stream<DocumentSnapshot<Object?>> getRecipeDetails(String recipeId) {
    return _recipesReference.doc(recipeId).snapshots();
  }

  static Future<String> addRecipe(Map<String, dynamic> recipe) async {
    DocumentReference docRef = await _recipesReference.add(recipe);
    return docRef.id;
  }

  static void updateRecipe(Recipe recipe) async {
    await _recipesReference.doc(recipe.id).update(recipe.toDocumentMap());
  }

  static void deleteRecipe(String recipeId) async {
    await _recipesReference.doc(recipeId).delete();
  }

}