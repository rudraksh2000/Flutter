// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key key}) : super(key: key);

  // final String id;
  // final String title;
  // final String imageUrl;

  // const ProductItem(
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  // );

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<ProductProvider>(
            builder: (ctx, value, _) => IconButton(
              icon: Icon(product.isFavourite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded),
              onPressed: () {
                product.toggleIsFavourite();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(product.title),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart_rounded),
            onPressed: () {
              cart.addItem(
                product.id,
                product.title,
                product.price,
                product.imageUrl,
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
