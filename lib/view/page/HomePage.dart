import 'package:flutter/material.dart';
import 'package:houseoftasty/view/widget/SelectDrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.isLogged});

  final bool isLogged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('House of Tasty')),
        body: Center(
        ),
        drawer: SelectDrawer(isLogged: widget.isLogged),
    );
  }
}