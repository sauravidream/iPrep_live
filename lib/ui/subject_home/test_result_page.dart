import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/ui/subject_home/review_test_page.dart';
import 'package:idream/ui/subject_home/test_pop_up_page.dart';

import '../../common/references.dart';
import '../../model/test_questions_model.dart';

class TestResultPage extends StatefulWidget {
  final TestPopUpPageState? testPopUpPageStatePage;
  final List<TestQuestionsAttemptedModel>? testQuestionsAttemptedModel;
  const TestResultPage(
      {Key? key, this.testPopUpPageStatePage, this.testQuestionsAttemptedModel})
      : super(key: key);

  @override
  State<TestResultPage> createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {
  Widget summaryRow(
      {String? imagePath, required String text, required String number}) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            color: const Color(0xFF212121),
            fontWeight: FontWeight.values[4],
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Image.asset("assets/images/$imagePath.png"),
            const SizedBox(
              width: 7,
            ),
            Text(
              text,
              style: TextStyle(
                color: const Color(0xFF9E9E9E),
                fontWeight: FontWeight.values[4],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget reviewTestButton(context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          Navigator.of(context).push(
            CupertinoPageRoute<void>(
                builder: (_) => ReviewTestPage(
                      testPopUpPageStatePage: widget.testPopUpPageStatePage,
                      testQuestionsAttemptedModel:
                          widget.testQuestionsAttemptedModel,
                    )),
          );
        },
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 48,
            maxWidth: 160,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0077FF),
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(
              color: const Color(0xFF0077FF),
            ),
          ),
          child: Center(
            child: Text(
              "Review Test",
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

  @override
  void initState() {
    super.initState();
    /*testRepository
        .fetchTestQuestions(widget.testPopUpPageStatePage!.widget
            .testPageWidget!.subjectHome!.subjectWidget!.subjectID)
        .then((value) {
      debugPrint(value.toString());
    });*/
  }

  @override
  Widget build(BuildContext context) {
    widget.testPopUpPageStatePage!.widget.testModel!.topicID;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/close.png",
                  height: 13,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder(
                    future: getStringValuesSF("fullName"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  snapshot.data,
                                  style: TextStyle(
                                      color: const Color(0xFF212121),
                                      fontSize: 16,
                                      fontWeight: FontWeight.values[5]),
                                ),
                                Flexible(
                                  child: Text(
                                    ", you have Scored",
                                    style: TextStyle(
                                        color: const Color(0xFF212121),
                                        fontSize: 16,
                                        fontWeight: FontWeight.values[4]),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }

                      return Container();
                    }),
                Container(
                  padding: const EdgeInsets.only(
                    left: 49,
                    top: 20,
                    right: 49,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: [
                          Image.asset(
                            "assets/images/test_complete.png",
                            height: 256,
                            width: double.maxFinite,
                            fit: BoxFit.fill,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: (256 - 140) / 2),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 160,
                                      maxWidth: 160,
                                    ),
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFfff5dc),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                    ),
                                    constraints: const BoxConstraints(
                                      minHeight: 120,
                                      maxWidth: 120,
                                    ),
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      top: 25,
                                    ),
                                    constraints: const BoxConstraints(
                                      minHeight: 110,
                                      maxWidth: 110,
                                    ),
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFfde6af),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 140 / 2),
                                    child: Text(
                                      "${((widget.testPopUpPageStatePage!.correctAnswerIndexList.length / widget.testPopUpPageStatePage!.totalQuestionsList.length) * 100).toStringAsFixed(1)} %",
                                      style: TextStyle(
                                        color: const Color(0xFFfb9e36),
                                        fontSize: 24,
                                        fontWeight: FontWeight.values[5],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      /* RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'This is your ',
                              style: TextStyle(
                                color: const Color(0xFF666666),
                                fontSize: 14,
                                fontWeight: FontWeight.values[4],
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${(widget.testPopUpPageStatePage!.widget.testModel!.testReports != null ? widget.testPopUpPageStatePage!.widget.testModel!.testReports!.length : 0) + 1}${getSuffix((widget.testPopUpPageStatePage!.widget.testModel!.testReports != null ? widget.testPopUpPageStatePage!.widget.testModel!.testReports!.length : 0) + 1)} attempt',
                              style: TextStyle(
                                color: const Color(0xFF212121),
                                fontSize: 14,
                                fontWeight: FontWeight.values[5],
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 5,
                      ),*/
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'You have spent ',
                              style: TextStyle(
                                color: const Color(0xFF666666),
                                fontSize: 14,
                                fontWeight: FontWeight.values[4],
                              ),
                            ),
                            if (Duration(
                                        seconds: widget.testPopUpPageStatePage!
                                            .stopwatch.elapsed.inSeconds)
                                    .inHours !=
                                0)
                              TextSpan(
                                text:
                                    '${Duration(seconds: widget.testPopUpPageStatePage!.stopwatch.elapsed.inSeconds).inHours} hours ',
                                style: TextStyle(
                                  color: const Color(0xFF212121),
                                  fontSize: 14,
                                  fontWeight: FontWeight.values[5],
                                ),
                              ),
                            if (Duration(
                                        seconds: widget.testPopUpPageStatePage!
                                            .stopwatch.elapsed.inSeconds)
                                    .inMinutes !=
                                0)
                              TextSpan(
                                text:
                                    '${Duration(seconds: widget.testPopUpPageStatePage!.stopwatch.elapsed.inSeconds).inMinutes} minutes ',
                                style: TextStyle(
                                  color: const Color(0xFF212121),
                                  fontSize: 14,
                                  fontWeight: FontWeight.values[5],
                                ),
                              ),
                            if (Duration(
                                        seconds: widget.testPopUpPageStatePage!
                                            .stopwatch.elapsed.inSeconds)
                                    .inSeconds
                                    .remainder(60) !=
                                0)
                              TextSpan(
                                text:
                                    '${Duration(seconds: widget.testPopUpPageStatePage!.stopwatch.elapsed.inSeconds).inSeconds.remainder(60)} seconds ',
                                style: TextStyle(
                                  color: const Color(0xFF212121),
                                  fontSize: 14,
                                  fontWeight: FontWeight.values[5],
                                ),
                              ),
                            TextSpan(
                              text: 'completing this test.',
                              style: TextStyle(
                                color: const Color(0xFF666666),
                                fontSize: 14,
                                fontWeight: FontWeight.values[4],
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            summaryRow(
                                imagePath: "correct_question",
                                number: widget.testPopUpPageStatePage!
                                    .correctAnswerIndexList.length
                                    .toString(),
                                text: "Correct"),
                            summaryRow(
                                imagePath: "incorrect_question",
                                number: widget.testPopUpPageStatePage!
                                    .incorrectAnswerIndexList.length
                                    .toString(),
                                text: "Incorrect"),
                            summaryRow(
                                imagePath: "unattempted",
                                number: widget.testPopUpPageStatePage!
                                    .skippedQuestionsIndexList.length
                                    .toString(),
                                text: "Unattempted"),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      reviewTestButton(context),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () async {
                          await Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => TestPopUpPage(
                                testModel: widget
                                    .testPopUpPageStatePage!.widget.testModel,
                                testPageWidget: widget.testPopUpPageStatePage!
                                    .widget.testPageWidget,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Retake Test",
                          style: TextStyle(
                              color: const Color(0xFF0077FF),
                              fontSize: 14,
                              fontWeight: FontWeight.values[4]),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Image.asset("assets/images/line_1.png"),
                    ],
                  ),
                ),
                if (widget.testPopUpPageStatePage!.widget.testModel!
                        .testReports !=
                    null)
                  const SizedBox(
                    height: 28,
                  ),
                if (widget.testPopUpPageStatePage!.widget.testModel!
                        .testReports !=
                    null)
                  Text(
                    "Previous Attempts",
                    style: TextStyle(
                        color: const Color(0xFF212121),
                        fontSize: 14,
                        fontWeight: FontWeight.values[5]),
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (widget.testPopUpPageStatePage!.widget.testModel!
                        .testReports !=
                    null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        previousAttemptsOption("Attempt"),
                        previousAttemptsOption("Correct"),
                        previousAttemptsOption("Incorrect"),
                        previousAttemptsOption("Unattempted"),
                        previousAttemptsOption("Marks"),
                      ],
                    ),
                  ),
                if (widget.testPopUpPageStatePage!.widget.testModel!
                        .testReports !=
                    null)
                  const SizedBox(
                    height: 10,
                  ),
                if (widget.testPopUpPageStatePage!.widget.testModel!
                        .testReports !=
                    null)
                  ListView.builder(
                      itemCount: widget.testPopUpPageStatePage!.widget
                          .testModel!.testReports!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        bool colorRow = (index % 2 == 0) ? true : false;
                        return Container(
                          color: colorRow ? const Color(0xFFECF5FF) : null,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                          ),
                          height: 38,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              previousAttemptsRowContent(
                                  "${index + 1}${getSuffix(index + 1)}"),
                              previousAttemptsRowContent(widget
                                  .testPopUpPageStatePage!
                                  .widget
                                  .testModel!
                                  .testReports![index]
                                  .correctCount!),
                              previousAttemptsRowContent(widget
                                  .testPopUpPageStatePage!
                                  .widget
                                  .testModel!
                                  .testReports![index]
                                  .incorrectCount!),
                              previousAttemptsRowContent(widget
                                  .testPopUpPageStatePage!
                                  .widget
                                  .testModel!
                                  .testReports![index]
                                  .unattemptedCount!),
                              previousAttemptsRowContent(
                                  "${widget.testPopUpPageStatePage!.widget.testModel!.testReports![index].marks} %"),
                            ],
                          ),
                        );
                      }),
                const SizedBox(
                  height: 76,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget previousAttemptsOption(String text) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: const Color(0xFF666666),
            fontSize: 12,
            fontWeight: FontWeight.values[4]),
      ),
    );
  }

  Widget previousAttemptsRowContent(String text) {
    return Expanded(
      flex: 1,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: const Color(0xFF212121),
            fontSize: 12,
            fontWeight: FontWeight.values[5]),
      ),
    );
  }

  getSuffix(int classNumber) {
    if (classNumber >= 11 && classNumber <= 13) {
      return "th";
    }
    switch (classNumber % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }
}

Widget startNewTestButton(BuildContext _context) {
  return Center(
    child: GestureDetector(
      onTap: () {
        Navigator.pop(_context);
      },
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 48,
          maxWidth: 248,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF0077FF),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Center(
          child: Text(
            "Start another Practice",
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
