import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/custom_widgets/linear_percent_indicator.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/model/my_reports_model.dart';
import 'package:idream/ui/menu/my_report/books_completed_report_home_page.dart';
import 'package:idream/ui/menu/my_report/books_library_report_home_page.dart';
import 'package:idream/ui/menu/my_report/notes_completed_report_home_page.dart';
import 'package:idream/ui/menu/my_report/practice_attempted_report_home_page.dart';
import 'package:idream/ui/menu/my_report/project_and_practicals_report_home_page.dart';
import 'package:idream/ui/menu/my_report/video_watched_report_home_page.dart';
import 'package:flutter/cupertino.dart';
import '../my_reports_page.dart';
import 'test_attempted_report_home_page.dart';

class MyReportDetailedViewPage extends StatefulWidget {
  final List<MyReportsModel>? listMyReportsModel;
  final String? viewName;
  final String? bookLibraryCompleteData;
  final String? stemVideosCompleteData;
  final MyReportsPage? myReportsPage;

  const MyReportDetailedViewPage({
    Key? key,
    this.listMyReportsModel,
    this.viewName,
    this.bookLibraryCompleteData,
    this.stemVideosCompleteData,
    this.myReportsPage,
  }) : super(key: key);

  @override
  _MyReportDetailedViewPageState createState() =>
      _MyReportDetailedViewPageState();
}

class _MyReportDetailedViewPageState extends State<MyReportDetailedViewPage> {
  DateTime? _selectedWeekStartDate;
  DateTime? _selectedWeekEndDate;
  final List<MyReportsModel> _filteredListMyReportsModel = [];
  int? _selectedWeekNumber;
  late String _weekText;
  bool _dataPrepared = false;
  int _totalTimeSpentOnCoreApp = 0;
  int _totalVideosWatched = 0;
  int _totalPracticeSetCompleted = 0;
  int _totalTestCompleted = 0;
  int _totalNotesCompleted = 0;
  int _totalBooksCompleted = 0;
  int _totalDuration = 0;

  String? _totalTimeSpentText = "";
  String _totalSpentDays = "";
  Map? _bookLibraryDataMap, _stemVideosDataMap;
  final List<MyReportsModel> _bookLibraryReportModel = [];
  int _uniqueTotalBookLibraryCount = 0;
  int _totalBookLibraryDuration = 0;
  final List<MyReportsModel> _stemVideosReportModel = [];
  int _uniqueTotalStemVideosCount = 0;
  int _totalStemVideosDuration = 0;

  // Map _current

  Future _getTotalTimeSpentOnApp() async {
    _filteredListMyReportsModel.forEach((myReportModel) {
      _totalDuration += myReportModel.totalTimeSpentOnApp;
    });
    _totalTimeSpentOnCoreApp = _totalDuration;
    // _totalTimeSpentText = await _getTotalTimeString(_totalDuration);
  }

  Future _getTotalTimeString(int duration) async {
    // duration = 7185;
    String timeSpentString = "";
    if (Duration(seconds: duration).inHours > 0) {
      timeSpentString += "${Duration(seconds: duration).inHours}h ";
    }
    if (Duration(seconds: duration).inMinutes.remainder(60) > 0) {
      timeSpentString +=
          "${Duration(seconds: duration).inMinutes.remainder(60)}m ";
    }
    if (Duration(seconds: duration).inSeconds.remainder(60) > 0) {
      timeSpentString +=
          "${Duration(seconds: duration).inSeconds.remainder(60)}s ";
    }
    return timeSpentString;
  }

