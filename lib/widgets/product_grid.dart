import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool favProductStatus;
  ProductGrid(this.favProductStatus);
  @override
  Widget build(BuildContext context) {
    final productdata = Provider.of<ProductsProvider>(context);
    final product =
        favProductStatus ? productdata.favoriteItem : productdata.getItems;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: product.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 2,
          crossAxisCount: 2),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: product[index],

        // create: (cx) => product[index],
        child: ProductItem(
            // product[index].title,
            // product[index].id,
            ),
      ),
    );
  }
}
