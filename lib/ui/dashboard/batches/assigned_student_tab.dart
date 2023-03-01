import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/chapter_book_tile.dart';
import 'package:idream/custom_widgets/custom_pop_up.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/custom_widgets/subject_home_page_widget.dart';
import 'package:idream/custom_widgets/subject_tile_widget.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/model/books_model.dart';
import 'package:idream/model/extra_book_model.dart';
import 'package:idream/model/notes_model.dart';
import 'package:idream/model/practice_model.dart';
import 'package:idream/model/test_model.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/repository/in_app.dart';
import 'package:idream/ui/dashboard/extra_books/extra_book_rendering_page.dart';
import 'package:idream/ui/dashboard/extra_books/extra_book_widget.dart';
import 'package:idream/ui/menu/upgrade_plan_page.dart';
import 'package:idream/ui/subject_home/book_rendering_page.dart';
import 'package:idream/ui/subject_home/notes_page.dart';
import 'package:idream/ui/subject_home/notes_rendering_page.dart';
import 'package:idream/ui/subject_home/practice_page.dart';
import 'package:idream/ui/subject_home/practice_pop_up.dart';
import 'package:idream/ui/subject_home/subject_home.dart';
import 'package:idream/video_player/youtube_player_demo.dart';

import '../../../subscription/andriod/android_subscription.dart';

class AssignedTabForStudent extends StatefulWidget {
  final Batch? selectedBatch;
  const AssignedTabForStudent({Key? key, this.selectedBatch}) : super(key: key);

  @override
  _AssignedTabForStudentState createState() => _AssignedTabForStudentState();
}

