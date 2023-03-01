import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/model/class_model.dart';
import 'package:idream/model/extra_book_model.dart';
import 'package:idream/model/stem.dart';
import 'package:idream/model/streams_model.dart';
import 'package:idream/model/subject_model.dart';
import 'package:idream/repository/class_repository.dart';
import 'package:idream/ui/teacher/chapter_listing_teacher.dart';
import 'package:idream/ui/teacher/extrabooks_listing_page_teacher.dart';
import 'package:idream/ui/teacher/stem_chapter_listing_teacher.dart';
import 'package:idream/ui/teacher/subject_home_teacher.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';

// Class Bottom Sheet
showClassBottomSheet(BuildContext context, Batch? currentBatch) async {
  ClassRepository classRepository = ClassRepository();
  List<ClassStandard>? _classesList = await (classRepository.fetchClasses());

  showMaterialModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    ),
    context: context,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * .50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 2,
              ),
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
                  "Select a Class",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff666666),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _classesList!.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return buildClassValue(
                      _classesList[_classesList.length - index - 1].className,
                      false,
                      currentBatch,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

buildClassValue(String? text, bool check, Batch? batch) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter _setState) {
      return Container(
        margin: const EdgeInsets.only(
          bottom: 0.0,
          left: 12,
        ),
        child: Material(
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              _setState(() {
                if (check) {
                  check = false;
                } else {
                  check = true;
                }
              });
              Navigator.pop(context);
              if (text != "11th" && text != "12th") {
                String selectedClass = text!.replaceAll(RegExp(r'[^0-9]'), '');
                showContentBottomSheet(
                    context, text, batch, selectedClass, null);
              } else {
                showStreamBottomSheet(context, text, batch);
              }
            },
            // splashColor: const Color(0xff0070FF),
            child: Container(
              // color: check ? const Color(0xffE8F2FF) : Colors.white,
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Class $text",
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: "Inter",
                          color: Color(0xff212121)),
                    ),
                    Center(
                        child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: check
                            ? Image.asset(
                                'assets/images/checked_image_blue.png',
                                height: 22,
                                width: 22,
                              )
                            : Container(height: 22, width: 22),
                      ),
                    )),
                  ]),
            ),
          ),
        ),
      );
    },
  );
}

// Stream Bottom Sheet
showStreamBottomSheet(
    BuildContext context, String? selectedClass, Batch? currentBatch) async {
  showMaterialModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    ),
    context: context,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * .40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 2,
                ),
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
                    "Select a Stream",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff666666),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                    initialData: null,
                    future: assignmentRepository.fetchStream(
                        selectedClass!, currentBatch!),
                    builder: (context, streams) {
                      if (streams.connectionState == ConnectionState.none &&
                          streams.hasData == null) {
                        return buildStreamValue("Non medical", false,
                            currentBatch, selectedClass, null);
                      } else if (streams.connectionState ==
                              ConnectionState.done &&
                          streams.data == null) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text(
                            "No data available.",
                            style: Constants.noDataTextStyle,
                          ),
                        );
                      } else if (streams.hasData) {
                        List<StreamsModel>? _streamList =
                            streams.data as List<StreamsModel>?;
                        return Container(
                          child: Column(
                            children:
                                List.generate(_streamList!.length, (index) {
                              return buildStreamValue(
                                  _streamList[index].streamName,
                                  false,
                                  currentBatch,
                                  _streamList[index].streamID,
                                  _streamList[index]);
                            }),
                          ),
                        );
                      } else {
                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: const Text("Loading..."),
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      );
    },
  );
}