  Future _videosWatchedCount() async {
    _filteredListMyReportsModel.forEach((myReportModel) {
      if (myReportModel.myReportVideoLessonsModelList != null &&
          myReportModel.myReportVideoLessonsModelList!.isNotEmpty) {
        List _newList = [];

        myReportModel.myReportVideoLessonsModelList!
            .forEach((element) => _newList.add(element.videoUrl));
        /* comment this line because we need all count of the videos so we only remove set */
        // _totalVideosWatched += _newList.toSet().length;
        _totalVideosWatched += _newList.length;
        debugPrint(_totalVideosWatched.toString());
      }

      if (myReportModel.myReportPracticeModelList != null &&
          myReportModel.myReportPracticeModelList!.isNotEmpty) {
        List newList = [];
        for (var element in myReportModel.myReportPracticeModelList!) {
          newList.add(element.topicID);
        }
        /* comment this line because we need all count of the videos so we only remove set */
        // _totalPracticeSetCompleted += _newList.toSet().length;
        _totalPracticeSetCompleted += newList.length;
        // _totalPracticeSetCompleted +=
        //     myReportModel.totalUniquePracticeSetAttempted;
      }

      if (myReportModel.myReportTestModelList != null &&
          myReportModel.myReportTestModelList!.isNotEmpty) {
        List newList = [];
        for (var element in myReportModel.myReportTestModelList!) {
          newList.add(element.topicID);
        }
        _totalTestCompleted += newList.length;
      }

      if (myReportModel.myReportNotesModelList != null &&
          myReportModel.myReportNotesModelList!.isNotEmpty) {
        List newList = [];
        for (var element in myReportModel.myReportNotesModelList!) {
          newList.add(element.noteID);
        }

        /* comment this line because we need all count of the videos so we only remove set */
        // _totalNotesCompleted += _newList.toSet().length;
        _totalNotesCompleted += newList.length;
        // _totalNotesCompleted += myReportModel.totalUniqueNotesAttempted;
      }

      if (myReportModel.myReportBooksModelList != null &&
          myReportModel.myReportBooksModelList!.isNotEmpty) {
        List _newList = [];
        myReportModel.myReportBooksModelList!
            .forEach((element) => _newList.add(element.bookID));
        /* comment this line because we need all count of the videos so we only remove set */
        // _totalBooksCompleted += _newList.toSet().length;
        _totalBooksCompleted += _newList.length;
        // _totalBooksCompleted += myReportModel.totalUniqueBooksAttempted;
      }
    });
  }

  _compareDates({String? alreadySavedDate, String? newDate}) {
    if (alreadySavedDate!.isNotEmpty) {
      if (DateTime.parse(alreadySavedDate).compareTo(DateTime.parse(newDate!)) >
          0) {
        alreadySavedDate = newDate;
      }
    } else {
      alreadySavedDate = newDate;
    }
    return alreadySavedDate;
  }

  Future _calculateSpentDays() async {
    String _learningStartTime = DateTime.now().toString();

    _filteredListMyReportsModel.forEach((myReportModel) {
      if (myReportModel.myReportBooksModelList != null &&
          myReportModel.myReportBooksModelList!.isNotEmpty) {
        _learningStartTime = _compareDates(
            alreadySavedDate: _learningStartTime,
            newDate: myReportModel.myReportBooksModelList!.first.updatedTime);
      }
      if (myReportModel.myReportNotesModelList != null &&
          myReportModel.myReportNotesModelList!.isNotEmpty) {
        _learningStartTime = _compareDates(
            alreadySavedDate: _learningStartTime,
            newDate: myReportModel.myReportNotesModelList!.first.updatedTime);
      }
      if (myReportModel.myReportPracticeModelList != null &&
          myReportModel.myReportPracticeModelList!.isNotEmpty) {
        _learningStartTime = _compareDates(
            alreadySavedDate: _learningStartTime,
            newDate:
                myReportModel.myReportPracticeModelList!.first.updatedTime);
      }
      // if (myReportModel.myReportTestModelList != null && myReportModel.myReportTestModelList.isNotEmpty) {
      //   _learningStartTime = _compareDates(
      //       alreadySavedDate: _learningStartTime,
      //       newDate: myReportModel.myReportTestModelList.first.updatedTime);
      // }
      if (myReportModel.myReportVideoLessonsModelList != null &&
          myReportModel.myReportVideoLessonsModelList!.isNotEmpty) {
        _learningStartTime = _compareDates(
            alreadySavedDate: _learningStartTime,
            newDate:
                myReportModel.myReportVideoLessonsModelList!.first.updatedTime);
      }
    });

    _totalSpentDays = DateTime.now()
        .difference(DateTime.parse(_learningStartTime))
        .inDays
        .toString()
        .padLeft(2, "0");
  }

  _updateStartAndEndWeekDate() {
    DateTime.now().weekday;
    _selectedWeekStartDate = DateTime.now().subtract(Duration(
        days:
            (((_selectedWeekNumber! + 1) * 7) - (8 - DateTime.now().weekday))));
    _selectedWeekStartDate = DateTime(_selectedWeekStartDate!.year,
        _selectedWeekStartDate!.month, _selectedWeekStartDate!.day);
    _selectedWeekEndDate = DateTime.now().subtract(Duration(
        days: ((_selectedWeekNumber! * 7) - (7 - DateTime.now().weekday))));
    _selectedWeekEndDate = DateTime(_selectedWeekEndDate!.year,
        _selectedWeekEndDate!.month, _selectedWeekEndDate!.day, 23, 59);
    debugPrint(_selectedWeekStartDate.toString());
    debugPrint(_selectedWeekEndDate.toString());
  }

