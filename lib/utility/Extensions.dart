import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

// Extension per FirebaseAuth
extension FirebaseAuthExtended on FirebaseAuth {
  String? get currentUserId => currentUser?.uid;
  String getCurrentUserIdOrEmptyString() => currentUserId ?? '';
  String getCurrentUserIdOrNullString() => currentUserId ?? 'null';
  Future<String?> getCurrentUserIdOrDeviceId() async {
    return currentUserId ?? await DeviceInfo.deviceId;
  }
  bool isCurrentUserLoggedIn() => currentUser != null;
}

extension DeviceInfo on DeviceInfoPlugin {

  static Stream<QuerySnapshot<Object?>> getQueryStream(
      Stream<QuerySnapshot<Object?>> Function(String? userOrDeviceId) queryStream
      ) async* {
    yield* queryStream(await getCurrentUserIdOrDeviceId());
}

  static Stream<DocumentSnapshot<Object?>> getDocumentStream(
      Stream<DocumentSnapshot<Object?>> Function(String? userOrDeviceId) documentStream
      ) async* {
    yield* documentStream(await getCurrentUserIdOrDeviceId());
  }

  static Future<String?> getCurrentUserIdOrDeviceId() async {
    return FirebaseAuth.instance.currentUserId ?? await deviceId;
  }

  static Future<String?> get deviceId async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }

    return null;
  }
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

// Extension per List<dynamic>
extension ListExtended on List<dynamic> {
  List<String> toStringList() {
    List<String> stringList = List.empty(growable: true);
    for (dynamic element in this) {
      stringList.add(element.toString());
    }
    return stringList;
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

  int timeDiffSeconds() {
    return Timestamp.now().seconds - seconds;
  }

  String timeDiffToString() {
    int secondsPassed = timeDiffSeconds();
    int minutesPassed = secondsPassed ~/ 60;
    int hoursPassed = minutesPassed ~/ 60;
    int daysPassed = hoursPassed ~/ 24;
    int monthsPassed = daysPassed ~/ 30;
    int yearsPassed = daysPassed ~/ 356;
    if (secondsPassed < 60) {
      return 'Adesso';
    } else if (minutesPassed == 1) {
      return '1 minuto fa';
    } else if (minutesPassed >= 2 && minutesPassed <= 59) {
      return '$minutesPassed minuti fa';
    } else if (hoursPassed == 1) {
      return '1 ora fa';
    } else if (hoursPassed >= 2 && hoursPassed <= 23) {
      return '$hoursPassed ore fa';
    } else if (daysPassed == 1) {
      return '1 giorno fa';
    } else if (daysPassed >= 2 && daysPassed <= 29) {
      return '$daysPassed giorni fa';
    } else if (daysPassed >= 30 && daysPassed <= 59) {
      return '1 mese fa';
    } else if (daysPassed >= 60 && daysPassed <= 355) {
      return '$monthsPassed mesi fa';
    } else if (yearsPassed == 1) {
      return '1 anno fa';
    } else if (yearsPassed >= 2) {
      return '$yearsPassed anni fa';
    } else {
      return '';
    }
  }
}