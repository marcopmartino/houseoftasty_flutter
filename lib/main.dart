
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:houseoftasty/utility/AppColors.dart';
import 'package:houseoftasty/utility/ScheduledFunction.dart';
import 'package:houseoftasty/view/page/CookbookPage.dart';
import 'package:houseoftasty/view/page/ExplorePage.dart';
import 'package:houseoftasty/view/page/ProductsPage.dart';
import 'package:houseoftasty/view/page/ProfilePage.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

import 'firebase_options.dart';

import '/view/page/HomePage.dart';

const fetchBackground = 'fetchBackground';

@pragma('vm:entry-point')
void alarmStarter(String code) async{
  await AndroidAlarmManager.periodic(const Duration(days: 1), 104, ScheduledFunction.checkExpire);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AndroidAlarmManager.initialize();

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

  FlutterIsolate.spawn(alarmStarter, '');

}



