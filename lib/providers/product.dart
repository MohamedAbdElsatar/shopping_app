import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
    @required this.description,
    this.isFavorite = false,
  });

  void setFavorite(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggelefavoriteState(String authToken,String userId) async {
    var oldFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://flutter-update-6a460-default-rtdb.firebaseio.com/UserFavorites/$userId/$id.json?auth=$authToken';

    try {
      final response = await http.put(Uri.parse(url),
          body: convert.json.encode(isFavorite));

      if (response.statusCode >= 400) {
        setFavorite(oldFavorite);
      }
    } catch (error) {
      setFavorite(oldFavorite);
    }
  }
}
