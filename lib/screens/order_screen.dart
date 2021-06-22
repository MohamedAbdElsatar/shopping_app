import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';
import '../widgets/order_item.dart' as or;

class OrederScreen extends StatelessWidget {
  static const routeName = '/order_screen';
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your orders'),
        ),
        body: FutureBuilder(
            future:
                Provider.of<Order>(context, listen: false).fetchAndSetOder(),
            builder: (context, snapshotData) {
              if (snapshotData.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshotData.error != null) {
                  return Center(child: Text('There is an error occured!'));
                } else {
                  return Consumer<Order>(
                    builder: (ctx, orderdata, child) {
                      return ListView.builder(
                        itemBuilder: (context, index) =>
                            or.OrderItem(orderdata.order[index]),
                        itemCount: orderdata.order.length,
                      );
                    },
                  );
                }
              }
            }));
  }
}
