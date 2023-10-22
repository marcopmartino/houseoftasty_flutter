import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../HomePage.dart';
import '../LoginPage.dart';

class SelectDrawer extends StatelessWidget {
  const SelectDrawer({super.key, required this.isLogged});

  final bool isLogged;


  Drawer drawerType(BuildContext context) {
    signOut() async{
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(isLogged: false)));
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
                    image: AssetImage('assets/logo_big.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(''), //Child necessario per il DrawerHeader
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
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
                leading: Icon(Icons.explore),
                title: Text('Esplora'),
                onTap: () {
                  Navigator.pop(context);
                }),
            ListTile(
              leading: Icon(Icons.folder),
              title: const Text('Raccolte'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
                leading: Icon(Icons.apple),
                title: Text('Prodotti'),
                onTap: () {
                  Navigator.pop(context);
                }),
            ListTile(
              leading: Icon(Icons.logout),
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
                    image: AssetImage('assets/logo_big.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(''), //Child necessario per il DrawerHeader
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
                leading: Icon(Icons.explore),
                title: Text('Esplora'),
                onTap: () {
                  Navigator.pop(context);
                }),
            ListTile(
              leading: Icon(Icons.book),
              title: const Text('Ricettario'),
              onTap: () {
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: const Text('Raccolte'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
                leading: Icon(Icons.apple),
                title: Text('Prodotti'),
                onTap: () {
                  Navigator.pop(context);
                }),
            ListTile(
                leading: Icon(Icons.logout),
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
