import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/model/user.dart';
import 'package:idream/ui/teacher/dashboard_coach.dart';

class NameEnterCoachScreen extends StatefulWidget {
  final String? userFullName;
  final bool switchProfile;
  final String? email;

  const NameEnterCoachScreen(
      {Key? key, this.userFullName, this.switchProfile = false, this.email})
      : super(key: key);

  @override
  _NameEnterCoachScreenState createState() => _NameEnterCoachScreenState();
}

class _NameEnterCoachScreenState extends State<NameEnterCoachScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.userFullName ?? "";
    _emailController.text = widget.email ?? "";
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
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height /* * 0.95*/,
              //TODO: We need to look into this later.
              padding: const EdgeInsets.only(
                bottom: 40,
                left: 18,
                right: 18,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Column(
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.only(
                  //         top: 25,
                  //       ),
                  //       child: Row(
                  //         children: [
                  //           IconButton(
                  //             onPressed: () {
                  //               Navigator.pop(context);
                  //             },
                  //             icon: Image.asset("assets/images/back_icon.png"),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                          bottom: 30,
                        ),
                        child: Text(
                          "Tell us a bit about yourself",
                          style: TextStyle(
                              color: const Color(0xFF212121),
                              fontSize: 16,
                              fontWeight: FontWeight.values[5]),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: const Text(
                          "What’s your name?",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8A8A8E),
                          ),
                        ),
                      ),
                      TextFormField(
                        autocorrect: false,
                        controller: _nameController,
                        autofocus: true,
                        cursorColor: Colors.black87,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: "Your name",
                          focusedBorder: Constants.inputTextOutlineFocus,
                          enabledBorder: Constants.inputTextOutline,
                          border: Constants.inputTextOutline,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: const Text(
                          "Your email address?",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8A8A8E),
                          ),
                        ),
                      ),
                      TextFormField(
                        autocorrect: false,
                        controller: _emailController,
                        autofocus: true,
                        cursorColor: Colors.black87,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: "Your email",
                          focusedBorder: Constants.inputTextOutlineFocus,
                          enabledBorder: Constants.inputTextOutline,
                          border: Constants.inputTextOutline,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      OnBoardingBottomButton(
                        buttonText: "Next",
                        buttonColor: (_nameController.text.isNotEmpty)
                            ? 0xFF0077FF
                            : 0xFFDEDEDE,
                        onPressed: () async {
                          if (_nameController.text.isNotEmpty ||
                              _emailController.text.isNotEmpty) {
                            //Save remaining user details
                            //TODO: Remove all the saved data. And then fetch new data and save them.

                            String? userID =
                                await (getStringValuesSF("userID"));
                            String? token = await firebaseMessaging.getToken();
                            String? language =
                                await getStringValuesSF('language');
                            String? mobile = appUser!.mobile;

                            await dbRef
                                .child("users")
                                .child("teachers")
                                .child(userID!)
                                .set({
                              "full_name": _nameController.text,
                              "language": language,
                              "mobile": mobile ?? "+91-",
                              "email": _emailController.text,
                              'profile_photo':
                                  Constants.defaultProfileImagePath,
                              "token": token,
                              "user_type": "App",
                              "users_plans": {
                                "date_started":
                                    DateTime.now().toUtc().toString(),
                                "plan_duration": "7",
                                "status": "Trial",
                              }
                            }).then((_) async {
                              print("Saved Data successfully");
                              await userRepository.saveReferralCode();
                              await userRepository
                                  .sendSuccessfulSignUpNotification();
                              appUser = AppUser(
                                  userType: "Coach",
                                  fullName: _nameController.text,
                                  token: token,
                                  userID: userID,
                                  language: language,
                                  profilePhoto:
                                      Constants.defaultProfileImagePath,
                                  mobile: mobile,
                                  userPlans: UserPlans(
                                    planDuration: '7',
                                    status: 'Trial',
                                    dateStarted:
                                        DateTime.now().toUtc().toString(),
                                  ));
                              await userRepository.saveUserDetailToLocal(
                                  "userID", userID);
                              await userRepository.saveUserDetailToLocal(
                                  "email", _emailController.text);
                              await userRepository.saveUserDetailToLocal(
                                  "language", language!);
                              await userRepository.saveUserDetailToLocal(
                                  "UserType", "Coach");
                              await userRepository.saveUserDetailToLocal(
                                  "fullName", _nameController.text);
                              await userRepository.saveUserDetailToLocal(
                                  "mobileNumber", mobile!);
                              await userRepository.saveUserDetailToLocal(
                                  "fcmToken", token!);
                              await userRepository.saveUserDetailToLocal(
                                  "userPlanStatus", "Trial");
                              await userRepository.saveUserDetailToLocal(
                                  "userPlanDuration", "7");
                              await userRepository.saveUserDetailToLocal(
                                  "userPlanDateStarted",
                                  DateTime.now().toUtc().toString());
                              await userRepository.saveUserDetailToLocal(
                                  "profilePhoto",
                                  Constants.defaultProfileImagePath);
                            }).catchError((onError) {
                              print(onError);
                            });

                            var _userDetails =
                                await userRepository.fetchUserDetails(userID);
                            debugPrint(_userDetails.toString());

                            await userRepository.saveUserDetailToLocal(
                                "fullName", _nameController.text);
                            appUser!.fullName = _nameController.text;
                            await coachOnBoardingRepository.saveTeachersName(
                                fullName: _nameController.text);

                            await userRepository.saveUserDetailToLocal(
                                "onBoarding", "Completed");

                            //Save Current Device Info
                            await userRepository.saveCurrentDeviceInfo();

                            await Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const DashboardCoach(),
                              ),
                              (Route<dynamic> route) => false,
                            );
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
      ),
    );
  }
}
