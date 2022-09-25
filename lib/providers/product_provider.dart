import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite = false;

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

  void toggleIsFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
