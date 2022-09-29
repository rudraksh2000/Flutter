// ignore_for_file: use_rethrow_when_possible, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product_provider.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductProvider> _items = [
    //   ProductProvider(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageUrl:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   ),
    //   ProductProvider(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   ),
    //   ProductProvider(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageUrl:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   ),
    //   ProductProvider(
    //     id: 'p4',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ),
  ];

  List<ProductProvider> get items {
    // here we are returning a copy of list so that to protect the actual list
    // from changing unexpectedly from outside the class. We know that in dart
    // we get the reference of the object address therefore we want to have a
    // copy to update the item from outside and then with the help of listeners
    // we will notify other widgets by applying changes in the list.
    return [..._items];
  }

  List<ProductProvider> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  ProductProvider findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
        'shops-app-flutter-demo-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<ProductProvider> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(ProductProvider(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavourite: prodData['isFavourite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(ProductProvider product) async {
    // earlier url can be stored as strings but now it follows this convention.
    final url = Uri.https(
        'shops-app-flutter-demo-default-rtdb.firebaseio.com', '/products.json');
    // to store date we want to return a future also.
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavourite': product.isFavourite,
        }),
      );
      //_items.add(value);
      final newProduct = ProductProvider(
          // this will return a unique string.
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, ProductProvider newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https(
          'shops-app-flutter-demo-default-rtdb.firebaseio.com',
          '/products/$id.json');
      try {
        await http.patch(
          url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }),
        );
        _items[prodIndex] = newProduct;
      } catch (error) {
        throw error;
      }
    }
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    final url = Uri.https('shops-app-flutter-demo-default-rtdb.firebaseio.com',
        '/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    existingProduct = null;
    _items.removeAt(existingProductIndex);

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      // here we are storing the to be deleted product as here we want to keep the
      // product if error occurs. This is optimistic updating.
      items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product!');
    }
    notifyListeners();
  }
}
