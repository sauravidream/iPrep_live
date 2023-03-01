import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';

import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/ui/menu/my_reports_page.dart';
import 'package:idream/ui/teacher/dashboard_coach.dart';
import 'package:idream/ui/teacher/one_to_one_messaging.dart';
import 'package:idream/ui/teacher/utilities/bottom_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Student extends StatefulWidget {
  final Batch? batchInfo;
  final DashboardCoachState? dashboardOneState;

  const Student({
    Key? key,
    this.batchInfo,
    this.dashboardOneState,
  }) : super(key: key);

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .70,
            child: (widget.batchInfo!.joinedStudentsList!.isNotEmpty)
                ? ListView.builder(
                    itemCount: widget.batchInfo!.joinedStudentsList!.length,
                    // physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildData(
                          batch: widget.batchInfo,
                          joinedStudents:
                              widget.batchInfo!.joinedStudentsList![index],
                          batchId: widget.batchInfo!.batchId);
                    },
                  )
                : Center(
                    child: Text(
                      "No student joined yet.\nAdd now.",
                      textAlign: TextAlign.center,
                      style: Constants.noDataTextStyle,
                    ),
                  ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () async {
              debugPrint('Add Student: ${widget.batchInfo}');

              String _batchSubjectString = widget.batchInfo!.batchSubject!
                  .map((e) => e.subjectName)
                  .toList()
                  .toString();

              _batchSubjectString = _batchSubjectString.replaceAll('[', "");
              _batchSubjectString = _batchSubjectString.replaceAll(']', "");

              String _batchJoiningLinkText = Constants.getBatchJoiningLink(
                teacherName: widget.batchInfo!.teacherName,
                subjectsText: _batchSubjectString,
                className: (widget.batchInfo!.batchClass!.length > 2)
                    ? widget.batchInfo!.batchClass!.substring(0, 2)
                    : widget.batchInfo!.batchClass,
                batchName: widget.batchInfo!.batchName,
              );

              await shareEarnRepository.shareContent(
                  context: context,
                  content:
                      '${widget.batchInfo!.deeplink!}\n\n$_batchJoiningLinkText');
            },
            child: Image.asset(
              "assets/images/add_student_button.png",
              height: 46,
              width: 116,
            ),
          )
        ],
      ),
    );
  }

  buildData(
      {Batch? batch, required JoinedStudents joinedStudents, String? batchId}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => MyReportsPage(
              joinedStudent: joinedStudents,
              boardID: batch!.board,
              language: batch.language,
              studentClass: batch.batchClass,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: joinedStudents.profileImage!,
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
                // CircleAvatar(
                //   backgroundImage: NetworkImage(
                //     joinedStudents.profileImage,
                //   ),
                //   radius: ScreenUtil().setSp(22, ),
                // ),
                const SizedBox(width: 12),
                Text(
                  joinedStudents.fullName!,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.values[5],
                    color: const Color(0xff212121),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () async {
                await showStudentTabEditBottomSheet(context,
                    batch: batch,
                    batchId: batchId,
                    joinedStudents: joinedStudents);
              },
              child: Image.asset(
                "assets/images/3_dot.png",
                height: 24,
                width: 24,
                color: const Color(0xff212121),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showStudentTabEditBottomSheet(BuildContext context,
      {Batch? batch, String? batchId, JoinedStudents? joinedStudents}) {
    showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10.0),
            topRight: Radius.circular(10.0)),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * .25,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      height: 3,
                      width: 40,
                      color: const Color(0xffDEDEDE),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Center(
                    child: Text(
                      "Edit",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Inter",
                          color: Color(0xff666666)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        String? _loggedInUserId =
                            await getStringValuesSF("userID");
                        await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                OneToOneMessagingPage(
                                    loggedInUserId: _loggedInUserId,
                                    selectedBatchModel: batch,
                                    joinedStudentModel: joinedStudents),
                          ),
                        );
                      },
                      child: const Text(
                        "Message Student",
                        style: const TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF212121),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: InkWell(
                      onTap: () async {
                        await showClassBottomSheet(context, widget.batchInfo);
                      },
                      child: const Text(
                        "Assign Content",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: InkWell(
                      onTap: () async {
                        var _response =
                            await batchRepository.removeStudentFromBatch(
                                batchId: batchId!,
                                studentUserId: joinedStudents!.userID!);
                        if (_response) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          widget.dashboardOneState!.setState(() {});
                        } else {
                          Navigator.pop(context);
                          SnackbarMessages.showErrorSnackbar(context,
                              error: Constants.studentRemovalFromBatchError);
                        }
                      },
                      child: const Text(
                        "Remove Student",
                        style: const TextStyle(
                            fontSize: 14,
                            color: const Color(0xFFFF6F6F),
                            fontWeight: FontWeight.w600),
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
