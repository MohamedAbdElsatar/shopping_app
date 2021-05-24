import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/order.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var expanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.orderItem.amount}'),
              subtitle: Text(
                  DateFormat.yMMMMEEEEd().format(widget.orderItem.dateTime)),
              trailing: IconButton(
                  icon: Icon(  expanded ? Icons.expand_less: Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  }),
            ),

          if(expanded)
             Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.orderItem.products.length * 20.0 + 10, 100),
                child: ListView.builder( itemBuilder: (context,index){
                 return Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(widget.orderItem.products[index].title,style: TextStyle(color: Colors.black,fontSize: 18),),
                     Text('\$${widget.orderItem.products[index].price} X ${widget.orderItem.products[index].quantity}'),
                   ],
                 );
               },
               itemCount: widget.orderItem.products.length)
              
               ),
            
          ],
        ),
      ),
    );
  }
}
