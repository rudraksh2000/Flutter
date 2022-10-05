// ignore_for_file: prefer_const_constructors, deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth_provider.dart';
import './providers/orders_provider.dart';
import './providers/cart_provider.dart';
import './providers/products_provider.dart';

import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // we have created a ChangeNotifierProvider so when any changes occur in
    // the provider the descendants or the child widget which are listening
    // will only be rebuild not the other widgets.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (ctx) => ProductsProvider(null, null, []),
          update: (ctx, auth, previousProducts) => ProductsProvider(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (ctx) => OrdersProvider(null, null, []),
          update: (ctx, auth, previousOrders) => OrdersProvider(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      // since we want to change the landing page based onif the user is
      // authenticated or not which depends on AuthProvider we are building
      // our material app accordingly and that's why using consumer here.
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.cyan,
            accentColor: Colors.amber,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductsOverviewScreen.routeName: (ct) => ProductDetailScreen(),
            ProductDetailScreen.routeName: (ct) => ProductDetailScreen(),
            CartScreen.routeName: (ct) => CartScreen(),
            OrdersScreen.routeName: (ct) => OrdersScreen(),
            UserProductsScreen.routeName: (ct) => UserProductsScreen(),
            EditProductScreen.routeName: (ct) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
