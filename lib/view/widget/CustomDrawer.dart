import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/utility/Extensions.dart';
import 'package:houseoftasty/view/page/ProductsPage.dart';

import 'package:houseoftasty/view/page/HomePage.dart';
import 'package:houseoftasty/view/page/LoginPage.dart';
import 'package:houseoftasty/view/page/CookbookPage.dart';
import 'package:houseoftasty/view/page/ProfilePage.dart';

import '../../utility/AppColors.dart';
import '../../utility/Navigation.dart';
import '../page/ExplorePage.dart';
import '../page/RecipeCollectionsPage.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Drawer getDrawer(BuildContext context) {

    signOut() async{
      await FirebaseAuth.instance.signOut();
      if(context.mounted){
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(
                builder: (_) => LoginPage()
            ),
                (Route route) => false);
      }
    }

    ListTile homeListTile() {
      return ListTile(
        leading: Icon(Icons.home, size: 30, color: AppColors.tawnyBrown),
        title: const Text('Home'),
        onTap: () {
          // Then close the drawer
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage()),
          );
        },
      );
    }

    ListTile profileListTile() {
      return ListTile(
        leading: Icon(Icons.person, size: 30, color: AppColors.tawnyBrown),
        title: const Text('Profilo'),
        onTap: () {
          // Then close the drawer
          Navigator.pop(context);
          Navigation.navigate(context, ProfilePage(), route: ProfilePage.route);
        },
      );
    }

    ListTile exploreListTile() {
      return ListTile(
          leading: Icon(Icons.explore, size: 30, color: AppColors.tawnyBrown),
          title: Text('Esplora'),
          onTap: () {
            Navigator.pop(context);
            Navigation.navigate(context, ExplorePage(), route: ExplorePage.route);
          });
    }

    ListTile cookbookListTile() {
      return ListTile(
        leading: Icon(Icons.book, size: 30, color: AppColors.tawnyBrown),
        title: const Text('Ricettario'),
        onTap: () {
          Navigator.pop(context);
          Navigation.navigate(context, CookbookPage(), route: CookbookPage.route);
        },
      );
    }

    ListTile collectionsListTile() {
      return ListTile(
        leading: Icon(Icons.folder, size: 30, color: AppColors.tawnyBrown),
        title: const Text('Raccolte'),
        onTap: () {
          Navigator.pop(context);
          Navigation.navigate(context, RecipeCollectionsPage(), route: RecipeCollectionsPage.route);
        },
      );
    }

    ListTile productsListTile() {
      return ListTile(
          leading: Icon(Icons.apple, size: 30, color: AppColors.tawnyBrown),
          title: Text('Prodotti'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProductsPage()));
          });
    }

    ListTile loginListTile() {
      return ListTile(
        leading: Icon(Icons.login, size: 30, color: AppColors.tawnyBrown),
        title: Text('Login'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginPage()));
        },
      );
    }

    ListTile logoutListTile() {
      return ListTile(
          leading: Icon(Icons.logout, size: 30, color: AppColors.tawnyBrown),
          title: Text('Logout'),
          onTap: () {
            signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginPage()));
          });
    }

    Widget drawerHeader() {
      return const SizedBox(
        height: 200, // To change the height of DrawerHeader
        width: double.infinity, // To Change the width of DrawerHeader
        child: DrawerHeader(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo_big.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Text(''), // Child necessario per il DrawerHeader
        ),
      );
    }

    if (FirebaseAuth.instance.isCurrentUserLoggedIn()) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            drawerHeader(),
            homeListTile(),
            profileListTile(),
            exploreListTile(),
            cookbookListTile(),
            collectionsListTile(),
            productsListTile(),
            logoutListTile(),
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
            drawerHeader(),
            homeListTile(),
            exploreListTile(),
            cookbookListTile(),
            collectionsListTile(),
            productsListTile(),
            loginListTile(),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return getDrawer(context);
  }
}
