import 'package:flutter/material.dart';
import 'package:houseoftasty/view/widget/CustomDrawer.dart';

import '../../utility/AppColors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('House of Tasty'),
          backgroundColor: AppColors.tawnyBrown),
        body: Center(),
        drawer: CustomDrawer(),
    );
  }
}