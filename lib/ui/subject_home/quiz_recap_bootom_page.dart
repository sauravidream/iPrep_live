import 'package:flutter/material.dart';

import 'package:idream/ui/subject_home/test_pop_up_page.dart';

class QuizRecapBottomPage extends StatefulWidget {
  final TestPopUpPageState? testPopUpPageState;

  QuizRecapBottomPage({this.testPopUpPageState});

  @override
  _QuizRecapBottomPageState createState() => _QuizRecapBottomPageState();
}

class _QuizRecapBottomPageState extends State<QuizRecapBottomPage> {
  bool _displayQuestionView = false;

  Row summaryRow(
      {required int lineColor, required String text, required String number}) {
    return Row(
      children: [
        Container(
          color: Color(lineColor),
          child: const SizedBox(
            width: 2,
            height: 26,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  number,
                  style: TextStyle(
                    color: const Color(0xFF212121),
                    fontWeight: FontWeight.values[4],
                    fontSize: 12,
                  ),
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
        ),
      ],
    );
  }

  Container getClassWidget(int questionNumber,
      {required int borderColor, required int bgColor}) {
    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(
        minWidth: 45,
        minHeight: 45,
      ),
      decoration: BoxDecoration(
        color: Color(bgColor),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Color(borderColor)),
      ),
      child: Text(
        "${questionNumber < 10 ? 0 : ""}$questionNumber",
        style: const TextStyle(
          color: const Color(0xFF212121),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 20,
              ),
              child: Center(
                child: Image.asset(
                  "assets/images/line.png",
                  width: 40,
                ),
              ),
            ),
            Text(
              widget.testPopUpPageState!.widget.testModel!.tName!,
              style: TextStyle(
                color: const Color(0xFF212121),
                fontWeight: FontWeight.values[4],
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.testPopUpPageState!.totalQuestionsList.length} Questions",
                  // overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF9E9E9E),
                    fontWeight: FontWeight.values[4],
                    fontSize: 10,
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
                    Text(
                      "${Duration(seconds: widget.testPopUpPageState!.stopwatch.elapsed.inSeconds).inHours}:${Duration(seconds: widget.testPopUpPageState!.stopwatch.elapsed.inSeconds).inMinutes.remainder(60)}:${(Duration(seconds: widget.testPopUpPageState!.stopwatch.elapsed.inSeconds).inSeconds.remainder(60))}",
                      // '00:${snapshot.data}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFF6F6F),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  summaryRow(
                      lineColor: 0xFF0077FF,
                      number: (widget.testPopUpPageState!.correctAnswerIndexList
                                  .length +
                              widget.testPopUpPageState!
                                  .incorrectAnswerIndexList.length)
                          .toString(),
                      text: "Attempted"),
                  summaryRow(
                      lineColor: 0xFFFDC500,
                      number: (widget.testPopUpPageState!
                              .skippedQuestionsIndexList.length)
                          .toString(),
                      text: "Skipped"),
                  summaryRow(
                      lineColor: 0xFFC9C9C9,
                      number:
                          (widget.testPopUpPageState!.totalQuestionsList
                                      .length -
                                  (widget.testPopUpPageState!
                                          .correctAnswerIndexList.length +
                                      widget.testPopUpPageState!
                                          .incorrectAnswerIndexList.length +
                                      widget.testPopUpPageState!
                                          .skippedQuestionsIndexList.length))
                              .toString(),
                      text: "Yet to attempt"),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              color: const Color(0xFFDEDEDE),
              child: const SizedBox(
                width: double.maxFinite,
                height: 0.5,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All Questions",
                  style: TextStyle(
                    color: const Color(0xFF212121),
                    fontWeight: FontWeight.values[5],
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _displayQuestionView = !_displayQuestionView;
                    });
                  },
                  child: Image.asset(
                    "assets/images/${_displayQuestionView ? "four_square" : "3_lines"}.png",
                    height: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            _displayQuestionView ? questionList() : questionGrid(),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 30,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  width: size.width,
                  child: const Text(
                    "Resume Test",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0077ff),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GridView questionGrid() {
    return GridView.count(
      crossAxisCount: 6,
      shrinkWrap: true,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
          widget.testPopUpPageState!.totalQuestionsList.length, (index) {
        return GestureDetector(
          onTap: () async {
            widget.testPopUpPageState!.currentPageIndex = index;
            String _providedAnswer = widget
                .testPopUpPageState!.providedAnsweredList
                .elementAt(index);
            widget.testPopUpPageState!.setState(() {
              widget.testPopUpPageState!.selectedOption = _providedAnswer;
              widget.testPopUpPageState!.questionAnswered =
                  _providedAnswer.isNotEmpty ? true : false;
            });
            Navigator.pop(context);
          },
          child: getClassWidget(
            index + 1,
            borderColor:
                ((widget.testPopUpPageState!.providedAnsweredList.length - 1) >=
                        index
                    ? (widget.testPopUpPageState!.providedAnsweredList[index]
                            .isNotEmpty
                        ? 0xFF0077FF
                        : 0xFFFDC500)
                    : 0xFFC9C9C9),
            bgColor:
                ((widget.testPopUpPageState!.providedAnsweredList.length - 1) >=
                        index
                    ? (widget.testPopUpPageState!.providedAnsweredList[index]
                            .isNotEmpty
                        ? 0xFFECF5FF
                        : 0xFFFFF8DF)
                    : 0xFFF3F3F3),
          ),
        );
      }),
    );
  }

  Widget questionList() {
    return ListView.builder(
      itemCount: widget.testPopUpPageState!.totalQuestionsList.length,
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.testPopUpPageState!.currentPageIndex = index;
            String _providedAnswer = widget
                .testPopUpPageState!.providedAnsweredList
                .elementAt(index);
            widget.testPopUpPageState!.setState(() {
              widget.testPopUpPageState!.selectedOption = _providedAnswer;
              widget.testPopUpPageState!.questionAnswered =
                  _providedAnswer.isNotEmpty ? true : false;
            });
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(
              bottom: 9,
            ),
            padding: const EdgeInsets.all(
              14,
            ),
            decoration: BoxDecoration(
              color: Color(
                ((widget.testPopUpPageState!.providedAnsweredList.length - 1) >=
                        index
                    ? (widget.testPopUpPageState!.providedAnsweredList[index]
                            .isNotEmpty
                        ? 0xFFECF5FF
                        : 0xFFFFF8DF)
                    : 0xFFF3F3F3),
              ),
              border: Border.all(
                  color: Color(
                ((widget.testPopUpPageState!.providedAnsweredList.length - 1) >=
                        index
                    ? (widget.testPopUpPageState!.providedAnsweredList[index]
                            .isNotEmpty
                        ? 0xFF0077FF
                        : 0xFFFDC500)
                    : 0xFFC9C9C9),
              )),
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${index < 9 ? 0 : ""}${index + 1}.",
                  style: const TextStyle(
                    color: const Color(0xFF212121),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    widget.testPopUpPageState!.totalQuestionsList[index]
                        .question!,
                    style: const TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
