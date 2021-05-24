import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order.dart';
import '../widgets/order_item.dart' as or;

class OrederScreen extends StatelessWidget {
  static const routeName = '/order_screen';
  @override
  Widget build(BuildContext context) {
    final orderdata = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your oreders'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => or.OrderItem(orderdata.order[index]),
        itemCount: orderdata.order.length,
      ),
    );
  }
}
