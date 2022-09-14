import 'package:flutter/material.dart';

import '../screens/filters_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(
    BuildContext ctx,
    IconData iconData,
    String title,
    Function tileHandler,
  ) {
    return ListTile(
      tileColor: Theme.of(ctx).accentColor,
      leading: Icon(iconData, color: Theme.of(ctx).primaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(ctx).primaryColor,
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      onTap: tileHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: Text(
              'Cooking Up!',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile(
            context,
            Icons.restaurant_rounded,
            'Meals',
            () {
              // we are using pushReplacementNamed because for these screens we
              // are using drawer to navigate therefore no need to have previous
              // screen stored.
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          SizedBox(
            height: 10,
          ),
          buildListTile(
            context,
            Icons.settings_rounded,
            'Filters',
            () {
              Navigator.of(context)
                  .pushReplacementNamed(FiltersScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
