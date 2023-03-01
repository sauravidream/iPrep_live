import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/model/batch_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:idream/common/references.dart';

showAssignBottomSheet(BuildContext context, String contentType, String? dataID,
    List<dynamic> dataContent,
    {required Batch batchInfo, String? subjectName, String? classNumber}) async {
  bool _batchSelected = true;
  // List<Batch> batchList = [batchInfo];
  List<JoinedStudents> _studentList = [];
  List<bool> _studentCheck =
      List.filled(batchInfo.joinedStudentsList!.length, true);
  _studentList.addAll(batchInfo.joinedStudentsList!);
  // for (int i = 0; i < batchInfo.joinedStudentsList.length; i++) {
  //   _studentCheck.add(true);
  //   _studentList.add(batchInfo.joinedStudentsList[i]);
  // }

  _getParsableDate(String selectedDueDate) {
    try {
      return DateFormat.yMMMd().parse(selectedDueDate);
    } catch (e) {
      return DateTime.now();
    }
  }

  showMaterialModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    ),
    context: context,
    builder: (context) {
      String _assignmentDueDate = "";

      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xff0070FF)),
                                  )),
                              const Text(
                                "Select",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (_studentList.isNotEmpty) {
                                    if (dataContent.isNotEmpty) {
                                      if (_assignmentDueDate.isNotEmpty) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        if (contentType != "Extra Books") {
                                          Navigator.pop(context);
                                        }
                                        await assignmentRepository
                                            .saveAssignmentDetails(
                                                contentType,
                                                dataID,
                                                dataContent,
                                                batchInfo,
                                                _studentList,
                                                subjectName: subjectName,
                                                classNumber: classNumber,
                                                assignmentDueDate:
                                                    _assignmentDueDate);
                                      } else {
                                        SnackbarMessages.showErrorSnackbar(
                                            context,
                                            error: Constants
                                                .assignmentEndDateSelectionAlert);
                                      }
                                    } else {
                                      SnackbarMessages.showErrorSnackbar(
                                          context,
                                          error: Constants
                                              .assignmentNoItemSelectionAlert);
                                    }
                                  } else {
                                    SnackbarMessages.showErrorSnackbar(context,
                                        error: Constants
                                            .noStudentSelectionErrorForAssignment);
                                  }
                                },
                                child: const Text(
                                  "Assign",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff0070FF)),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 40.0,
                              height: 40.0,
                              child: TextField(
                                decoration: InputDecoration(
                                    fillColor: Colors.red,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: const BorderSide(
                                            width: 1.0,
                                            color: Color(0xFFC1C1C1))),
                                    contentPadding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    hintText: "Search",
                                    hintStyle:
                                        const TextStyle(color: Color(0xFFC1C1C1))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      color: const Color(0xFFC1C1C1),
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10.0, left: 20.0, bottom: 10.0),
                          child: const Text(
                            "Classes",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              color: Color(0xFF606060),
                            ),
                          ),
                        ),
                        StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter _setState) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _setState(() {
                                      if (_batchSelected) {
                                        _studentCheck.fillRange(
                                            0, _studentCheck.length, false);
                                        _studentList.clear();
                                      } else {
                                        _studentCheck.fillRange(
                                            0, _studentCheck.length, true);
                                        _studentList.addAll(
                                            batchInfo.joinedStudentsList!);
                                      }
                                      _batchSelected = !_batchSelected;
                                    });
                                  },
                                  child: Container(
                                    color: _batchSelected
                                        ? const Color(0xFFE8F2FF)
                                        : Colors.transparent,
                                    padding: const EdgeInsets.only(
                                        left: 15.0,
                                        right: 15,
                                        top: 8,
                                        bottom: 8),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            'assets/images/${_batchSelected ? "checked_image_blue" : "check_box_empty"}.png',
                                            height: 22,
                                            width: 22,
                                          ),
                                        ),
                                        Container(
                                          height: 44.0,
                                          width: 44.0,
                                          margin: const EdgeInsets.only(
                                              top: 1.0, left: 5.0, right: 5.0),
                                          padding: const EdgeInsets.only(bottom: 6),
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: Color(0xffD1E6FF),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(6),
                                            ),
                                          ),
                                          child: Text(
                                            (batchInfo.batchClass!.length > 2)
                                                ? batchInfo.batchClass!
                                                    .substring(0, 2)
                                                : batchInfo.batchClass!,overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Color(0xff0070FF),
                                            ),
                                          ),
                                        ),
                                        Flexible(flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                batchInfo.batchName!,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xff212121),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                "${batchInfo != null ? batchInfo.joinedStudentsList!.length.toString() : '0'} ${batchInfo.joinedStudentsList!.length > 1 ? "Students" : "Student"}",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF666666),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 10.0,
                                    left: 20.0,
                                  ),
                                  child: const Text(
                                    "Students",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                                batchInfo != null &&
                                        batchInfo.joinedStudentsList!.isNotEmpty
                                    ? Column(
                                        children: List.generate(
                                          batchInfo.joinedStudentsList!.length,
                                          (index) {
                                            return InkWell(
                                              onTap: () {
                                                _setState(
                                                  () {
                                                    if (_studentCheck[index]) {
                                                      _studentCheck[index] =
                                                          false;
                                                      _studentList.remove(batchInfo
                                                          .joinedStudentsList!
                                                          .firstWhere((element) =>
                                                              element ==
                                                              batchInfo
                                                                      .joinedStudentsList![
                                                                  index]));
                                                    } else {
                                                      _studentCheck[index] =
                                                          true;
                                                      _studentList.add(batchInfo
                                                              .joinedStudentsList![
                                                          index]);
                                                    }
                                                  },
                                                );
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 8.0),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                        'assets/images/${_studentCheck[index] ? "checked_image_blue" : "check_box_empty"}.png',
                                                        height: 22,
                                                        width: 22,
                                                      ),
                                                    ),
                                                    CachedNetworkImage(
                                                      imageUrl: batchInfo
                                                          .joinedStudentsList![
                                                              index]
                                                          .profileImage!,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image: DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              Center(
                                                        child: SizedBox(
                                                          height: 25,
                                                          width: 25,
                                                          child:
                                                              CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress,
                                                            strokeWidth: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(Icons.error),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      batchInfo
                                                          .joinedStudentsList![
                                                              index]
                                                          .fullName!,
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xff212121),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Container()
                              ],
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter _setState) {
                  return InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _assignmentDueDate.isNotEmpty
                            ? _getParsableDate(_assignmentDueDate)
                            : DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                        helpText: "Assignment End Date",
                        errorFormatText: 'Enter valid date',
                        errorInvalidText: 'Enter date in valid range',
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData
                                .dark(), // This will change to light theme.
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        _setState(() {
                          _assignmentDueDate = picked.toString();
                        });
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/stopwatch.png",
                            height: 24,
                            color: const Color(0xFF0070FF),
                          ),
                          Text(
                            _assignmentDueDate.isNotEmpty
                                ? DateFormat.yMMMd()
                                    .format(DateTime.parse(_assignmentDueDate))
                                : "Add End Date & Time",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0070FF),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    },
  );
}
