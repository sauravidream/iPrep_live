import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import 'test_attempted_report_home_page.dart';

class DateWiseReportPage extends StatefulWidget {
  final List<MyReportsModel>? listMyReportsModel;
  final String? bookLibraryCompleteData;
  final String? stemVideosCompleteData;
  final DateTime? selectedDate;

  const DateWiseReportPage({
    Key? key,
    this.listMyReportsModel,
    this.bookLibraryCompleteData,
    this.stemVideosCompleteData,
    this.selectedDate,
  }) : super(key: key);

  @override
  _DateWiseReportPageState createState() => _DateWiseReportPageState();
}

class _DateWiseReportPageState extends State<DateWiseReportPage> {
  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;
  final List<MyReportsModel> _filteredListMyReportsModel = [];
  // _bookLibraryDataMap = jsonDecode(widget.bookLibraryCompleteData);
  // _stemVideosDataMap = jsonDecode(widget.stemVideosCompleteData);

  bool _dataPrepared = false;
  int _totalTimeSpentOnCoreApp = 0;
  int _totalVideosWatched = 0;
  int _totalPracticeSetCompleted = 0;
  int _totalTestCompleted = 0;
  int _totalNotesCompleted = 0;
  int _totalBooksCompleted = 0;
  int _totalDuration = 0;

  String _totalTimeSpentText = "";
  String _totalSpentDays = "";

  Map? _bookLibraryDataMap, _stemVideosDataMap;
  final List<MyReportsModel> _bookLibraryReportModel = [];
  int _uniqueTotalBookLibraryCount = 0;
  int _totalBookLibraryDuration = 0;
  final List<MyReportsModel> _stemVideosReportModel = [];
  int _uniqueTotalStemVideosCount = 0;
  int _totalStemVideosDuration = 0;

  Future _getTotalTimeSpentOnApp() async {
    _filteredListMyReportsModel.forEach((myReportModel) {
      _totalDuration += myReportModel.totalTimeSpentOnApp;
    });
    _totalTimeSpentOnCoreApp = _totalDuration;
    _totalTimeSpentText = await (_getTotalTimeString(_totalDuration));
  }

  Future _getTotalTimeString(int duration) async {
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
    return _timeSpentString;
  }

  Future _videosWatchedCount() async {
    _filteredListMyReportsModel.forEach((myReportModel) {
      if (myReportModel.myReportVideoLessonsModelList != null &&
          myReportModel.myReportVideoLessonsModelList!.isNotEmpty) {
        List newList = [];

        for (var element in myReportModel.myReportVideoLessonsModelList!) {
          newList.add(element.videoUrl);
        }
        _totalVideosWatched += newList.length;
      }

      if (myReportModel.myReportPracticeModelList != null &&
          myReportModel.myReportPracticeModelList!.isNotEmpty) {
        List newList = [];

        for (var element in myReportModel.myReportPracticeModelList!) {
          newList.add(element.topicID);
        }

        _totalPracticeSetCompleted += newList.length;
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

        _totalNotesCompleted += newList.length;
      }

      if (myReportModel.myReportBooksModelList != null &&
          myReportModel.myReportBooksModelList!.isNotEmpty) {
        List newList = [];

        for (var element in myReportModel.myReportBooksModelList!) {
          newList.add(element.bookID);
        }

        _totalBooksCompleted += newList.length;
      }
    });
  }

