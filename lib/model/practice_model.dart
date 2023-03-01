class PracticeModel {
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
  int? attempts;
  double? mastery;
  int? masteryLevel;

  PracticeModel.fromJson(Map<String, dynamic> json)
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
        attempts = 0,
        mastery = 0.0,
        masteryLevel = 0;

  Map<String, dynamic> toJson() => {
        if (display != null) 'display': display,
        if (foundationalTopicID != null)
          'foundational_topic_id': foundationalTopicID,
        if (incorrectStreak != null) 'incorrect_streak': incorrectStreak,
        if (isAlternateLanguageAvailable != null)
          'is_alternate_language_available': isAlternateLanguageAvailable,
        if (isModelTestPaper != null) 'is_model_test_paper': isModelTestPaper,
        if (levels != null) 'levels': levels,
        if (streakCount != null) 'streak_count': streakCount,
        if (tName != null) 't_name': tName,
        if (tNameAlt != null) 't_name_alt': tNameAlt,
        if (topicID != null) 'topic_id': topicID,
      };

  PracticeModel({
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
    this.attempts,
    this.mastery,
    this.masteryLevel,
  });
}

class PracticeReports {
  String? correctStreakCount;
  String? duration;
  double? mastery;
  String? topicID;
  int? topicLevel;
  String? updatedTime;

  PracticeReports.fromJson(Map<dynamic, dynamic> json)
      : correctStreakCount = json['correct_streak_count'],
        duration = json['duration'],
        mastery = json['mastery'].runtimeType == int
            ? double.parse(json['mastery'].toString())
            : json['mastery'],
        topicID = json['topic_id'],
        topicLevel = json['topic_level'],
        updatedTime = json['updated_time'];

  PracticeReports({
    this.correctStreakCount,
    this.duration,
    this.mastery,
    this.topicID,
    this.topicLevel,
    this.updatedTime,
  });
}
