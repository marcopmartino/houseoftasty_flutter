import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String? id;
  String idCreatore;
  String titolo;
  String ingredienti;
  int numPersone;
  String preparazione;
  int tempoPreparazione;
  bool boolPubblicata;
  bool boolPostPrivato;
  bool boolImmagine;
  late Timestamp timestampCreazione;
  Timestamp? timestampPubblicazione;
  int views;
  late List<String> downloads;
  int downloadCounter;
  late List<String>? likes;
  int likeCounter;
  int commentCounter;
  String? nomeCreatore;

  Recipe({
    this.id,
    required this.idCreatore,
    required this.titolo,
    required this.ingredienti,
    required this.numPersone,
    required this.preparazione,
    required this.tempoPreparazione,
    this.boolPubblicata = false,
    this.boolPostPrivato = false,
    this.boolImmagine = false,
    Timestamp? timestampCreazione,
    this.timestampPubblicazione,
    this.views = 0,
    List<dynamic>? downloads,
    this.downloadCounter = 0,
    List<dynamic>? likes,
    this.likeCounter = 0,
    this.commentCounter = 0,
    this.nomeCreatore
  }) {
    this.timestampCreazione = timestampCreazione ?? Timestamp.now();
    this.downloads = (downloads ?? List.empty()).cast<String>();
    this.likes = (likes ?? List.empty()).cast<String>();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCreatore': idCreatore,
      'titolo': titolo,
      'ingredienti': ingredienti,
      'numPersone': numPersone,
      'preparazione': preparazione,
      'tempoPreparazione': tempoPreparazione,
      'boolPubblicata': boolPubblicata,
      'boolPostPrivato': boolPostPrivato,
      'boolImmagine': boolImmagine,
      'timestampCreazione': timestampCreazione,
      'timestampPubblicazione': timestampPubblicazione,
      'views': views,
      'downloads': downloads,
      'downloadCounter': downloadCounter,
      'likes': likes,
      'likeCounter': likeCounter,
      'commentCounter': commentCounter,
      'nomeCreatore': nomeCreatore,
    };
  }

  Map<String, dynamic> toDocumentMap() {
    return {
      'idCreatore': idCreatore,
      'titolo': titolo,
      'ingredienti': ingredienti,
      'numPersone': numPersone,
      'preparazione': preparazione,
      'tempoPreparazione': tempoPreparazione,
      'boolPubblicata': boolPubblicata,
      'boolPostPrivato': boolPostPrivato,
      'boolImmagine': boolImmagine,
      'timestampCreazione': timestampCreazione,
      'timestampPubblicazione': timestampPubblicazione,
      'views': views,
      'downloads': downloads,
      'downloadCounter': downloadCounter,
      'likes': likes,
      'likeCounter': likeCounter,
      'commentCounter': commentCounter,
    };
  }

  Recipe.fromMap(Map<String, dynamic> recipeMap):
        id = recipeMap['id'],
        idCreatore = recipeMap['nomeCreatore'],
        titolo = recipeMap['titolo'],
        ingredienti = recipeMap['ingredienti'],
        numPersone = recipeMap['numPersone'],
        preparazione = recipeMap['preparazione'],
        tempoPreparazione = recipeMap['tempoPreparazione'],
        boolPubblicata = recipeMap['boolPubblicata'],
        boolPostPrivato = recipeMap['boolPostPrivato'],
        boolImmagine = recipeMap['boolImmagine'],
        timestampCreazione = recipeMap['timestampCreazione'],
        timestampPubblicazione = recipeMap['timestampPubblicazione'],
        views = recipeMap['views'],
        downloads = recipeMap['downloads'],
        downloadCounter = recipeMap['downloadCounter'],
        likes = recipeMap['likes'],
        likeCounter = recipeMap['likeCounter'],
        commentCounter = recipeMap['commentCounter'],
        nomeCreatore = recipeMap['nomeCreatore'];

  Recipe.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc):
        id = doc.id,
        idCreatore = doc.data()!['nomeCreatore'],
        titolo = doc.data()!['titolo'],
        ingredienti = doc.data()!['ingredienti'],
        numPersone = doc.data()!['numPersone'],
        preparazione = doc.data()!['preparazione'],
        tempoPreparazione = doc.data()!['tempoPreparazione'],
        boolPubblicata = doc.data()!['boolPubblicata'],
        boolPostPrivato = doc.data()!['boolPostPrivato'],
        boolImmagine = doc.data()!['boolImmagine'],
        timestampCreazione = doc.data()!['timestampCreazione'],
        timestampPubblicazione = doc.data()!['timestampPubblicazione'],
        views = doc.data()!['views'],
        downloads = doc.data()!['downloads'],
        downloadCounter = doc.data()!['downloadCounter'],
        likes = doc.data()!['likes'],
        likeCounter = doc.data()!['likeCounter'],
        commentCounter = doc.data()!['commentCounter'];

  Recipe.fromQueryDocumentSnapshot(QueryDocumentSnapshot<Object?> doc):
        id = doc.id,
        idCreatore = doc['nomeCreatore'],
        titolo = doc['titolo'],
        ingredienti = doc['ingredienti'],
        numPersone = doc['numPersone'],
        preparazione = doc['preparazione'],
        tempoPreparazione = doc['tempoPreparazione'],
        boolPubblicata = doc['boolPubblicata'],
        boolPostPrivato = doc['boolPostPrivato'],
        boolImmagine = doc['boolImmagine'],
        timestampCreazione = doc['timestampCreazione'],
        timestampPubblicazione = doc['timestampPubblicazione'],
        views = doc['views'],
        downloads = doc['downloads'],
        downloadCounter = doc['downloadCounter'],
        likes = doc['likes'],
        likeCounter = doc['likeCounter'],
        commentCounter = doc['commentCounter'];

}