  _updateStartAndEndMonthDateNext({String? monthType = ""}) {
    if (_selectedWeekNumber == 0) {
      _selectedWeekStartDate =
          DateTime(DateTime.now().year, DateTime.now().month, 1);
      _selectedWeekEndDate = DateTime.now();
    } else {
      if (monthType == "next") {
        _selectedWeekStartDate =
            _selectedWeekEndDate!.add(const Duration(days: 1));
        _selectedWeekEndDate = _selectedWeekEndDate!.add(Duration(
            days: Constants.daysInMonth[((_selectedWeekStartDate!.month == 12)
                ? 1
                : (_selectedWeekStartDate!.month))]));
        _selectedWeekEndDate = DateTime(_selectedWeekEndDate!.year,
            _selectedWeekEndDate!.month, _selectedWeekEndDate!.day, 23, 59, 59);
      } else {
        _selectedWeekEndDate =
            _selectedWeekStartDate!.subtract(const Duration(days: 1));
        _selectedWeekStartDate = _selectedWeekStartDate!.subtract(Duration(
            days: Constants.daysInMonth[((_selectedWeekStartDate!.month == 1)
                ? 12
                : (_selectedWeekStartDate!.month - 1))]));
        _selectedWeekEndDate = DateTime(_selectedWeekEndDate!.year,
            _selectedWeekEndDate!.month, _selectedWeekEndDate!.day, 23, 59, 59);
      }
    }
    debugPrint(_selectedWeekStartDate.toString());
    debugPrint(_selectedWeekEndDate.toString());
  }

  _updateStartAndEndYearDateNext() {
    if (_selectedWeekNumber == 0) {
      _selectedWeekStartDate = DateTime(DateTime.now().year, 1, 1);
      _selectedWeekEndDate = DateTime.now();
    } else {
      if ((DateTime.now().year -
              _selectedWeekStartDate!.year -
              _selectedWeekNumber!) >=
          1) {
        _selectedWeekStartDate =
            DateTime(_selectedWeekStartDate!.year + 1, 1, 1);
        _selectedWeekEndDate = DateTime(_selectedWeekStartDate!.year, 12, 31);
      } else {
        _selectedWeekStartDate =
            DateTime(_selectedWeekStartDate!.year - 1, 1, 1);
        _selectedWeekEndDate = DateTime(_selectedWeekStartDate!.year, 12, 31);
      }
    }
    debugPrint(_selectedWeekStartDate.toString());
    debugPrint(_selectedWeekEndDate.toString());
  }

