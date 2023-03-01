// To parse this JSON data, do
//
//     final batch = batchFromJson(jsonString);

import 'dart:convert';
import 'package:idream/model/subject_model.dart';

// Batch batchFromJson(String str) => Batch.fromJson(json.decode(str));

String batchToJson(Batch data) => json.encode(data.toJson());

class Batch {
  Batch({
    this.batchName,
    this.batchSubject,
    this.batchCode,
    this.batchId,
    this.boardId,
    this.teacherId,
    this.teacherName,
    this.deeplink,
    this.board,
    this.language,
    this.batchClass,
    this.joinedStudentsList,
    this.teacherProfilePhoto,
  });

  String? batchName;
  String? batchCode;
  String? batchId;
  String? boardId;
  String? teacherId;
  String? teacherName;
  String? deeplink;
  String? batchClass;
  String? board;
  String? language;
  List<SubjectModel>? batchSubject;
  List<JoinedStudents>? joinedStudentsList;
  String? teacherProfilePhoto;

  factory Batch.fromJson(Map<String, dynamic> json) => Batch(
      batchName: json["batchName"],
      batchSubject: json["subjects"]
          .map<SubjectModel>((i) => SubjectModel.fromJson(i))
          .toList() /*List<SubjectModel>.from(json["subjects"].map((x) => x))*/,
      batchCode: json["batchCode"],
      batchId: json["batchId"],
      boardId: json['board_id'],
      teacherId: json["teacherId"],
      teacherName: json["teacherName"],
      board: json["board"],
      deeplink: json["deeplink"],
      language: json["language"],
      batchClass: json["batchClass"],
      teacherProfilePhoto: json['profile_photo'],
      joinedStudentsList: (json["students"] != null
          ? json["students"]
              .values
              .map<JoinedStudents>((i) => JoinedStudents.fromJson(i))
              .toList()
          : []));

  Map<String, dynamic> toJson() => {
        "BatchName": batchName,
        "Subjects": List<dynamic>.from(batchSubject!.map((x) => x)),
        "BatchCode": batchCode,
        "BatchId": batchId,
        "board_id": boardId,
        "TeacherId": teacherId,
        "TeacherName": teacherName,
        "board": board,
        "Deeplink": deeplink,
        "language": language,
        "batchClass": batchClass,
        "profile_photo": teacherProfilePhoto,
      };
}

class JoinedStudents {
  JoinedStudents({
    this.profileImage,
    this.fullName,
    this.userID,
    this.assignmentProgress,
  });

  final String? profileImage;
  final String? fullName;
  final String? userID;
  final AssignmentProgress? assignmentProgress;

  factory JoinedStudents.fromJson(Map<String, dynamic> json) => JoinedStudents(
        profileImage: json["profile_photo"],
        fullName: json["student_name"],
        userID: json["user_id"],
        assignmentProgress: json["progress"] != null
            ? AssignmentProgress.fromJson(json["progress"].values.last)
            : null,
      );

  Map<String, dynamic> toJson() => {
        "profile_photo": profileImage,
        "student_name": fullName,
        "user_id": userID,
      };
}

class AssignmentProgress {
  AssignmentProgress({
    this.progressText,
    this.progressTextColor,
    this.updatedTime,
  });

  final String? progressText;
  final String? progressTextColor;
  final String? updatedTime;

  factory AssignmentProgress.fromJson(Map<String, dynamic> json) =>
      AssignmentProgress(
        progressText: json["progress_text"],
        progressTextColor: json["progress_text_color"],
        updatedTime: json["updated_time"],
      );

  Map<String, dynamic> toJson() => {
        "progress_text": progressText,
        "student_name": progressTextColor,
        "updated_time": updatedTime,
      };
}
