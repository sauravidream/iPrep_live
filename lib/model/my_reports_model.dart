class MyReportsModel {
  String? boardID;
  String? classID;
  String? language;
  String? subjectID;
  String? subjectName;
  String? subjectIconUrl;
  String? reportType;
  String? chapterName;
 late int totalTimeSpentOnApp;
  String? mostWatchedChapterName;
  int? mostWatchedChapterNameCount;
  double? subjectLevelMastery;
  int? totalUniquePracticeSetAttempted;
  int? totalUniqueTestsAttempted;
  int? totalUniqueBooksAttempted;
  int? totalUniqueNotesAttempted;
  List<MyReportBooksModel>? myReportBooksModelList;
  List<MyReportNotesModel>? myReportNotesModelList;
  List<MyReportPracticeModel>? myReportPracticeModelList;
  List<MyReportTestModel>? myReportTestModelList;
  List<MyReportVideoLessonsModel>? myReportVideoLessonsModelList;
  List<MyReportExtraBooksModel>? myReportExtraBooksModelList;

  MyReportsModel({
    this.boardID,
    this.classID,
    this.language,
    this.subjectID,
    this.subjectName,
    this.subjectIconUrl,
    this.reportType,
    this.chapterName,
    this.totalTimeSpentOnApp = 0,
    this.mostWatchedChapterName = "",
    this.mostWatchedChapterNameCount = 0,
    this.subjectLevelMastery = 0.0,
    this.totalUniquePracticeSetAttempted = 0,
    this.totalUniqueTestsAttempted = 0,
    this.totalUniqueBooksAttempted = 0,
    this.totalUniqueNotesAttempted = 0,
    this.myReportBooksModelList,
    this.myReportNotesModelList,
    this.myReportPracticeModelList,
    this.myReportTestModelList,
    this.myReportVideoLessonsModelList,
    this.myReportExtraBooksModelList,
  });

  // convenience constructor to create a Categories object
  MyReportsModel.fromJson(Map<String, dynamic> map) {
    boardID = map["boardID"];
    classID = map["classID"];
    language = map["language"];
    subjectID = map["subjectID"];
    subjectIconUrl = map["subjectIconUrl"];
    subjectName = map["subjectName"];
    reportType = map["reportType"];
    chapterName = map["chapterName"];
    totalTimeSpentOnApp = 0;

  }
}

class MyReportBooksModel {
  String? duration;
  String? bookID;
  String? bookName;
  String? topicName;
  String? updatedTime;
  String? subjectID;
  String? pageRead;
  String? totalPages;

  MyReportBooksModel({
    this.duration,
    this.bookID,
    this.bookName,
    this.topicName,
    this.updatedTime,
    this.subjectID,
    this.pageRead = "0",
    this.totalPages = "0",
  });

  // convenience constructor to create a Categories object
  MyReportBooksModel.fromJson(Map<String, dynamic> map) {
    duration = map["duration"];
    bookID = map["book_id"];
    bookName = map["book_name"];
    topicName = map["topic_name"];
    updatedTime = map["updated_time"];
    subjectID = map["subject_id"];
    pageRead = map["page_read"];
    totalPages = map["total_pages"];
  }
}

class MyReportNotesModel {
  String? duration;
  String? noteID;
  String? notesName;
  String? topicName;
  String? updatedTime;
  String? subjectID;
  String? pageRead;
  String? totalPages;

  MyReportNotesModel({
    this.duration,
    this.noteID,
    this.notesName,
    this.topicName,
    this.updatedTime,
    this.subjectID,
    this.pageRead = "0",
    this.totalPages = "0",
  });

  // convenience constructor to create a Categories object
  MyReportNotesModel.fromJson(Map<String, dynamic> map) {
    duration = map["duration"];
    noteID = map["note_id"];
    notesName = map["notes_name"];
    topicName = map["topic_name"];
    updatedTime = map["updated_time"];
    subjectID = map["subject_id"];
    pageRead = map["page_read"];
    totalPages = map["total_pages"];
  }
}

