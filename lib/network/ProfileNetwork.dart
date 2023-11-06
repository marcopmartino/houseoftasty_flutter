import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/Profile.dart';
import '../utility/Extensions.dart';

class ProfileNetwork{
  static DocumentReference _user = FirebaseFirestore.instance.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  static createUserIfNotExists(String? userId) async {
    DocumentReference userReference = FirebaseFirestore.instance.collection('users').doc(userId);
    await userReference.get().then((document) async => {
      if (!document.exists) {
        await userReference.set({})
      }
    });
  }

  static createDeviceUserIfNotExists() async {
    createUserIfNotExists(await DeviceInfo.deviceId);
  }

  static Future<Object?> addUser({
      required String nome,
      required String cognome,
      required String email,
      required String username}) async {

    final Profile user = Profile(
      nome: nome,
      cognome: cognome,
      email: email,
      username: username,
      boolImmagine: false
    );

    _user.set(user.toMap()).catchError((e){
      return e;
    });

    return null;
  }

  static Stream<DocumentSnapshot<Object?>> getCurrentUserInfo() {
    return _user.snapshots();
  }

  static Stream<DocumentSnapshot<Object?>> getUserInfo(String userId) {
    return FirebaseFirestore.instance.collection('users')
        .doc(userId).snapshots();
  }

  static Future<DocumentSnapshot<Object?>> getUserInfoOnce(String userId) {
    return FirebaseFirestore.instance.collection('users')
        .doc(userId).get();
  }

  static void updateProfile(Profile user){
    _user.update(user.toMap());
  }
}