import 'package:flutter/material.dart';
import 'package:houseoftasty/view/page/NewestPage.dart';
import 'package:houseoftasty/view/page/SearchPage.dart';

import '../../utility/AppColors.dart';
import '../../utility/AppFontWeight.dart';
import '../widget/CustomDrawer.dart';
import '../widget/TextWidgets.dart';
import 'PopularPage.dart';


class ExplorePage extends StatelessWidget{

  static const String title = 'Esplora';

  static const String route = '/explore';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    child: TextWidget('Cerca'.toUpperCase(), textColor: Colors.white, fontWeight: AppFontWeight.semiBold)
                  ),
                  Tab(
                    child: TextWidget('Popolari'.toUpperCase(), textColor: Colors.white, fontWeight: AppFontWeight.semiBold)
                  ),
                  Tab(
                    child: TextWidget('Nuovi'.toUpperCase(), textColor: Colors.white, fontWeight: AppFontWeight.semiBold)
                  )
                ]
              ),
              title: Text('Esplora'),
              backgroundColor: AppColors.tawnyBrown
          ),
        body: TabBarView(
              children: [
                SearchPage(),
                PopularPage(),
                NewestPage()
              ]
          ),
        drawer: CustomDrawer(),
      ),
    );
  }

}