class MyReportPracticeModel {
  String? correctStreakCount;
  String? duration;
  double? mastery;
  String? topicID;
  int? topicLevel;
  String? updatedTime;
  String? topicName;
  String? subjectID;

  MyReportPracticeModel({
    this.correctStreakCount,
    this.duration,
    this.mastery,
    this.topicID,
    this.topicLevel,
    this.updatedTime,
    this.topicName,
    this.subjectID,
  });

  // convenience constructor to create a Categories object
  MyReportPracticeModel.fromJson(Map<String, dynamic> map) {
    correctStreakCount = map["correct_streak_count"];
    duration = map["duration"];
    mastery = map["mastery"];
    topicID = map["topic_id"];
    topicLevel = map["topic_level"];
    topicName = map["topic_name"];
    updatedTime = map["updated_time"];
    subjectID = map["subject_id"];
  }
}

class MyReportTestModel {
  String? correctCount;
  String? duration;
  String? incorrectCount;
  String? marks;
  String? topicID;
  String? topicName;
  String? unattemptedCount;
  String? updatedTime;
  String? subjectID;

  MyReportTestModel({
    this.correctCount,
    this.duration,
    this.incorrectCount,
    this.marks,
    this.topicID,
    this.topicName,
    this.unattemptedCount,
    this.updatedTime,
    this.subjectID,
  });

  // convenience constructor to create a Categories object
  MyReportTestModel.fromJson(Map<String, dynamic> map) {
    correctCount = map["correct_count"];
    duration = map["duration"];
    incorrectCount = map["incorrect_count"];
    marks = map["marks"];
    topicID = map["topic_id"];
    topicName = map["topic_name"];
    unattemptedCount = map["unattempted_count"];
    updatedTime = map["updated_time"];
    subjectID = map["subject_id"];
  }
}

class MyReportVideoLessonsModel {
  String? duration;
  String? topicName;
  String? updatedTime;
  String? videoID;
  String? videoUrl;
  String? videoName;
  String? videoTotalDuration;
  String? subjectID;

  MyReportVideoLessonsModel({
    this.duration,
    this.topicName,
    this.updatedTime,
    this.videoID,
    this.videoUrl,
    this.videoName,
    this.videoTotalDuration,
    this.subjectID,
  });

  // convenience constructor to create a Categories object
  MyReportVideoLessonsModel.fromJson(Map<String, dynamic> map) {
    duration = map["duration"];
    topicName = map["topic_name"];
    updatedTime = map["updated_time"];
    videoID = map["video_id"];
    videoUrl = map["video_url"];
    videoName = map["video_name"];
    videoTotalDuration = map["video_total_duration"];
    subjectID = map["subject_id"];
  }
}

class MyReportExtraBooksModel {
  String? duration;
  String? bookID;
  String? bookName;
  String? bookCategory;
  String? updatedTime;
  String? pageRead;
  String? totalPages;

  MyReportExtraBooksModel({
    this.duration,
    this.bookID,
    this.bookName,
    this.bookCategory,
    this.updatedTime,
    this.pageRead = "0",
    this.totalPages = "0",
  });

  // convenience constructor to create a Categories object
  MyReportExtraBooksModel.fromJson(Map<String, dynamic> map) {
    duration = map["duration"];
    bookID = map["book_id"];
    bookName = map["book_name"];
    bookCategory = map["book_category"];
    updatedTime = map["updated_time"];
    pageRead = map["page_read"];
    totalPages = map["total_pages"];
  }
}

class MyReportDetailedModel {
  String? topicName;
  String videosWatched;
  String practiceAttempted;
  String testsAttempted;
  String notesReadCount;
  String booksReadCount;

  MyReportDetailedModel({
    this.topicName,
    this.videosWatched = "0",
    this.practiceAttempted = "0",
    this.testsAttempted = "0",
    this.notesReadCount = "0",
    this.booksReadCount = "0",
  });
}
