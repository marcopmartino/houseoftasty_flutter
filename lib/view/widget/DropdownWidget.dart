
import 'package:flutter/material.dart';

import '../../utility/AppColors.dart';
import 'CustomDecoration.dart';

class DropdownWidget extends StatelessWidget{

  final TextEditingController controller;
  final List<String> items;

  DropdownWidget({
    required this.controller,
    required this.items
  });


  @override
  Widget build(BuildContext context){
    return SizedBox(
        width: 90,
        child: DropdownButtonFormField(
          padding: EdgeInsets.only(top: 15, bottom: 0),
          decoration: CustomDecoration.dropDownInputDecoration(),
          style: TextStyle(
            color: Colors.black,
            fontSize:20
          ),
          dropdownColor:AppColors.sandBrown,
          iconSize: 24,
          value: controller.text,
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item));
          }).toList(),
          onChanged:(String? newValue) {
            controller.text = newValue!;
          },
        ),
    );
  }



}