buildStreamValue(String? text, bool check, Batch? batch, String? selectedClass,
    StreamsModel? streams) {
  return StatefulBuilder(
      builder: (BuildContext context, StateSetter _setState) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: InkWell(
        onTap: () {
          _setState(() {
            if (check) {
              check = false;
            } else {
              check = true;
            }
          });
          Navigator.pop(context);
          showContentBottomSheet(context, text, batch, selectedClass, streams);
        },
        child: Container(
          color: check ? const Color(0xffE8F2FF) : Colors.white,
          padding: const EdgeInsets.all(6),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              text!,
              style: const TextStyle(
                  fontSize: 14, fontFamily: "Inter", color: Color(0xff212121)),
            ),
            Center(
                child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: check
                    ? Image.asset(
                        'assets/images/checked_image_blue.png',
                        height: 22,
                        width: 22,
                      )
                    : Container(height: 22, width: 22),
              ),
            )),
          ]),
        ),
      ),
    );
  });
}

// Content Bottom Sheet
showContentBottomSheet(BuildContext context, String? selectedClass,
    Batch? currentBatch, String? classValue, StreamsModel? stream) async {
  List<String> _contentList = ["Subjects", "STEM Videos", "Books"];

  showMaterialModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    ),
    context: context,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * .40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 2,
                ),
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
                    "Select an Option",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff666666),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: List.generate(_contentList.length, (index) {
                    return buildContentValue(_contentList[index], false,
                        currentBatch, classValue, stream);
                  }),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