  Future _reinitializeAllTheData() async {
    _filteredListMyReportsModel.clear();
    await Future.forEach(widget.listMyReportsModel!, (myReportModel) async {
      debugPrint(myReportModel.toString());
      List<MyReportBooksModel> _booksReportModelList = [];
      if ((myReportModel as MyReportsModel).myReportBooksModelList != null) {
        await Future.forEach((myReportModel).myReportBooksModelList!,
            (dynamic element) {
          _booksReportModelList.add(MyReportBooksModel(
              duration: element.duration,
              bookID: element.bookID,
              bookName: element.bookName,
              topicName: element.topicName,
              updatedTime: element.updatedTime,
              subjectID: element.subjectID,
              pageRead: element.pageRead,
              totalPages: element.totalPages));
        });
      }
      List<MyReportNotesModel> _notesReportModelList = [];
      if ((myReportModel).myReportNotesModelList != null) {
        await Future.forEach((myReportModel).myReportNotesModelList!,
            (dynamic element) {
          _notesReportModelList.add(MyReportNotesModel(
              duration: element.duration,
              noteID: element.noteID,
              notesName: element.notesName,
              topicName: element.topicName,
              updatedTime: element.updatedTime,
              subjectID: element.subjectID,
              pageRead: element.pageRead,
              totalPages: element.totalPages));
        });
      }
      List<MyReportPracticeModel> _practiceReportModelList = [];
      double? subjectMastery = 0.0;
      List subjectMasteryCount = [];
      if ((myReportModel).myReportPracticeModelList != null) {
        await Future.forEach((myReportModel).myReportPracticeModelList!,
            (dynamic element) {
          subjectMasteryCount.add(element.mastery);

          subjectMastery = (subjectMastery! + element.mastery);

          _practiceReportModelList.add(MyReportPracticeModel(
            duration: element.duration,
            topicID: element.topicID,
            topicLevel: element.topicLevel,
            topicName: element.topicName,
            updatedTime: element.updatedTime,
            subjectID: element.subjectID,
            correctStreakCount: element.correctStreakCount,
            mastery: element.mastery,
          ));
        });
      }

      List<MyReportTestModel>? _myReportTestModelList = [];

      if ((myReportModel).myReportTestModelList != null) {
        await Future.forEach((myReportModel).myReportTestModelList!,
            (dynamic element) {
          _myReportTestModelList.add(
            MyReportTestModel(
              correctCount: element.correctCount,
              duration: element.duration,
              incorrectCount: element.incorrectCount,
              marks: element.marks,
              subjectID: element.subjectID,
              topicID: element.topicID,
              topicName: element.topicName,
              unattemptedCount: element.unattemptedCount,
              updatedTime: element.updatedTime,
            ),
          );
        });
      }

      List<MyReportVideoLessonsModel> _videoLessonReportModelList = [];
      if ((myReportModel).myReportVideoLessonsModelList != null) {
        await Future.forEach((myReportModel).myReportVideoLessonsModelList!,
            (dynamic element) {
          _videoLessonReportModelList.add(MyReportVideoLessonsModel(
            duration: element.duration,
            videoID: element.videoID,
            videoName: element.videoName,
            topicName: element.topicName,
            updatedTime: element.updatedTime,
            subjectID: element.subjectID,
            videoUrl: element.videoUrl,
            videoTotalDuration: element.videoTotalDuration,
          ));
        });
      }
      double? subjectLevelMastery = 0.0;

      subjectLevelMastery = subjectMastery! / subjectMasteryCount.length;

      subjectLevelMastery.toString() == "NaN"
          ? subjectLevelMastery = 0.0
          : subjectLevelMastery;

      _filteredListMyReportsModel.add(MyReportsModel(
        boardID: myReportModel.boardID,
        classID: myReportModel.classID,
        language: myReportModel.language,
        subjectID: myReportModel.subjectID,
        reportType: myReportModel.reportType,
        chapterName: myReportModel.chapterName,
        totalTimeSpentOnApp: myReportModel.totalTimeSpentOnApp,
        mostWatchedChapterName: myReportModel.mostWatchedChapterName,
        mostWatchedChapterNameCount: myReportModel.mostWatchedChapterNameCount,
        subjectLevelMastery: subjectLevelMastery,
        totalUniquePracticeSetAttempted:
            myReportModel.totalUniquePracticeSetAttempted,
        totalUniqueTestsAttempted: myReportModel.totalUniqueTestsAttempted,
        totalUniqueBooksAttempted: myReportModel.totalUniqueBooksAttempted,
        totalUniqueNotesAttempted: myReportModel.totalUniqueNotesAttempted,
        myReportBooksModelList: _booksReportModelList,
        myReportNotesModelList: _notesReportModelList,
        myReportPracticeModelList: _practiceReportModelList,
        myReportTestModelList: _myReportTestModelList,
        myReportVideoLessonsModelList: _videoLessonReportModelList,
      ));
    });
    _totalTimeSpentOnCoreApp = 0;
    _totalVideosWatched = 0;
    _totalPracticeSetCompleted = 0;
    _totalTestCompleted = 0;
    _totalNotesCompleted = 0;
    _totalBooksCompleted = 0;
    _totalDuration = 0;
  }

