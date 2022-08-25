import 'dart:ffi';

import 'package:flutter/material.dart';
import './questions.dart';
import './answers.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int currentIndex;
  final Function answerQuestion;

  Quiz(this.questions, this.answerQuestion, this.currentIndex);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Questions(questions[currentIndex]['questionText'] as String),
        //here first we were hard coding answers like
        // Answer(_answerQuestion),
        // Answer(_answerQuestion),
        // Answer(_answerQuestion),
        //but what we can do is to add answers dynamically as per the question
        //we can add them as list of widgets which can be merged with the children.
        // List<Map<String, Object>> we are using Object since it contain multiple
        // type of values(K,V) i.e String and Int.
        ...(questions[currentIndex]['answerText'] as List<Map<String, Object>>)
            .map((answer) {
          // here instead of passing the function name we are passing a function
          // having the address of the answerQuestion function in call only, since
          // we need to have score so we are passing the score as argument since it
          // is mapped that is why we have to specify the key and had to pass the
          // function like this
          return Answer(() => answerQuestion(answer['score']), answer['text']);
          // also we know that without () while passing the function as argument
          // we are passing the function body but not triggering it. Above we do have
          // to access answerQuestion() when button is triggered (selectHandler) and
          // we get the access to the key value.
        }).toList(),
      ],
    );
  }
}
