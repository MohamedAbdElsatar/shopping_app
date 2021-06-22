import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import '../screens/user_products_screen.dart';
import '../screens/order_screen.dart';

class AppDrawer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            title: Text('Shop'),
            leading: Icon(Icons.shop),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(OrederScreen.routeName);
            },
            title: Text('Orders'),
            leading: Icon(Icons.payment),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(UserProductScreen.routeName);
            },
            title: Text('Manage Product'),
            leading: Icon(Icons.edit),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();

              Provider.of<Auth>(context, listen: false).logOut();
            },
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
          )
        ],
      ),
    );
  }
}
