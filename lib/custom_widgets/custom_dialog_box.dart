import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/ui/subject_home/practice_pop_up.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class QuitPracticeWidget extends StatefulWidget {
  final String? title, descriptions, text;
  final Image? img;
  final PracticePopUpPageState? practicePopUpPageState;
  final String? appLevelLanguage;

  const QuitPracticeWidget(
      {Key? key,
      this.title,
      this.descriptions,
      this.text,
      this.img,
      this.practicePopUpPageState,
      this.appLevelLanguage})
      : super(key: key);

  @override
  _QuitPracticeWidgetState createState() => _QuitPracticeWidgetState();
}

class _QuitPracticeWidgetState extends State<QuitPracticeWidget> {
  bool _showLoader = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 400,
      ),
      child: ModalProgressHUD(
        dismissible: false,
        inAsyncCall: _showLoader,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          color: Colors.white,
          child: Image.asset(
            "assets/images/line.png",
            width: 40,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 29,
            horizontal: 37,
          ),
          // margin: EdgeInsets.only(top: 12),
          constraints: const BoxConstraints(
            minHeight: 325,
            minWidth: 287,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "assets/images/warning.png",
                height: 75,
                width: 75,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                (widget.appLevelLanguage == "hindi")
                    ? "क्या आप अभ्यास को मध्य में ही रोकना चाहते हैं?"
                    : "Closing Midway?",
                style: TextStyle(
                    color: const Color(0xFF212121),
                    fontSize: 16,
                    fontWeight: FontWeight.values[5]),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                (widget.appLevelLanguage == "hindi")
                    ? "केवल कुछ और प्रयास आपकी अध्याय की निपुणता काफी बेहतर बनाने में सहयोगी साबित होगी।"
                    : "Just a few more attempts shall improve your mastery on this topic",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              continueButton(),
              const SizedBox(
                height: 12,
              ),
              AbsorbPointer(
                absorbing: _showLoader,
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      _showLoader = true;
                    });
                    if ((widget.practicePopUpPageState!.correctQuestionIndexList
                                .length ==
                            int.parse(widget.practicePopUpPageState!.widget
                                .practiceModel!.streakCount!)) &&
                        (widget.practicePopUpPageState!.masteryPercentage! <
                            1)) {
                      widget.practicePopUpPageState!.currentLevel =
                          (widget.practicePopUpPageState!.currentLevel! + 1);
                    }

                    if (!usingIprepLibrary) {
                      await practiceRepository.saveUsersPracticeMastery(
                        widget
                            .practicePopUpPageState!
                            .widget
                            .practicePageWidget!
                            .subjectHome!
                            .subjectWidget!
                            .subjectName,
                        correctStreakCount: widget.practicePopUpPageState!
                            .widget.practiceModel!.streakCount,
                        topicID: widget.practicePopUpPageState!.widget
                            .practiceModel!.topicID!,
                        mastery:
                            widget.practicePopUpPageState!.masteryPercentage,
                        practiceStartTime:
                            widget.practicePopUpPageState!.practiceStartTime,
                        subjectID: widget
                            .practicePopUpPageState!
                            .widget
                            .practicePageWidget!
                            .subjectHome!
                            .subjectWidget!
                            .subjectID!,
                        topicLevel: widget.practicePopUpPageState!.currentLevel,
                        topicName: widget.practicePopUpPageState!.widget
                            .practiceModel!.tName,
                        batchId: widget.practicePopUpPageState!.widget.batchId,
                        teacherId:
                            widget.practicePopUpPageState!.widget.teacherId,
                        assignmentId:
                            widget.practicePopUpPageState!.widget.assignmentId,
                        assignmentIndex: widget
                            .practicePopUpPageState!.widget.assignmentIndex,
                        language:
                            widget.practicePopUpPageState!.widget.language,
                        classID:
                            widget.practicePopUpPageState!.widget.classNumber,
                        boardID: widget.practicePopUpPageState!.widget.boardId,
                      );
                    }
                    setState(() {
                      _showLoader = false;
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    (widget.appLevelLanguage == "hindi")
                        ? "अभ्यास को मध्य में ही रोक दें"
                        : "Close Anyway",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget continueButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 48,
            maxWidth: 210,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF0077FF),
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Center(
            child: Text(
              (widget.appLevelLanguage == "hindi")
                  ? "अभ्यास जारी रखें"
                  : "Continue Practice",
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontWeight: FontWeight.values[4],
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
