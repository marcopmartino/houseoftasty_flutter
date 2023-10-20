
import 'package:flutter/material.dart';

import 'package:houseoftasty/utility/SelectDrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required this.isLogged});

  final String title;
  final bool isLogged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
        ),
        drawer: SelectDrawer(isLogged: widget.isLogged),
    );
  }
}