import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  late final String? id;
  final String nome;
  final String quantita;
  final String misura;
  final String scadenza;

  Product({
    this.id,
    required this.nome,
    required this.quantita,
    required this.misura,
    required this.scadenza
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'quantita': quantita,
      'misura': misura,
      'scadenza': scadenza
    };
  }

  Product.fromMap(Map<String, dynamic> productMap) :
        id = productMap['id'],
        nome = productMap['nome'],
        quantita = productMap['quantita'],
        misura = productMap['misura'],
        scadenza = productMap['scadenza'];

  Product.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc):
        id = doc.id,
        nome = doc.data()!['nome'],
        quantita = doc.data()!['quantita'],
        misura = doc.data()!['misura'],
        scadenza = doc.data()!['scadenza'];

  Product.formQueryDocumentSnapshot(QueryDocumentSnapshot<Object?> doc):
    id = doc.id,
    nome = doc['nome'],
    quantita = doc['quantita'],
    misura = doc['misura'],
    scadenza = doc['scadenza'];

}