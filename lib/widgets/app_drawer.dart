// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_app/helpers/custom_route.dart';
import 'package:shops_app/providers/auth_provider.dart';

import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hi User'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.shop_rounded),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment_rounded),
            title: const Text('My Orders'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                CustomRoute(
                  builder: (ctx) => OrdersScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
