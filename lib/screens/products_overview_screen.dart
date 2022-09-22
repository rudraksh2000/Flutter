// ignore_for_file: missing_return, sort_child_properties_last, prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_app/providers/cart_provider.dart';
import 'package:shops_app/screens/cart_screen.dart';
import 'package:shops_app/widgets/app_drawer.dart';

import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  favourites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shops App'),
        actions: [
          PopupMenuButton(
              // accent color
              color: Theme.of(context).colorScheme.secondary,
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favourites) {
                    _showOnlyFavourites = true;
                  } else {
                    _showOnlyFavourites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert_rounded),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Favourites'),
                      value: FilterOptions.favourites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.all,
                    )
                  ]),
          Consumer<CartProvider>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart_rounded,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ProductsGrid(_showOnlyFavourites),
      ),
    );
  }
}
