import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  // In new version for this instead of Function we use VoidCallback
  final VoidCallback resetHandler;

  Result(this.resultScore, this.resetHandler);

  String get resultPhase {
    String resultText;
    if (resultScore >= 110) {
      resultText = 'We are alike';
    } else if (resultScore >= 80 && resultScore < 110) {
      resultText = 'We are kind of similar';
    } else if (resultScore >= 50 && resultScore < 80) {
      resultText = 'We are not so similar';
    } else {
      resultText = 'We are very different';
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            resultPhase,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          FlatButton(onPressed: resetHandler, child: Text('Restart Quiz'))
        ],
      ),
    );
  }
}
