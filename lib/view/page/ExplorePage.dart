import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/view/page/NewestPage.dart';
import 'package:houseoftasty/view/page/SearchPage.dart';

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
                    text: 'Cerca',
                  ),
                  Tab(
                    text: 'Popolari',
                  ),
                  Tab(
                      text: 'Nuovi'
                  )
                ]
            ),
            title: Text('Esplora'),
          ),
          body: TabBarView(
              children: [
                SearchPage(),
                PopularPage(),
                NewestPage()
              ]
          )
      ),
    );
  }

}