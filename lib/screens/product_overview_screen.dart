import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../providers/cart.dart';
import '../screens/Cart_screen.dart';
import '../widgets/App_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';

enum FilteredItems { Favorite, AllProducts }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showOnlyFavorite = false;
  var _isInit = true; // to ensure it run for the first time
  var _isLoading = false;

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilteredItems selectedValue) {
              setState(() {
                if (selectedValue == FilteredItems.Favorite) {
                  showOnlyFavorite = true;
                } else
                  showOnlyFavorite = false;
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Favorite'), value: FilteredItems.Favorite),
              PopupMenuItem(
                  child: Text('Show All'), value: FilteredItems.AllProducts),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, chil) => Badge(
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
                value: cart.countItems.toString()),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showOnlyFavorite),
    );
  }
}