  Future _filterTotalReportModelBasisOnSelectedWeek() async {
    await _reinitializeAllTheData();
    for (var filteredReportsModel in _filteredListMyReportsModel) {
      if (filteredReportsModel.myReportPracticeModelList != null) {
        for (int i = filteredReportsModel.myReportPracticeModelList!.length - 1;
            i >= 0;
            i--) {
          if ((DateTime.parse(filteredReportsModel
                      .myReportPracticeModelList![i].updatedTime!)
                  .isBefore(_selectedWeekStartDate!)) ||
              (DateTime.parse(filteredReportsModel
                      .myReportPracticeModelList![i].updatedTime!)
                  .isAfter(_selectedWeekEndDate!))) {
            filteredReportsModel.totalTimeSpentOnApp -= int.parse(
                filteredReportsModel.myReportPracticeModelList![i].duration!);
            filteredReportsModel.myReportPracticeModelList!
                .remove(filteredReportsModel.myReportPracticeModelList![i]);
          }
        }

        filteredReportsModel.totalUniquePracticeSetAttempted =
            filteredReportsModel.myReportPracticeModelList!.length;
      }
      if (filteredReportsModel.myReportTestModelList != null) {
        for (int i = filteredReportsModel.myReportTestModelList!.length - 1;
            i >= 0;
            i--) {
          if ((DateTime.parse(filteredReportsModel
                      .myReportTestModelList![i].updatedTime!)
                  .isBefore(_selectedWeekStartDate!)) ||
              (DateTime.parse(filteredReportsModel
                      .myReportTestModelList![i].updatedTime!)
                  .isAfter(_selectedWeekEndDate!))) {
            filteredReportsModel.totalTimeSpentOnApp -= int.parse(
                filteredReportsModel.myReportTestModelList![i].duration!);
            filteredReportsModel.myReportTestModelList!
                .remove(filteredReportsModel.myReportTestModelList![i]);
          }
        }

        filteredReportsModel.totalUniqueTestsAttempted =
            filteredReportsModel.myReportTestModelList!.length;
      }

      if (filteredReportsModel.myReportNotesModelList != null) {
        for (int i = filteredReportsModel.myReportNotesModelList!.length - 1;
            i >= 0;
            i--) {
          if ((DateTime.parse(filteredReportsModel
                      .myReportNotesModelList![i].updatedTime!)
                  .isBefore(_selectedWeekStartDate!)) ||
              (DateTime.parse(filteredReportsModel
                      .myReportNotesModelList![i].updatedTime!)
                  .isAfter(_selectedWeekEndDate!))) {
            filteredReportsModel.totalTimeSpentOnApp -= int.parse(
                filteredReportsModel.myReportNotesModelList![i].duration!);
            filteredReportsModel.myReportNotesModelList!
                .remove(filteredReportsModel.myReportNotesModelList![i]);
          }
        }
        filteredReportsModel.totalUniqueNotesAttempted =
            filteredReportsModel.myReportNotesModelList!.length;
      }

      if (filteredReportsModel.myReportBooksModelList != null) {
        for (int i = filteredReportsModel.myReportBooksModelList!.length - 1;
            i >= 0;
            i--) {
          if ((DateTime.parse(filteredReportsModel
                      .myReportBooksModelList![i].updatedTime!)
                  .isBefore(_selectedWeekStartDate!)) ||
              (DateTime.parse(filteredReportsModel
                      .myReportBooksModelList![i].updatedTime!)
                  .isAfter(_selectedWeekEndDate!))) {
            filteredReportsModel.totalTimeSpentOnApp -= int.parse(
                filteredReportsModel.myReportBooksModelList![i].duration!);
            filteredReportsModel.myReportBooksModelList!
                .remove(filteredReportsModel.myReportBooksModelList![i]);
          }
        }

        filteredReportsModel.totalUniqueBooksAttempted =
            filteredReportsModel.myReportBooksModelList!.length;
      }

      if (filteredReportsModel.myReportVideoLessonsModelList != null) {
        for (int i =
                filteredReportsModel.myReportVideoLessonsModelList!.length - 1;
            i >= 0;
            i--) {
          if ((DateTime.parse(filteredReportsModel
                      .myReportVideoLessonsModelList![i].updatedTime!)
                  .isBefore(_selectedWeekStartDate!)) ||
              (DateTime.parse(filteredReportsModel
                      .myReportVideoLessonsModelList![i].updatedTime!)
                  .isAfter(_selectedWeekEndDate!))) {
            filteredReportsModel.totalTimeSpentOnApp -= int.parse(
                filteredReportsModel
                    .myReportVideoLessonsModelList![i].duration!);
            filteredReportsModel.myReportVideoLessonsModelList!
                .remove(filteredReportsModel.myReportVideoLessonsModelList![i]);
          }
        }
      }
    }
    debugPrint(_filteredListMyReportsModel.toList().toString());
  }

