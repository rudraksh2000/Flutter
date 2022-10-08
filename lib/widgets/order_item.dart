// ignore_for_file: depend_on_referenced_packages, sized_box_for_whitespace, prefer_const_constructors

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders_provider.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem(this.order, {Key key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 180, 200) : 100,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm aaa')
                    .format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded == true
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              // it will either take the height of the products length and
              // as per the calculations or 180 pixels.
              height: _expanded
                  ? min(widget.order.products.length * 10.0 + 90, 100)
                  : 0,
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: widget.order.products
                    .map(
                      (prod) => ListTile(
                        title: Text(
                          prod.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                            '${prod.quantity} x \$${prod.price.toStringAsFixed(2)}'),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
