import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? id;
  String userId;
  String text;
  late Timestamp timestamp;

  Comment({
    this.id,
    required this.userId,
    required this.text,
    Timestamp? timestamp
  }) {
    this.timestamp = timestamp ?? Timestamp.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'timestamp': timestamp,
      'text': text,
    };
  }

  Map<String, dynamic> toDocumentMap() {
    return {
      'userId': userId,
      'timestamp': timestamp,
      'text': text,
    };
  }

  Comment.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc):
        id = doc.id,
        userId = doc.data()!['userId'],
        timestamp = doc.data()!['timestamp'],
        text = doc.data()!['text'];

  Comment.fromQueryDocumentSnapshot(QueryDocumentSnapshot<Object?> doc):
        id = doc.id,
        userId = doc['userId'],
        timestamp = doc['timestamp'],
        text = doc['text'];
}

