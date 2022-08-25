import 'package:flutter/material.dart';

// we are adding final here so that the question text value can't be changed in the
// class object please note here we are changing the class object instance not the
// property value(questiontext).
class Questions extends StatelessWidget {
  final String questiontext;

  Questions(this.questiontext);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Text(
        questiontext,
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    );
  }
}
