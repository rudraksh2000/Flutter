// ignore_for_file: missing_return, deprecated_member_use, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:great_places_app/providers/great_places_provider.dart';
import 'package:great_places_app/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlacesDetailScreen extends StatelessWidget {
  const PlacesDetailScreen({Key key}) : super(key: key);

  static const routeName = '/place-detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final selectedPlace =
        Provider.of<GreatPlacesProvider>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            selectedPlace.location.address,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (ctx) => MapScreen(
                          initialLocation: selectedPlace.location,
                          isSelecting: false,
                        )),
              );
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('View On Map'),
          ),
        ],
      ),
    );
  }
}