class _AssignedTabForStudentState extends State<AssignedTabForStudent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: null,
      future: assignmentRepository.fetchAssignments(widget.selectedBatch!),
      builder: (context, assignments) {
        if (assignments.connectionState == ConnectionState.none &&
            assignments.hasData == null) {
          return Container();
        } else if (assignments.connectionState == ConnectionState.done &&
            assignments.data == null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Image.asset(
                    "assets/images/Nothing Assigned.png",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Nothing Assigned",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Inter",
                      color: Color(0xff212121),
                    ),
                  ),
                ],
              ),
              // Container(
              //     alignment: Alignment.centerRight,
              //     margin: EdgeInsets.only(right: 20, bottom: 20),
              //     child: ElevatedButton(
              //       onPressed: () {
              //         showClassBottomSheet(context, widget.selectedBatch);
              //       },
              //       child: Text(
              //         "Assign from iPrep Library",
              //         style: TextStyle(color: Colors.white),
              //       ),
              //       style:
              //           ElevatedButton.styleFrom(primary: Color(0xff0070FF)),
              //     ),
              // ),
            ],
          );
        } else if (assignments.hasData) {
          List<dynamic>? assignmentData = assignments.data as List<dynamic>?;
          List<dynamic> assignment = [];
          for (var element in assignmentData!.reversed) {
            if (element["extra_books"] != null) {
              int assignmentItemIndex = 0;
              element["extra_books"].forEach((ebooks) {
                if ((ebooks['student_report'] as Map)
                    .containsKey(appUser!.userID)) {
                  assignment.add({
                    'class_number': element['class_number'],
                    'assignment_image_url': 'assets/images/books_category.png',
                    'time': element['time'],
                    'due_date': element['due_date'],
                    'subject_name': element['subject_name'],
                    'subject_id': element['subject_id'],
                    "teacher_id": element['teacher_id'],
                    'data': Topics(
                      id: ebooks['assignment_details']["id"],
                      name: ebooks['assignment_details']["name"],
                      onlineLink: ebooks['assignment_details']["onlineLink"],
                      topicName: ebooks['assignment_details']["topicName"],
                    ),
                    'student_report': ebooks['student_report']
                        .values
                        .map<JoinedStudents>((i) => JoinedStudents.fromJson(i))
                        .toList(),
                    'assignment_progress': ebooks['student_report']
                        [appUser!.userID]['progress'],
                    if (ebooks['student_report'][appUser!.userID]['progress'] !=
                        null)
                      "progress_text": ebooks['student_report'][appUser!.userID]
                              ['progress']
                          .values
                          .last['progress_text'],
                    if (ebooks['student_report'][appUser!.userID]['progress'] !=
                        null)
                      "progress_text_color": ebooks['student_report']
                              [appUser!.userID]['progress']
                          .values
                          .last['progress_text_color'],
                    "item_index": assignmentItemIndex.toString(),
                    "assignment_id": element['assignment_id'],
                  });
                }
                assignmentItemIndex++;
              });
            }
            if (element["stem_videos"] != null) {
              int _assignmentItemIndex = 0;
              element["stem_videos"].forEach((svids) {
                if ((svids['student_report'] as Map)
                    .containsKey(appUser!.userID)) {
                  assignment.add({
                    'class_number': element['class_number'],
                    'assignment_image_url': 'assets/images/video_category.png',
                    'time': element['time'],
                    'due_date': element['due_date'],
                    'subject_name': element['subject_name'],
                    'subject_id': element['subject_id'],
                    "teacher_id": element['teacher_id'],
                    'data': VideoLessonModel(
                      detail: svids['assignment_details']["detail"],
                      id: svids['assignment_details']["id"],
                      name: svids['assignment_details']["name"],
                      offlineLink: svids['assignment_details']["offlineLink"],
                      offlineThumbnail: svids['assignment_details']
                          ["offlineThumbnail"],
                      onlineLink: svids['assignment_details']["onlineLink"],
                      thumbnail: svids['assignment_details']["thumbnail"],
                      topicName: svids['assignment_details']["topicName"],
                    ),
                    'student_report': svids['student_report']
                        .values
                        .map<JoinedStudents>((i) => JoinedStudents.fromJson(i))
                        .toList(),
                    'assignment_progress': svids['student_report']
                        [appUser!.userID]['progress'],
                    if (svids['student_report'][appUser!.userID]['progress'] !=
                        null)
                      "progress_text": svids['student_report'][appUser!.userID]
                              ['progress']
                          .values
                          .last['progress_text'],
                    if (svids['student_report'][appUser!.userID]['progress'] !=
                        null)
                      "progress_text_color": svids['student_report']
                              [appUser!.userID]['progress']
                          .values
                          .last['progress_text_color'],
                    "item_index": _assignmentItemIndex.toString(),
                    "assignment_id": element['assignment_id'],
                  });
                }
                _assignmentItemIndex++;
              });
            }
            if (element["videos"] != null) {
              int _assignmentItemIndex = 0;
              element["videos"].forEach((svids) {
                if ((svids['student_report'] as Map)
                    .containsKey(appUser!.userID)) {
                  assignment.add({
                    'class_number': element['class_number'],
                    'assignment_image_url': 'assets/images/video_category.png',
                    'time': element['time'],
                    'due_date': element['due_date'],
                    'subject_name': element['subject_name'],
                    'subject_id': element['subject_id'],
                    "teacher_id": element['teacher_id'],
                    'data': VideoLessonModel(
                      detail: svids['assignment_details']["detail"],
                      id: svids['assignment_details']["id"],
                      name: svids['assignment_details']["name"],
                      offlineLink: svids['assignment_details']["offlineLink"],
                      offlineThumbnail: svids['assignment_details']
                          ["offlineThumbnail"],
                      onlineLink: svids['assignment_details']["onlineLink"],
                      thumbnail: svids['assignment_details']["thumbnail"],
                      topicName: svids['assignment_details']["topicName"],
                    ),
                    'student_report': svids['student_report']
                        .values
                        .map<JoinedStudents>((i) => JoinedStudents.fromJson(i))
                        .toList(),
                    'assignment_progress': svids['student_report']
                        [appUser!.userID]['progress'],
                    if (svids['student_report'][appUser!.userID]['progress'] !=
                        null)
                      "progress_text": svids['student_report'][appUser!.userID]
                              ['progress']
                          .values
                          .last['progress_text'],
                    if (svids['student_report'][appUser!.userID]['progress'] !=
                        null)
                      "progress_text_color": svids['student_report']
                              [appUser!.userID]['progress']
                          .values
                          .last['progress_text_color'],
                    "item_index": _assignmentItemIndex.toString(),
                    "assignment_id": element['assignment_id'],
                  });
                }
                _assignmentItemIndex++;
              });
            }
            if (element["practice"] != null) {
              int _assignmentItemIndex = 0;
              element["practice"].forEach((practice) {
                if ((practice['student_report'] as Map)
                    .containsKey(appUser!.userID)) {
                  assignment.add({
                    'class_number': element['class_number'],
                    'assignment_image_url':
                        'assets/images/practice_category.png',
                    'time': element['time'],
                    'due_date': element['due_date'],
                    'subject_name': element['subject_name'],
                    'subject_id': element['subject_id'],
                    "teacher_id": element['teacher_id'],
                    "language": element['language'],
                    'data':
                        PracticeModel.fromJson(practice['assignment_details']),
                    'student_report': practice['student_report']
                        .values
                        .map<JoinedStudents>((i) => JoinedStudents.fromJson(i))
                        .toList(),
                    'assignment_progress': practice['student_report']
                        [appUser!.userID]['progress'],
                    if (practice['student_report'][appUser!.userID]
                            ['progress'] !=
                        null)
                      "progress_text": practice['student_report']
                              [appUser!.userID]['progress']
                          .values
                          .last['progress_text'],
                    if (practice['student_report'][appUser!.userID]
                            ['progress'] !=
                        null)
                      "progress_text_color": practice['student_report']
                              [appUser!.userID]['progress']
                          .values
                          .last['progress_text_color'],
                    "item_index": _assignmentItemIndex.toString(),
                    "assignment_id": element['assignment_id'],
                  });
                }
                _assignmentItemIndex++;
              });
            }
            if (element["notes"] != null) {
              int _assignmentItemIndex = 0;
              element["notes"].forEach((notes) {
                if ((notes['student_report'] as Map)
                    .containsKey(appUser!.userID)) {
                  assignment.add({
                    'class_number': element['class_number'],
                    'assignment_image_url': 'assets/images/notes_category.png',
                    'time': element['time'],
                    'due_date': element['due_date'],
                    'subject_name': element['subject_name'],
                    'subject_id': element['subject_id'],
                    "teacher_id": element['teacher_id'],
                    'data': NotesModel(
                      id: notes['assignment_details']["id"],
                      boardID: notes['assignment_details']["boardID"],
                      classID: notes['assignment_details']["classID"],
                      language: notes['assignment_details']["language"],
                      subjectName: notes['assignment_details']["subjectName"],
                      chapterName: notes['assignment_details']["chapterName"],
                      noteDetails: notes['assignment_details']["bookDetails"],
                      noteID: notes['assignment_details']["bookID"],
                      noteName: notes['assignment_details']["bookName"],
                      noteOfflineLink: notes['assignment_details']
                          ["bookOfflineLink"],
                      noteOfflineThumbnail: notes['assignment_details']
                          ["bookOfflineThumbnail"],
                      noteOnlineLink: notes['assignment_details']
                          ["bookOnlineLink"],
                      noteThumbnail: notes['assignment_details']
                          ["bookThumbnail"],
                      noteTopicName: notes['assignment_details']
                          ["bookTopicName"],
                    ),
                    'student_report': notes['student_report']
                        .values
                        .map<JoinedStudents>((i) => JoinedStudents.fromJson(i))
                        .toList(),
                    'assignment_progress': notes['student_report']
                        [appUser!.userID]['progress'],
                    if (notes['student_report'][appUser!.userID]['progress'] !=
                        null)
                      "progress_text": notes['student_report'][appUser!.userID]
                              ['progress']
                          .values
                          .last['progress_text'],
                    if (notes['student_report'][appUser!.userID]['progress'] !=
                        null)
                      "progress_text_color": notes['student_report']
                              [appUser!.userID]['progress']
                          .values
                          .last['progress_text_color'],
                    "item_index": _assignmentItemIndex.toString(),
                    "assignment_id": element['assignment_id'],
                  });
                }
                _assignmentItemIndex++;
              });
            }
            if (element["books"] != null) {
              int _assignmentItemIndex = 0;
              element["books"].forEach((books) {
                if ((books['student_report'] as Map)
                    .containsKey(appUser!.userID)) {
                  assignment.add({
                    'class_number': element['class_number'],
                    'assignment_image_url': 'assets/images/books_category.png',
                    'time': element['time'],
                    'due_date': element['due_date'],
                    'subject_name': element['subject_name'],
                    'subject_id': element['subject_id'],
                    "teacher_id": element['teacher_id'],
                    'data': BooksModel(
                      id: books['assignment_details']["id"],
                      boardID: books['assignment_details']["boardID"],
                      classID: books['assignment_details']["classID"],
                      language: books['assignment_details']["language"],
                      subjectName: books['assignment_details']["subjectName"],
                      chapterName: books['assignment_details']["chapterName"],
                      bookDetails: books['assignment_details']["bookDetails"],
                      bookID: books['assignment_details']["bookID"],
                      bookName: books['assignment_details']["bookName"],
                      bookOfflineLink: books['assignment_details']
                          ["bookOfflineLink"],
                      bookOfflineThumbnail: books['assignment_details']
                          ["bookOfflineThumbnail"],
                      bookOnlineLink: books['assignment_details']
                          ["bookOnlineLink"],
                      bookThumbnail: books['assignment_details']
                          ["bookThumbnail"],
                      bookTopicName: books['assignment_details']
                          ["bookTopicName"],
                    ),
                    'student_report': books['student_report']
                        .values
                        .map<JoinedStudents>((i) => JoinedStudents.fromJson(i))
                        .toList(),
                    'assignment_progress': books['student_report']
                        [appUser!.userID]['progress'],
                    if (books['student_report'][appUser!.userID]['progress'] !=
                        null)
                      "progress_text": books['student_report'][appUser!.userID]
                              ['progress']
                          .values
                          .last['progress_text'],
                    if (books['student_report'][appUser!.userID]['progress'] !=
                        null)
                      "progress_text_color": books['student_report']
                              [appUser!.userID]['progress']
                          .values
                          .last['progress_text_color'],
                    "item_index": _assignmentItemIndex.toString(),
                    "assignment_id": element['assignment_id'],
                  });
                }
                _assignmentItemIndex++;
              });
            }
          }
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                child: assignment.isNotEmpty
                    ? ListView(
                        children: List.generate(
                          assignment.length,
                          (index) {
                            return InkWell(
                              onTap: () async {
                                //Redirect user from here to the page where content can be played.
                                if (assignment[index]['data']
                                    is VideoLessonModel) {
                                  if (assignment[index]['data']
                                      .onlineLink
                                      .contains("youtube")) {
                                    await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                            YoutubeVideo(
                                          stemVideosKey: null,
                                          videosChild: null,
                                          youtubeLink: assignment[index]['data']
                                              .onlineLink,
                                          videoLesson: assignment[index]
                                              ['data'],
                                          subjectId: assignment[index]
                                              ['subject_id'],
                                          videoName:
                                              assignment[index]['data'].name ??
                                                  "",
                                          batchInfo: widget.selectedBatch,
                                          assignment: assignment[index],
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (restrictUser) {
                                      var _response =
                                          await planExpiryPopUpForStudent(
                                              context);
                                      if ((_response != null) &&
                                          (_response == "Yes")) {
                                        if (!mounted) return;
                                        await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                Platform.isAndroid
                                                    ? const AndroidSubscriptionPlan()
                                                    : const UpgradePlan(),
                                          ),
                                        );
                                      }
                                    } else {
                                      await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              CustomPlayerVideo(
                                            subjectID: assignment[index]
                                                ['subject_id'],
                                            videoLesson: assignment[index]
                                                ['data'],
                                            videoName: assignment[index]['data']
                                                    .name ??
                                                "",
                                            videoUrl: assignment[index]['data']
                                                .onlineLink,
                                            batchInfo: widget.selectedBatch,
                                            assignment: assignment[index],
                                            // batchId: widget.selectedBatch.batchId,
                                            // assignmentId: assignment[index]
                                            //     ["assignment_id"],
                                            // assignmentIndex: assignment[index]
                                            //     ["item_index"],
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                } else if (assignment[index]['data']
                                    is Topics) {
                                  Stopwatch _booksStopwatch = Stopwatch();
                                  _booksStopwatch.start();
                                  print("render Extra Book now");
                                  await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          ExtraBookRenderingPage(
                                        bookName: (assignment[index]['data']
                                                as Topics)
                                            .name,
                                        bookUrl: (assignment[index]['data']
                                                as Topics)
                                            .onlineLink,
                                        chapterBookTileWidget:
                                            const ExtraBooksWidget(
                                          subjectColor: 0xFF5dc4f2,
                                        ),
                                      ),
                                    ),
                                  );
                                  _booksStopwatch.stop();
                                  await assignmentTrackingRepository
                                      .trackAssignedExtraBooks(
                                    spentTimeInSec:
                                        _booksStopwatch.elapsed.inSeconds,
                                    extraBookModel: assignment[index]['data'],
                                    subjectID: assignment[index]['subject_id'],
                                    batchId: widget.selectedBatch!.batchId!,
                                    assignmentId: assignment[index]
                                        ["assignment_id"],
                                    assignmentIndex: assignment[index]
                                        ["item_index"],
                                    language: widget.selectedBatch!.language,
                                    boardId: widget.selectedBatch!.boardId,
                                    classId: assignment[index]["class_number"],
                                    teacherId: assignment[index]["teacher_id"],
                                  );
                                } else if (assignment[index]['data']
                                    is BooksModel) {
                                  //Display Books
                                  Stopwatch _booksStopwatch = Stopwatch();
                                  _booksStopwatch.start();
                                  await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          BookRenderingPage(
                                        chapterBookTileWidget: ChapterBookTile(
                                          booksModel: assignment[index]['data'],
                                          subjectHome: const SubjectHome(
                                            subjectWidget: SubjectWidget(
                                              subjectColor: 0xFF5dc4f2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                  _booksStopwatch.stop();
                                  await assignmentTrackingRepository
                                      .trackAssignedBooks(
                                    assignment[index]['subject_name'],
                                    spentTimeInSec:
                                        _booksStopwatch.elapsed.inSeconds,
                                    booksModel: assignment[index]['data'],
                                    subjectID: assignment[index]['subject_id'],
                                    batchId: widget.selectedBatch!.batchId!,
                                    assignmentId: assignment[index]
                                        ["assignment_id"],
                                    teacherId: assignment[index]["teacher_id"],
                                    assignmentIndex: assignment[index]
                                        ["item_index"],
                                    language: widget.selectedBatch!.language,
                                    classId: assignment[index]["class_number"],
                                    boardId: widget.selectedBatch!.boardId,
                                  );
                                } else if (assignment[index]['data']
                                    is NotesModel) {
                                  if (restrictUser) {
                                    var _response =
                                        await planExpiryPopUpForStudent(
                                            context);
                                    if ((_response != null) &&
                                        (_response == "Yes")) {
                                      if (!mounted) return;
                                      await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              Platform.isAndroid
                                                  ? const AndroidSubscriptionPlan()
                                                  : const UpgradePlan(),
                                        ),
                                      );
                                    }
                                  } else {
                                    Stopwatch _notesStopwatch = Stopwatch();
                                    _notesStopwatch.start();
                                    await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                            NotesRenderingPage(
                                          notesModel: assignment[index]['data'],
                                          notesPageWidget: const NotesPage(
                                            subjectHome: SubjectHome(
                                              subjectWidget: SubjectWidget(
                                                subjectColor: 0xFF5dc4f2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                    _notesStopwatch.stop();
                                    await assignmentTrackingRepository
                                        .trackAssignedNotes(
                                      assignment[index]["subject_name"],
                                      spentTimeInSec:
                                          _notesStopwatch.elapsed.inSeconds,
                                      notesModel: assignment[index]['data'],
                                      subjectID: assignment[index]
                                          ['subject_id'],
                                      batchId: widget.selectedBatch!.batchId!,
                                      assignmentId: assignment[index]
                                          ["assignment_id"],
                                      assignmentIndex: assignment[index]
                                          ["item_index"],
                                      teacherId: assignment[index]
                                          ["teacher_id"],
                                      language: widget.selectedBatch!.language,
                                      classId: assignment[index]
                                          ["class_number"],
                                      boardId: widget.selectedBatch!.boardId,
                                    );
                                  }
                                } else if (assignment[index]['data']
                                    is PracticeModel) {
                                  if (restrictUser) {
                                    var _response =
                                        await planExpiryPopUpForStudent(
                                            context);
                                    if ((_response != null) &&
                                        (_response == "Yes")) {
                                      if (!mounted) return;
                                      await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              Platform.isAndroid
                                                  ? const AndroidSubscriptionPlan()
                                                  : const UpgradePlan(),
                                        ),
                                      );
                                    }
                                  } else {
                                    //Display Practice
                                    await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => PracticePopUpPage(
                                          practicePageWidget: PracticePage(
                                            subjectHome: SubjectHome(
                                              subjectWidget: SubjectWidget(
                                                subjectID: assignment[index]
                                                    ['subject_id'],
                                                subjectName: assignment[index]
                                                    ['subject_name'],
                                              ),
                                            ),
                                          ),
                                          practiceModel: assignment[index]
                                              ['data'],
                                          classNumber: assignment[index]
                                              ['class_number'],
                                          batchId:
                                              widget.selectedBatch!.batchId,
                                          assignmentId: assignment[index]
                                              ["assignment_id"],
                                          assignmentIndex: assignment[index]
                                              ["item_index"],
                                          teacherId: assignment[index]
                                              ["teacher_id"],
                                          language:
                                              widget.selectedBatch!.language,
                                          boardId:
                                              widget.selectedBatch!.boardId,
                                        ),
                                      ),
                                    );
                                  }
                                }
                                setState(() {
                                  debugPrint('dataChange');
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12,
                                  bottom: 19.5,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(children: [
                                            Text(
                                              Constants.months[DateTime.parse(
                                                          assignment[index]
                                                              ['time'])
                                                      .month -
                                                  1],
                                              style: const TextStyle(
                                                  fontSize: 10.0,
                                                  color: Color(0xFF9E9E9E)),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              (DateTime.parse(assignment[index]
                                                          ['time'])
                                                      .day)
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 10.0,
                                                  color: Color(0xFF9E9E9E)),
                                            ),
                                          ]),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 8.0, right: 12.0),
                                            child: Image.asset(
                                              assignment[index]
                                                  ['assignment_image_url'],
                                              height: 36.0,
                                              width: 36.0,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  assignment[index]['data']
                                                              is VideoLessonModel ||
                                                          assignment[index]
                                                              ['data'] is Topics
                                                      ? assignment[index]['data']
                                                          .name
                                                      : assignment[index]['data']
                                                                  is PracticeModel ||
                                                              assignment[index]
                                                                      ['data']
                                                                  is TestModel
                                                          ? assignment[index]['data']
                                                              .tName
                                                          : assignment[index]['data']
                                                                  is NotesModel
                                                              ? assignment[index]
                                                                      ['data']
                                                                  .chapterName
                                                              : assignment[index]
                                                                          ['data']
                                                                      is BooksModel
                                                                  ? assignment[index]
                                                                          ['data']
                                                                      .bookName
                                                                  : '',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.values[5],
                                                      fontSize: 14,
                                                      color: const Color(
                                                          0xFF212121)),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  '${assignment[index]['subject_name']} | Due: ${DateTime.parse(assignment[index]['due_date']).day} ${Constants.months[DateTime.parse(assignment[index]['due_date']).month - 1]} ${DateTime.parse(assignment[index]['due_date']).year}',
                                                  style: const TextStyle(
                                                      color: Color(0xFF9E9E9E),
                                                      fontSize: 12.0),
                                                  overflow: TextOverflow.clip,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    (assignment[index]['assignment_progress'] ==
                                            null)
                                        ? const Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Yet to attempt",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color: Color(0xFFFF7575),
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            flex: 2,
                                            child: Text(
                                              assignment[index]
                                                  ['progress_text'],
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color: Color(int.parse(
                                                    assignment[index][
                                                        'progress_text_color'])),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Text(
                        'No Segment Assigned yet',
                        style: TextStyle(fontSize: 20),
                      )),
              )
            ],
          );
        } else {
          return const Center(
            child: Loader(),
          );
        }
      },
    );
  }
}
