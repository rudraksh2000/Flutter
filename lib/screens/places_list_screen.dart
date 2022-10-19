// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:great_places_app/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

import './add_place_screen.dart';
import '../providers/great_places_provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Places'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlacesProvider>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlacesProvider>(
                  child: Center(child: const Text('Got no places yet')),
                  builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <=
                          0
                      ? ch
                      : ListView.builder(
                          itemCount: greatPlaces.items.length,
                          itemBuilder: (ctx, index) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  FileImage(greatPlaces.items[index].image),
                            ),
                            title: Text(greatPlaces.items[index].title),
                            subtitle:
                                Text(greatPlaces.items[index].location.address),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  PlacesDetailScreen.routeName,
                                  arguments: greatPlaces.items[index].id);
                            },
                          ),
                        ),
                ),
        )
        //CircularProgressIndicator(),

        );
  }
}
