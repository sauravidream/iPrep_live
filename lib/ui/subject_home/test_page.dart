import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/model/test_model.dart';
import 'package:idream/ui/subject_home/subject_home.dart';
import 'package:idream/ui/subject_home/test_instructions.dart';

import '../../common/global_variables.dart';

class TestPage extends StatefulWidget {
  final SubjectHome? subjectHome;
  const TestPage({Key? key, this.subjectHome}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with AutomaticKeepAliveClientMixin {
  Future fetchTestTopics() async {
    return testRepository
        .fetchTestQuestions(widget.subjectHome!.subjectWidget!.subjectID);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Container(
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
              future: fetchTestTopics(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    int? chaptersCount = snapshot.data.length;
                    List<TestModel>? testWidgetList = snapshot.data;
                    return ListView.builder(
                        itemCount:
                            snapshot.data == null ? 1 : snapshot.data.length,
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
                          return chapterTile(index, testWidgetList![index],
                              chaptersCount: chaptersCount);
                        });
                  } else {
                    return const Text("No data found");
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Color(0xFF3399FF),
                    ),
                    /*  Loader(),*/
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget chapterTile(int index, TestModel testModel, {chaptersCount}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => TestInstructionsPage(
                testModel: testModel,
                testPageWidget: widget,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${index < 9 ? "0" : ""}${index + 1}.",
                    style: TextStyle(
                      fontSize: selectedAppLanguage!.toLowerCase() == "english"
                          ? 15
                          : 16,
                      fontWeight: FontWeight.values[5],
                      color: Color(
                          widget.subjectHome!.subjectWidget!.subjectColor!),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      testModel.tName!,
                      style: TextStyle(
                        color: Color(
                            widget.subjectHome!.subjectWidget!.subjectColor!),
                        fontSize:
                            selectedAppLanguage!.toLowerCase() == "english"
                                ? 15
                                : 16,
                        fontWeight: FontWeight.values[5],
                      ),
                    ),
                  ),
                ],
              ),
              //TODO: Commenting out this section due unavailability of data
              // SizedBox(
              //   height: ScreenUtil().setSp(8, ),
              // ),
              // Text(
              //   "65 Questions",
              //   textAlign: TextAlign.start,
              //   style: _textStyle,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
