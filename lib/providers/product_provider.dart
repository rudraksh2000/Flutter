import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  ProductProvider({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  ProductProvider copyWith({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    bool isFavourite = false,
  }) {
    return ProductProvider(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  Future<void> toggleIsFavourite(String authToken, String userId) async {
    var _params = {
      'auth': authToken,
    };
    final url = Uri.https('shops-app-flutter-demo-default-rtdb.firebaseio.com',
        '/userFavourites/$userId/$id.json', _params);

    var oldIsFavourite = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

    final response = await http.put(
      url,
      body: json.encode(
        isFavourite,
      ),
    );
    if (response.statusCode >= 400) {
      isFavourite = oldIsFavourite;
      notifyListeners();
    }
  }
}
