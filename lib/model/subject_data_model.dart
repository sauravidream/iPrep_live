// To parse this JSON data, do
//
//     final subjectDataModel = subjectDataModelFromJson(jsonString);

import 'dart:convert';

SubjectDataModel subjectDataModelFromJson(String str) =>
    SubjectDataModel.fromJson(json.decode(str));

String? subjectDataModelToJson(SubjectDataModel? data) =>
    json.encode(data?.toJson());

class SubjectDataModel {
  SubjectDataModel({
    this.booksNcert,
    this.booksNotes,
    this.practice,
    this.videoLessons,
  });

  final List<BooksNcert>? booksNcert;
  final List<BooksNcert>? booksNotes;
  final List<Practice>? practice;
  final List<BooksNcert>? videoLessons;

  factory SubjectDataModel.fromJson(Map<String?, dynamic> json) =>
      SubjectDataModel(
        booksNcert: json["books_ncert"] != null
            ? List<BooksNcert>.from(
                json["books_ncert"].map((x) => BooksNcert.fromJson(x)))
            : null,
        booksNotes: json["books_notes"] != null
            ? List<BooksNcert>.from(
                json["books_notes"].map((x) => BooksNcert.fromJson(x)))
            : null,
        practice: json["practice"] != null
            ? List<Practice>.from(
                json["practice"].map((x) => Practice.fromJson(x)))
            : null,
        videoLessons: json["video_lessons"] != null
            ? List<BooksNcert>.from(
                json["video_lessons"].map((x) => BooksNcert.fromJson(x)))
            : null,
      );

  Map<String?, dynamic> toJson() => {
        "books_ncert": List<dynamic>.from(booksNcert!.map((x) => x.toJson())),
        "books_notes": List<dynamic>.from(booksNotes!.map((x) => x.toJson())),
        "practice": List<dynamic>.from(practice!.map((x) => x.toJson())),
        "video_lessons":
            List<dynamic>.from(videoLessons!.map((x) => x.toJson())),
      };
}

class BooksNcert {
  BooksNcert({
    this.name,
    this.topics,
  });

  final String? name;
  final List<Topic>? topics;

  factory BooksNcert.fromJson(Map<String?, dynamic> json) => BooksNcert(
        name: json["name"],
        topics: List<Topic>.from(json["topics"].map((x) => Topic.fromJson(x))),
      );

  Map<String?, dynamic> toJson() => {
        "name": name,
        "topics": List<dynamic>.from(topics!.map((x) => x.toJson())),
      };
}

class Topic {
  Topic({
    this.detail,
    this.id,
    this.name,
    this.offlineLink,
    this.offlineThumbnail,
    this.onlineLink,
    this.subjectId,
    this.thumbnail,
    this.topicName,
  });

  final String? detail;
  final String? id;
  final String? name;
  final String? offlineLink;
  final String? offlineThumbnail;
  final String? onlineLink;
  final String? subjectId;
  final String? thumbnail;
  final String? topicName;

  factory Topic.fromJson(Map<String?, dynamic> json) => Topic(
        detail: json["detail"],
        id: json["id"],
        name: json["name"],
        offlineLink: json["offlineLink"],
        offlineThumbnail: json["offlineThumbnail"],
        onlineLink: json["onlineLink"],
        subjectId: json["subjectID"],
        thumbnail: json["thumbnail"],
        topicName: json["topicName"],
      );

  Map<String?, dynamic> toJson() => {
        "detail": detail,
        "id": id,
        "name": name,
        "offlineLink": offlineLink,
        "offlineThumbnail": offlineThumbnail,
        "onlineLink": onlineLink,
        "subjectID": subjectId,
        "thumbnail": thumbnail,
        "topicName": topicName,
      };
}

class Practice {
  Practice({
    this.display,
    this.foundationalTopicId,
    this.incorrectStreak,
    this.isAlternateLanguageAvailable,
    this.isModelTestPaper,
    this.levels,
    this.questionCount,
    this.streakCount,
    this.tName,
    this.tNameAlt,
    this.topicId,
  });

  final String? display;
  final String? foundationalTopicId;
  final String? incorrectStreak;
  final String? isAlternateLanguageAvailable;
  final String? isModelTestPaper;
  final String? levels;
  final int? questionCount;
  final String? streakCount;
  final String? tName;
  final String? tNameAlt;
  final String? topicId;

  factory Practice.fromJson(Map<String?, dynamic> json) => Practice(
        display: json["display"],
        foundationalTopicId: json["foundational_topic_id"],
        incorrectStreak: json["incorrect_streak"],
        isAlternateLanguageAvailable: json["is_alternate_language_available"],
        isModelTestPaper: json["is_model_test_paper"],
        levels: json["levels"],
        questionCount: json["questionCount"],
        streakCount: json["streak_count"],
        tName: json["t_name"],
        tNameAlt: json["t_name_alt"],
        topicId: json["topic_id"],
      );

  Map<String?, dynamic> toJson() => {
        "display": display,
        "foundational_topic_id": foundationalTopicId,
        "incorrect_streak": incorrectStreak,
        "is_alternate_language_available": isAlternateLanguageAvailable,
        "is_model_test_paper": isModelTestPaper,
        "levels": levels,
        "questionCount": questionCount,
        "streak_count": streakCount,
        "t_name": tName,
        "t_name_alt": tNameAlt,
        "topic_id": topicId,
      };
}

class EnumValues<T> {
  Map<String?, T>? map;
  Map<T, String?>? reverseMap;

  EnumValues(this.map);

  Map<T, String?>? get reverse {
    reverseMap ??= map!.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
