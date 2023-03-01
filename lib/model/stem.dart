import 'package:idream/model/video_lesson.dart';

class StemModel {
  String? subjectID;
  String? subjectName;
  int? subjectColor;
  String? subjectIconPath;
  List<Chapters>? chapterList;

  StemModel.fromJson(Map<String, dynamic> json)
      : subjectID = json['subjectID'],
        subjectName = null,
        chapterList = null;

  StemModel({
    this.subjectID,
    this.subjectName,
    this.subjectColor,
    this.subjectIconPath,
    this.chapterList,
  });
}

class Chapters {
  String? chapterName;
  List<VideoLessonModel>? videoLesson;

  Chapters.fromJson(Map<String, dynamic> json)
      : chapterName = json['chapter_name'],
        videoLesson = null;

  Chapters({
    this.chapterName,
    this.videoLesson,
  });
}
