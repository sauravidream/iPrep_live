import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/ui/network_error_page.dart';
import 'package:provider/provider.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/model/books_model.dart';
import 'package:idream/model/extra_book_model.dart';
import 'package:idream/model/notes_model.dart';
import 'package:idream/model/practice_model.dart';
import 'package:idream/model/test_model.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// ignore: must_be_immutable
class AssignmentReportPage extends StatefulWidget {
  dynamic assignment;
  final String? batchId;

  AssignmentReportPage({Key? key,
    this.assignment,
    this.batchId,
  }) : super(key: key);

  @override
  _AssignmentReportPageState createState() => _AssignmentReportPageState();
}

class _AssignmentReportPageState extends State<AssignmentReportPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(
      builder: (BuildContext context, networkProvider, Widget? child) {
        return networkProvider.isAvailable == true
            ? Container(
                color: Colors.white,
                child: SafeArea(
                  bottom: false,
                  child: Scaffold(
                    body: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverOverlapAbsorber(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                            sliver: SliverSafeArea(
                              top: false,
                              bottom: false,
                              sliver: SliverAppBar(
                                backgroundColor: Colors.white,
                                elevation: 0,
                                flexibleSpace: const SizedBox(height: 20),
                                titleSpacing: 0,
                                leadingWidth: 11,
                                leading: Container(),
                                actions: [
                                  InkWell(
                                    onTap: () async {
                                      await showAssignmentEditBottomSheet(
                                          context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 11.0,
                                        left: 11,
                                      ),
                                      child: Image.asset(
                                        'assets/images/3_dot.png',
                                        height: 24,
                                        width: 24,
                                        color: const Color(0xff212121),
                                      ),
                                    ),
                                  )
                                ],
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Image.asset(
                                        "assets/images/back_icon.png",
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Image.asset(
                                      widget.assignment['assignment_image_url'],
                                      height: 36.0,
                                      width: 36.0,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.assignment['data']
                                                        is VideoLessonModel ||
                                                    widget.assignment['data']
                                                        is Topics
                                                ? widget.assignment['data'].name
                                                : widget.assignment['data']
                                                            is PracticeModel ||
                                                        widget.assignment[
                                                            'data'] is TestModel
                                                    ? widget.assignment['data']
                                                        .tName
                                                    : widget.assignment['data']
                                                            is NotesModel
                                                        ? widget
                                                            .assignment['data']
                                                            .chapterName
                                                        : widget.assignment[
                                                                    'data']
                                                                is BooksModel
                                                            ? widget
                                                                .assignment[
                                                                    'data']
                                                                .bookName
                                                            : '',
                                            style: TextStyle(
                                                fontWeight:
                                                    FontWeight.values[5],
                                                fontSize: 18,
                                                color: const Color(0xFF212121)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            '${widget.assignment['subject_name']} | Due: ${DateTime.parse(widget.assignment['due_date']).day} ${Constants.months[DateTime.parse(widget.assignment['due_date']).month - 1]} ${DateTime.parse(widget.assignment['due_date']).year}',
                                            style: const TextStyle(
                                                color: Color(0xFF9E9E9E),
                                                fontSize: 12.0),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                floating: false,
                                pinned: true,
                                // snap: true,
                                primary: false,
                                forceElevated: innerBoxIsScrolled,
                                bottom: PreferredSize(
                                  preferredSize: const Size.fromHeight(1),
                                  child: Container(
                                    height: 0.5,
                                    color: const Color(0xFF6A6A6A),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                      body: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Summary",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Flexible(
                              child: ListView(
                                shrinkWrap: true,
                                children: List.generate(
                                  widget.assignment['student_report'].length,
                                  (index) {
                                    return _assignmentStudentReportTile(
                                        studentData:
                                            widget.assignment['student_report']
                                                [index]);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const NetworkError();
      },
    );
  }

  Future showAssignmentEditBottomSheet(BuildContext context) async {
    showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .25,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/line.png",
                      width: 45,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Center(
                    child: Text(
                      "Edit",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16, color: Color(0xff666666)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 21,
                      bottom: 27,
                    ),
                    child: InkWell(
                      onTap: () async {
                        //Write code to update End date
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.parse(widget.assignment['due_date']),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 1),
                          helpText: "Assignment End Date",
                          errorFormatText: 'Enter valid date',
                          errorInvalidText: 'Enter date in valid range',
                          confirmText: "Update End Date",
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData
                                  .dark(), // This will change to light theme.
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          var _response = await assignmentRepository
                              .updateAssignmentEndDate(
                            batchId: widget.batchId,
                            assignmentDetails: widget.assignment,
                            updatedDueDate: picked.toString(),
                          );
                          Navigator.pop(context);
                          if (_response != null && _response) {
                            setState(() {
                              widget.assignment['due_date'] = picked.toString();
                            });
                            SnackbarMessages.showSuccessSnackbar(context,
                                message:
                                    Constants.assignmentEndDateUpdationSuccess);
                          } else {
                            SnackbarMessages.showErrorSnackbar(context,
                                error:
                                    Constants.assignmentEndDateUpdationError);
                          }
                        }
                      },
                      child: Text(
                        "Edit Date and Time",
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF212121),
                          fontWeight: FontWeight.values[5],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      var _response =
                          await assignmentRepository.deleteAssignment(
                        batchId: widget.batchId,
                        assignmentDetails: widget.assignment,
                      );
                      if ((_response != null) && _response) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        SnackbarMessages.showSuccessSnackbar(context,
                            message: Constants.assignmentRemovalSuccess);
                      } else {
                        SnackbarMessages.showErrorSnackbar(context,
                            error: Constants.assignmentRemovalError);
                      }
                    },
                    child: Text(
                      "Delete Assignment",
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFFFF6F6F),
                        fontWeight: FontWeight.values[5],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

_assignmentStudentReportTile({required dynamic studentData}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: InkWell(
      onTap: () async {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: studentData.profileImage,
                imageBuilder: (context, imageProvider) => Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      strokeWidth: 0.5,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentData.fullName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.values[5],
                      color: const Color(0xff212121),
                    ),
                  ),
                  SizedBox(
                      height: (studentData.assignmentProgress != null) ? 8 : 0),
                  if (studentData.assignmentProgress != null)
                    Text(
                      'Attempted: ${DateTime.parse(studentData.assignmentProgress.updatedTime).day + 3} ${Constants.months[DateTime.parse(studentData.assignmentProgress.updatedTime).month - 1]} ${DateTime.parse(studentData.assignmentProgress.updatedTime).year}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff9E9E9E),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: (studentData.assignmentProgress != null)
                ? Text(
                    studentData.assignmentProgress.progressText,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(int.parse(
                          studentData.assignmentProgress.progressTextColor)),
                      fontWeight: FontWeight.values[5],
                    ),
                  )
                : const Text(
                    "Yet to attempt",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Color(0xFFFF7575),
                      fontSize: 12,
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}
