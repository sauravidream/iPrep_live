import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/custom_widgets/custom_dialog_box.dart';
import 'package:idream/custom_widgets/linear_percent_indicator.dart';
import 'package:idream/model/practice_model.dart';
import 'package:idream/model/practice_question_model.dart';
import 'package:idream/ui/subject_home/practice_page.dart';
import 'package:idream/ui/subject_home/practice_well_done_page.dart';
import 'package:idream/ui/subject_home/understand_mastery_bottom_sheet_page.dart';
import 'package:flutter/cupertino.dart';
import '../../common/global_variables.dart';

class PracticePopUpPage extends StatefulWidget {
  final PracticePage? practicePageWidget;
  final PracticeModel? practiceModel;
  final String? classNumber;
  final String? language;
  final String? batchId;
  final String? assignmentId;
  final String? assignmentIndex;
  final String? boardId;
  final String? teacherId;

  const PracticePopUpPage({
    Key? key,
    this.practicePageWidget,
    this.practiceModel,
    this.classNumber,
    this.language,
    this.batchId,
    this.assignmentId,
    this.assignmentIndex,
    this.boardId,
    this.teacherId,
  }) : super(key: key);

  @override
  PracticePopUpPageState createState() => PracticePopUpPageState();
}

class PracticePopUpPageState extends State<PracticePopUpPage> {
  Future fetchTotalQuestionsList() async {
    return await practiceRepository.fetchPracticeQuestions(
      widget.practiceModel!.topicID,
      classNumber: widget.classNumber,
      language: widget.language,
    );
  }

  late DateTime practiceStartTime;
  bool _nextQuestion = false;
  int? currentLevel;
  String? _selectedOptionText = "";
  String _selectedOption = "";
  bool _dataFetched = false;
  int _currentPageIndex = 0;
  List<List<PracticeQuestionModel>> _totalQuestionsList = [];
  bool _questionAnswered = false;

  List<int> correctQuestionIndexList = [];
  final List<int> _incorrectQuestionIndexList = [];
  double? masteryPercentage;

  bool _calculateMastery() {
    if (_totalQuestionsList[currentLevel!][_currentPageIndex].correctAnswer ==
        _selectedOptionText) {
      // if (int.parse(widget.practiceModel.streakCount) > 1 &&
      //     _correctQuestionIndexList.length >= 1) {
      //   if ((_currentPageIndex - _correctQuestionIndexList.last) != 1) {
      //     _correctQuestionIndexList.clear();
      //   }
      // }
      correctQuestionIndexList.add(_currentPageIndex);
      // _incorrectQuestionIndexList = [];
      return true;
    } else {
      _incorrectQuestionIndexList.add(_currentPageIndex);
      if (widget.practicePageWidget!.subjectHome!.subjectWidget!.subjectID ==
              "math" ||
          widget.practicePageWidget!.subjectHome!.subjectWidget!.subjectID ==
              "science") {
        if (correctQuestionIndexList.isNotEmpty) {
          correctQuestionIndexList.removeLast();
        }
      } else {
        correctQuestionIndexList.clear();
      }
      return false;
    }
  }

