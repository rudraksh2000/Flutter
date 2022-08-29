import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveAddTxnButton extends StatelessWidget {
  final String text;
  final Function addTxnHandler;

  AdaptiveAddTxnButton(this.text, this.addTxnHandler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              text,
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: addTxnHandler,
            color: Theme.of(context).primaryColor,
          )
        : RaisedButton(
            child: Text(
              'Add Transaction',
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: addTxnHandler,
            color: Theme.of(context).primaryColor,
          );
  }
}
