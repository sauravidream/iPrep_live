import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/my_reports_model.dart';
import 'package:idream/model/subject_model.dart';

class MyReportsRepository {
  Future fetchCompleteReport({
    String? boardName,
    String? studentUserID,
    String? studentLanguage,
    String? studentClass,
  }) async {
    try {
      String? _classNumber;
      String? _stream;
      String? _userID = studentUserID ?? await getStringValuesSF("userID");
      String? _educationBoard = boardName != null
          ? boardName.toLowerCase()
          : (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String? _language = studentLanguage ??
          (await getStringValuesSF("language"))!.toLowerCase();
      _classNumber = studentClass ?? await (getStringValuesSF("classNumber"));

      if ((int.parse(_classNumber!)) > 10) {
        _stream = await getStringValuesSF("stream"); //2
        _classNumber = "${_classNumber}_${_stream!}";
      } else {
        _classNumber = _classNumber;
      }

      var _response = await apiHandler.getAPICall(
          endPointURL:
              "reports/app_reports/$_userID/data/$_classNumber/$_educationBoard/$_language/");
      // endPointURL:
      //     "reports/app_reports/daAifEckeLQcx5db7XOpPvp3cfQ2/data/$_classNumber/$_educationBoard/$_language/");

      if (_response == null) return _response;

      List<MyReportsModel> _myReportsModelList = [];

      int _subjectLevelIndex = 0;

      if ((_response as Map).containsKey("books")) {
        (_response).remove("books");
      }
      if ((_response).containsKey("stem_videos")) {
        (_response).remove("stem_videos");
      }

      await Future.forEach((_response).values, (myReportModelList) async {
        List<MyReportTestModel> _myReportsTestModelList = [];
        MyReportsModel _myReportsModel = MyReportsModel(
          myReportVideoLessonsModelList: [],
          myReportTestModelList: [],
          myReportPracticeModelList: [],
          myReportNotesModelList: [],
          myReportBooksModelList: [],
        );
        if ((myReportModelList as Map)["books_ncert"] != null) {
          await Future.forEach(((myReportModelList)["books_ncert"]).values,
              (myReportBookModelList) {
            List<MyReportBooksModel> _myReportsBookModelList = [];
            (myReportBookModelList as Map).values.forEach((reportBookModel) {
              _myReportsBookModelList.add(
                MyReportBooksModel(
                  duration: reportBookModel["duration"],
                  topicName: reportBookModel["topic_name"],
                  bookID: reportBookModel["book_id"],
                  bookName: reportBookModel["book_name"],
                  updatedTime: reportBookModel["updated_time"],
                  pageRead: reportBookModel["page_read"],
                  totalPages: reportBookModel["total_pages"],
                  subjectID:
                      (_response).keys.toList().elementAt(_subjectLevelIndex),
                ),
              );
              _myReportsModel.totalTimeSpentOnApp =
                  _myReportsModel.totalTimeSpentOnApp +
                      int.parse(reportBookModel["duration"]);
            });
            _myReportsModel.myReportBooksModelList!
                .addAll(_myReportsBookModelList);
          });
          _myReportsModel.totalUniqueBooksAttempted =
              ((myReportModelList)["books_ncert"]).values.length;
        }

        if ((myReportModelList)["books_notes"] != null) {
          await Future.forEach(((myReportModelList)["books_notes"]).values,
              (myReportBookModelList) {
            List<MyReportNotesModel> _myReportsNoteModelList = [];
            (myReportBookModelList as Map).values.forEach((reportBookModel) {
              _myReportsNoteModelList.add(
                MyReportNotesModel(
                  duration: reportBookModel["duration"],
                  topicName: reportBookModel["topic_name"],
                  noteID: reportBookModel["note_id"],
                  notesName: reportBookModel["notes_name"],
                  updatedTime: reportBookModel["updated_time"],
                  pageRead: reportBookModel["page_read"],
                  totalPages: reportBookModel["total_pages"],
                  subjectID:
                      (_response).keys.toList().elementAt(_subjectLevelIndex),
                ),
              );
              _myReportsModel.totalTimeSpentOnApp =
                  _myReportsModel.totalTimeSpentOnApp +
                      int.parse(reportBookModel["duration"]);
            });
            _myReportsModel.myReportNotesModelList!
                .addAll(_myReportsNoteModelList);
          });
          _myReportsModel.totalUniqueNotesAttempted =
              ((myReportModelList)["books_notes"]).values.length;
        }

        //Declare a variable to add all the mastery inside a subject.
        double _subjectLevelTotalMasteryValue = 0.0;
        if ((myReportModelList)["practice"] != null) {
          await Future.forEach(((myReportModelList)["practice"]).values,
              (myReportBookModelList) {
            List<MyReportPracticeModel> myReportsPracticeModelList = [];
            (myReportBookModelList as Map).values.forEach((reportBookModel) {
              myReportsPracticeModelList.add(
                MyReportPracticeModel(
                  duration: reportBookModel["duration"],
                  correctStreakCount: reportBookModel["correct_streak_count"],
                  mastery: (reportBookModel["mastery"].runtimeType == int)
                      ? double.parse(reportBookModel["mastery"].toString())
                      : reportBookModel["mastery"],
                  topicID: reportBookModel["topic_id"],
                  topicLevel: reportBookModel["topic_level"],
                  updatedTime: reportBookModel["updated_time"],
                  topicName: reportBookModel["topic_name"],
                  subjectID:
                      (_response).keys.toList().elementAt(_subjectLevelIndex),
                ),
              );
              _myReportsModel.totalTimeSpentOnApp =
                  _myReportsModel.totalTimeSpentOnApp +
                      int.parse(reportBookModel["duration"]);
            });

            _subjectLevelTotalMasteryValue +=
                (myReportBookModelList).values.last['mastery'];

            if (_myReportsModel.myReportPracticeModelList == null) {
              _myReportsModel.myReportPracticeModelList =
                  myReportsPracticeModelList;
            } else {
              _myReportsModel.myReportPracticeModelList!
                  .addAll(myReportsPracticeModelList);
            }
          });
          _myReportsModel.totalUniquePracticeSetAttempted =
              ((myReportModelList)["practice"]).values.length;
        }

        if ((myReportModelList)["test"] != null) {
          await Future.forEach(((myReportModelList)["test"]).values,
              (myReportBookModelList) {
            (myReportBookModelList as Map).values.forEach((reportBookModel) {
              _myReportsTestModelList.add(
                MyReportTestModel(
                  duration: reportBookModel["duration"],
                  correctCount: reportBookModel["correct_count"],
                  incorrectCount: reportBookModel["incorrect_count"],
                  marks: reportBookModel["marks"],
                  topicID: reportBookModel["topic_id"],
                  topicName: reportBookModel["topic_name"],
                  unattemptedCount: reportBookModel["unattempted_count"],
                  updatedTime: reportBookModel["updated_time"],
                  subjectID:
                      (_response).keys.toList().elementAt(_subjectLevelIndex),
                ),
              );
              _myReportsModel.totalTimeSpentOnApp +=
                  int.parse(reportBookModel["duration"]);
            });
            _myReportsModel.myReportTestModelList = _myReportsTestModelList;
          });
          _myReportsModel.totalUniqueTestsAttempted =
              ((myReportModelList)["test"]).values.length;
        }

        if ((myReportModelList)["video_lessons"] != null) {
          await Future.forEach(((myReportModelList)["video_lessons"]).values,
              (myReportBookModelList) {
            List<MyReportVideoLessonsModel> _myReportsVideoLessonsModelList =
                [];
            (myReportBookModelList as Map).values.forEach((reportBookModel) {
              _myReportsVideoLessonsModelList.add(
                MyReportVideoLessonsModel(
                  duration: reportBookModel["duration"],
                  videoID: reportBookModel["video_id"],
                  videoName: reportBookModel["video_name"],
                  videoUrl: reportBookModel["video_url"],
                  videoTotalDuration: reportBookModel["video_total_duration"],
                  topicName: reportBookModel["topic_name"],
                  updatedTime: reportBookModel["updated_time"],
                  subjectID:
                      (_response).keys.toList().elementAt(_subjectLevelIndex),
                ),
              );
              _myReportsModel.totalTimeSpentOnApp =
                  _myReportsModel.totalTimeSpentOnApp +
                      int.parse(reportBookModel["duration"]);
            });
            if (_myReportsModel.myReportVideoLessonsModelList == null) {
              _myReportsModel.myReportVideoLessonsModelList =
                  _myReportsVideoLessonsModelList;
            } else {
              _myReportsModel.myReportVideoLessonsModelList!
                  .addAll(_myReportsVideoLessonsModelList);
            }

            //Check most watched video chapter
            if (_myReportsModel.mostWatchedChapterName == null ||
                (_myReportsModel.mostWatchedChapterName != null &&
                    (_myReportsModel.mostWatchedChapterNameCount! <
                        ((myReportBookModelList).values.length)))) {
              _myReportsModel.mostWatchedChapterName =
                  (myReportBookModelList).values.first['topic_name'];
              _myReportsModel.mostWatchedChapterNameCount =
                  (myReportBookModelList).values.length;
            }
          });
        }

        _myReportsModel.subjectID =
            (_response).keys.toList().elementAt(_subjectLevelIndex);

        //TODO: Find out subject name and subject image url on the basis of Subject Id.
        var _locallySavedSubjects = await helper
            .fetchSubjectNameBasisEducationBoardClassSubjectIDAndLanguage(
          language: _language,
          subjectID: _myReportsModel.subjectID,
          boardName: _educationBoard,
          classID: _classNumber,
        );

        if ((_locallySavedSubjects != null) &&
            (_locallySavedSubjects as List).isNotEmpty) {
          _myReportsModel.subjectName = _locallySavedSubjects[0]['subjectName'];
          _myReportsModel.subjectIconUrl =
              _locallySavedSubjects[0]['subjectIconPath'];
        } else {
          _locallySavedSubjects = await dashboardRepository.fetchSubjectList(
              educationBoard: boardName?.toLowerCase(),
              batch: true,
              selectedClass: studentClass);
          if (_locallySavedSubjects != null) {
            SubjectModel? _subjectModel =
                (_locallySavedSubjects as List<SubjectModel>)
                    .where((element) =>
                        (element.subjectID == _myReportsModel.subjectID))
                    .first;
            _myReportsModel.subjectName = _subjectModel.subjectName;
            _myReportsModel.subjectIconUrl = _subjectModel.subjectIconPath;
          }
        }
        _myReportsModel.boardID = _educationBoard;
        _myReportsModel.classID = _classNumber;
        _myReportsModel.language = _language;

        //Fetch total Chapter count in order to calculate subject level mastery.
        var response = await videoLessonRepository
            .fetchVideoLessons(_myReportsModel.subjectID);
        if (response is List<String>) {
          int _chapterCount = response.length;
          _myReportsModel.subjectLevelMastery =
              (_subjectLevelTotalMasteryValue / _chapterCount) * 100;
        }

        _myReportsModelList.add(_myReportsModel);
        _subjectLevelIndex++;
      });
      debugPrint(_myReportsModelList.toList().toString());

      return _myReportsModelList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future fetchExtraBookReport({
    String? boardName,
    String? studentUserID,
    String? studentLanguage,
    String? studentClass,
  }) async {
    try {
      String? _classNumber;
      String? _stream;
      String? _userID = studentUserID ?? await getStringValuesSF("userID");
      String? _educationBoard = boardName != null
          ? boardName.toLowerCase()
          : (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String? _language = studentLanguage ??
          (await getStringValuesSF("language"))!.toLowerCase();
      _classNumber = studentClass ?? await (getStringValuesSF("classNumber"));

      if ((int.parse(_classNumber!)) > 10) {
        _stream = await getStringValuesSF("stream"); //2
        _classNumber = "${_classNumber}_${_stream!}";
      } else {
        _classNumber = _classNumber;
      }

      var _response = await apiHandler.getAPICall(
          endPointURL: "reports/app_reports/"
              "$_userID/"
              "data/"
              "$_classNumber/"
              "$_educationBoard/"
              "$_language/"
              "books/");

      return _response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future fetchStemVideosReport({
    String? boardName,
    String? studentUserID,
    String? studentLanguage,
    String? studentClass,
  }) async {
    try {
      String? _classNumber;
      String? _stream;
      String? _userID = studentUserID ?? await getStringValuesSF("userID");
      String? _educationBoard = boardName != null
          ? boardName.toLowerCase()
          : (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String? _language = studentLanguage ??
          (await getStringValuesSF("language"))!.toLowerCase();
      _classNumber = studentClass ?? await (getStringValuesSF("classNumber"));

      if ((int.parse(_classNumber!)) > 10) {
        _stream = await getStringValuesSF("stream"); //2
        _classNumber = "${_classNumber}_${_stream!}";
      } else {
        _classNumber = _classNumber;
      }
      var _response = await apiHandler.getAPICall(
          endPointURL:
              "reports/app_reports/$_userID/data/$_classNumber/$_educationBoard/$_language/stem_videos/");

      return _response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future saveOverallAppUses({
    String? subjectID,
    required String categoryName,
    String? className,
    required String userId,
    required String boardName,
    required String language,
    required String appUsesDuration,
  }) async {
    try {
      await dbRef
          .child('iprep_app_usage/$userId/total_time')
          .once()
          .then((snapshot) async {
        var _data = snapshot.snapshot.value;
        int? _totalAppUses = int.parse(appUsesDuration);
        if (_data != null) {
          _totalAppUses += _data as int;
        }
        await dbRef.child('iprep_app_usage/$userId').update({
          'total_time': _totalAppUses,
        });
        await dbRef
            .child(
                'iprep_app_usage/$userId/$subjectID/$boardName/$className/$language/$categoryName')
            .once()
            .then((snapshot1) async {
          var _data1 = snapshot1.snapshot.value;
          int _totalCategoryWiseUses = int.parse(appUsesDuration);
          if (_data1 != null) {
            _totalCategoryWiseUses += _data1 as int;
          }
          await dbRef
              .child(
                  'iprep_app_usage/$userId/$subjectID/$boardName/$className/$language/')
              .update({
            categoryName: _totalCategoryWiseUses,
          });
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
