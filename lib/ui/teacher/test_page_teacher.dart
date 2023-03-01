import 'package:flutter/material.dart';

import 'package:idream/common/references.dart';
import 'package:idream/model/test_model.dart';
import 'package:idream/ui/teacher/subject_home_teacher.dart';
import 'package:idream/ui/teacher/utilities/selectstudentbottom_sheet.dart';

class TestPageTeacher extends StatefulWidget {
  final SubjectHomeTeacher? subjectHome;
  TestPageTeacher({this.subjectHome});

  @override
  _TestPageTeacherState createState() => _TestPageTeacherState();
}

class _TestPageTeacherState extends State<TestPageTeacher>
    with AutomaticKeepAliveClientMixin {
  Future fetchTestTopics() async {
    return assignmentRepository.fetchTestQuestions(widget.subjectHome!.subjectID,
        widget.subjectHome!.batch!, widget.subjectHome!.classId);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    List<TestModel> selectedTopic = [];
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 16.5,
              ),
              Container(
                height: 0.5,
                color: Color(0xFF6A6A6A),
              ),
              Expanded(
                child: FutureBuilder(
                  future: fetchTestTopics(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data != null) {
                        int? _chaptersCount = snapshot.data.length;
                        List<TestModel>? _testWidgetList = snapshot.data;
                        return ListView.builder(
                            itemCount: snapshot.data == null
                                ? 1
                                : snapshot.data.length,
                            padding: EdgeInsets.all(
                              16,
                            ),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (snapshot.data == null) {
                                return Center(
                                    child: Text(
                                  "No content available",
                                  style: TextStyle(
                                    color: Color(0xFF212121),
                                    fontWeight: FontWeight.values[5],
                                    fontSize: 15,
                                  ),
                                ));
                              }
                              return chapterTile(index, _testWidgetList![index],
                                  _chaptersCount, selectedTopic, false);
                            });
                      } else {
                        return Text("No data found");
                      }
                    } else
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: Color(0xFF3399FF),
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 15.0,
            right: 15.0,
            child: ElevatedButton(
                onPressed: () {
                  showAssignBottomSheet(
                    context,
                    "SubjectTest",
                    widget.subjectHome!.subjectID,
                    selectedTopic,
                    batchInfo: widget.subjectHome!.batch!,
                    subjectName: widget.subjectHome!.subjectName,
                    classNumber: widget.subjectHome!.classId,
                  );
                },
                child: Text(
                  "Select Students",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(primary: Color(0xff0070FF))))
      ],
    );
  }

  Widget chapterTile(int index, TestModel testModel, int? chaptersCount,
      List<TestModel> selectedTopic, bool check) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter _setState) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            _setState(() {
              if (check) {
                check = false;
                selectedTopic.remove(testModel);
              } else {
                check = true;
                selectedTopic.add(testModel);
              }
            });
          },
          child: Container(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
            color: check ? Color(0xffE8F2FF) : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(children: [
                        Text(
                          "${index < 9 ? "0" : ""}${index + 1}.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(widget.subjectHome!.subjectColor!),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Text(
                            testModel.tName!,
                            style: TextStyle(
                              color: Color(widget.subjectHome!.subjectColor!),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    check
                        ? Center(
                            child: Container(
                            decoration: BoxDecoration(
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
              ],
            ),
          ),
        ),
      );
    });
  }
}
