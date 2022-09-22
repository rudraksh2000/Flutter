import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavs;

  ProductsGrid(this.showOnlyFavs);

  @override
  Widget build(BuildContext context) {
    // here we are telling the provider that we are estabilishing a
    // direct communication to ProductsProvider class instance.

    // the Provider package goes ahead and looks at the parent of ProductsGrid
    // that is ProductsOverviewScreen there it finds no provider. Then it
    // goes to its parent class that is MyApp (main) class there it finds a
    // provider (i.e. ChangeNotifierProvider) there it finds an instance of
    // type Products.
    final productsData = Provider.of<ProductsProvider>(context);
    final products =
        showOnlyFavs == true ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      // here we are using another provider for Single Product for getting the
      // isfavourite value since ProductItem is using it we need to provide
      // it using Provider and here we are sending products[index] for a single
      // product.
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: const ProductItem(
            // products[index].id,
            // products[index].title,
            // products[index].imageUrl,
            ),
      ),
    );
  }
}
