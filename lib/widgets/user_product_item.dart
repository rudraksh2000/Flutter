// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProuctItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProuctItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: const Icon(Icons.edit_rounded),
              color: Theme.of(context).accentColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .removeProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text('Deleting failed!'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.delete_rounded),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
