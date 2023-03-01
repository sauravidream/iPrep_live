import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/model/test_model.dart';
import 'package:idream/model/test_question_model.dart';
import 'package:idream/ui/subject_home/quiz_recap_bootom_page.dart';
import 'package:idream/ui/subject_home/test_page.dart';
import 'package:idream/ui/subject_home/test_result_page.dart';

import '../../common/global_variables.dart';
import '../../model/test_questions_model.dart';

class TestPopUpPage extends StatefulWidget {
  final TestPage? testPageWidget;
  final TestModel? testModel;

  const TestPopUpPage({
    Key? key,
    this.testPageWidget,
    this.testModel,
  }) : super(key: key);

  @override
  TestPopUpPageState createState() => TestPopUpPageState();
}

class TestPopUpPageState extends State<TestPopUpPage>
    with SingleTickerProviderStateMixin {
  Future fetchTotalQuestionsList() async {
    return await testRepository
        .fetchTotalTestQuestions(widget.testModel!.topicID);
  }

  final GlobalKey<AnimatedListState> animatedListKey =
      GlobalKey<AnimatedListState>();

  List<int> correctAnswerIndexList = [];
  List<int> incorrectAnswerIndexList = [];
  List<int> skippedQuestionsIndexList = [];
  List<String> providedAnsweredList = [];
  List initialItemCount = [];

  String selectedOption = "";
  int currentPageIndex = 0;
  List<TestQuestionModel> totalQuestionsList = [];
  List<TestQuestionsAttemptedModel> testQuestionsAttemptedModel = [];
  bool questionAnswered = false;
  bool _dataFetched = false;

  Tween<Offset> offset =
      Tween(begin: const Offset(1, 0), end: const Offset(0, 0));

  _currentPageQuestion() {
    if (totalQuestionsList.isNotEmpty) {
      if (currentPageIndex > (totalQuestionsList.length - 1)) {
        currentPageIndex = totalQuestionsList.length - 1;
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          testQuestionWidget(),
          AnimatedList(
            shrinkWrap: true,
            initialItemCount: 4,
            key: animatedListKey,
            itemBuilder: (context, index, animation) {
              return SlideTransition(
                  position: animation.drive(offset),
                  child: testOptionWidget(
                      index == 0
                          ? "a"
                          : index == 1
                              ? "b"
                              : index == 2
                                  ? "c"
                                  : "d",
                      index == 0
                          ? totalQuestionsList[currentPageIndex]
                              .option1!
                              .value
                              .toString()
                          : index == 1
                              ? totalQuestionsList[currentPageIndex]
                                  .option2!
                                  .value
                                  .toString()
                              : index == 2
                                  ? totalQuestionsList[currentPageIndex]
                                      .option3!
                                      .value
                                      .toString()
                                  : totalQuestionsList[currentPageIndex]
                                      .option4!
                                      .value
                                      .toString(),
                      optionType: index == 0
                          ? totalQuestionsList[currentPageIndex].option1!.type
                          : index == 1
                              ? totalQuestionsList[currentPageIndex]
                                  .option2!
                                  .type
                              : index == 2
                                  ? totalQuestionsList[currentPageIndex]
                                      .option3!
                                      .type
                                  : totalQuestionsList[currentPageIndex]
                                      .option4!
                                      .type));
            },
          ),
        ],
      );
    } else {
      return const Text("No data available.");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTotalQuestionsList().then((value) {
      if (value is List<TestQuestionModel>) {
        totalQuestionsList = value;
        if (totalQuestionsList.isNotEmpty) {
          _stream();
          stopwatch.start();
        }
      }
      setState(() {
        _dataFetched = true;
      });
    });
  }

  Stopwatch stopwatch = Stopwatch();

  Stream<int>? stream;
  Stream<int>? _stream() {
    Duration interval = const Duration(seconds: 1);
    stream = Stream<int>.periodic(interval, transform);
    return stream;
  }

  int transform(int value) {
    return stopwatch.elapsed.inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _dataFetched
            ? Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 20),
                      child: Column(
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
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // showDialog(
                                          //     context: context,
                                          //     builder: (BuildContext context) {
                                          //       return CustomDialogBox();
                                          //     });
                                        },
                                        icon: Image.asset(
                                          "assets/images/close.png",
                                          height: 13,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.testModel!.tName!,
                                          // overflow: TextOverflow.ellipsis,
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
                                const Expanded(
                                  flex: 1,
                                  /* child: GestureDetector(
                                    onTap: () async {
                                      if ((totalQuestionsList.isNotEmpty)) {
                                        stopwatch.stop();
                                      }
                                      await showQuizRecapBottomSheet(
                                          context: context);

                                      if ((totalQuestionsList.isNotEmpty)) {
                                        stopwatch.start();
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Image.asset(
                                        "assets/images/3_dot_black.png",
                                        height: 24,
                                      ),
                                    ),
                                  ),*/

                                  child: SizedBox(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Question ${((currentPageIndex + 1) > totalQuestionsList.length ? totalQuestionsList.length : (currentPageIndex + 1))} / ${totalQuestionsList.length}",
                                style: TextStyle(
                                  color: const Color(0xFF666666),
                                  fontWeight: FontWeight.values[4],
                                  fontSize: 12,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      "assets/images/stopwatch.png",
                                      height: 24,
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: stream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return const Text(
                                            '00:00:00',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFFFF6F6F),
                                            ),
                                          );
                                        case ConnectionState.active:
                                          Duration duration =
                                              Duration(seconds: snapshot.data);
                                          return Text(
                                            "${duration.inHours}:${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}",
                                            // '00:${snapshot.data}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFFFF6F6F),
                                            ),
                                          );
                                        case ConnectionState.none:
                                          // TODO: Handle this case.
                                          break;
                                        case ConnectionState.done:
                                          // TODO: Handle this case.
                                          break;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          _dataFetched
                              ? _currentPageQuestion()
                              : const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    backgroundColor: Color(0xFF3399FF),
                                  ),
                                  /*  Loader(),*/
                                ),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (totalQuestionsList.isNotEmpty)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          left: 16,
                          right: 16,
                        ),
                        child: SizedBox(
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  previousButtonTapEvent();
                                },
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Image.asset(
                                    "assets/images/previous_question.png",
                                    height: 34,
                                  ),
                                ),
                              ),
                              testSubmitButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Color(0xFF3399FF),
                ),
                /*  Loader(),*/
              ),
      ),
      /*),*/
    );
  }

  previousButtonTapEvent() {
    if (currentPageIndex != 0) {
      currentPageIndex = currentPageIndex - 1;
      String _providedAnswer = providedAnsweredList.elementAt(currentPageIndex);
      setState(() {
        selectedOption = _providedAnswer;
        questionAnswered = _providedAnswer.isNotEmpty ? true : false;
      });
    }
  }

  Widget testSubmitButton() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          if (correctAnswerIndexList.contains(currentPageIndex)) {
            correctAnswerIndexList.remove(currentPageIndex);
            providedAnsweredList.removeAt(currentPageIndex);
          } else if (incorrectAnswerIndexList.contains(currentPageIndex)) {
            incorrectAnswerIndexList.remove(currentPageIndex);
            providedAnsweredList.removeAt(currentPageIndex);
          } else if (skippedQuestionsIndexList.contains(currentPageIndex)) {
            skippedQuestionsIndexList.remove(currentPageIndex);
            providedAnsweredList.removeAt(currentPageIndex);
          }

          providedAnsweredList.insert(currentPageIndex, "");

          skippedQuestionsIndexList.add(currentPageIndex);
          if (currentPageIndex < (totalQuestionsList.length - 1)) {
            setState(() {
              if ((providedAnsweredList.length - 1) > currentPageIndex) {
                currentPageIndex = providedAnsweredList.length;
              } else {
                ++currentPageIndex;
              }
              questionAnswered = false;
              selectedOption = "";
            });
          } else {
            await showTestSubmitBottomSheet(
                context: context,
                testQuestionsAttemptedModel: testQuestionsAttemptedModel);
          }

          List optionsList = [
            Option.fromJson(
                totalQuestionsList[currentPageIndex].option1!.toJson()),
            Option.fromJson(
                totalQuestionsList[currentPageIndex].option2!.toJson()),
            Option.fromJson(
                totalQuestionsList[currentPageIndex].option3!.toJson()),
            Option.fromJson(
                totalQuestionsList[currentPageIndex].option4!.toJson()),
          ];

          testQuestionsAttemptedModel.add(
            TestQuestionsAttemptedModel(
              option1: optionsList[0],
              option3: optionsList[1],
              option2: optionsList[2],
              option4: optionsList[3],
              feedbackImage: totalQuestionsList[currentPageIndex].feedbackImage,
              correctFeedback:
                  totalQuestionsList[currentPageIndex].correctFeedback,
              incorrectFeedback:
                  totalQuestionsList[currentPageIndex].incorrectFeedback,
              questionImage: totalQuestionsList[currentPageIndex].questionImage,
              userResponse: totalQuestionsList[currentPageIndex].userResponse,
              questionID: totalQuestionsList[currentPageIndex].questionID,
              question: totalQuestionsList[currentPageIndex].question,
              correctAnswer: totalQuestionsList[currentPageIndex].correctAnswer,
              userUnSelectedAnswerIndex: currentPageIndex,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(
            top: 16,
            bottom: 20,
          ),
          constraints: const BoxConstraints(
            minHeight: 48,
            maxWidth: 168,
          ),
          decoration: BoxDecoration(
            color: (currentPageIndex == (totalQuestionsList.length - 1))
                ? const Color(0xFF0077FF)
                : null,
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(
              color: (currentPageIndex == (totalQuestionsList.length - 1))
                  ? const Color(0xFF0077FF)
                  : const Color(0xFF9E9E9E),
            ),
          ),
          child: Center(
            child: Text(
              (currentPageIndex == (totalQuestionsList.length - 1))
                  ? selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "सबमिट करें"
                      : "Submit Test"
                  : selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "स्किप करेंं"
                      : "Skip Question",
              style: TextStyle(
                color: (currentPageIndex == (totalQuestionsList.length - 1))
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF9E9E9E),
                fontWeight: FontWeight.values[4],
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding testOptionWidget(String optionNumber, String optionText,
      {required String? optionType}) {
    questionAnswered = (selectedOption.isNotEmpty &&
        selectedOption == optionText /*optionNumber*/);
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
      ),
      child: GestureDetector(
        onTap: () async {
          setState(() {
            selectedOption = (selectedOption == optionText) ? "" : optionText;
          });

          ///  TODO: Add Questions for reView

          List optionsList = [
            Option.fromJson(
                totalQuestionsList[currentPageIndex].option1!.toJson()),
            Option.fromJson(
                totalQuestionsList[currentPageIndex].option2!.toJson()),
            Option.fromJson(
                totalQuestionsList[currentPageIndex].option3!.toJson()),
            Option.fromJson(
                totalQuestionsList[currentPageIndex].option4!.toJson()),
          ];

          if (testQuestionsAttemptedModel.isNotEmpty &&
              testQuestionsAttemptedModel.length > currentPageIndex) {
            if (testQuestionsAttemptedModel[currentPageIndex].questionID ==
                testQuestionsAttemptedModel[currentPageIndex].questionID) {
              testQuestionsAttemptedModel[currentPageIndex] =
                  TestQuestionsAttemptedModel(
                option1: optionsList[0],
                option3: optionsList[1],
                option2: optionsList[2],
                option4: optionsList[3],
                feedbackImage:
                    totalQuestionsList[currentPageIndex].feedbackImage,
                correctFeedback:
                    totalQuestionsList[currentPageIndex].correctFeedback,
                incorrectFeedback:
                    totalQuestionsList[currentPageIndex].incorrectFeedback,
                questionImage:
                    totalQuestionsList[currentPageIndex].questionImage,
                userResponse: totalQuestionsList[currentPageIndex].userResponse,
                questionID: totalQuestionsList[currentPageIndex].questionID,
                question: totalQuestionsList[currentPageIndex].question,
                correctAnswer:
                    totalQuestionsList[currentPageIndex].correctAnswer,
                userSelectedAnswer: optionText,
                // userUnSelectedAnswerIndex: ,
              );
            } else {
              testQuestionsAttemptedModel.add(
                TestQuestionsAttemptedModel(
                  option1: optionsList[0],
                  option3: optionsList[1],
                  option2: optionsList[2],
                  option4: optionsList[3],
                  feedbackImage:
                      totalQuestionsList[currentPageIndex].feedbackImage,
                  correctFeedback:
                      totalQuestionsList[currentPageIndex].correctFeedback,
                  incorrectFeedback:
                      totalQuestionsList[currentPageIndex].incorrectFeedback,
                  questionImage:
                      totalQuestionsList[currentPageIndex].questionImage,
                  userResponse:
                      totalQuestionsList[currentPageIndex].userResponse,
                  questionID: totalQuestionsList[currentPageIndex].questionID,
                  question: totalQuestionsList[currentPageIndex].question,
                  correctAnswer:
                      totalQuestionsList[currentPageIndex].correctAnswer,
                  userSelectedAnswer: optionText,
                  // userUnSelectedAnswerIndex: ,
                ),
              );
            }
          } else {
            testQuestionsAttemptedModel.add(
              TestQuestionsAttemptedModel(
                option1: optionsList[0],
                option3: optionsList[1],
                option2: optionsList[2],
                option4: optionsList[3],
                feedbackImage:
                    totalQuestionsList[currentPageIndex].feedbackImage,
                correctFeedback:
                    totalQuestionsList[currentPageIndex].correctFeedback,
                incorrectFeedback:
                    totalQuestionsList[currentPageIndex].incorrectFeedback,
                questionImage:
                    totalQuestionsList[currentPageIndex].questionImage,
                userResponse: totalQuestionsList[currentPageIndex].userResponse,
                questionID: totalQuestionsList[currentPageIndex].questionID,
                question: totalQuestionsList[currentPageIndex].question,
                correctAnswer:
                    totalQuestionsList[currentPageIndex].correctAnswer,
                userSelectedAnswer: optionText,
                // userUnSelectedAnswerIndex: ,
              ),
            );
          }

          if (selectedOption.isNotEmpty) {
            if ((providedAnsweredList.length - 1) >= currentPageIndex) {
              providedAnsweredList.removeAt(currentPageIndex);
            }
            providedAnsweredList.insert(currentPageIndex, optionText);

            if (correctAnswerIndexList.contains(currentPageIndex)) {
              correctAnswerIndexList.remove(currentPageIndex);
            } else if (incorrectAnswerIndexList.contains(currentPageIndex)) {
              incorrectAnswerIndexList.remove(currentPageIndex);
            } else {
              skippedQuestionsIndexList.remove(currentPageIndex);
            }

            if (totalQuestionsList[currentPageIndex].correctAnswer ==
                optionText) {
              correctAnswerIndexList.add(currentPageIndex);
            } else {
              incorrectAnswerIndexList.add(currentPageIndex);
            }
            Future.delayed(const Duration(milliseconds: 100), () async {
              if (currentPageIndex < (totalQuestionsList.length - 1)) {
                setState(() {
                  if ((providedAnsweredList.length - 1) > currentPageIndex) {
                    currentPageIndex = providedAnsweredList.length;
                  } else {
                    ++currentPageIndex;
                  }
                  questionAnswered = false;
                  selectedOption = "";
                });
              } else {
                await showTestSubmitBottomSheet(
                    context: context,
                    testQuestionsAttemptedModel: testQuestionsAttemptedModel);
              }
            });
          }
        },
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
          decoration: BoxDecoration(
            color: questionAnswered
                ? const Color(0xFFF3F9FF)
                : const Color(0xFFFFFFFF),
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(
              color: questionAnswered
                  ? const Color(0xFF0077FF)
                  : const Color(0xFFDEDEDE),
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
                  color: questionAnswered
                      ? const Color(0xFF0077FF).withOpacity(0.1)
                      : Colors.grey.withOpacity(0.08),
                ),
                child: Text(
                  optionNumber,
                  style: TextStyle(
                    color: questionAnswered
                        ? const Color(0xFF0077FF)
                        : const Color(0xFF212121),
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
    );
  }

  Widget testQuestionWidget() {
    return Column(
      children: [
        Text(
          "${totalQuestionsList[currentPageIndex].question}:",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: const Color(0xFF212121),
            fontWeight: FontWeight.values[4],
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        totalQuestionsList[currentPageIndex].questionImage != ''
            ? CachedNetworkImage(
                imageUrl:
                    "${totalQuestionsList[currentPageIndex].questionImage}",
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
                errorWidget: (context, url, error) {
                  return const Icon(
                    Icons.error,
                    size: 50,
                  );
                })
            : const SizedBox(),
      ],
    );
  }

  Widget finalTestSubmitButton() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          stopwatch.stop();
          Navigator.pop(context);
          await testRepository.saveUsersTestReport(
            testPopUpPageStatePageWidget: this,
          );
          if (!mounted) return;
          await Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => TestResultPage(
                testPopUpPageStatePage: this,
                testQuestionsAttemptedModel: testQuestionsAttemptedModel,
              ),
            ),
          );
        },
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 48,
            maxWidth: 130,
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
              selectedAppLanguage!.toLowerCase() == "hindi"
                  ? "जमा करें"
                  : "Submit",
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

  Future showTestSubmitBottomSheet(
      {required BuildContext context,
      List<String>? chapterList,
      int? subjectColor,
      required List<TestQuestionsAttemptedModel> testQuestionsAttemptedModel}) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      builder: (builder) {
        return Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 20,
                ),
                child: Image.asset(
                  "assets/images/line.png",
                  width: 40,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child: Image.asset(
                  "assets/images/file.png",
                  height: 76,
                ),
              ),
              Text(
                selectedAppLanguage!.toLowerCase() == "hindi"
                    ? "परीक्षण जमा करें?"
                    : "Submit Test?",
                style: TextStyle(
                  color: const Color(0xFF212121),
                  fontWeight: FontWeight.values[5],
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              selectedAppLanguage!.toLowerCase() == "hindi"
                  ? Text(
                      "Hey ${appUser!.fullName ?? ""}, क्या आप वाकई इस परीक्षा को समाप्त करना चाहते हैं?",
                      style: TextStyle(
                        color: const Color(0xFF212121),
                        fontWeight: FontWeight.values[4],
                        fontSize: 12,
                      ),
                    )
                  : Text(
                      "Hey ${appUser!.fullName ?? ""}, are you sure you want to finish this test?",
                      style: TextStyle(
                        color: const Color(0xFF212121),
                        fontWeight: FontWeight.values[4],
                        fontSize: 12,
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              finalTestSubmitButton(),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "रद्द करें?"
                      : "Cancel",
                  style: TextStyle(
                    color: const Color(0xFF9E9E9E),
                    fontWeight: FontWeight.values[4],
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        );
      },
    );
  }

  Future showQuizRecapBottomSheet({
    required BuildContext context,
    List<String>? chapterList,
    int? subjectColor,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      isScrollControlled: true,
      builder: (builder) {
        return QuizRecapBottomPage(
          testPopUpPageState: this,
        );
      },
    );
  }
}
