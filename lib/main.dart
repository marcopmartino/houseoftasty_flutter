import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:houseoftasty/utility/AppColors.dart';
import 'package:houseoftasty/view/page/CookbookPage.dart';
import 'package:houseoftasty/view/page/ExplorePage.dart';
import 'package:houseoftasty/view/page/ProductsPage.dart';
import 'package:houseoftasty/view/page/ProfilePage.dart';

import 'firebase_options.dart';

import '/view/page/HomePage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: 'House of Tasty',
    theme: ThemeData(
      primarySwatch: AppColors.getMaterialColor(AppColors.caramelBrown),
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      ProfilePage.route: (context) => ProfilePage(),
      ProductsPage.route: (context) => ProductsPage(),
      CookbookPage.route: (context) => CookbookPage(),
      ExplorePage.route: (context) => ExplorePage(),
    },
  ));
}



