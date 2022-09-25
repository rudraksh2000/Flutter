// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';

import '../providers/orders_provider.dart';
import '../providers/cart_provider.dart' show CartProvider;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total :',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Chip(
                  padding: const EdgeInsets.all(8),
                  backgroundColor: Theme.of(context).accentColor,
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<OrdersProvider>(context, listen: false)
                        .addOrder(
                      cart.items.values.toList(),
                      cart.totalAmount,
                    );
                    cart.clear();
                  },
                  child: const Text('PLACE ORDER'),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, index) => CartItem(
                id: cart.items.values.toList()[index].id,
                productId: cart.items.keys.toList()[index],
                title: cart.items.values.toList()[index].title,
                imageUrl: cart.items.values.toList()[index].imageUrl,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 2,
                vertical: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