  Future _filterBooksLibraryAndStemVideosData() async {
    _totalBookLibraryDuration = 0;
    _totalStemVideosDuration = 0;
    _bookLibraryReportModel.clear();
    _bookLibraryDataMap = jsonDecode(widget.bookLibraryCompleteData!);
    _uniqueTotalBookLibraryCount = 0;

    if (_bookLibraryDataMap != null) {
      int _bookLevelIndex = 0;
      await Future.forEach(_bookLibraryDataMap!.values.toList(),
          (dynamic element) async {
        MyReportsModel _myBookLibraryModel = MyReportsModel(
          subjectName: _bookLibraryDataMap!.keys.toList()[_bookLevelIndex],
          myReportExtraBooksModelList: [],
        );
        List<String> _bookIdsList = [];
        await Future.forEach(element.values.toList(), (dynamic element1) async {
          await Future.forEach(element1.values.toList(),
              (dynamic element2) async {
            if (((DateTime.parse(element2['updated_time'])
                    .isAfter(_selectedWeekStartDate!)) &&
                (DateTime.parse(element2['updated_time'])
                    .isBefore(_selectedWeekEndDate!)))) {
              _totalBookLibraryDuration +=
                  int.tryParse(element2['duration']) ?? 0;
              MyReportExtraBooksModel _myReportExtraBooksModel =
                  MyReportExtraBooksModel.fromJson(element2);
              _myBookLibraryModel.myReportExtraBooksModelList!
                  .add(_myReportExtraBooksModel);
              _bookIdsList.add(_myReportExtraBooksModel.bookID!);
            }
          });
        });
        _myBookLibraryModel.totalUniqueBooksAttempted = _bookIdsList.length;
        _uniqueTotalBookLibraryCount +=
            _myBookLibraryModel.totalUniqueBooksAttempted!;
        _bookLibraryReportModel.add(_myBookLibraryModel);
        _bookLevelIndex++;
      });
    }

    _stemVideosReportModel.clear();
    dynamic _stemVideosDataMap = jsonDecode(widget.stemVideosCompleteData!);
    _uniqueTotalStemVideosCount = 0;

    if (_stemVideosDataMap != null) {
      int _stemVideosLevelIndex = 0;
      await Future.forEach(_stemVideosDataMap.values.toList(),
          (dynamic element) async {
        MyReportsModel _myStemVideosModel = MyReportsModel(
          subjectID: _stemVideosDataMap.keys.toList()[_stemVideosLevelIndex],
          myReportVideoLessonsModelList: [],
        );
        List<String> _videoIdsList = [];
        await Future.forEach(element.values.toList(), (dynamic element1) async {
          await Future.forEach(element1.values.toList(),
              (dynamic element2) async {
            await Future.forEach(element2.values.toList(),
                (dynamic element3) async {
              if (((DateTime.parse(element3['updated_time'])
                      .isAfter(_selectedWeekStartDate!)) &&
                  (DateTime.parse(element3['updated_time'])
                      .isBefore(_selectedWeekEndDate!)))) {
                _totalStemVideosDuration +=
                    int.tryParse(element3['duration']) ?? 0;
                MyReportVideoLessonsModel _myReportStemVideosModel =
                    MyReportVideoLessonsModel.fromJson(element3);
                _myStemVideosModel.myReportVideoLessonsModelList!
                    .add(_myReportStemVideosModel);
                _videoIdsList.add(_myReportStemVideosModel.videoID!);
              }
            });
          });
        });

        _uniqueTotalStemVideosCount += _videoIdsList.length;
        _stemVideosReportModel.add(_myStemVideosModel);
        _stemVideosLevelIndex++;
      });
    }
    _totalDuration += _totalBookLibraryDuration + _totalStemVideosDuration;
    _totalTimeSpentText = await _getTotalTimeString(_totalDuration);
  }

  Future _getsRequiredDataReady() async {
    _filterTotalReportModelBasisOnSelectedWeek().then((value) {
      _getTotalTimeSpentOnApp().then((value1) {
        _videosWatchedCount().then((value2) {
          _calculateSpentDays().then((value3) {
            _filterBooksLibraryAndStemVideosData().then((_) {
              setState(() {
                _dataPrepared = true;
              });
            });
          });
        });
      });
    });
  }

  _updateStartAndDateForTheSelectedView({String? monthType}) {
    switch (widget.viewName) {
      case "week":
        _updateStartAndEndWeekDate();
        break;
      case "month":
        _updateStartAndEndMonthDateNext(monthType: monthType);
        break;
      case "year":
        _updateStartAndEndYearDateNext();
        break;
    }
  }

