import 'package:flutter/material.dart';
import 'package:houseoftasty/utility/AppColors.dart';

import 'CustomDrawer.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final FloatingActionButton? floatingActionButton;
  final bool withDrawer;
  final bool resize;

  const CustomScaffold({super.key, required this.title, this.resize = false, this.withDrawer = false, this.floatingActionButton, required this.body});
  const CustomScaffold.form({super.key, required this.title, this.resize = true, this.withDrawer = false, this.floatingActionButton, required this.body});
  const CustomScaffold.withDrawer({super.key, required this.title, this.resize = false, this.withDrawer = true, this.floatingActionButton, required this.body});

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.tawnyBrown,
          title: Text(title)
      ),
      backgroundColor: AppColors.sandBrown,
      body: body,
      drawer: withDrawer ? CustomDrawer() : null,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resize,
    );
  }
}