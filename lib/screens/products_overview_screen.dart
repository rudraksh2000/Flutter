// ignore_for_file: missing_return, sort_child_properties_last, prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';

import './cart_screen.dart';

import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  favourites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key key}) : super(key: key);
  static const routeName = '/products-overview';

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // we can't initialize Provider here as we know all these of(context) things
    // don't work like ModalRoute.of(context) etc, although if we set
    //Provider.of<ProductsProvider>(context, listen: false) it will work.

    //Provider.of<ProductsProvider>(context).fetchAndSetProducts(); // Won't work

    // Below code will work but it is not the ideal way of doing it since
    // Future.delayed add some delay to the code which is set to zero, it will
    // work though but it is just a hack.

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<ProductsProvider>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(10),
              child: ProductsGrid(_showOnlyFavourites),
            ),
    );
  }
}
