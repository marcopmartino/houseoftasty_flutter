
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/utility/Extensions.dart';
import 'package:image_picker/image_picker.dart';

import '../network/StorageNetwork.dart';
import 'AppColors.dart';
import 'Navigation.dart';

class ImageLoader {

  // Metodi statici
  static Image asset(String fileName) {
    return Image.asset(fit: BoxFit.cover, 'assets/images/$fileName');
  }

  static Image defaultRecipe() {
    return asset('kitchen_background_01.jpg');
  }

  static Image defaultProfile() {
    return asset('user_image_default.png');
  }

  static Image file(File file) {
    return Image.file(fit: BoxFit.cover, file);
  }

  static Image path(String path) {
    return Image.file(fit: BoxFit.cover, File(path));
  }

  // Funzioni per ottenere immagini dallo Storage
  static Future<Image> _getStorageImage(String filepath) async {
    return Image.network(fit: BoxFit.cover, await StorageNetwork.getDownloadURL(filepath));
  }

  static FutureBuilder<Image> firebaseStorageImage(String filepath, Image defaultImage) {
    return FutureBuilder<Image>(
        future: _getStorageImage(filepath),
        builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppColors.tawnyBrown));
          } else {
            return snapshot.data ?? defaultImage;
          }
        }
    );
  }

  static FutureBuilder<Image> firebaseRecipeStorageImage(String recipeId) {
    return firebaseStorageImage('immagini_ricette/$recipeId', defaultRecipe());
  }

  static FutureBuilder<Image> firebaseProfileStorageImage(String userId) {
    return firebaseStorageImage('immagini_profili/$userId', defaultProfile());
  }

  static FutureBuilder<Image> currentUserImage() {
    return firebaseProfileStorageImage(FirebaseAuth.instance.currentUserId!);
  }

  // Funzioni per ottenere immagini dal dispositivo
  static Future device(BuildContext context, {required Function(PickedFile? pickedImage) callback}) {
    return _showSelectionDialog(context, callback);
  }

  // Funzione per ottenere un'immagine
  static Future<PickedFile?> _getImage({required ImageSource source}) async {
    return await ImagePicker().getImage(source: source);
  }

  // Funzione per ottenere un'immagine dalla galleria
  static Future<PickedFile?> _getImageFromGallery() async {
    return await _getImage(source: ImageSource.gallery);
  }

  // Funzione per ottenere un'immagine dalla fotocamera
  static Future<PickedFile?> _getImageFromCamera() async {
    return await _getImage(source: ImageSource.camera);
  }

  static Future _showSelectionDialog(BuildContext context, Function(PickedFile? pickedImage) callback) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {

          void dismissDialog() {
            Navigation.back(context);
          }

          return AlertDialog(
              title: Text('Selezione Immagine'),
              content: Text("Scatta una foto o scegli un'immagine dalla galleria."),
              actionsPadding: EdgeInsets.symmetric(horizontal: 16),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                    child: Text('Fotocamera', style: TextStyle(color: AppColors.tawnyBrown)),
                    onPressed:  () async {
                      callback(await _getImageFromCamera());
                      dismissDialog();
                    }),
                TextButton(
                    child: Text('Galleria', style: TextStyle(color: AppColors.tawnyBrown)),
                    onPressed: () async {
                      callback(await _getImageFromGallery());
                      dismissDialog();
                    }),
                TextButton(
                    child: Text('Annulla', style: TextStyle(color: AppColors.heartRed)),
                    onPressed: () {
                      dismissDialog();
                    }),
              ]);
    });
  }

}