  _currentPageQuestion() {
    if (_totalQuestionsList.isNotEmpty &&
        currentLevel! < _totalQuestionsList.length) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${_totalQuestionsList[currentLevel!][_currentPageIndex].question}:",
            style: TextStyle(
              color: const Color(0xFF212121),
              fontWeight: FontWeight.values[4],
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _totalQuestionsList[currentLevel!][_currentPageIndex].questionImage !=
                  ''
              ? CachedNetworkImage(
                  // height: 100,width: 100,
                  imageUrl:
                      "${_totalQuestionsList[currentLevel!][_currentPageIndex].questionImage}",
                  // height: ScreenUtil()
                  //     .setSp(43, ),
                  // width: ScreenUtil()
                  //     .setSp(43, ),
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
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    size: 50,
                  ),
                )
              : const SizedBox(),
          if (_totalQuestionsList[currentLevel!][_currentPageIndex].option1 !=
              null)
            testOptionWidget(
                "a",
                _totalQuestionsList[currentLevel!][_currentPageIndex]
                    .option1!
                    .value,
                optionType: _totalQuestionsList[currentLevel!]
                        [_currentPageIndex]
                    .option1!
                    .type),
          if (_totalQuestionsList[currentLevel!][_currentPageIndex].option2 !=
              null)
            testOptionWidget(
                "b",
                _totalQuestionsList[currentLevel!][_currentPageIndex]
                    .option2!
                    .value,
                optionType: _totalQuestionsList[currentLevel!]
                        [_currentPageIndex]
                    .option2!
                    .type),
          if (_totalQuestionsList[currentLevel!][_currentPageIndex].option3 !=
              null)
            testOptionWidget(
                "c",
                _totalQuestionsList[currentLevel!][_currentPageIndex]
                    .option3!
                    .value,
                optionType: _totalQuestionsList[currentLevel!]
                        [_currentPageIndex]
                    .option3!
                    .type),
          if (_totalQuestionsList[currentLevel!][_currentPageIndex].option4 !=
              null)
            testOptionWidget(
                "d",
                _totalQuestionsList[currentLevel!][_currentPageIndex]
                    .option4!
                    .value,
                optionType: _totalQuestionsList[currentLevel!]
                        [_currentPageIndex]
                    .option4!
                    .type),
        ],
      );
    } else {
      return const Text("No data available.");
    }
  }

  Widget testSubmitButton() {
    return GestureDetector(
      onTap: () async {
        if (_selectedOption.isNotEmpty) {
          if (!_nextQuestion) {
            bool _answer = _calculateMastery();
            if (_answer) {
              if (correctQuestionIndexList.length ==
                  int.parse(widget.practiceModel!.streakCount!)) {
                if (currentLevel! <
                    (int.parse(widget.practiceModel!.levels!) - 1)) {
                  double _masteryDoubleValue = ((100 /
                          (int.parse(widget.practiceModel!.levels!))) *
                      ((correctQuestionIndexList.length /
                              int.parse(widget.practiceModel!.streakCount!)) +
                          currentLevel!) /
                      100);
                  masteryPercentage =
                      double.parse(_masteryDoubleValue.toStringAsFixed(2));
                } else {
                  if ((currentLevel! < (_totalQuestionsList.length - 1)) &&
                      (_currentPageIndex <
                          (_totalQuestionsList[currentLevel!].length - 1))) {
                    setState(() {
                      ++_currentPageIndex;
                      _questionAnswered = false;
                      _selectedOption = "";
                    });
                  } else {
                    currentLevel = (currentLevel! + 1);
                    masteryPercentage = 1;
                    if (!usingIprepLibrary) {
                      await practiceRepository.saveUsersPracticeMastery(
                        widget.practicePageWidget!.subjectHome!.subjectWidget!
                            .subjectName,
                        correctStreakCount: widget.practiceModel!.streakCount,
                        topicID: widget.practiceModel!.topicID!,
                        mastery: masteryPercentage,
                        practiceStartTime: practiceStartTime,
                        subjectID: widget.practicePageWidget!.subjectHome!
                            .subjectWidget!.subjectID!,
                        topicLevel: currentLevel,
                        topicName: widget.practiceModel!.tName,
                        batchId: widget.batchId,
                        assignmentId: widget.assignmentId,
                        assignmentIndex: widget.assignmentIndex,
                        language: widget.language,
                        classID: widget.classNumber,
                        boardID: widget.boardId,
                      );
                    }
                    String? _appLevelLanguage =
                        await getStringValuesSF('language');
                    if (!mounted) return;
                    await Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => PracticeWellDonePage(
                          topicName: widget.practiceModel!.tName,
                          appLevelLanguage: _appLevelLanguage,
                        ),
                      ),
                    );
                  }
                }
              } else {
                double _masteryDoubleValue =
                    ((100 / (int.parse(widget.practiceModel!.levels!))) *
                        ((correctQuestionIndexList.length /
                                int.parse(widget.practiceModel!.streakCount!)) +
                            currentLevel!) /
                        100);
                masteryPercentage =
                    double.parse(_masteryDoubleValue.toStringAsFixed(2));
                debugPrint(masteryPercentage.toString());
              }
            } else {
              double _masteryDoubleValue;
              if (widget.practicePageWidget!.subjectHome!.subjectWidget!
                          .subjectID ==
                      "math" ||
                  widget.practicePageWidget!.subjectHome!.subjectWidget!
                          .subjectID ==
                      "science") {
                _masteryDoubleValue =
                    ((100 / (int.parse(widget.practiceModel!.levels!))) *
                        ((correctQuestionIndexList.length /
                                int.parse(widget.practiceModel!.streakCount!)) +
                            currentLevel!) /
                        100);
              } else {
                _masteryDoubleValue =
                    (((100 / (int.parse(widget.practiceModel!.levels!))) *
                            currentLevel!) /
                        100);
              }
              masteryPercentage =
                  double.parse(_masteryDoubleValue.toStringAsFixed(2));
              if (_incorrectQuestionIndexList.length ==
                  int.parse(widget.practiceModel!.incorrectStreak!)) {
                if (currentLevel == 0) {
                  if (!usingIprepLibrary) {
                    await practiceRepository.saveUsersPracticeMastery(
                      widget.practicePageWidget?.subjectHome?.subjectWidget
                          ?.subjectName,
                      correctStreakCount: widget.practiceModel!.streakCount,
                      topicID: widget.practiceModel!.topicID!,
                      mastery: masteryPercentage,
                      practiceStartTime: practiceStartTime,
                      subjectID: widget.practicePageWidget!.subjectHome!
                          .subjectWidget!.subjectID!,
                      topicLevel: currentLevel,
                      topicName: widget.practiceModel!.tName,
                      batchId: widget.batchId,
                      assignmentId: widget.assignmentId,
                      assignmentIndex: widget.assignmentIndex,
                      language: widget.language,
                      classID: widget.classNumber,
                      boardID: widget.boardId,
                    );
                  }
                  await showLearnMoreBottomSheet(context: context);
                  Navigator.pop(context);
                  // await SnackbarMessages.showErrorSnackbar(context,
                  //     error:
                  //         "Please learn more before attempting this level of practice question.");
                  return;
                } else {
                  await showLevelDemotingWarningBottomSheet(context: context);
                  setState(() {
                    _nextQuestion = true;
                    currentLevel = currentLevel! - 1;
                  });
                  _incorrectQuestionIndexList.clear();
                  correctQuestionIndexList.clear();
                  //TODO: User has tried and got failed... Decrease the current level, keep mastery of that level but user has to clear the
                  // level and show message
                  // SnackbarMessages.showErrorSnackbar(context,
                  //     error:
                  //         "Demoting you to previous level and please clear this level before attempting next level practice question.");
                }
              }
            }
            setState(() {
              _nextQuestion = true;
            });
          } else {
            //I was working here
            _nextQuestion = false;
            if (correctQuestionIndexList.length ==
                int.parse(widget.practiceModel!.streakCount!)) {
              if (currentLevel! <
                  (int.parse(widget.practiceModel!.levels!) - 1)) {
                correctQuestionIndexList.clear();
                _incorrectQuestionIndexList.clear();
                currentLevel = (currentLevel! + 1);
                _currentPageIndex = 0;
                _selectedOption = "";
                _selectedOptionText = "";
              }
            } else {
              if (_currentPageIndex ==
                  _totalQuestionsList[currentLevel!].length - 1) {
                _currentPageIndex = 0;
              } else {
                ++_currentPageIndex;
              }
            }
            setState(() {
              _questionAnswered = false;
              _selectedOption = "";
              _selectedOptionText = "";
            });
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(
          top: 16,
          bottom: 4,
        ),
        constraints: const BoxConstraints(
          minHeight: 48,
          maxHeight: 48,
          maxWidth: 176,
        ),
        decoration: BoxDecoration(
          color: _selectedOption.isNotEmpty ? const Color(0xFF0077FF) : null,
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          border: Border.all(
            color: _selectedOption.isEmpty
                ? const Color(0xFF9E9E9E)
                : const Color(0xFF0077FF),
          ),
        ),
        child: Center(
          child: selectedAppLanguage!.toLowerCase() == 'hindi'
              ? Text(
                  _nextQuestion ? "अगला सवाल" : "उत्तर सबमिट करें",
                  style: TextStyle(
                    color: _selectedOption.isNotEmpty
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFF9E9E9E),
                    fontWeight: FontWeight.values[5],
                    fontSize: 14,
                  ),
                )
              : Text(
                  _nextQuestion ? "Next Question" : "Submit Answer",
                  style: TextStyle(
                    color: _selectedOption.isNotEmpty
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFF9E9E9E),
                    fontWeight: FontWeight.values[5],
                    fontSize: 14,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    masteryPercentage = widget.practiceModel!.mastery;
    currentLevel = widget.practiceModel!.masteryLevel ?? 0;
    practiceStartTime = DateTime.now();
    fetchTotalQuestionsList().then((value) async {
      if (value is List<List<PracticeQuestionModel>>) {
        value.forEach((element) => element.shuffle());
        _totalQuestionsList = value;
      }
      setState(() {
        _dataFetched = true;
      });
      if ((widget.practicePageWidget!.subjectHome!.subjectWidget!
                  .dashboardScreenState !=
              null) &&
          firstTimeLanded) {
        await showUnderstandMasteryBottomSheet(context: context);
        firstTimeLanded = false;
      } else {
        double _currentQuestionIndex1 =
            ((masteryPercentage! * int.parse(widget.practiceModel!.levels!)) -
                    currentLevel!) *
                int.parse(widget.practiceModel!.streakCount!);
        _currentPageIndex = _currentQuestionIndex1.round();
        for (int i = 0; i < _currentPageIndex; i++) {
          correctQuestionIndexList.add(i);
        }
        // _currentPageIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            return await (showQuitPracticeBottomSheet(
              context: context,
              practicePopUpPageState: this,
            ));
          },
          child: Scaffold(
            body: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(
                16,
              ),
              child: Stack(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            await showQuitPracticeBottomSheet(
                              context: context,
                              practicePopUpPageState: this,
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  right: 16,
                                ),
                                child: Image.asset(
                                  "assets/images/close.png",
                                  height: 13,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  widget.practiceModel!.tName!,
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
                        const SizedBox(
                          height: 20,
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: const Color(0xFF212121),
                              fontWeight: FontWeight.values[5],
                              fontSize: 12,
                              height: 1.8,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                            children: [
                              TextSpan(
                                text: 'Mastery ',
                                style: TextStyle(
                                  fontWeight: FontWeight.values[4],
                                ),
                              ),
                              TextSpan(
                                text: '${(masteryPercentage! * 100).floor()}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.values[5],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            SizedBox(
                              height: 20,
                              child: LinearPercentIndicator(
                                padding: const EdgeInsets.only(left: 3),
                                backgroundColor: const Color(0xFFD1E6FF),
                                percent: masteryPercentage!,
                                progressColor: const Color(0xFF0077FF),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      (MediaQuery.of(context).size.width - 32) *
                                          masteryPercentage!,
                                ),
                                child: Image.asset(
                                  "assets/images/single_star.png",
                                  width: 15,
                                  height: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        _dataFetched
                            ? _currentPageQuestion()
                            : const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  backgroundColor: Color(0xFF3399FF),
                                ),
                              ),
                        if (_nextQuestion &&
                            (_selectedOption.isNotEmpty &&
                                _totalQuestionsList[currentLevel!]
                                        [_currentPageIndex]
                                    .correctFeedback!
                                    .isNotEmpty))
                          feedbackWidget(),
                        if (_nextQuestion &&
                            (_selectedOption.isNotEmpty &&
                                _totalQuestionsList[currentLevel!]
                                            [_currentPageIndex]
                                        .feedbackImage !=
                                    null &&
                                _totalQuestionsList[currentLevel!]
                                            [_currentPageIndex]
                                        .feedbackImage !=
                                    ''))
                          imageFeedbackWidget(),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: testSubmitButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget testOptionWidget(String optionNumber, String? optionText,
      {String? optionType}) {
    _questionAnswered =
        (_selectedOption.isNotEmpty && _selectedOption == optionNumber);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 16,
          ),
          child: InkWell(
            onTap: () {
              if (!_nextQuestion) {
                setState(() {
                  _selectedOption =
                      (_selectedOption == optionNumber) ? "" : optionNumber;
                  _selectedOptionText =
                      (_selectedOptionText == optionText) ? "" : optionText;
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
                color: _questionAnswered
                    ? (!_nextQuestion
                        ? const Color(0xFFF3F9FF)
                        : ((_totalQuestionsList[currentLevel!]
                                        [_currentPageIndex]
                                    .correctAnswer ==
                                _selectedOptionText)
                            ? const Color(0xFFF8FFFD)
                            : const Color(0xFFFF7575).withOpacity(0.05)))
                    : const Color(0xFFFFFFFF),
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                border: Border.all(
                  color: _questionAnswered
                      ? (!_nextQuestion
                          ? const Color(0xFF0077FF)
                          : ((_totalQuestionsList[currentLevel!]
                                          [_currentPageIndex]
                                      .correctAnswer ==
                                  _selectedOptionText)
                              ? const Color(0xFF22C59B)
                              : const Color(0xFFFF7575)))
                      : const Color(0xFFDEDEDE),
                ),
              ),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                      right: 8,
                    ),
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      color: _questionAnswered
                          ? (!_nextQuestion
                              ? const Color(0xFF0077FF).withOpacity(0.1)
                              : ((_totalQuestionsList[currentLevel!]
                                                  [_currentPageIndex]
                                              .correctAnswer ==
                                          _selectedOptionText)
                                      ? const Color(0xFF22C59B)
                                      : const Color(0xFFFF7575))
                                  .withOpacity(0.1))
                          : Colors.grey.withOpacity(0.08),
                    ),
                    child: _questionAnswered && !_nextQuestion
                        ? Text(
                            optionNumber,
                            style: TextStyle(
                              color: const Color(0xFF0077FF),
                              fontWeight: FontWeight.values[4],
                              fontSize: 14,
                            ),
                          )
                        : ((_questionAnswered &&
                                _totalQuestionsList.isNotEmpty &&
                                (_totalQuestionsList[currentLevel!]
                                            [_currentPageIndex]
                                        .correctAnswer !=
                                    _selectedOptionText))
                            ? Image.asset("assets/images/red_cross_new.png")
                            : ((_questionAnswered &&
                                    _totalQuestionsList.isNotEmpty &&
                                    (_totalQuestionsList[currentLevel!]
                                                [_currentPageIndex]
                                            .correctAnswer ==
                                        _selectedOptionText))
                                ? Image.asset(
                                    "assets/images/correct_answer.png")
                                : Text(
                                    optionNumber,
                                    style: TextStyle(
                                      color: _questionAnswered
                                          ? const Color(0xFF0077FF)
                                          : const Color(0xFF212121),
                                      fontWeight: FontWeight.values[4],
                                      fontSize: 14,
                                    ),
                                  ))),
                  ),
                  Expanded(
                    child: Container(
                      child: ((optionType != null) &&
                              (optionType.toLowerCase() == 'text'))
                          ? Text(
                              optionText!,
                              style: TextStyle(
                                color: const Color(0xFF212121),
                                fontWeight: FontWeight.values[4],
                                fontSize: 14,
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: "$optionText",
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
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                                size: 50,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_questionAnswered && _nextQuestion)
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  margin: const EdgeInsets.only(
                    top: 8,
                  ),
                  width: (_totalQuestionsList[currentLevel!][_currentPageIndex]
                              .correctAnswer ==
                          _selectedOptionText)
                      ? 100
                      : 110,
                  alignment: Alignment.topCenter,
                  child: selectedAppLanguage!.toLowerCase() == 'hindi'
                      ? Text(
                          (_totalQuestionsList[currentLevel!][_currentPageIndex]
                                      .correctAnswer ==
                                  _selectedOptionText)
                              ? "सही उत्तर"
                              : "ग़लत उत्तर",
                          style: TextStyle(
                            color: (_totalQuestionsList[currentLevel!]
                                            [_currentPageIndex]
                                        .correctAnswer ==
                                    _selectedOptionText)
                                ? const Color(0xFF22C59B)
                                : const Color(0xFFFF7575),
                            fontSize: 12,
                            fontWeight: FontWeight.values[4],
                          ),
                        )
                      : Text(
                          (_totalQuestionsList[currentLevel!][_currentPageIndex]
                                      .correctAnswer ==
                                  _selectedOptionText)
                              ? "Correct Answer"
                              : "Incorrect Answer",
                          style: TextStyle(
                            color: (_totalQuestionsList[currentLevel!]
                                            [_currentPageIndex]
                                        .correctAnswer ==
                                    _selectedOptionText)
                                ? const Color(0xFF22C59B)
                                : const Color(0xFFFF7575),
                            fontSize: 12,
                            fontWeight: FontWeight.values[4],
                          ),
                        )),
            ),
          ),
      ],
    );
  }

  feedbackWidget() {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(
        top: 12,
      ),
      padding: const EdgeInsets.all(
        12,
      ),
      decoration: BoxDecoration(
        color: (_selectedOption
                .isNotEmpty /*_questionAnswered &&
                _totalQuestionsList[_currentLevel][_currentPageIndex]
                        .correctAnswer ==
                    _selectedOptionText*/
            )
            ? const Color(0xFFF3F9FF)
            : const Color(0xFFFFFFFF),
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(
          color: _questionAnswered
              ? const Color(0xFF0077FF)
              : const Color(0xFFDEDEDE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Feedback",
            style: TextStyle(
              color: (_selectedOption
                      .isNotEmpty /*_questionAnswered &&
                      _totalQuestionsList[_currentLevel][_currentPageIndex]
                              .correctAnswer ==
                          _selectedOptionText*/
                  )
                  ? const Color(0xFF0077FF)
                  : const Color(0xFF212121),
              fontWeight: FontWeight.values[4],
              fontSize: 10,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            _totalQuestionsList[currentLevel!][_currentPageIndex]
                .correctFeedback!,
            style: TextStyle(
              color: const Color(0xFF212121),
              fontWeight: FontWeight.values[4],
              fontSize: 12,
            ),
          ),
          // _totalQuestionsList[currentLevel!][_currentPageIndex]
          //     .correctFeedback!=''? CachedNetworkImage(
          //   imageUrl: _totalQuestionsList[currentLevel!][_currentPageIndex]
          //       .feedbackImage!,
          //   // height: ScreenUtil()
          //   //     .setSp(43, ),
          //   // width: ScreenUtil()
          //   //     .setSp(43, ),
          //   progressIndicatorBuilder:
          //       (context, url, downloadProgress) => Center(
          //     child: SizedBox(
          //       height: 25,
          //       width: 25,
          //       child: CircularProgressIndicator(
          //         value: downloadProgress.progress,
          //         strokeWidth: 0.5,
          //       ),
          //     ),
          //   ),
          //   errorWidget: (context, url, error) => const Icon(
          //     Icons.error,
          //     size: 50,
          //   ),
          // ):const SizedBox(),
        ],
      ),
    );
  }

  imageFeedbackWidget() {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(
        top: 12,
      ),
      padding: const EdgeInsets.all(
        12,
      ),
      decoration: BoxDecoration(
        color: (_selectedOption
                .isNotEmpty /*_questionAnswered &&
                _totalQuestionsList[_currentLevel][_currentPageIndex]
                        .correctAnswer ==
                    _selectedOptionText*/
            )
            ? const Color(0xFFF3F9FF)
            : const Color(0xFFFFFFFF),
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(
          color: _questionAnswered
              ? const Color(0xFF0077FF)
              : const Color(0xFFDEDEDE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Feedback",
            style: TextStyle(
              color: (_selectedOption
                      .isNotEmpty /*_questionAnswered &&
                      _totalQuestionsList[_currentLevel][_currentPageIndex]
                              .correctAnswer ==
                          _selectedOptionText*/
                  )
                  ? const Color(0xFF0077FF)
                  : const Color(0xFF212121),
              fontWeight: FontWeight.values[4],
              fontSize: 10,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CachedNetworkImage(
            imageUrl: _totalQuestionsList[currentLevel!][_currentPageIndex]
                .feedbackImage
                .toString(),
            // height: ScreenUtil()
            //     .setSp(43, ),
            // width: ScreenUtil()
            //     .setSp(43, ),
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
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}

Future showQuitPracticeBottomSheet({
  required BuildContext context,
  PracticePopUpPageState? practicePopUpPageState,
}) async {
  String? _appLevelLanguage = await getStringValuesSF("language");

  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        12,
      ),
    ),
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.white,
    builder: (builder) {
      return QuitPracticeWidget(
        practicePopUpPageState: practicePopUpPageState,
        appLevelLanguage: _appLevelLanguage,
      );
    },
  );
}

Future showUnderstandMasteryBottomSheet({
  required BuildContext context,
}) async {
  String? _appLevelLanguage = await getStringValuesSF('language');
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        12,
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (builder) {
      return UnderstandMasteryBottomSheetPage(
        appLevelLanguage: _appLevelLanguage,
      );
    },
  );
}

Future showLearnMoreBottomSheet({
  required BuildContext context,
}) async {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12), topRight: Radius.circular(12)),
    ),
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.white,
    builder: (builder) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 46),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 12.5,
            ),
            Image.asset(
              "assets/images/line.png",
              width: 40,
            ),
            const SizedBox(height: 20),
            Image.asset(
              "assets/images/warning.png",
              height: 75,
              width: 75,
            ),
            const SizedBox(
              height: 12.5,
            ),
            Text(
              "Oops!",
              style: TextStyle(
                  color: const Color(0xFF212121),
                  fontSize: 16,
                  fontWeight: FontWeight.values[5]),
            ),
            const SizedBox(
              height: 22,
            ),
            const Text(
              "You answered incorrect multiple times!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF212121),
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              "Please watch videos to help you perform better and come back again.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF212121),
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 48,
                    maxWidth: 214,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0077FF),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: Center(
                    child: Text(
                      "Okay, got it",
                      style: TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontWeight: FontWeight.values[4],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      );
    },
  );
}

Future showLevelDemotingWarningBottomSheet({
  required BuildContext context,
}) async {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12), topRight: Radius.circular(12)),
    ),
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.white,
    builder: (builder) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 46),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 12.5,
            ),
            Image.asset(
              "assets/images/line.png",
              width: 40,
            ),
            const SizedBox(height: 20),
            Image.asset(
              "assets/images/warning.png",
              height: 75,
              width: 75,
            ),
            const SizedBox(
              height: 12.5,
            ),
            Text(
              "Oops!",
              style: TextStyle(
                  color: const Color(0xFF212121),
                  fontSize: 16,
                  fontWeight: FontWeight.values[5]),
            ),
            const SizedBox(
              height: 22,
            ),
            const Text(
              "You answered incorrect multiple times!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF212121),
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              "We have reduced the difficulty level for you, please clear this level to move forward.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF212121),
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 48,
                    maxWidth: 214,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0077FF),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: Center(
                    child: Text(
                      "Okay, got it",
                      style: TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontWeight: FontWeight.values[4],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      );
    },
  );
}
