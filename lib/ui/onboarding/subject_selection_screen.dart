import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/custom_tile.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/ui/onboarding/board_selection_screen.dart';

class SubjectSelectionScreen extends StatefulWidget {
  const SubjectSelectionScreen({Key? key}) : super(key: key);

  @override
  SubjectSelectionScreenState createState() => SubjectSelectionScreenState();
}

class SubjectSelectionScreenState extends State<SubjectSelectionScreen> {
  List<String> selectedSubjectList = [];

  @override
  void initState() {
    super.initState();
  }

  onTapEvent(String subjectName) {
    if (selectedSubjectList.contains(subjectName)) {
      setState(() {
        selectedSubjectList.remove(subjectName);
      });
    } else {
      setState(() {
        selectedSubjectList.add(subjectName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.only(
              bottom: 40,
              left: 18,
              right: 18,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 55),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Color(0xFF000000),
                            ),
                          ),
                          SizedBox(
                            width: 45,
                          ),
                          Text(
                            "What are your subjects?",
                            style: TextStyle(
                                color: Color(0xFF212121),
                                fontSize: 17,
                                fontWeight: FontWeight.values[5]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        onTapEvent("Maths");
                      },
                      child: CustomTileWidget(
                        selected: selectedSubjectList.contains("Maths")
                            ? true
                            : false,
                        streamText: "Maths",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onTapEvent("Chemistry");
                      },
                      child: CustomTileWidget(
                        selected: selectedSubjectList.contains("Chemistry")
                            ? true
                            : false,
                        streamText: "Chemistry",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onTapEvent("Physics");
                      },
                      child: CustomTileWidget(
                        selected: selectedSubjectList.contains("Physics")
                            ? true
                            : false,
                        streamText: "Physics",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onTapEvent("English");
                      },
                      child: CustomTileWidget(
                        selected: selectedSubjectList.contains("English")
                            ? true
                            : false,
                        streamText: "English",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onTapEvent("Hindi");
                      },
                      child: CustomTileWidget(
                        selected: selectedSubjectList.contains("Hindi")
                            ? true
                            : false,
                        streamText: "Hindi",
                      ),
                    ),
                    OnBoardingBottomButton(
                      buttonText: "Next",
                      onPressed: () async {
                        if (selectedSubjectList.isNotEmpty) {
                          await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => BoardSelectionScreen(),
                            ),
                          );
                        } else {
                          SnackbarMessages.showErrorSnackbar(context,
                              error: Constants.languageSelectionAlert);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
