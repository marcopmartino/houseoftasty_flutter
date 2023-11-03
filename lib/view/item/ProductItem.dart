import 'package:flutter/material.dart';

import '../../utility/AppColors.dart';
import '../widget/CustomDecoration.dart';
import 'Item.dart';

class ProductItem extends Item {
  ProductItem({required super.itemData});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        elevation: 5,
        color: AppColors.darkSandBrown,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  "${itemData['nome']}",
                  style: TextStyle(
                    color: AppColors.caramelBrown,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                        'Quantità: ',
                      ), //Quantita Label
                      Text(
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        "${itemData['quantita']}${itemData['misura'] == '-'? '': "${itemData['misura']}"}",
                      ), //Quantita Txt
                    ],
                  ),
                  SizedBox(
                    width: 150,
                    child: Row(
                      children: [
                        Text(
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                          ),
                          'Scadenza: ',
                        ), //Scadenza Label
                        Text(
                          style: CustomDecoration.checkData(itemData['scadenza']),
                          "${itemData['scadenza']}",
                        ), //Scadenza Txt
                      ],
                    ),
                  )


                ],
              ),
            ]
          ),
        ),
      );
  }
}
