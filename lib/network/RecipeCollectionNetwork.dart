import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houseoftasty/utility/Extensions.dart';

import '../model/RecipeCollection.dart';

class RecipeCollectionNetwork {
  static Future<CollectionReference<Object?>> get _recipeCollectionsReference async =>
      FirebaseFirestore.instance.collection('users')
          .doc(await DeviceInfo.getCurrentUserIdOrDeviceId()).collection('collections');

  static Stream<QuerySnapshot<Object?>> getCurrentUserRecipeCollections() {
    return DeviceInfo.getQueryStream((userOrDeviceId) =>
        FirebaseFirestore.instance.collection('users')
            .doc(userOrDeviceId).collection('collections').snapshots()
    );
  }

  static Future<QuerySnapshot<Object?>> getCurrentUserRecipeCollectionsOnce() async {
    return (await _recipeCollectionsReference).get();
  }

  static Stream<DocumentSnapshot<Object?>> getRecipeCollectionDetails(String recipeCollectionId) {
    return DeviceInfo.getDocumentStream((userOrDeviceId) =>
        FirebaseFirestore.instance.collection('users')
            .doc(userOrDeviceId).collection('collections').doc(recipeCollectionId).snapshots()
    );
  }

  static Future<String> addRecipeCollection(Map<String, dynamic> recipeCollection) async {
    DocumentReference docRef = await (await _recipeCollectionsReference).add(recipeCollection);
    return docRef.id;
  }

  static Future updateRecipeCollection(RecipeCollection recipeCollection) async {
    await (await _recipeCollectionsReference).doc(recipeCollection.id).update(recipeCollection.toDocumentMap());
  }

  static Future deleteRecipeCollection(String recipeCollectionId) async {
    await (await _recipeCollectionsReference).doc(recipeCollectionId).delete();
  }

  static Future removeFromRecipeCollection(String recipeCollectionId, String recipeId) async {
    await (await _recipeCollectionsReference).doc(recipeCollectionId).update({
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

  static Future addRecipeToSaveCollection(String recipeId) async {
    DocumentReference saveCollectionReference = (await _recipeCollectionsReference).doc('saveCollection');
    DocumentSnapshot<Object?>? saveCollection = await saveCollectionReference.get();

    // Se la raccolta delle ricette salvate non esiste, la creo
    if (!saveCollection.exists) {
      await saveCollectionReference.set(RecipeCollection(nome: 'Salvati').toDocumentMap());
    }

    // Aggiungo la ricetta alla lista di quelle salvate
    await saveCollectionReference.update({'listaRicette': FieldValue.arrayUnion([recipeId])});
  }

  static Future removeRecipeFromSaveCollection(String recipeId) async {
    DocumentReference saveCollectionReference = (await _recipeCollectionsReference).doc('saveCollection');

    // Rimuovo la ricetta dalla lista di quelle salvate
    await saveCollectionReference.update({'listaRicette': FieldValue.arrayRemove([recipeId])});
  }

  static Future removeRecipeFromAllSaveCollections(String recipeId) async {
    CollectionReference usersReference = FirebaseFirestore.instance.collection('users');
    usersReference.get().then((collection) {
      for (QueryDocumentSnapshot userDocument in collection.docs) {
        // Rimuovo la ricetta dalla lista di quelle salvate
        usersReference
            .doc(userDocument.id)
            .collection('collections')
            .doc('saveCollection')
            .update({'listaRicette': FieldValue.arrayRemove([recipeId])});
      }
    });
  }

}