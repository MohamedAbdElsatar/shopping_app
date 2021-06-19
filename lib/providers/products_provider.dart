import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exceptions.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get item {
    return [..._items]; // a copy  of items in case of any failler
  }

  List<Product> get favoriteItem {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    const uri =
        'https://flutter-update-6a460-default-rtdb.firebaseio.com/products.json';
    //try {
    final response = await http.get(Uri.parse(uri));
    final extractedData =
        convert.json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }
    final List<Product> loadedProducts = [];

    extractedData.forEach((prodId, prodData) {
      loadedProducts.add(Product(
        id: prodId,
        title: prodData['title'],
        description: prodData['description'],
        price: prodData['price'],
        isFavorite: prodData['isFavorite'],
        imageUrl: prodData['imageUrl'],
      ));
    });
    _items = loadedProducts;
    notifyListeners();
    //  }
    // catch (error) {
    //   print(error);
    //  // throw error.toString();
    // }
  }

  Future<void> addProduct(Product product) async {
    const uri =
        'https://flutter-update-6a460-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(Uri.parse(uri),
          body: convert.json.encode({
            'title': product.title,
            'id': product.id,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite
          }));

      Product p = Product(
          id: convert.json.decode(response.body)['name'],
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title,
          description: product.description);
      _items.add(p);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product findById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  Future<void> updateProduct(Product newProduct, String id) async {
    final url =
        'https://flutter-update-6a460-default-rtdb.firebaseio.com/products/$id.json';

    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      await http.patch(Uri.parse(url),
          body: convert.json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl
          }));

      _items[productIndex] = newProduct;
    }
    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    //products/$id.json == to acess the item wanted
    final url =
        'https://flutter-update-6a460-default-rtdb.firebaseio.com/products/$id.json';
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var deletedProduct = _items[existingProductIndex];

    // delete object before sending request and wait the response
    _items.removeWhere((product) => product.id == id);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    // >=400 mean there is an error
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, deletedProduct);
      notifyListeners();
      throw HttpException('There is an error occured!');
    }
    // optimistic updating = delete
    //assinging (null) to notify dart that oject not needed anymore(remove from memory)
    deletedProduct = null;
  }
}
