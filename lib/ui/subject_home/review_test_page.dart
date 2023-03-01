import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:idream/ui/subject_home/test_pop_up_page.dart';

import '../../model/test_questions_model.dart';

class ReviewTestPage extends StatefulWidget {
  final TestPopUpPageState? testPopUpPageStatePage;
  final List<TestQuestionsAttemptedModel>? testQuestionsAttemptedModel;
  const ReviewTestPage(
      {Key? key, this.testPopUpPageStatePage, this.testQuestionsAttemptedModel})
      : super(key: key);

  @override
  ReviewTestPageState createState() => ReviewTestPageState();
}

class ReviewTestPageState extends State<ReviewTestPage> {
  @override
  void initState() {
    super.initState();
  }

  int _currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.testQuestionsAttemptedModel!.toList().toString());
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                GestureDetector(
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
                                  width: 16,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.testPopUpPageStatePage!.widget
                                        .testModel!.tName!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0xFF212121),
                                      fontWeight: FontWeight.values[5],
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Question ${_currentQuestionIndex + 1} / ${widget.testPopUpPageStatePage!.totalQuestionsList.length}",
                          style: TextStyle(
                            color: const Color(0xFF666666),
                            fontWeight: FontWeight.values[4],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget
                            .testPopUpPageStatePage!
                            .totalQuestionsList[_currentQuestionIndex]
                            .question!,
                        style: TextStyle(
                          color: const Color(0xFF212121),
                          fontWeight: FontWeight.values[4],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (widget
                            .testPopUpPageStatePage!
                            .totalQuestionsList[_currentQuestionIndex]
                            .questionImage !=
                        '')
                      CachedNetworkImage(
                          imageUrl:
                              "${widget.testPopUpPageStatePage!.totalQuestionsList[_currentQuestionIndex].questionImage}",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                        strokeWidth: 0.5,
                                      ),
                                    ),
                                  ),
                          errorWidget: (context, url, error) {
                            return const Icon(
                              Icons.error,
                              size: 50,
                            );
                          }),
                    const SizedBox(
                      height: 20,
                    ),
                    testOptionWidget(
                        optionType: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .option1!
                            .type,
                        optionNumber: 'a',
                        optionText: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .option1!
                            .value
                            .toString(),
                        correctAnswer: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .correctAnswer,
                        userAnswer: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .userSelectedAnswer),
                    const SizedBox(
                      height: 10,
                    ),
                    testOptionWidget(
                        optionType: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .option1!
                            .type,
                        optionNumber: 'b',
                        optionText: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .option2!
                            .value
                            .toString(),
                        correctAnswer: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .correctAnswer,
                        userAnswer: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .userSelectedAnswer),
                    const SizedBox(
                      height: 10,
                    ),
                    testOptionWidget(
                        optionType: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .option1!
                            .type,
                        optionNumber: 'c',
                        optionText: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .option3!
                            .value
                            .toString(),
                        correctAnswer: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .correctAnswer,
                        userAnswer: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .userSelectedAnswer),
                    const SizedBox(
                      height: 10,
                    ),
                    testOptionWidget(
                        optionType: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .option1!
                            .type,
                        optionNumber: 'd',
                        optionText: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .option4!
                            .value
                            .toString(),
                        correctAnswer: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .correctAnswer,
                        userAnswer: widget
                            .testQuestionsAttemptedModel![_currentQuestionIndex]
                            .userSelectedAnswer),
                    const SizedBox(
                      height: 12,
                    ),
                    if (widget
                        .testPopUpPageStatePage!
                        .totalQuestionsList[_currentQuestionIndex]
                        .userResponse!
                        .isNotEmpty)
                      _feedbackWidget(),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  left: 16,
                  right: 16,
                ),
                child: SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_currentQuestionIndex > 0) {
                              setState(() {
                                _currentQuestionIndex--;
                              });
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            "assets/images/previous_question.png",
                            height: 34,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_currentQuestionIndex <
                              (widget.testPopUpPageStatePage!.totalQuestionsList
                                      .length -
                                  1)) {
                            setState(() {
                              _currentQuestionIndex++;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: RotationTransition(
                          turns: const AlwaysStoppedAnimation(180 / 360),
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Image.asset(
                              "assets/images/previous_question.png",
                              height: 34,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Stack testOptionWidget({
    required String optionNumber,
    required String optionText,
    required String? optionType,
    String? userAnswer,
    String? correctAnswer,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 7,
          ),
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 12,
              right: 12,
            ),
            constraints: const BoxConstraints(
              minHeight: 56,
            ),
            /* decoration: BoxDecoration(
              color: userAnswer == correctAnswer
                  ? userAnswer != optionText
                      ? Colors.grey.withOpacity(0.08)
                      : const Color(0xFF0077FF).withOpacity(0.1)
                  : userAnswer != optionText
                      ? Colors.grey.withOpacity(0.08)
                      : const Color(0xFF0077FF).withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              border: Border.all(
                color: optionText == correctAnswer
                    ? const Color(0xFF22C59B)
                    : optionText == userAnswer
                        ? const Color(0xFFFF7575)
                        : optionText != userAnswer
                            ? Colors.grey.withOpacity(0.08)
                            : Colors.black,
              ),
            ),*/
            decoration: BoxDecoration(
              color: optionText == correctAnswer
                  ? const Color(0xFF22C59B).withOpacity(.08)
                  : (optionText != correctAnswer) ==
                          (userAnswer == correctAnswer)
                      ? optionText == correctAnswer
                          ? const Color(0xFF22C59B).withOpacity(.08)
                          : optionText == correctAnswer
                              ? const Color(0xFFFF7575)
                              : Colors.white
                      : optionText == userAnswer
                          ? const Color(0xFFFF7575).withOpacity(.08)
                          : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              border: Border.all(
                color: optionText == correctAnswer
                    ? const Color(0xFF22C59B)
                    : (optionText != correctAnswer) ==
                            (userAnswer == correctAnswer)
                        ? optionText == correctAnswer
                            ? const Color(0xFF22C59B)
                            : optionText == correctAnswer
                                ? const Color(0xFFFF7575)
                                : Colors.grey
                        : optionText == userAnswer
                            ? const Color(0xFFFF7575)
                            : Colors.grey,
              ),
            ),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    right: 8,
                  ),
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    color: Colors.grey.withOpacity(0.08),
                  ),
                  child: Text(
                    optionNumber,
                    style: TextStyle(
                      color: const Color(0xFF212121),
                      fontWeight: FontWeight.values[4],
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: ((optionType != null) &&
                          (optionType.toLowerCase() == 'text'))
                      ? Text(
                          optionText,
                          style: TextStyle(
                            color: const Color(0xFF212121),
                            fontWeight: FontWeight.values[4],
                            fontSize: 14,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: optionText,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                        strokeWidth: 0.5,
                                      ),
                                    ),
                                  ),
                          errorWidget: (context, url, error) {
                            return const Icon(
                              Icons.error,
                              size: 50,
                            );
                          }),
                ),
              ],
            ),
          ),
        ),
        optionText == userAnswer
            ? Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: optionText != correctAnswer ? 73 : 92,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      optionText != correctAnswer
                          ? "Your Answer"
                          : "Correct Answer",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: optionText == correctAnswer
                            ? const Color(0xFF22C59B)
                            : optionText == userAnswer
                                ? const Color(0xFFFF7575)
                                : optionText != userAnswer
                                    ? Colors.grey.withOpacity(0.08)
                                    : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.values[4],
                      ),
                    ),
                  ),
                ),
              )
            : optionText != userAnswer
                ? Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: optionText != correctAnswer
                            ? optionText != userAnswer
                                ? 0
                                : 80
                            : 90,
                        color: Colors.white,
                        alignment: Alignment.topRight,
                        child: Text(
                          optionText != correctAnswer
                              ? optionText == userAnswer
                                  ? "Your Answer"
                                  : ""
                              : "Correct Answer",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: optionText == correctAnswer
                                ? const Color(0xFF22C59B)
                                : optionText == userAnswer
                                    ? const Color(0xFFFF7575)
                                    : optionText != userAnswer
                                        ? Colors.grey.withOpacity(0.08)
                                        : Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.values[4],
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
      ],
    );
  }

  Widget _testOptionWidget(
      {String? imageName,
      required String containerText,
      String? containerType,
      String? optionType}) {
    return Stack(
      children: [
        Container(
          width: double.maxFinite,
          margin: const EdgeInsets.only(
            top: 8,
          ),
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 16,
            left: 12,
            right: 12,
          ),
          constraints: const BoxConstraints(
            minHeight: 56,
          ),
          decoration: BoxDecoration(
            color: containerType == "correct"
                ? const Color(0xFFF8FFFD)
                : const Color(0xFFFF7575).withOpacity(0.04),
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(
              color: containerType == "correct"
                  ? const Color(0xFF22C59B)
                  : const Color(0xFFFF7575),
            ),
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/images/$imageName.png",
                height: 22,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  containerText,
                  style: TextStyle(
                    color: const Color(0xFF212121),
                    fontWeight: FontWeight.values[4],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 20,
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              width: optionType == "my" ? 80 : 100,
              color: Colors.white,
              alignment: Alignment.topRight,
              child: Text(
                optionType == "my" ? "Your Answer" : "Correct Answer",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: containerType == "correct"
                      ? const Color(0xFF22C59B)
                      : const Color(0xFFFF7575),
                  fontSize: 12,
                  fontWeight: FontWeight.values[4],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _feedbackWidget() {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(
        top: 12,
      ),
      padding: const EdgeInsets.all(
        12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F9FF),
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(
          color: const Color(0xFF0077FF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Feedback",
            style: TextStyle(
              color: const Color(0xFF0077FF),
              fontWeight: FontWeight.values[4],
              fontSize: 10,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            child: Text(
              widget
                      .testPopUpPageStatePage!
                      .totalQuestionsList[_currentQuestionIndex]
                      .correctFeedback!
                      .isEmpty
                  ? "${(widget.testPopUpPageStatePage!.totalQuestionsList[_currentQuestionIndex].userResponse == widget.testPopUpPageStatePage!.totalQuestionsList[_currentQuestionIndex].correctAnswer) ? "Correct Answer" : "Wrong Answer"}"
                  : widget
                      .testPopUpPageStatePage!
                      .totalQuestionsList[_currentQuestionIndex]
                      .correctFeedback!,
              style: TextStyle(
                color: const Color(0xFF212121),
                fontWeight: FontWeight.values[4],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
