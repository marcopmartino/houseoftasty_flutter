import 'package:flutter/material.dart';

class CustomDecoration{

  static InputDecoration inputDecoration(String nome){
    return InputDecoration(
        hintStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        labelStyle: TextStyle(color: Colors.white),
        hintText: nome);
  }

}