
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

// Extension per FirebaseAuth
extension FirebaseAuthExtended on FirebaseAuth {
  String? get currentUserId => currentUser?.uid;
  String getCurrentUserIdOrEmptyString() => currentUserId ?? '';
  String getCurrentUserIdOrNullString() => currentUserId ?? 'null';
  bool isCurrentUserLoggedIn() => currentUser != null;
}

// Extension per int
extension IntExtended on int {
  String toPreparationTime() {
    return preparationTime(minutes: this);
  }

  static String preparationTime({required int minutes}) {
    var stringBuilder = StringBuffer();
    var hours = 0;
    if (minutes >= 60) {
      hours = minutes ~/ 60;
      stringBuilder.write('$hours h ');
    }
    stringBuilder.write('${minutes - hours * 60} min');
    return stringBuilder.toString();
  }
}

// Extension per String
extension StringExtended on String {
  int toInt() => int.parse(this);
  int toIntOrZero() => int.tryParse(this) ?? 0;
  int? toIntOrNull() => int.tryParse(this);
  static String empty() => '';
}

// Extension per Timestamp
extension TimestampExtended on Timestamp {
  Map<String,String> toDateTime() {
    final DateTime datetime = toDate();
    return <String, String>{
      'date': DateFormat('dd/MM/yyyy').format(datetime),
      'time': DateFormat('HH:mm').format(datetime)
    };
  }
}