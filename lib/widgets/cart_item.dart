// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;

  const CartItem({
    Key key,
    this.id,
    this.productId,
    this.title,
    this.imageUrl,
    this.price,
    this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false).removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        padding: const EdgeInsets.only(right: 5),
        child: Icon(
          Icons.delete_rounded,
          color: Theme.of(context).accentColor,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: imageUrl == null
                ? const Text('No image')
                : Container(
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            title: Text(title),
            subtitle: Text('Quantity: $quantity'),
            trailing: Chip(
              backgroundColor: Theme.of(context).primaryColor,
              label: Text('${price * quantity}'),
            ),
          ),
        ),
      ),
    );
  }
}
