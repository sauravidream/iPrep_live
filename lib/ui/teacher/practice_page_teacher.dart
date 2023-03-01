import 'package:flutter/material.dart';

import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/model/practice_model.dart';
import 'package:idream/ui/teacher/subject_home_teacher.dart';
import 'package:idream/ui/teacher/utilities/selectstudentbottom_sheet.dart';

class PracticePageTeacher extends StatefulWidget {
  final SubjectHomeTeacher? subjectHome;
  PracticePageTeacher({this.subjectHome});

  @override
  _PracticePageTeacherState createState() => _PracticePageTeacherState();
}

class _PracticePageTeacherState extends State<PracticePageTeacher>
    with AutomaticKeepAliveClientMixin {
  Future fetchPracticeTopics() async {
    return assignmentRepository.fetchPracticeTopicList(
        widget.subjectHome!.subjectID,
        widget.subjectHome!.batch!,
        widget.subjectHome!.classId);
  }

  List<PracticeModel> selectedTopic = [];

  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(
                height: 16.5,
              ),
              Container(
                height: 0.5,
                color: const Color(0xFF6A6A6A),
              ),
              Expanded(
                child: FutureBuilder(
                  future: fetchPracticeTopics(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data.length > 0) {
                        int? _chaptersCount = snapshot.data.length;
                        List<PracticeModel>? _practiceModel = snapshot.data;
                        return ListView.builder(
                            itemCount: snapshot.data == null
                                ? 1
                                : snapshot.data.length,
                            padding: const EdgeInsets.all(
                              16,
                            ),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (snapshot.data == null) {
                                return Center(
                                    child: Text(
                                  "No content available",
                                  style: TextStyle(
                                    color: const Color(0xFF212121),
                                    fontWeight: FontWeight.values[5],
                                    fontSize: 15,
                                  ),
                                ));
                              }
                              return chapterTile(index, _practiceModel![index],
                                  _chaptersCount, selectedTopic, false);
                            });
                      } else {
                        return const Text("No data found");
                      }
                    } else {
                      return const Center(
                        child: Loader(),
                        /*CircularProgressIndicator(
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: Color(0xFF3399FF),
                        ),*/
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 25.0,
          right: 16.0,
          child: ElevatedButton(
            onPressed: () {
              showAssignBottomSheet(
                context,
                "SubjectPractice",
                widget.subjectHome!.subjectID,
                selectedTopic,
                batchInfo: widget.subjectHome!.batch!,
                subjectName: widget.subjectHome!.subjectName,
                classNumber: widget.subjectHome!.classId,
              );
            },
            child: const Text(
              "Select Students",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF0077FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              minimumSize: const Size(176, 50),
            ),
          ),
        )
      ],
    );
  }

  Widget chapterTile(int index, PracticeModel practiceModel, int? chaptersCount,
      List<PracticeModel> selectedTopic, bool check) {
    TextStyle _textStyle = const TextStyle(
      color: Color(0xFF9E9E9E),
      fontSize: 10,
    );
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter _setState) {
      return InkWell(
        onTap: () async {
          _setState(() {
            if (check) {
              check = false;
              selectedTopic.remove(practiceModel);
            } else {
              check = true;
              selectedTopic.add(practiceModel);
            }
          });
        },
        child: Container(

         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: check ? const Color(0xffE8F2FF) : Colors.white,),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "${index < 9 ? "0" : ""}${index + 1}.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(widget.subjectHome!.subjectColor!),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        practiceModel.tName!,
                        style: TextStyle(
                          color: Color(widget.subjectHome!.subjectColor!),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    check
                        ? Center(
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
                          ))
                        : Container()
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      "${practiceModel.attempts.toString()} Attempts",
                      style: _textStyle,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Mastery ${(practiceModel.mastery! * 100).toStringAsFixed(2)}%",
                      style: _textStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
