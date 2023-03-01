

import 'package:idream/model/test_question_model.dart';

class TestQuestionsAttemptedModel {
  String? questionID;
  Option? option1;
  Option? option2;
  Option? option3;
  Option? option4;
  String? correctFeedback;
  String? incorrectFeedback;
  String? question;
  String? questionImage;
  String? correctAnswer;
  String? userResponse;
  String? feedbackImage;
  String? userSelectedAnswer;
  int? userUnSelectedAnswerIndex;

  TestQuestionsAttemptedModel.fromJson(Map<String, dynamic> json)
      : questionID = json['question_id'],
        option1 = Option.fromJson(json['A']),
        option2 = Option.fromJson(json['B']),
        option3 = Option.fromJson(json['C']),
        option4 = Option.fromJson(json['D']),
        correctFeedback = json['correct_feedback'],
        incorrectFeedback = json['incorrect_feedback'],
        question = json['q'],
        questionImage = json['questionImage'],
        correctAnswer = json['correctAnswer'],
        userResponse = json['user_response'],
        feedbackImage = json['feedbackImage'];


  Map<String, dynamic> toJson() => {
    if (questionID != null) 'question_id': questionID,
    if (option1 != null) 'A': option1,
    if (option2 != null) 'B': option2,
    if (option3 != null) 'C': option3,
    if (option4 != null) 'D': option4,
    if (correctFeedback != null) 'correct_feedback': correctFeedback,
    if (incorrectFeedback != null) 'incorrect_feedback': incorrectFeedback,
    if (question != null) 'q': question,
    if (questionImage != null) 'questionImage': questionImage,
    if (userResponse != null) 'user_response': userResponse,
    if (feedbackImage != null) 'feedbackImage': feedbackImage,
  };

  TestQuestionsAttemptedModel({
    this.questionID,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.correctFeedback,
    this.incorrectFeedback,
    this.question,
    this.questionImage,
    this.correctAnswer,
    this.userResponse,
    this.feedbackImage,
    this.userSelectedAnswer,
    this.userUnSelectedAnswerIndex,

  });
}
