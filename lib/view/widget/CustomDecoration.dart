import 'package:flutter/material.dart';
import 'package:houseoftasty/utility/AppFontWeight.dart';
import 'package:intl/intl.dart';

import 'package:houseoftasty/utility/AppColors.dart';

class CustomDecoration {

  static InputDecoration loginInputDecoration(String nome){
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
        filled: true,
        fillColor: AppColors.transparentCaramelBrown,
        hintText: nome);
  }

  static InputDecoration textFieldInputDecoration(String nome, String hint){
    return InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        hintStyle: TextStyle(color: Colors.black12),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: AppColors.caramelBrown,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: AppColors.caramelBrown,
          ),
        ),
        labelStyle: TextStyle(
          fontSize: 20,
          fontWeight: AppFontWeight.semiBold,
          color: AppColors.caramelBrown
        ),
        labelText: nome,
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
    );
  }

  static InputDecoration dropDownInputDecoration(){
    return InputDecoration(
      contentPadding: EdgeInsets.all(17),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: AppColors.caramelBrown,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: AppColors.caramelBrown,
        ),
      ),
      labelStyle: TextStyle(color: Colors.black),
      filled: true,
      fillColor: Colors.white,
    );
  }

  static InputDecoration dataLabelDecoration(){
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      hintStyle: TextStyle(color: Colors.black12),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: AppColors.caramelBrown,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: AppColors.caramelBrown,
        ),
      ),
      labelStyle: TextStyle(
          fontSize: 20,
          color: AppColors.caramelBrown
      ),
      labelText: 'Scadenza',
      filled: true,
      fillColor: Colors.white,
      suffixIcon: Icon(Icons.calendar_today)
    );
  }

  static TextStyle? checkData(String data){

    if(data == '--/--/----'){
      return TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold);
    }

    int diff;

    DateTime now = DateTime.now();
    DateTime date = DateFormat('dd/MM/yyyy').parse(data);
    now.isAfter(date) ? diff = 0 : diff = now.difference(date).inDays;

    int daysBetween(DateTime now, DateTime date) {
      now = DateTime(now.year, now.month, now.day);
      date = DateTime(date.year, date.month, date.day);
      return (date.difference(now).inHours / 24).round();
    }
    diff = daysBetween(now, date);
    print(diff);
    if(diff<0){
      return TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold);
    }else if(diff<=2 && diff>0){
      return TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold);
    }else if(diff>2){
      return TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold);
    }

    return null;
  }

  static ButtonStyle textButtonDecoration(bool isDelete){
    if(!isDelete) {
      return ElevatedButton.styleFrom(
        foregroundColor: AppColors.tawnyBrown,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        fixedSize: Size(250,60),
      );
    }else{
      return ElevatedButton.styleFrom(
        foregroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        fixedSize: Size(250,60),
      );
    }
  }

  static ButtonStyle submitButtonDecoration() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.tawnyBrown,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      fixedSize: Size(280,60),
    );
  }

  static ButtonStyle submitSmallButtonDecoration() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.tawnyBrown,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      fixedSize: Size(180,40),
    );
  }

  static ButtonStyle deleteButtonDecoration() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.darkRed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      fixedSize: Size(280,60),
    );
  }

  static ButtonStyle deleteSmallButtonDecoration() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.darkRed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      fixedSize: Size(180,40),
    );
  }
}