// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart' show OrdersProvider;

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // although with Stateless widget this will work but here we are providing
  // this approach so that if we have some other data that should change or
  // any other widget then using Stateless widget will allow multiple providers
  // to listen to changes therefore to protect it (not here though) we are using
  // below method.

  Future _ordersFuture;

  Future _obtainFutureOrders() {
    return Provider.of<OrdersProvider>(context, listen: false)
        .fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainFutureOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            // we only need to get provider data in our list.
            return Consumer<OrdersProvider>(
              builder: (context, ordersData, child) => ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (ctx, index) =>
                    OrderItem(ordersData.orders[index]),
              ),
            );
          }
        },
      ),
      // _isLoading
      //     ? const Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : ListView.builder(
      //         itemCount: ordersData.orders.length,
      //         itemBuilder: (ctx, index) => OrderItem(ordersData.orders[index]),
      //       ),
    );
  }
}
