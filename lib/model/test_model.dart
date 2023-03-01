import 'package:idream/model/test_question_model.dart';

class TestPrepModel {
  String? href;
  String? icon;
  String? id;
  String? name;

  TestPrepModel.fromJson(Map<String, dynamic> json)
      : href = json['href'],
        icon = json['icon'],
        id = json['id'].toString(),
        name = json['name'];

  Map<String, dynamic> toJson() => {
        if (href != null) 'href': href,
        if (icon != null) 'icon': icon,
        if (id != null) 'id': id,
        if (name != null) 'name': name,
      };

  TestPrepModel({
    this.href,
    this.icon,
    this.id,
    this.name,
  });
}

class TestModel {
  String? display;
  String? foundationalTopicID;
  String? incorrectStreak;
  String? isAlternateLanguageAvailable;
  String? isModelTestPaper;
  String? levels;
  String? streakCount;
  String? tName;
  String? tNameAlt;
  String? topicID;
  double? mastery;
  int? masteryLevel;
  List<TestReports>? testReports;

  TestModel.fromJson(Map<String, dynamic> json)
      : display = json['display'],
        foundationalTopicID = json['foundational_topic_id'],
        incorrectStreak = json['incorrect_streak'],
        isAlternateLanguageAvailable = json['is_alternate_language_available'],
        isModelTestPaper = json['is_model_test_paper'],
        levels = json['levels'],
        streakCount = json['streak_count'],
        tName = json['t_name'],
        tNameAlt = json['t_name_alt'],
        topicID = json['topic_id'],
        testReports = null;

  Map<String, dynamic> toJson() => {
        if (display != null) 'display': display,
        if (foundationalTopicID != null)
          'foundationalTopicID': foundationalTopicID,
        if (isModelTestPaper != null) 'isModelTestPaper': isModelTestPaper,
        if (tName != null) 'tName': tName,
        if (tNameAlt != null) 'tNameAlt': tNameAlt,
        if (topicID != null) 'topicID': topicID,
      };

  TestModel({
    this.display,
    this.foundationalTopicID,
    this.incorrectStreak,
    this.isAlternateLanguageAvailable,
    this.isModelTestPaper,
    this.levels,
    this.streakCount,
    this.tName,
    this.tNameAlt,
    this.topicID,
    this.mastery,
    this.masteryLevel,
    this.testReports,
  });
}

class TestReports {
  String? correctCount;
  String? duration;
  String? incorrectCount;
  String? marks;
  String? topicID;
  String? topicName;
  String? unattemptedCount;
  String? updatedTime;
  List<TestQuestionModel>? testQuestionnaire;

  TestReports.fromJson(Map<String, dynamic> json)
      : correctCount = json['correct_count'],
        duration = json['duration'],
        incorrectCount = json['incorrect_count'],
        marks = json['marks'],
        topicID = json['topic_id'],
        topicName = json['topic_name'],
        unattemptedCount = json['unattempted_count'],
        updatedTime = json['updated_time'],
        testQuestionnaire = json['test_questionnaire']
            .map<TestQuestionModel>((i) => TestQuestionModel.fromJson(i))
            .toList();

  // Map<String, dynamic> toJson() => {
  //   if (id != null) 'id': id,
  //   if (name != null) 'name': name,
  //   if (description != null) 'description': description,
  //   if (alreadySelected != null) 'alreadySelected': alreadySelected,
  // };

  TestReports({
    this.correctCount,
    this.duration,
    this.incorrectCount,
    this.marks,
    this.topicID,
    this.topicName,
    this.unattemptedCount,
    this.updatedTime,
    this.testQuestionnaire,
  });
}
