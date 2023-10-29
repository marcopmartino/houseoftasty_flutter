import 'package:flutter/material.dart';
import 'package:houseoftasty/view/page/ProductFormPage.dart';

import '../../utility/Navigation.dart';
import '../../utility/StreamBuilders.dart';
import '../item/Item.dart';
import '../widget/CustomScaffold.dart';
import '../widget/FloatingButtons.dart';
import '../../network/ProductNetwork.dart';

class ProductsPage extends StatefulWidget {

  static const String title = 'I miei prodotti';

  static const String route = '/products';


  @override
  State<ProductsPage> createState() => _ProductsPageState();
}


class _ProductsPageState extends State<ProductsPage> {

  @override
  Widget build(BuildContext context) {
    return CustomScaffold.withDrawer(
      title: ProductsPage.title,
      body:
      ListViewStreamBuilder(
          stream: ProductNetwork.getProductByUserId(),
          itemType: ItemType.PRODUCT,
          scale: 1.0,
          onTap: (String productId) {
            Navigation.navigate(context, ProductFormPage.edit(productId: productId));
          }
      ),
      floatingActionButton: FloatingActionButtons.add(
        onPressed: () => Navigation.navigate(context, ProductFormPage()),
      ),
    );
  }
}
