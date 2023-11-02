import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeCollection {
  String? id;
  String nome;
  late Timestamp timestampCreazione;
  late List<String> listaRicette;

  RecipeCollection({
    this.id,
    required this.nome,
    Timestamp? timestampCreazione,
    List<dynamic>? listaRicette,
  }) {
    this.timestampCreazione = timestampCreazione ?? Timestamp.now();
    this.listaRicette = (listaRicette ?? List.empty(growable: true)).cast<String>();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'timestampCreazione': timestampCreazione,
      'listaRicette': listaRicette,
    };
  }

  Map<String, dynamic> toDocumentMap() {
    return {
      'nome': nome,
      'timestampCreazione': timestampCreazione,
      'listaRicette': listaRicette,
    };
  }

  RecipeCollection.fromMap(Map<String, dynamic> recipeMap):
        id = recipeMap['id'],
        nome = recipeMap['nome'],
        timestampCreazione = recipeMap['timestampCreazione'],
        listaRicette = recipeMap['listaRicette'];

  RecipeCollection.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc):
        id = doc.id,
        nome = doc.data()!['nome'],
        timestampCreazione = doc.data()!['timestampCreazione'],
        listaRicette = doc.data()!['listaRicette'];

  RecipeCollection.fromQueryDocumentSnapshot(QueryDocumentSnapshot<Object?> doc):
        id = doc.id,
        nome = doc['nome'],
        timestampCreazione = doc['timestampCreazione'],
        listaRicette = doc['listaRicette'];

}