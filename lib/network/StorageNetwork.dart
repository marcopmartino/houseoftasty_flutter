import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageNetwork {
  static Future<String> getDownloadURL(String filepath) {
    return FirebaseStorage.instance.ref().child(filepath).getDownloadURL();
  }
  
  static Future uploadFile({required File file, required String filepath}) async {
    await FirebaseStorage.instance.ref().child(filepath).putFile(file);
  }

  static Future uploadRecipeImage({required File file, required String filename}) async {
    await uploadFile(file: file, filepath: '/immagini_ricette/$filename');
  }

  static Future uploadProfileImage({required File file, required String filename}) async {
    await uploadFile(file: file, filepath: '/immagini_profili/$filename');
  }

  static Future deleteFile({required String filepath}) async {
    await FirebaseStorage.instance.ref().child(filepath).delete();
  }

  static Future deleteRecipeImage({required String filename}) async {
    await deleteFile(filepath: '/immagini_ricette/$filename');
  }

  static Future deleteProfileImage({required String filename}) async {
    await deleteFile(filepath: '/immagini_profili/$filename');
  }
}