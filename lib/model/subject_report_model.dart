// To parse this JSON data, do
//
//     final subjectReportModel = subjectReportModelFromJson(jsonString);

import 'dart:convert';

SubjectReportModel subjectReportModelFromJson(String str) =>
    SubjectReportModel.fromJson(json.decode(str));

String subjectReportModelToJson(SubjectReportModel data) =>
    json.encode(data.toJson());

class SubjectReportModel {
  SubjectReportModel({
    this.subject,
  });

  final Subject? subject;

  factory SubjectReportModel.fromJson(Map<String, dynamic> json) =>
      SubjectReportModel(
        subject: Subject.fromJson(json),
      );

  Map<String, dynamic> toJson() => {
        "subject": subject!.toJson(),
      };
}

class Subject {
  Subject({
    this.practice,
    this.videoLessons,
  });

  final Map<String, Map<String, Practice>>? practice;
  final Map<String, Map<String, VideoLesson>>? videoLessons;

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        practice: Map.from(json["practice"]).map((k, v) =>
            MapEntry<String, Map<String, Practice>>(
                k,
                Map.from(v).map((k, v) =>
                    MapEntry<String, Practice>(k, Practice.fromJson(v))))),
        videoLessons: Map.from(json["video_lessons"]).map((k, v) =>
            MapEntry<String, Map<String, VideoLesson>>(
                k,
                Map.from(v).map((k, v) => MapEntry<String, VideoLesson>(
                    k, VideoLesson.fromJson(v))))),
      );

  Map<String, dynamic> toJson() => {
        "practice": Map.from(practice!).map((k, v) => MapEntry<String, dynamic>(
            k,
            Map.from(v)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())))),
        "video_lessons": Map.from(videoLessons!).map((k, v) =>
            MapEntry<String, dynamic>(
                k,
                Map.from(v)
                    .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())))),
      };
}

class Practice {
  Practice({
    this.className,
    this.correctStreakCount,
    this.duration,
    this.mastery,
    this.subjectName,
    this.topicId,
    this.topicLevel,
    this.topicName,
    this.updatedTime,
    this.userName,
  });

  final String? className;
  final String? correctStreakCount;
  final String? duration;
  final double? mastery;
  final String? subjectName;
  final String? topicId;
  final int? topicLevel;
  final String? topicName;
  final DateTime? updatedTime;
  final String? userName;

  factory Practice.fromJson(Map<String, dynamic> json) => Practice(
        className: json["class_name"],
        correctStreakCount: json["correct_streak_count"],
        duration: json["duration"],
        mastery: json["mastery"].toDouble(),
        subjectName: json["subject_name"],
        topicId: json["topic_id"],
        topicLevel: json["topic_level"],
        topicName: json["topic_name"],
        updatedTime: DateTime.parse(json["updated_time"]),
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "class_name": className,
        "correct_streak_count": correctStreakCount,
        "duration": duration,
        "mastery": mastery,
        "subject_name": subjectName,
        "topic_id": topicId,
        "topic_level": topicLevel,
        "topic_name": topicName,
        "updated_time": updatedTime?.toIso8601String(),
        "user_name": userName,
      };
}

class VideoLesson {
  VideoLesson({
    this.className,
    this.duration,
    this.subjectName,
    this.thumbnail,
    this.topicName,
    this.updatedTime,
    this.userName,
    this.videoId,
    this.videoName,
    this.videoTotalDuration,
    this.videoUrl,
  });

  final String? className;
  final String? duration;
  final String? subjectName;
  final String? thumbnail;
  final String? topicName;
  final DateTime? updatedTime;
  final String? userName;
  final String? videoId;
  final String? videoName;
  final String? videoTotalDuration;
  final String? videoUrl;

  factory VideoLesson.fromJson(Map<String, dynamic> json) => VideoLesson(
        className: json["class_name"],
        duration: json["duration"],
        subjectName: json["subject_name"],
        thumbnail: json["thumbnail"],
        topicName: json["topic_name"],
        updatedTime: DateTime.parse(json["updated_time"]),
        userName: json["user_name"],
        videoId: json["video_id"],
        videoName: json["video_name"],
        videoTotalDuration: json["video_total_duration"],
        videoUrl: json["video_url"],
      );

  Map<String, dynamic> toJson() => {
        "class_name": className,
        "duration": duration,
        "subject_name": subjectName,
        "thumbnail": thumbnail,
        "topic_name": topicName,
        "updated_time": updatedTime?.toIso8601String(),
        "user_name": userName,
        "video_id": videoId,
        "video_name": videoName,
        "video_total_duration": videoTotalDuration,
        "video_url": videoUrl,
      };
}

class SubjectReportModelList {
  final Map<String, SubjectReportModel>? subjectReportModelMap;
  SubjectReportModelList({this.subjectReportModelMap});

  factory SubjectReportModelList.fromJson(Map<String, dynamic> json) =>
      SubjectReportModelList(
        subjectReportModelMap: (json).map(
          (k, e) => MapEntry(
              k, SubjectReportModel.fromJson(e as Map<String, dynamic>)),
        ),
      );

  Map<String, dynamic> toJson(SubjectReportModelList instance) =>
      <String, dynamic>{
        'subjectReportModelMap': instance.subjectReportModelMap,
      };
}
