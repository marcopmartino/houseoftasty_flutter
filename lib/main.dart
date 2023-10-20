import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'HomePage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.deepOrange,
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'House of Tasty';

  @override
  Widget build(BuildContext context) {
    var isLogged = FirebaseAuth.instance.currentUser != null;
    return HomePage(title: appTitle, isLogged: isLogged);
  }
}

