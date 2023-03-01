import 'package:flutter/material.dart';

import 'package:idream/common/constants.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/custom_pop_up.dart';
import 'package:idream/custom_widgets/custom_tile.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/ui/onboarding/login_screen.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  final String? appLevelLanguage;

  const UserTypeSelectionScreen({Key? key, this.appLevelLanguage})
      : super(key: key);

  @override
  UserTypeSelectionScreenState createState() => UserTypeSelectionScreenState();
}

class UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  bool _studentSelected = false;
  bool _teacherSelected = false;

  @override
  void initState() {
    _studentSelected = true;
    userType = "Student";
    super.initState();
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
            padding: const EdgeInsets.only(
              bottom: 40,
              left: 18,
              right: 18,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Text(
                        /*"Sign up as"*/
                        (selectedAppLanguage!.toLowerCase() == "hindi")
                            ? "मैं एक"
                            : "I am a",
                        style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 17,
                          fontWeight: FontWeight.values[5],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _studentSelected = true;
                          _teacherSelected = false;
                          userType = "Student";
                        });
                      },
                      child: CustomTileWidget(
                        selected: _studentSelected,
                        streamText:
                            (selectedAppLanguage!.toLowerCase() == "hindi")
                                ? "विद्यार्थी हूँ"
                                : "Student",
                        selectedColor: 0xFF22C59B,
                        leadingWidgetRequired: true,
                        leadingImagePath: "assets/images/student_icon.png",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _studentSelected = false;
                          _teacherSelected = true;
                          userType = "Coach";
                        });
                      },
                      child: CustomTileWidget(
                        selected: _teacherSelected,
                        streamText:
                            (selectedAppLanguage!.toLowerCase() == "hindi")
                                ? "शिक्षक हूँ"
                                : "Coach / Teacher / Tutor",
                        leadingWidgetRequired: true,
                        leadingImagePath: "assets/images/teacher_icon.png",
                      ),
                    ),
                    OnBoardingBottomButton(
                      buttonText:
                          (selectedAppLanguage!.toLowerCase() == "hindi")
                              ? "आगे बढ़ें"
                              : "Next",
                      onPressed: () async {
                        if (userType != null) {
                          //TODO: Here we are changing the Flow....
                          var _result =
                              await userTypeConfirmationPopUp(context);
                          if (_result == "Yes") {
                            await userRepository.saveUserDetailToLocal(
                                "UserType", userType!);
                            Navigator.pop(context);
                          }
                        } else {
                          SnackbarMessages.showErrorSnackbar(context,
                              error: Constants.userTypeSelectionAlert);
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
