import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import '../screens/product_detials_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    final authToken =Provider.of<Auth>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(product.title),
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (cnxt, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? (Icons.favorite) : (Icons.favorite_border),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggelefavoriteState(authToken.token,authToken.userId);
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Item added to cart'),
                action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    }),
              ));
            },
          ),
        ),
      ),
    );
  }
}