  _getWeekText() {
    switch (widget.viewName) {
      case "week":
        switch (_selectedWeekNumber) {
          case 0:
            _weekText = "This Week";
            break;
          case 1:
            _weekText = "Last Week";
            break;
          default:
            _weekText =
                "${_selectedWeekStartDate!.day} ${Constants.months[_selectedWeekStartDate!.month - 1]}"
                " - ${_selectedWeekEndDate!.day} ${Constants.months[_selectedWeekEndDate!.month - 1]}";
            break;
        }
        break;
      case "month":
        switch (_selectedWeekNumber) {
          case 0:
            _weekText = "This Month";
            break;
          case 1:
            _weekText = "Last Month";
            break;
          default:
            _weekText =
                "${Constants.months[_selectedWeekStartDate!.month - 1]} ${_selectedWeekStartDate!.year}";
            break;
        }
        break;
      case "year":
        switch (_selectedWeekNumber) {
          case 0:
            _weekText = "This Year";
            break;
          case 1:
            _weekText = "Last Year";
            break;
          default:
            _weekText = "Year ${_selectedWeekStartDate!.year}";
            break;
        }
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedWeekNumber = 0;
    _updateStartAndDateForTheSelectedView();
    _getWeekText();
    _getsRequiredDataReady();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 24,
                    bottom: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(7),
                          onTap: () {
                            _selectedWeekNumber = _selectedWeekNumber! + 1;
                            _updateStartAndDateForTheSelectedView(
                                monthType: "previous");
                            _getWeekText();
                            setState(() {
                              _dataPrepared = false;
                            });
                            _getsRequiredDataReady();
                          },
                          child: Image.asset(
                            "assets/images/back_grey.png",
                            height: 25,
                          ),
                        ),
                      ),
                      Text(
                        _weekText,
                        style: TextStyle(
                            color: const Color(0xFF212121),
                            fontSize: 14,
                            fontWeight: FontWeight.values[5]),
                      ),
                      RotationTransition(
                        turns: const AlwaysStoppedAnimation(180 / 360),
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(7),
                            onTap: () {
                              if (_selectedWeekNumber != 0) {
                                _selectedWeekNumber = _selectedWeekNumber! - 1;
                                _updateStartAndDateForTheSelectedView(
                                    monthType: "next");
                                _getWeekText();
                                setState(() {
                                  _dataPrepared = false;
                                });
                                _getsRequiredDataReady();
                              }
                            },
                            child: Image.asset(
                              "assets/images/back_grey.png",
                              height: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  "assets/images/line_1.png",
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_totalDuration != 0)
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              "Time Spent on Learning",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: const Color(0xFF9E9E9E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.values[4]),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              _totalTimeSpentText!,
                              style: TextStyle(
                                  color: const Color(0xFF212121),
                                  fontSize: 22,
                                  fontWeight: FontWeight.values[4]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (_totalDuration != 0)
                  const SizedBox(
                    height: 26,
                  ),
                if (_totalDuration != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: ListView.builder(
                      itemCount: _filteredListMyReportsModel.length,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(
                        0,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Material(
                          color: Colors.transparent,
                          child: myReportSubjectRow(
                            subjectName:
                                widget.listMyReportsModel![index].subjectName ??
                                    widget.listMyReportsModel![index].subjectID,
                            subjectIconUrl: widget
                                .listMyReportsModel![index].subjectIconUrl,
                            duration: _filteredListMyReportsModel[index]
                                .totalTimeSpentOnApp,
                            totalDuration: _totalTimeSpentOnCoreApp,
                            myReportsModel: _filteredListMyReportsModel[index],
                          ),
                        );
                      },
                    ),
                  ),
                if (_totalDuration != 0)
                  Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 30,
                      bottom: 50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Categories",
                            style: TextStyle(
                                color: const Color(0xFF212121),
                                fontSize: 18,
                                fontWeight: FontWeight.values[5]),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (_totalVideosWatched != 0)
                          myReportCategoryRow(
                              imageName: "video_category",
                              categoryCount: _totalVideosWatched.toString(),
                              categoryText: "Videos Watched",
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => VideoWatchedReportHomePage(
                                      completeSubjectWiseReportList:
                                          _filteredListMyReportsModel,
                                    ),
                                  ),
                                );
                              }),
                        if (_totalPracticeSetCompleted != 0)
                          myReportCategoryRow(
                              imageName: "practice_category",
                              categoryCount:
                                  _totalPracticeSetCompleted.toString(),
                              categoryText: "Practice Completed",
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) =>
                                        PracticeAttemptedReportHomePage(
                                      completeSubjectWiseReportList:
                                          _filteredListMyReportsModel,
                                    ),
                                  ),
                                );
                              }),
                        if (_totalTestCompleted != 0)
                          myReportCategoryRow(
                              imageName: "tests_category",
                              categoryCount: _totalTestCompleted.toString(),
                              categoryText: "Tests Completed",
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => TestAttemptedReportHomePage(
                                      completeSubjectWiseReportList:
                                          _filteredListMyReportsModel,
                                    ),
                                  ),
                                );
                              }),
                        if (_totalNotesCompleted != 0)
                          myReportCategoryRow(
                            imageName: "notes_category",
                            categoryCount: _totalNotesCompleted.toString(),
                            categoryText: "Notes Read",
                            onTap: () async {
                              await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => NotesCompletedReportHomePage(
                                    completeSubjectWiseReportList:
                                        _filteredListMyReportsModel,
                                  ),
                                ),
                              );
                            },
                          ),
                        if (_totalBooksCompleted != 0)
                          myReportCategoryRow(
                            imageName: "books_category",
                            categoryCount: _totalBooksCompleted.toString(),
                            categoryText: "Syllabus Books Read",
                            onTap: () async {
                              await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => BooksCompletedReportHomePage(
                                    completeSubjectWiseReportList:
                                        _filteredListMyReportsModel,
                                  ),
                                ),
                              );
                            },
                          ),
                        if (_uniqueTotalBookLibraryCount != 0)
                          myReportCategoryRow(
                            imageName: "books_category",
                            categoryCount:
                                _uniqueTotalBookLibraryCount.toString(),
                            categoryText: "Books Read",
                            onTap: () async {
                              await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => BooksLibraryReportHomePage(
                                    booksLibraryReportData:
                                        _bookLibraryReportModel,
                                  ),
                                ),
                              );
                            },
                          ),
                        if (_uniqueTotalStemVideosCount != 0)
                          myReportCategoryRow(
                            imageName: "video_category",
                            categoryCount:
                                _uniqueTotalStemVideosCount.toString(),
                            categoryText: "Project And Practicals",
                            onTap: () async {
                              await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) =>
                                      ProjectAndPracticalsReportHomePage(
                                    projectAndPracticalsReportData:
                                        _stemVideosReportModel,
                                  ),
                                ),
                              );
                            },
                          )
                      ],
                    ),
                  ),
                if (_totalDuration == 0)
                  Center(
                    child: Text(
                      "No data exist",
                      style: Constants.noDataTextStyle,
                    ),
                  )
              ],
            ),
          ),
          if (!_dataPrepared) const FullPageLoader()
        ],
      ),
    );
  }

  Widget myReportSubjectRow(
      {String? subjectName,
      String? subjectIconUrl,
      required int duration,
      int? totalDuration,
      MyReportsModel? myReportsModel}) {
    String _timeSpentString = "";
    if (Duration(seconds: duration).inHours > 0) {
      _timeSpentString += "${Duration(seconds: duration).inHours}h ";
    }
    if (Duration(seconds: duration).inMinutes.remainder(60) > 0) {
      _timeSpentString +=
          "${Duration(seconds: duration).inMinutes.remainder(60)}m ";
    }
    if (Duration(seconds: duration).inSeconds.remainder(60) > 0) {
      _timeSpentString +=
          "${Duration(seconds: duration).inSeconds.remainder(60)}s ";
    }

    return _timeSpentString.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(
              bottom: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: (subjectIconUrl != null)
                      ? CachedNetworkImage(
                          imageUrl: subjectIconUrl,
                          height: 49,
                          width: 49,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                strokeWidth: 0.5,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : Image.asset(
                          "assets/images/physics.png",
                          height: 49,
                          alignment: Alignment.centerLeft,
                        ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                subjectName ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xFF9E9E9E),
                                  fontWeight: FontWeight.values[4],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              _timeSpentString,
                              style: TextStyle(
                                color: const Color(0xFF212121),
                                fontWeight: FontWeight.values[4],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 11,
                        ),
                        LinearPercentIndicator(
                          padding: const EdgeInsets.all(0),
                          backgroundColor: const Color(0xFFDEDEDE),
                          percent: duration / totalDuration!,
                          progressColor: const Color(0xFF3399FF),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    "assets/images/vertical_line.png",
                    height: 17,
                    color: const Color(0xFF9E9E9E),
                    alignment: Alignment.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        "${myReportsModel!.subjectLevelMastery!.toStringAsFixed(2)}%",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.values[4],
                          color: const Color(0xFF212121),
                        ),
                      ),
                      Text(
                        "Mastery",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.values[4],
                          color: const Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  Widget myReportCategoryRow({
    String? imageName,
    String? categoryText,
    String? categoryCount,
    Function? onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap as void Function()?,
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/$imageName.png",
                      height: 49,
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "$categoryText ",
                            style: TextStyle(
                              color: const Color(0xFF666666),
                              fontSize: 14,
                              fontWeight: FontWeight.values[4],
                            ),
                          ),
                          TextSpan(
                            text: categoryCount,
                            style: TextStyle(
                              color: const Color(0xFF212121),
                              fontSize: 16,
                              fontWeight: FontWeight.values[4],
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.asset(
                  "assets/images/forward_arrow.png",
                  height: 35,
                  alignment: Alignment.centerRight,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
