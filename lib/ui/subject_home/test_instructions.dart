import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idream/model/test_model.dart';
import 'package:idream/ui/subject_home/test_page.dart';
import 'package:idream/ui/subject_home/test_pop_up_page.dart';

import '../../common/global_variables.dart';

class TestInstructionsPage extends StatefulWidget {
  final TestPage? testPageWidget;
  final TestModel? testModel;

  const TestInstructionsPage({
    Key? key,
    this.testPageWidget,
    this.testModel,
  }) : super(key: key);

  @override
  _TestInstructionsPageState createState() => _TestInstructionsPageState();
}

class _TestInstructionsPageState extends State<TestInstructionsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(
              16,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedAppLanguage!.toLowerCase() == "hindi"
                            ? "परीक्षण निर्देश"
                            : "Test Instructions",
                        style: TextStyle(
                          color: const Color(0xFF212121),
                          fontWeight: FontWeight.values[5],
                          fontSize: 16,
                          fontFamily: GoogleFonts.lato().fontFamily,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          "assets/images/close.png",
                          height: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  testRow(
                    indexNumber: 1,
                    instruction: selectedAppLanguage!.toLowerCase() == "hindi"
                        ? "कृपया परीक्षण निर्देशों को पढ़ें और समझें ताकि आप आसानी से परीक्षण के माध्यम से नेविगेट कर सकें। "
                        : "Please read and understand the Test instructions so that you will be able to easily navigate through the Test",
                  ),
                  testRow(
                    indexNumber: 2,
                    instruction: selectedAppLanguage!.toLowerCase() == "hindi"
                        ? "एक बार जब आप 'स्टार्ट टेस्ट' बटन पर क्लिक करते हैं तो परीक्षा का समय शुरू हो जाएगा। "
                        : "Once you click on the ‘Start Test ‘ button the test time will begin.",
                  ),
                  testRow(
                    indexNumber: 3,
                    instruction: selectedAppLanguage!.toLowerCase() == "hindi"
                        ? "ऊपर दाईं ओर आप टेस्ट के लिए घड़ी देखेंगे। "
                        : "On the Upper right-hand side you will see the count-down timer for the Test",
                  ),
                  testRow(
                    indexNumber: 4,
                    instruction: selectedAppLanguage!.toLowerCase() == "hindi"
                        ? "मोबाइल स्क्रीन पर एक बार में केवल एक ही प्रश्न प्रदर्शित होगा। "
                        : "Only one Question will be displayed on the mobile screen at a time. ",
                  ),
                  testRow(
                    indexNumber: 5,
                    instruction: selectedAppLanguage!.toLowerCase() == "hindi"
                        ? "अगर आपको किसी प्रश्न का उत्तर नहीं आता तो आप स्किप का उपयोग करके आगे बढ़ सकते हैं।"
                        : "If you do not know the answer to a question, you can use skip button to move forward.",
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  testStartButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget testRow({int? indexNumber, required String instruction}) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${indexNumber.toString()}.",
            style: TextStyle(
              color: const Color(0xFF212121),
              fontFamily: GoogleFonts.lato().fontFamily,
              fontWeight: FontWeight.values[5],
              fontSize: 16,
            ),
          ),
          const SizedBox(
            width: 9,
          ),
          Expanded(
            child: Text(
              instruction,
              style: TextStyle(
                color: const Color(0xFF212121),
                fontFamily: GoogleFonts.lato().fontFamily,
                fontSize:
                    selectedAppLanguage!.toLowerCase() == "english" ? 15 : 16,
                fontWeight: FontWeight.values[5],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget testStartButton() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          await Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => TestPopUpPage(
                testPageWidget: widget.testPageWidget,
                testModel: widget.testModel,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(
            top: 16,
            bottom: 4,
          ),
          constraints: const BoxConstraints(
            minHeight: 48,
            maxWidth: 130,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF0077FF),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Center(
            child: Text(
              selectedAppLanguage!.toLowerCase() == "hindi"
                  ? "परीक्षण शुरू करें"
                  : "Start Test",
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize:
                    selectedAppLanguage!.toLowerCase() == "hindi" ? 15 : 16,
                fontWeight: FontWeight.values[5],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
