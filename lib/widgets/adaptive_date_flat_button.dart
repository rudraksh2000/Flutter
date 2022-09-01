import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveDateFlatButton extends StatelessWidget {
  final String text;
  final Function chooseDateHandler;

  AdaptiveDateFlatButton(this.text, this.chooseDateHandler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: (chooseDateHandler),
            child: Text(
              'Choose Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        : FlatButton(
            onPressed: (chooseDateHandler),
            textColor: Theme.of(context).primaryColor,
            child: Text(
              'Choose Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}
