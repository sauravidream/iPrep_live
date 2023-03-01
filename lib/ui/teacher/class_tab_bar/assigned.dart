import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/model/books_model.dart';
import 'package:idream/model/extra_book_model.dart';
import 'package:idream/model/notes_model.dart';
import 'package:idream/model/practice_model.dart';
import 'package:idream/model/test_model.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/ui/teacher/assignments/assignment_report_page.dart';
import 'package:idream/ui/teacher/utilities/bottom_sheet.dart';

class Assigned extends StatefulWidget {
  final Batch? selectedBatch;
  const Assigned({Key? key, this.selectedBatch}) : super(key: key);

  @override
  _AssignedState createState() => _AssignedState();
}

class _AssignedState extends State<Assigned> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: assignmentRepository.getAssignments(widget.selectedBatch!),
        builder: (context, snapshot) {
          return FutureBuilder(
            initialData: null,
            future:
                assignmentRepository.fetchAssignments(widget.selectedBatch!),
            builder: (context, assignments) {
              if (assignments.connectionState == ConnectionState.none &&
                  assignments.hasData == null) {
                return Container();
              } else if (assignments.connectionState == ConnectionState.done &&
                  assignments.data == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Column(children: [
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
                            color: Color(0xff212121)),
                      ),
                    ]),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(
                        bottom: 46.0,
                        right: 20.0,
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if ((widget.selectedBatch!.joinedStudentsList !=
                                  null) &&
                              (widget.selectedBatch!.joinedStudentsList!
                                  .isNotEmpty)) {
                            await showClassBottomSheet(
                                context, widget.selectedBatch);
                          } else {
                            SnackbarMessages.showErrorSnackbar(context,
                                error: Constants
                                    .assignmentNoStudentJoinedBatchAlert);
                          }
                        },
                        child: const Text(
                          "Assign from iPrep Library",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xff0070FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (assignments.hasData) {
                List<dynamic>? assignmentdata =
                    assignments.data as List<dynamic>?;
                List<dynamic> assignment = [];
                assignmentdata!.reversed.forEach((element) {
                  if (element["extra_books"] != null) {
                    int _assignmentItemIndex = 0;
                    element["extra_books"].forEach((ebooks) {
                      assignment.add({
                        'assignment_image_url':
                            'assets/images/books_category.png',
                        'assignment_category': 'extra_books',
                        'assignment_sub_category': 'extra_books',
                        'time': element['time'],
                        'subject_name': element['subject_name'],
                        'subject_id': element['subject_id'],
                        'due_date': element['due_date'],
                        'data': Topics(
                          id: ebooks['assignment_details']["id"],
                          name: ebooks['assignment_details']["name"],
                          onlineLink: ebooks['assignment_details']
                              ["onlineLink"],
                          topicName: ebooks['assignment_details']["topicName"],
                        ),
                        'student_report': ebooks['student_report']
                            .values
                            .map<JoinedStudents>(
                                (i) => JoinedStudents.fromJson(i))
                            .toList(),
                        "item_index": _assignmentItemIndex.toString(),
                        "assignment_id": element['assignment_id'],
                      });
                      _assignmentItemIndex++;
                    });
                  }
                  if (element["stem_videos"] != null) {
                    int _assignmentItemIndex = 0;
                    element["stem_videos"].forEach((svids) {
                      assignment.add({
                        'assignment_image_url':
                            'assets/images/video_category.png',
                        'assignment_category': 'stem_videos',
                        'assignment_sub_category': 'stem_videos',
                        'time': element['time'],
                        'subject_name': element['subject_name'],
                        'subject_id': element['subject_id'],
                        'due_date': element['due_date'],
                        'data': VideoLessonModel(
                          detail: svids['assignment_details']["detail"],
                          id: svids['assignment_details']["id"],
                          name: svids['assignment_details']["name"],
                          offlineLink: svids['assignment_details']
                              ["offlineLink"],
                          offlineThumbnail: svids['assignment_details']
                              ["offlineThumbnail"],
                          onlineLink: svids['assignment_details']["onlineLink"],
                          thumbnail: svids['assignment_details']["thumbnail"],
                          topicName: svids['assignment_details']["topicName"],
                        ),
                        'student_report': svids['student_report']
                            .values
                            .map<JoinedStudents>(
                                (i) => JoinedStudents.fromJson(i))
                            .toList(),
                        "item_index": _assignmentItemIndex.toString(),
                        "assignment_id": element['assignment_id'],
                      });
                      _assignmentItemIndex++;
                    });
                  }
                  if (element["videos"] != null) {
                    int _assignmentItemIndex = 0;
                    element["videos"].forEach((svids) {
                      assignment.add({
                        'assignment_image_url':
                            'assets/images/video_category.png',
                        'assignment_category': 'subjects',
                        'assignment_sub_category': 'videos',
                        'time': element['time'],
                        'subject_name': element['subject_name'],
                        'subject_id': element['subject_id'],
                        'due_date': element['due_date'],
                        'data': VideoLessonModel(
                          detail: svids['assignment_details']["detail"],
                          id: svids['assignment_details']["id"],
                          name: svids['assignment_details']["name"],
                          offlineLink: svids['assignment_details']
                              ["offlineLink"],
                          offlineThumbnail: svids['assignment_details']
                              ["offlineThumbnail"],
                          onlineLink: svids['assignment_details']["onlineLink"],
                          thumbnail: svids['assignment_details']["thumbnail"],
                          topicName: svids['assignment_details']["topicName"],
                        ),
                        'student_report': svids['student_report']
                            .values
                            .map<JoinedStudents>(
                                (i) => JoinedStudents.fromJson(i))
                            .toList(),
                        "item_index": _assignmentItemIndex.toString(),
                        "assignment_id": element['assignment_id'],
                      });
                      _assignmentItemIndex++;
                    });
                  }
                  if (element["practice"] != null) {
                    int _assignmentItemIndex = 0;
                    element["practice"].forEach((practice) {
                      assignment.add({
                        'assignment_image_url':
                            'assets/images/practice_category.png',
                        'assignment_category': 'subjects',
                        'assignment_sub_category': 'practice',
                        'time': element['time'],
                        'subject_name': element['subject_name'],
                        'subject_id': element['subject_id'],
                        'class_number': element['class_number'],
                        "language": element['language'],
                        'due_date': element['due_date'],
                        'data': PracticeModel.fromJson(
                            practice['assignment_details']),
                        'student_report': practice['student_report']
                            .values
                            .map<JoinedStudents>(
                                (i) => JoinedStudents.fromJson(i))
                            .toList(),
                        "item_index": _assignmentItemIndex.toString(),
                        "assignment_id": element['assignment_id'],
                      });
                      _assignmentItemIndex++;
                    });
                  }

                  if (element["notes"] != null) {
                    int _assignmentItemIndex = 0;
                    element["notes"].forEach((notes) {
                      assignment.add({
                        'assignment_image_url':
                            'assets/images/notes_category.png',
                        'assignment_category': 'subjects',
                        'assignment_sub_category': 'notes',
                        'time': element['time'],
                        'subject_name': element['subject_name'],
                        'subject_id': element['subject_id'],
                        'due_date': element['due_date'],
                        'data': NotesModel(
                          id: notes['assignment_details']["id"],
                          boardID: notes['assignment_details']["boardID"],
                          classID: notes['assignment_details']["classID"],
                          language: notes['assignment_details']["language"],
                          subjectName: notes['assignment_details']
                              ["subjectName"],
                          chapterName: notes['assignment_details']
                              ["chapterName"],
                          noteDetails: notes['assignment_details']
                              ["bookDetails"],
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
                            .map<JoinedStudents>(
                                (i) => JoinedStudents.fromJson(i))
                            .toList(),
                        "item_index": _assignmentItemIndex.toString(),
                        "assignment_id": element['assignment_id'],
                      });
                      _assignmentItemIndex++;
                    });
                  }
                  if (element["books"] != null) {
                    int _assignmentItemIndex = 0;
                    element["books"].forEach((books) {
                      assignment.add({
                        'assignment_image_url':
                            'assets/images/books_category.png',
                        'assignment_category': 'subjects',
                        'assignment_sub_category': 'books',
                        'time': element['time'],
                        'subject_name': element['subject_name'],
                        'subject_id': element['subject_id'],
                        'due_date': element['due_date'],
                        'data': BooksModel(
                          id: books['assignment_details']["id"],
                          boardID: books['assignment_details']["boardID"],
                          classID: books['assignment_details']["classID"],
                          language: books['assignment_details']["language"],
                          subjectName: books['assignment_details']
                              ["subjectName"],
                          chapterName: books['assignment_details']
                              ["chapterName"],
                          bookDetails: books['assignment_details']
                              ["bookDetails"],
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
                            .map<JoinedStudents>(
                                (i) => JoinedStudents.fromJson(i))
                            .toList(),
                        "item_index": _assignmentItemIndex.toString(),
                        "assignment_id": element['assignment_id'],
                      });
                      _assignmentItemIndex++;
                    });
                  }
                });
                return Stack(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: ListView(
                          children: List.generate(assignment.length, (index) {
                            return InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                    builder: (_) => AssignmentReportPage(
                                      assignment: assignment[index],
                                      batchId: widget.selectedBatch!.batchId,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Constants.months[DateTime.parse(
                                                            assignment[index]
                                                                ['time'])
                                                        .month -
                                                    1],
                                                style: const TextStyle(
                                                    fontSize: 10.0,
                                                    color: const Color(
                                                        0xFF9E9E9E)),
                                              ),
                                              Text(
                                                (DateTime.parse(
                                                            assignment[index]
                                                                ['time'])
                                                        .day /*+
                                                        1*/
                                                    )
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 10.0,
                                                    color: const Color(
                                                        0xFF9E9E9E)),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 8, right: 12.0),
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
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 30.0),
                                      child: const Icon(
                                        Icons.chevron_right_outlined,
                                        color: Color(0xFFB1B1B1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                        )),
                    Positioned(
                      bottom: 46.0,
                      right: 20.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          if ((widget.selectedBatch!.joinedStudentsList !=
                                  null) &&
                              (widget.selectedBatch!.joinedStudentsList!
                                  .isNotEmpty)) {
                            await showClassBottomSheet(
                                context, widget.selectedBatch);
                          } else {
                            SnackbarMessages.showErrorSnackbar(context,
                                error: Constants
                                    .assignmentNoStudentJoinedBatchAlert);
                          }
                        },
                        child: const Text(
                          "Assign from iPrep Library",
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xff0070FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return const Center(child: Loader());
              }
            },
          );
        });
  }
}
