import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/view/page/ProductsPage.dart';

import 'package:houseoftasty/view/page/HomePage.dart';
import 'package:houseoftasty/view/page/LoginPage.dart';
import 'package:houseoftasty/view/page/CookbookPage.dart';

import '../../utility/AppColors.dart';
import '../../utility/Navigation.dart';

class SelectDrawer extends StatelessWidget {
  const SelectDrawer({super.key, required this.isLogged});

  final bool isLogged;


  Drawer drawerType(BuildContext context) {

    signOut() async{
      await FirebaseAuth.instance.signOut();
      if(context.mounted){
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(
                builder: (_) => HomePage(isLogged: false)
            ),
                (Route route) => false);
      }
    }

    if (!isLogged) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 200, // To change the height of DrawerHeader
              width: double.infinity, // To Change the width of DrawerHeader
              child: DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo_big.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(''), //Child necessario per il DrawerHeader
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: AppColors.tawnyBrown),
              title: const Text('Home'),
              onTap: () {
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage(isLogged: false)),
                );
              },
            ),
            ListTile(
                leading: Icon(Icons.explore, color: AppColors.tawnyBrown),
                title: Text('Esplora'),
                onTap: () {
                  Navigator.pop(context);
                }),
            ListTile(
              leading: Icon(Icons.book, color: AppColors.tawnyBrown),
              title: const Text('Ricettario'),
              onTap: () {
                Navigator.pop(context);
                Navigation.navigate(context, CookbookPage(), route: CookbookPage.route);
              },
            ),
            ListTile(
              leading: Icon(Icons.folder, color: AppColors.tawnyBrown),
              title: const Text('Raccolte'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
                leading: Icon(Icons.apple, color: AppColors.tawnyBrown),
                title: Text('Prodotti'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProductsPage()));
                }),
            ListTile(
              leading: Icon(Icons.login, color: AppColors.tawnyBrown),
              title: Text('Login'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      );
    } else {
      return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 200, // To change the height of DrawerHeader
              width: double.infinity, // To Change the width of DrawerHeader
              child: DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo_big.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(''), //Child necessario per il DrawerHeader
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: AppColors.tawnyBrown),
              title: const Text('Home'),
              onTap: () {
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
                leading: Icon(Icons.explore, color: AppColors.tawnyBrown),
                title: Text('Esplora'),
                onTap: () {
                  Navigator.pop(context);
                }),
            ListTile(
              leading: Icon(Icons.book, color: AppColors.tawnyBrown),
              title: const Text('Ricettario'),
              onTap: () {
                Navigator.pop(context);
                Navigation.navigate(context, CookbookPage(), route: CookbookPage.route);
              },
            ),
            ListTile(
              leading: Icon(Icons.folder, color: AppColors.tawnyBrown),
              title: const Text('Raccolte'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
                leading: Icon(Icons.apple, color: AppColors.tawnyBrown),
                title: Text('Prodotti'),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ProductsPage()));
                }),
            ListTile(
                leading: Icon(Icons.logout, color: AppColors.tawnyBrown),
                title: Text('Logout'),
                onTap: () {
                  signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return drawerType(context);
  }
}