buildContentValue(String text, bool check, Batch? batch, String? selectedClass,
    StreamsModel? stream) {
  return StatefulBuilder(
      builder: (BuildContext context, StateSetter _setState) {
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          _setState(() {
            if (check) {
              check = false;
            } else {
              check = true;
            }
          });
          Navigator.pop(context);
          showSubjectBottomSheet(context, text, batch, selectedClass, stream);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "Inter",
                    color: Color(0xff212121)),
              ),
              Center(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: check
                        ? Image.asset(
                            'assets/images/checked_image_blue.png',
                            height: 22,
                            width: 22,
                          )
                        : Container(height: 22, width: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
}

// Subject Bottom Sheet
showSubjectBottomSheet(BuildContext context, String selectedOption,
    Batch? currentBatch, String? selectedClass, StreamsModel? stream) async {
  showMaterialModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    ),
    context: context,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * .40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 2,
              ),
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
                  "Select a Subject",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff666666),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: SingleChildScrollView(
                  child: FutureBuilder(
                      initialData: null,
                      future: assignmentRepository.fetchSubject(
                          selectedOption, currentBatch!, selectedClass, stream),
                      builder: (context, subjects) {
                        if (subjects.connectionState == ConnectionState.none &&
                            subjects.hasData == null) {
                          return buildSubjectValue("Physics", false,
                              currentBatch, selectedClass, null);
                        } else if (subjects.connectionState ==
                                ConnectionState.done &&
                            subjects.data == null) {
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              "No data available.",
                              style: Constants.noDataTextStyle,
                            ),
                          );
                        } else if (subjects.hasData) {
                          if (selectedOption == "Subjects") {
                            List<SubjectModel>? _subjectList =
                                subjects.data as List<SubjectModel>?;
                            return Column(
                              children:
                                  List.generate(_subjectList!.length, (index) {
                                return buildSubjectValue(
                                    _subjectList[index].subjectName,
                                    false,
                                    currentBatch,
                                    selectedClass,
                                    _subjectList[index]);
                              }),
                            );
                          } else if (selectedOption == "STEM Videos") {
                            List<StemModel>? _stemvidList =
                                subjects.data as List<StemModel>?;
                            return Container(
                              child: Column(
                                children: List.generate(_stemvidList!.length,
                                    (index) {
                                  return buildSubjectValue(
                                      _stemvidList[index].subjectName,
                                      false,
                                      currentBatch,
                                      selectedClass,
                                      _stemvidList[index]);
                                }),
                              ),
                            );
                          } else {
                            List<ExtraBookModel>? _extrabookList =
                                subjects.data as List<ExtraBookModel>?;
                            return Container(
                              child: Column(
                                children: List.generate(_extrabookList!.length,
                                    (index) {
                                  return buildSubjectValue(
                                      _extrabookList[index].subjectName,
                                      false,
                                      currentBatch,
                                      selectedClass,
                                      _extrabookList[index]);
                                }),
                              ),
                            );
                          }
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: const Text("Loading..."),
                          );
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

buildSubjectValue(
    String? text, bool check, Batch? batch, String? selectedClass, subject) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter _setState) {
      return Material(
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            if (subject is SubjectModel) {
              List _categoryWiseData = [];
              List categoryWiseId = [];
              final categoryList =
                  await subjectRepository.fetchCategoryWiseDataBasisOnSubjectID(
                subjectID: subject.subjectID,
                language: batch!.language,
                board: subject.boardName,
                classNumber: selectedClass,
              );
              await Future.forEach(categoryList!, (element) {
                _categoryWiseData.add(element.name);
                categoryWiseId.add(element.id);
              });
              if (_categoryWiseData.isNotEmpty) {
                if ((categoryWiseId).contains("multimedia")) {
                  await Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ChapterListingTeacherPage(
                        subjectImagePath: (subject.subjectIconPath != null &&
                                subject.subjectIconPath!.isNotEmpty)
                            ? subject.subjectIconPath
                            : Constants.defaultSubjectImagePath,
                        subjectName: subject.subjectName,
                        subjectColor: (subject.subjectColor != null &&
                                subject.subjectColor!.isNotEmpty)
                            ? (int.parse(subject.subjectColor!.substring(1, 7),
                                    radix: 16) +
                                0xFF000000)
                            : Constants.defaultSubjectHexColor,
                        subjectID: subject.subjectID,
                        classId: selectedClass,
                        batch: batch,
                        categoryWiseData: _categoryWiseData,
                      ),
                    ),
                  );
                } else {
                  await Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SubjectHomeTeacher(
                        subjectImagePath: (subject.subjectIconPath != null &&
                                subject.subjectIconPath!.isNotEmpty)
                            ? subject.subjectIconPath
                            : Constants.defaultSubjectImagePath,
                        subjectName: subject.subjectName,
                        subjectColor: (subject.subjectColor != null &&
                                subject.subjectColor!.isNotEmpty)
                            ? (int.parse(subject.subjectColor!.substring(1, 7),
                                    radix: 16) +
                                0xFF000000)
                            : Constants.defaultSubjectHexColor,
                        subjectID: subject.subjectID,
                        chapterName: "",
                        totalChapters: 0,
                        chapterList: [],
                        classId: selectedClass,
                        batch: batch,
                        categoryWiseData: _categoryWiseData,
                      ),
                    ),
                  );
                }
              } else {
                SnackbarMessages.showErrorSnackbar(context,
                    error: Constants.noCategoryDataAvailableForSubjects);
              }
            } else if (subject is StemModel) {
              await Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => StemChapterListingTeacherPage(
                    subjectImagePath: (subject.subjectIconPath != null &&
                            subject.subjectIconPath!.isNotEmpty)
                        ? subject.subjectIconPath
                        : Constants.defaultSubjectImagePath,
                    subjectColor: subject.subjectColor ??
                        Constants.defaultSubjectHexColor,
                    steamModel: subject,
                    batchInfo: batch,
                    classId: selectedClass,
                  ),
                ),
              );
            } else {
              await Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => ExtraBooksListingTeacherPage(
                    subjectImagePath: (Constants
                                .subjectColorAndImageMap[subject.subjectID] !=
                            null)
                        ? Constants.subjectColorAndImageMap[subject.subjectID]
                            ['assetPath']
                        : "assets/images/physics.png",
                    subjectColor: (Constants
                                .subjectColorAndImageMap[subject.subjectID] !=
                            null)
                        ? Constants.subjectColorAndImageMap[subject.subjectID]
                            ['subjectColor']
                        : 0xFFFCAC52,
                    extrabookModel: subject,
                    batchInfo: batch,
                    classId: selectedClass,
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text!,
                  style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      color: Color(0xff212121)),
                ),
                Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: check
                          ? Image.asset(
                              'assets/images/checked_image_blue.png',
                              height: 22,
                              width: 22,
                            )
                          : Container(height: 22, width: 22),
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
