import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  late final String? id;
  final String nome;
  final String cognome;
  final String email;
  final String username;
  final bool boolImmagine;

  Profile({
    this.id,
    required this.nome,
    required this.cognome,
    required this.email,
    required this.username,
    required this.boolImmagine
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cognome': cognome,
      'email': email,
      'password': username,
      'boolImmagine': boolImmagine,
    };
  }

  Profile.fromMap(Map<String, dynamic> profileMap) :
    id = profileMap['id'],
    nome = profileMap['nome'],
    cognome = profileMap['cognome'],
    email = profileMap['email'],
    username = profileMap['username'],
    boolImmagine = profileMap['boolImmagine'];

  Profile.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc):
    id = doc.id,
    nome = doc.data()!['nome'],
    cognome = doc.data()!['cognome'],
    email = doc.data()!['email'],
    username = doc.data()!['username'],
    boolImmagine = doc.data()!['boolImmagine'];

}