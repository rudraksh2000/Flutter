import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/result.dart';
import './questions.dart';
import './answers.dart';
import './quiz.dart';
import './result.dart';

// void main() {
//   runApp(MyApp());
// }

// we can use arrow => if we have only one expression in the function
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}
// the class Questions is stateless widget and since the text is changing it is used in this
// class and therefore it is a stateful widget class it is rebuilding the state the Question
// class is acting like an external input to this making the text change its state.

class _MyAppState extends State<MyApp> {
  var _currentIndex = 0;
  var _totalScore = 0;
// or we can use static
  final _questions = const [
    {
      'questionText': 'What\'s your favourite color?',
      'answerText': [
        {'text': 'Red', 'score': 10},
        {'text': 'Green', 'score': 40},
        {'text': 'Black', 'score': 20},
        {'text': 'White', 'score': 30},
      ]
    },
    {
      'questionText': 'What\'s your favourite animal?',
      'answerText': [
        {'text': 'Tiger', 'score': 30},
        {'text': 'Snake', 'score': 40},
        {'text': 'Zebra', 'score': 20},
        {'text': 'Elephant', 'score': 10},
      ]
    },
    {
      'questionText': 'What\'s your favourite cuisine?',
      'answerText': [
        {'text': 'Continental', 'score': 20},
        {'text': 'Chinese', 'score': 30},
        {'text': 'South Indian', 'score': 10},
        {'text': 'North Indian', 'score': 40},
      ]
    },
  ];

  void _resetQuiz() {
    setState(() {
      _currentIndex = 0;
      _totalScore = 0;
    });
  }

  void answerQuestion(int score) {
    _totalScore += score;
    if (_currentIndex < _questions.length) {
      print('Next question');
    } else {
      print('No more questions!');
    }
    setState(() {
      _currentIndex += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App'),
        ),
        body: (_currentIndex < _questions.length)
            ? Quiz(_questions, answerQuestion, _currentIndex)
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
