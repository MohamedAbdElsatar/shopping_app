import 'package:flutter/material.dart';
import 'package:shop_app/screens/order_screen.dart';

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
              Navigator.of(context).pushNamed(OrederScreen.routeName);
            },
            title: Text(
              'Orders',
            ),
            leading: Icon(
              Icons.payment,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            title: Text('Shop'),
            leading: Icon(
              Icons.shop,
            ),
          )
        ],
      ),
    );
  }
}
