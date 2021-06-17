import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';
import '../widgets/order_item.dart' as or;

class OrederScreen extends StatefulWidget {
  static const routeName = '/order_screen';

  @override
  _OrederScreenState createState() => _OrederScreenState();
}

class _OrederScreenState extends State<OrederScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero)
        .then((value) => Provider.of<Order>(context,listen:false).fetchAndSetOder());
    super.initState();
  }

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
