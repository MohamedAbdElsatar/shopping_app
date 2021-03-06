import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String _authToken;
  final String userId;
  Order(this._orders, this._authToken,this.userId,);

  List<OrderItem> get order {
    return [..._orders];
  }

  Future<void> fetchAndSetOder() async {
    final url =
        'https://flutter-update-6a460-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$_authToken';
    final response = await http.get(Uri.parse(url));
    final extractedData =
        convert.json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }

    final List<OrderItem> ordersList = [];
    extractedData.forEach((orderId, orderdata) {
      ordersList.insert(
          0,
          OrderItem(
              id: orderId,
              amount: orderdata['amount'],
              products: (orderdata['products'] as List)
                  .map((product) => CartItem(
                      id: product['id'],
                      title: product['title'],
                      price: product['price'],
                      quantity: product['quantity']))
                  .toList(),
              dateTime: DateTime.parse(orderdata['dateTime'])));
    });
    _orders = ordersList;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double amount) async {
    final url =
        'https://flutter-update-6a460-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$_authToken';
    // time in server and loacel memory the same
    final timeStamp = DateTime.now();

    final response = await http.post(Uri.parse(url),
        body: convert.json.encode({
          'amount': amount,
          //toIso8601String() => make it easy for retreving
          'dateTime': timeStamp.toIso8601String(),
          'products': products
              .map((productOrder) => {
                    'id': productOrder.id,
                    'title': productOrder.title,
                    'price': productOrder.price,
                    'quantity': productOrder.quantity
                  })
              .toList(),
        }));

    _orders.insert(
      0,
      OrderItem(
        // give it the sever gen id in case access product
        id: convert.json.decode(response.body)['name'],
        amount: amount,
        products: products,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
