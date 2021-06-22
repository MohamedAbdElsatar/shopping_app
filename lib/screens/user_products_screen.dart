import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/App_drawer.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user_product_screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshotData) =>
            snapshotData.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Consumer<ProductsProvider>(
                        builder: (context, product, child) => ListView.builder(
                          itemBuilder: (ctx, index) => Column(
                            children: [
                              UserProductItem(
                                product.item[index].id,
                                product.item[index].title,
                                product.item[index].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: product.item.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