  _compareDates({required String alreadySavedDate, String? newDate}) {
    if (alreadySavedDate.isNotEmpty) {
      if (DateTime.parse(alreadySavedDate).compareTo(DateTime.parse(newDate!)) >
          0) {
        alreadySavedDate = newDate;
      }
    } else {
      alreadySavedDate = newDate!;
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
      if (myReportModel.myReportTestModelList != null &&
          myReportModel.myReportTestModelList!.isNotEmpty) {
        _learningStartTime = _compareDates(
            alreadySavedDate: _learningStartTime,
            newDate: myReportModel.myReportTestModelList!.first.updatedTime);
      }
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

  _updateStartAndEndDate({required DateTime selectedDate}) {
    _selectedStartDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    _selectedEndDate = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);
  }

  Future _reinitializeAllTheData() async {
    _filteredListMyReportsModel.clear();
    await Future.forEach(widget.listMyReportsModel!,
        (dynamic myReportModel) async {
      List<MyReportBooksModel> booksReportModelList = [];
      if ((myReportModel as MyReportsModel).myReportBooksModelList != null) {
        await Future.forEach(myReportModel.myReportBooksModelList!,
            (dynamic element) {
          booksReportModelList.add(MyReportBooksModel(
            duration: element.duration,
            bookID: element.bookID,
            bookName: element.bookName,
            topicName: element.topicName,
            updatedTime: element.updatedTime,
            subjectID: element.subjectID,
          ));
        });
      }
      List<MyReportNotesModel> notesReportModelList = [];
      if (myReportModel.myReportNotesModelList != null) {
        await Future.forEach(myReportModel.myReportNotesModelList!,
            (dynamic element) {
          notesReportModelList.add(MyReportNotesModel(
            duration: element.duration,
            noteID: element.noteID,
            notesName: element.notesName,
            topicName: element.topicName,
            updatedTime: element.updatedTime,
            subjectID: element.subjectID,
          ));
        });
      }
      List<MyReportPracticeModel> practiceReportModelList = [];
      if (myReportModel.myReportPracticeModelList != null) {
        await Future.forEach(myReportModel.myReportPracticeModelList!,
            (dynamic element) {
          practiceReportModelList.add(MyReportPracticeModel(
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
      List<MyReportVideoLessonsModel> videoLessonReportModelList = [];
      if (myReportModel.myReportVideoLessonsModelList != null) {
        await Future.forEach(myReportModel.myReportVideoLessonsModelList!,
            (dynamic element) {
          videoLessonReportModelList.add(MyReportVideoLessonsModel(
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
        subjectLevelMastery: myReportModel.subjectLevelMastery,
        totalUniquePracticeSetAttempted:
            myReportModel.totalUniquePracticeSetAttempted,
        totalUniqueTestsAttempted: myReportModel.totalUniqueTestsAttempted,
        totalUniqueBooksAttempted: myReportModel.totalUniqueBooksAttempted,
        totalUniqueNotesAttempted: myReportModel.totalUniqueNotesAttempted,
        myReportBooksModelList: booksReportModelList,
        myReportNotesModelList: notesReportModelList,
        myReportPracticeModelList: practiceReportModelList,
        myReportTestModelList: myReportModel.myReportTestModelList,
        myReportVideoLessonsModelList: videoLessonReportModelList,
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

  Future _filterTotalReportModelBasisOnSelectedYear() async {
    await _reinitializeAllTheData();
    _filteredListMyReportsModel.forEach((filteredReportsModel) {
      if (filteredReportsModel.myReportPracticeModelList != null) {
        for (int i = filteredReportsModel.myReportPracticeModelList!.length - 1;
            i >= 0;
            i--) {
          if ((DateTime.parse(filteredReportsModel
                      .myReportPracticeModelList![i].updatedTime!)
                  .isBefore(_selectedStartDate)) ||
              (DateTime.parse(filteredReportsModel
                      .myReportPracticeModelList![i].updatedTime!)
                  .isAfter(_selectedEndDate))) {
            filteredReportsModel.totalTimeSpentOnApp = int.parse(
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
                  .isBefore(_selectedStartDate)) ||
              (DateTime.parse(filteredReportsModel
                      .myReportTestModelList![i].updatedTime!)
                  .isAfter(_selectedEndDate))) {
            filteredReportsModel.totalTimeSpentOnApp = int.parse(
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
                  .isBefore(_selectedStartDate)) ||
              (DateTime.parse(filteredReportsModel
                      .myReportNotesModelList![i].updatedTime!)
                  .isAfter(_selectedEndDate))) {
            filteredReportsModel.totalTimeSpentOnApp = int.parse(
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
                  .isBefore(_selectedStartDate)) ||
              (DateTime.parse(filteredReportsModel
                      .myReportBooksModelList![i].updatedTime!)
                  .isAfter(_selectedEndDate))) {
            filteredReportsModel.totalTimeSpentOnApp = int.parse(
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
                  .isBefore(_selectedStartDate)) ||
              (DateTime.parse(filteredReportsModel
                      .myReportVideoLessonsModelList![i].updatedTime!)
                  .isAfter(_selectedEndDate))) {
            filteredReportsModel.totalTimeSpentOnApp = int.parse(
                filteredReportsModel
                    .myReportVideoLessonsModelList![i].duration!);
            filteredReportsModel.myReportVideoLessonsModelList!
                .remove(filteredReportsModel.myReportVideoLessonsModelList![i]);
          }
        }
      }
    });
  }

  Future _filterBooksLibraryAndStemVideosData() async {
    _totalBookLibraryDuration = 0;
    _totalStemVideosDuration = 0;
    _bookLibraryReportModel.clear();
    if (widget.bookLibraryCompleteData != null) {
      _bookLibraryDataMap = jsonDecode(widget.bookLibraryCompleteData!);
    }
    _uniqueTotalBookLibraryCount = 0;

    if (_bookLibraryDataMap != null) {
      int _bookLevelIndex = 0;
      await Future.forEach(_bookLibraryDataMap!.values.toList(),
          (dynamic element) async {
        MyReportsModel _myBookLibraryModel = MyReportsModel(
          subjectName: _bookLibraryDataMap!.keys.toList()[_bookLevelIndex],
          myReportExtraBooksModelList: [],
        );
        List<String?> _bookIdsList = [];
        await Future.forEach(element.values.toList(), (dynamic element1) async {
          await Future.forEach(element1.values.toList(),
              (dynamic element2) async {
            if (((DateTime.parse(element2['updated_time'])
                    .isAfter(_selectedStartDate)) &&
                (DateTime.parse(element2['updated_time'])
                    .isBefore(_selectedEndDate)))) {
              _totalBookLibraryDuration +=
                  int.tryParse(element2['duration']) ?? 0;
              MyReportExtraBooksModel _myReportExtraBooksModel =
                  MyReportExtraBooksModel.fromJson(element2);
              _myBookLibraryModel.myReportExtraBooksModelList!
                  .add(_myReportExtraBooksModel);
              _bookIdsList.add(_myReportExtraBooksModel.bookID);
            }
          });
        });
        _myBookLibraryModel.totalUniqueBooksAttempted =
            _bookIdsList.toSet().length;
        _uniqueTotalBookLibraryCount +=
            _myBookLibraryModel.totalUniqueBooksAttempted!;
        _bookLibraryReportModel.add(_myBookLibraryModel);
        _bookLevelIndex++;
      });
    }

    _stemVideosReportModel.clear();
    if (widget.stemVideosCompleteData != null) {
      _stemVideosDataMap = jsonDecode(widget.stemVideosCompleteData!);
    }
    _uniqueTotalStemVideosCount = 0;

    if (_stemVideosDataMap != null) {
      int _stemVideosLevelIndex = 0;
      await Future.forEach(_stemVideosDataMap!.values.toList(),
          (dynamic element) async {
        MyReportsModel _myStemVideosModel = MyReportsModel(
          subjectID: _stemVideosDataMap!.keys.toList()[_stemVideosLevelIndex],
          myReportVideoLessonsModelList: [],
        );
        List<String?> _videoIdsList = [];
        await Future.forEach(element.values.toList(), (dynamic element1) async {
          await Future.forEach(element1.values.toList(),
              (dynamic element2) async {
            await Future.forEach(element2.values.toList(),
                (dynamic element3) async {
              if (((DateTime.parse(element3['updated_time'])
                      .isAfter(_selectedStartDate)) &&
                  (DateTime.parse(element3['updated_time'])
                      .isBefore(_selectedEndDate)))) {
                _totalStemVideosDuration +=
                    int.tryParse(element3['duration']) ?? 0;
                MyReportVideoLessonsModel _myReportStemVideosModel =
                    MyReportVideoLessonsModel.fromJson(element3);
                _myStemVideosModel.myReportVideoLessonsModelList!
                    .add(_myReportStemVideosModel);
                _videoIdsList.add(_myReportStemVideosModel.videoID);
              }
            });
          });
        });

        _uniqueTotalStemVideosCount += _videoIdsList.toSet().length;
        _stemVideosReportModel.add(_myStemVideosModel);
        _stemVideosLevelIndex++;
      });
    }
    _totalDuration += _totalBookLibraryDuration + _totalStemVideosDuration;
    _totalTimeSpentText = await (_getTotalTimeString(_totalDuration));
  }

  Future _getsRequiredDataReady() async {
    _filterTotalReportModelBasisOnSelectedYear().then((value) {
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

  @override
  void initState() {
    super.initState();
    _updateStartAndEndDate(selectedDate: widget.selectedDate!);
    _getsRequiredDataReady();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          bottom: false,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xFFFFFFFF),
              leading: IconButton(
                icon: Image.asset(
                  "assets/images/back_icon.png",
                  height: 25,
                  width: 25,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: false,
              titleSpacing: 0,
              actions: [
                IconButton(
                  icon: Image.asset(
                    "assets/images/calendar.png",
                    height: 25,
                    width: 25,
                    color: const Color(0xFF212121),
                  ),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      helpText: "Select Date",
                      errorFormatText: 'Enter valid date',
                      errorInvalidText: 'Enter date in valid range',
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData
                              .light(), // This will change to light theme.
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      if (!mounted) return;
                      await Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (BuildContext context) => DateWiseReportPage(
                            listMyReportsModel: widget.listMyReportsModel,
                            selectedDate: picked,
                            bookLibraryCompleteData:
                                widget.bookLibraryCompleteData,
                            stemVideosCompleteData:
                                widget.stemVideosCompleteData,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
              title: Text(
                DateFormat.yMMMMEEEEd().format(widget.selectedDate!),
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 16,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: _dataPrepared
                  ? Column(
                      children: [
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
                                      _totalTimeSpentText,
                                      style: TextStyle(
                                          color: const Color(0xFF212121),
                                          fontSize: 22,
                                          fontWeight: FontWeight.values[4]),
                                    ),
                                  ],
                                ),
                              ),
                              // Expanded(
                              //   flex: 1,
                              //   child: Column(
                              //     children: [
                              //       Text(
                              //         "Days Spent on Learning",
                              //         textAlign: TextAlign.center,
                              //         style: TextStyle(
                              //             color: Color(0xFF9E9E9E),
                              //             fontSize: 14,
                              //             fontWeight: FontWeight.values[4]),
                              //       ),
                              //       SizedBox(
                              //         height: 6,
                              //       ),
                              //       Text(
                              //         _totalSpentDays,
                              //         style: TextStyle(
                              //             color: Color(0xFF212121),
                              //             fontSize: 22,
                              //             fontWeight: FontWeight.values[4]),
                              //       ),
                              //     ],
                              //   ),
                              // ),
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
                                  child: InkWell(
                                    onTap: () async {
                                      // await Navigator.push(
                                      //   context,
                                      //   CupertinoPageRoute(
                                      //     builder: (_) => MyReportsDetailPage(
                                      //       myReportsModel:
                                      //           _filteredListMyReportsModel[index],
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    child: myReportSubjectRow(
                                      imageName: (Constants
                                                      .subjectColorAndImageMap[
                                                  _filteredListMyReportsModel[
                                                          index]
                                                      .subjectID] !=
                                              null)
                                          ? Constants.subjectColorAndImageMap[
                                              widget.listMyReportsModel![index]
                                                  .subjectID]['assetPath']
                                          : "assets/images/physics.png",
                                      // widget
                                      //     .listMyReportsModel[index].subjectID,
                                      subjectName: widget
                                          .listMyReportsModel![index].subjectID!
                                          .replaceRange(
                                              0,
                                              1,
                                              _filteredListMyReportsModel[index]
                                                  .subjectID!
                                                  .substring(0, 1)
                                                  .toUpperCase()),
                                      duration:
                                          _filteredListMyReportsModel[index]
                                              .totalTimeSpentOnApp,
                                      totalDuration: _totalTimeSpentOnCoreApp,
                                      myReportsModel:
                                          _filteredListMyReportsModel[index],
                                    ),
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
                                Text(
                                  "Categories",
                                  style: TextStyle(
                                      color: const Color(0xFF212121),
                                      fontSize: 18,
                                      fontWeight: FontWeight.values[5]),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                if (_totalVideosWatched != 0)
                                  myReportCategoryRow(
                                      imageName: "video_category",
                                      categoryCount:
                                          _totalVideosWatched.toString(),
                                      categoryText: "Videos Watched",
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (_) =>
                                                VideoWatchedReportHomePage(
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
                                      categoryCount:
                                          _totalTestCompleted.toString(),
                                      categoryText: "Tests Completed",
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (_) =>
                                                TestAttemptedReportHomePage(
                                              completeSubjectWiseReportList:
                                                  _filteredListMyReportsModel,
                                            ),
                                          ),
                                        );
                                      }),
                                if (_totalNotesCompleted != 0)
                                  myReportCategoryRow(
                                    imageName: "notes_category",
                                    categoryCount:
                                        _totalNotesCompleted.toString(),
                                    categoryText: "Notes Read",
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (_) =>
                                              NotesCompletedReportHomePage(
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
                                    categoryCount:
                                        _totalBooksCompleted.toString(),
                                    categoryText: "Syllabus Books Read",
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (_) =>
                                              BooksCompletedReportHomePage(
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
                                          builder: (_) =>
                                              BooksLibraryReportHomePage(
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
                              "No data exist for this Date",
                              style: Constants.noDataTextStyle,
                            ),
                          )
                      ],
                    )
                  : const Center(
                      child: Loader(),
                    ),
            ),
          )),
    );
  }

  Widget myReportSubjectRow(
      {String? imageName,
      String? subjectName,
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
                  child: Image.asset(
                    imageName!,
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
                                subjectName!,
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
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap as void Function()?,
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
      ),
    );
  }
}
