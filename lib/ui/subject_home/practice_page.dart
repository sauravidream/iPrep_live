import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:idream/common/constants.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/custom_pop_up.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/model/practice_model.dart';
import 'package:idream/repository/in_app.dart';
import 'package:idream/ui/menu/upgrade_plan_page.dart';
import 'package:idream/ui/subject_home/practice_pop_up.dart';
import 'package:idream/ui/subject_home/subject_home.dart';

import '../../subscription/andriod/android_subscription.dart';

class PracticePage extends StatefulWidget {
  final SubjectHome? subjectHome;
  const PracticePage({Key? key, this.subjectHome}) : super(key: key);

  @override
  _PracticePageState createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage>
    with AutomaticKeepAliveClientMixin {
  Future fetchPracticeTopics() async {
    return practiceRepository
        .fetchPracticeTopicList(widget.subjectHome!.subjectWidget!.subjectID);
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
            color: const Color(0xFFC9C9C9),
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
                          return chapterTile(index, _practiceModel![index],
                              chaptersCount: _chaptersCount);
                        });
                  } else {
                    return Center(
                        child: Text(
                      "No data found",
                      style: Constants.noDataTextStyle,
                    ));
                  }
                } else {
                  return const Center(
                    child:
                        /*  Loader()*/
                        CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Color(0xFF3399FF),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget chapterTile(int index, PracticeModel practiceModel, {chaptersCount}) {
    TextStyle _textStyle = const TextStyle(
      color: Color(0xFF9E9E9E),
      fontSize: 12,
    );
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          if (restrictUser && (index > 1)) {
            var _response = await planExpiryPopUpForStudent(context);
            if ((_response != null) && (_response == "Yes")) {
              await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => Platform.isAndroid
                      ? const AndroidSubscriptionPlan()
                      : const UpgradePlan(),
                ),
              );
            }
          } else {
            if (int.parse(practiceModel.levels!) !=
                practiceModel.masteryLevel) {
              await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => PracticePopUpPage(
                    practicePageWidget: widget,
                    practiceModel: practiceModel,
                  ),
                ),
              );
              setState(() {});
            } else {
              SnackbarMessages.showErrorSnackbar(context,
                  error: Constants.masteryCompletionAlert);
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 10, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Text(
                  "${index < 9 ? "0" : ""}${index + 1}.",
                  style: TextStyle(
                    fontSize: selectedAppLanguage!.toLowerCase() == "english"
                        ? 15
                        : 16,
                    fontWeight: FontWeight.values[5],
                    color:
                        Color(widget.subjectHome!.subjectWidget!.subjectColor!),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      practiceModel.tName ?? '',
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
                    const SizedBox(
                      height: 8,
                    ),
                    if (!usingIprepLibrary)
                      Row(
                        children: [
                          Text(
                            "${practiceModel.attempts.toString()} Attempt${(practiceModel.attempts! < 2) ? "" : "s"}",
                            style: _textStyle,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Mastery ${(practiceModel.mastery! * 100).floor()}%",
                            style: _textStyle,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
