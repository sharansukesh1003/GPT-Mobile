import 'dart:math';
import 'package:flutter_gpt/constants/constants.dart';

final List<String> questions = List.of(sampleQuestions);
final List<String> selectedQuestions = [];

List<String> getRandomSampleQuestions() {
  final Random random = Random();
  while (selectedQuestions.length < 4 && questions.isNotEmpty) {
    final int index = random.nextInt(questions.length);
    selectedQuestions.add(questions[index]);
    questions.removeAt(index);
  }

  return selectedQuestions;
}
