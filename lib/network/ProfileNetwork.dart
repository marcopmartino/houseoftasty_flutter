import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/Profile.dart';

class ProfileNetwork{
  static CollectionReference users = FirebaseFirestore.instance.collection('users');

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

    users.doc(FirebaseAuth.instance.currentUser!.uid).set(user.toMap()).catchError((e){
      return e;
    });

    return null;
  }
}