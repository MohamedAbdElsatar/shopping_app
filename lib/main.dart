import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import './providers/cart.dart';
import './providers/order.dart';
import './screens/Cart_screen.dart';
import './screens/order_screen.dart';
import './providers/products_provider.dart';
import './screens/product_detials_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (ctx, authData, previouseProduct) => ProductsProvider(
              authData.token,
              authData.userId,
              previouseProduct.item == null ? [] : previouseProduct.item),
          create: (ctx) => ProductsProvider('', '', []),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Order>(
            create: (ctx) => Order([], '', ''),
            update: (ctx, authData, orderData) => Order(
                orderData.order == null ? [] : orderData.order,
                authData.token,
                authData.userId))
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.red,
            fontFamily: 'Lato',
          ),
          home: authData.isAuthenticated
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: authData.autoTryLogIn(),
                  builder: (context, snapshotData) =>
                      snapshotData.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrederScreen.routeName: (ctx) => OrederScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
