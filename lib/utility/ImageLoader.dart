
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houseoftasty/utility/Extensions.dart';

import '../network/StorageNetwork.dart';
import 'AppColors.dart';

class ImageLoader {
  static Image asset(String fileName) {
    return Image.asset(fit: BoxFit.cover, 'assets/images/$fileName');
  }

  static Image defaultRecipe() {
    return asset('kitchen_background_01.jpg');
  }

  static Image defaultProfile() {
    return asset('user_image_default.png');
  }

  static Future<Image> _getStorageImageURL(String filepath) async {
    return Image.network(fit: BoxFit.cover, await StorageNetwork.getDownloadURL(filepath));
  }

  static FutureBuilder<Image> fromStorage(String filepath, Image defaultImage) {
    return FutureBuilder<Image>(
        future: _getStorageImageURL(filepath),
        builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppColors.tawnyBrown));
          } else {
            return snapshot.data ?? defaultImage;
          }
        }
    );
  }

  static FutureBuilder<Image> fromRecipeStorage(String recipeId) {
    return fromStorage('immagini_ricette/$recipeId', defaultRecipe());
  }

  static FutureBuilder<Image> fromProfileStorage(String userId) {
    return fromStorage('immagini_profili/$userId', defaultProfile());
  }

  static FutureBuilder<Image> currentUser() {
    return fromProfileStorage(FirebaseAuth.instance.currentUserId!);
  }
}