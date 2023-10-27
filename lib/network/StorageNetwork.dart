import 'package:firebase_storage/firebase_storage.dart';

class StorageNetwork {
  static Future<String> getDownloadURL(String filepath) {
    return FirebaseStorage.instance.ref().child(filepath).getDownloadURL();
  }

}