import 'package:flutter/material.dart';

import 'package:idream/common/constants.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/model/class_model.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:idream/ui/onboarding/stream_selection_screen.dart';
import 'package:flutter/cupertino.dart';

class NameClassSelectionScreen extends StatefulWidget {
  final String? userFullName;
  final String? email;

  const NameClassSelectionScreen({Key? key, this.userFullName, this.email})
      : super(key: key);

  @override
  NameClassSelectionScreenState createState() =>
      NameClassSelectionScreenState();
}

class NameClassSelectionScreenState extends State<NameClassSelectionScreen> {
  List<ClassStandard> _classStandardList = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int? selectedIndex;
  String? _selectedClass = "";
  bool _dataLoaded = false;

  Future fetchClasses() async {
    var response = await classRepository.fetchClasses();
    if (response is List<ClassStandard>) {
      _classStandardList = response;
    }
  }

  @override
  void initState() {
    selectedAppLanguage = selectedAppLanguage ?? 'english';
    _emailController.text = widget.email ?? "";
    _nameController.text = widget.userFullName ?? "";
    emailReplace();
    fetchClasses().then((value) {
      setState(() {
        _dataLoaded = true;
      });
    });
    super.initState();
  }

  emailReplace() {
    if (_emailController.text.contains("@iprep.org")) {
      _emailController.text = '';
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
          body: SingleChildScrollView(
            child: Container(
              // height: MediaQuery.of(context).size.height /* * 0.95*/,
              // ignore: todo
              //TODO: We need to look into this later.
              padding: const EdgeInsets.only(
                bottom: 40,
                left: 18,
                right: 18,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset("assets/images/back_icon.png"),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                          bottom: 30,
                        ),
                        child: Text(
                          selectedAppLanguage!.toLowerCase() == "hindi"
                              ? "हमें अपने बारे में कुछ बताएं"
                              : "Tell us a bit about yourself",
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
                        child: Text(
                          selectedAppLanguage!.toLowerCase() == "hindi"
                              ? "आपका क्या नाम है?"
                              : "What’s your name?",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8A8A8E),
                          ),
                        ),
                      ),
                      TextFormField(
                        autocorrect: false,
                        controller: _nameController,
                        autofocus: false,
                        cursorColor: Colors.black87,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText:
                              selectedAppLanguage!.toLowerCase() == "hindi"
                                  ? "आपका नाम"
                                  : "Your name",
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
                        child: Text(
                          selectedAppLanguage!.toLowerCase() == "hindi"
                              ? "आपका ईमेल पता?"
                              : "Your email address?",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8A8A8E),
                          ),
                        ),
                      ),
                      TextFormField(
                        autocorrect: false,
                        controller: _emailController,
                        autofocus: false,
                        cursorColor: Colors.black87,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText:
                              selectedAppLanguage!.toLowerCase() == "hindi"
                                  ? "आपका ईमेल"
                                  : "Your email",
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
                        child: Text(
                          selectedAppLanguage!.toLowerCase() == "hindi"
                              ? "अपनी कक्षा चुनें"
                              : "And you study in class?",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8D8D93),
                          ),
                        ),
                      ),
                      _dataLoaded
                          ? ((_classStandardList == null ||
                                  _classStandardList.isEmpty)
                              ? Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "No data available. Please try later.",
                                  ),
                                )
                              : GridView.count(
                                  crossAxisCount: 4,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: List.generate(
                                      _classStandardList.length, (index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        if (selectedIndex == index) {
                                          await removeStringToSF("classNumber");
                                          setState(() {
                                            selectedIndex = -1;
                                            _selectedClass = "";
                                          });
                                        } else {
                                          setState(() {
                                            selectedIndex = index;
                                            _selectedClass = _classStandardList[
                                                    _classStandardList.length -
                                                        index -
                                                        1]
                                                .classID;
                                          });
                                          await userRepository
                                              .saveUserDetailToLocal(
                                                  "classNumber",
                                                  _classStandardList[
                                                          _classStandardList
                                                                  .length -
                                                              index -
                                                              1]
                                                      .classID!);
                                        }
                                      },
                                      child: getClassWidget(
                                          int.parse(_classStandardList[
                                                  _classStandardList.length -
                                                      index -
                                                      1]
                                              .classID!),
                                          selected: selectedIndex == index
                                              ? true
                                              : false),
                                    );
                                  }),
                                ))
                          : const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                backgroundColor: Color(0xFF3399FF),
                              ),
                            ),
                      OnBoardingBottomButton(
                        buttonText: (selectedIndex != null &&
                                selectedIndex! >= 7 &&
                                selectedIndex! <= 11)
                            ? selectedAppLanguage!.toLowerCase() == "hindi"
                                ? "आगे बढ़ें"
                                : "Study Now"
                            : selectedAppLanguage!.toLowerCase() == "hindi"
                                ? "आगे बढ़ें"
                                : "Next",
                        buttonColor: (selectedIndex != null &&
                                selectedIndex! >= 0 &&
                                selectedIndex! <= 12 &&
                                _nameController.text.length > 0)
                            ? 0xFF0077FF
                            : 0xFFDEDEDE,
                        onPressed: () async {
                          if (_selectedClass!.isNotEmpty) {
                            if (_nameController.text.isNotEmpty) {
                              await userRepository.saveUserDetailToLocal(
                                  "fullName", _nameController.text);
                              await userRepository.saveUserDetailToLocal(
                                  "emailId", _emailController.text);
                              if (int.parse(_selectedClass!) < 11) {
                                await userRepository.saveUserDetailToLocal(
                                    "onBoarding", "Completed");

                                //Save remaining user details
                                await userRepository
                                    .saveUserInfoPostSuccessfulOnBoarding();

                                //Save Current Device Info
                                await userRepository.saveCurrentDeviceInfo();

                                await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const DashboardScreen(
                                      firstTimeLanded: true,
                                    ),
                                  ),
                                );
                              } else {
                                await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const StreamSelectionScreen(),
                                  ),
                                );
                              }
                            } else {
                              if (nameController.text.length > 0) {
                                SnackbarMessages.showErrorSnackbar(context,
                                    error: Constants.nameAlert);
                              } else {
                                SnackbarMessages.showErrorSnackbar(context,
                                    error: Constants.email);
                              }
                            }
                          } else {
                            SnackbarMessages.showErrorSnackbar(context,
                                error: Constants.classSelectionAlert);
                          }

                          // if (selectedIndex >= 0 && selectedIndex <= 12) {
                          //   if (_nameController.text.length > 0) {
                          //     await userRepository.saveUserDetailToLocal(
                          //         "fullName", _nameController.text);
                          //
                          //     if (selectedIndex >= 7 && selectedIndex <= 11) {
                          //       await Navigator.push(
                          //         context,
                          //         CupertinoPageRoute(
                          //           builder: (context) => DashboardScreen(),
                          //         ),
                          //       );
                          //     } else {
                          //       await Navigator.push(
                          //         context,
                          //         CupertinoPageRoute(
                          //           builder: (context) => BoardSelectionScreen(
                          //             classNumber: 12 - selectedIndex,
                          //           ),
                          //         ),
                          //       );
                          //     }
                          //   } else {
                          //     SnackbarMessages.showErrorSnackbar(context,
                          //         error: Constants.nameAlert);
                          //   }
                          // } else {
                          //   SnackbarMessages.showErrorSnackbar(context,
                          //       error: Constants.classSelectionAlert);
                          // }
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

  Container getClassWidget(int classNumber, {bool selected = false}) {
    String numberSuffix = getSuffix(classNumber);
    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(
        minWidth: 70,
        minHeight: 55,
      ),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF0077FF).withOpacity(0.05)
            : const Color(0xFFFFFFFF),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color:
                selected ? const Color(0xFF0077FF) : const Color(0xFFDEDEDE)),
      ),
      child: Text(
        "$classNumber$numberSuffix",
        style: TextStyle(
          color: selected ? const Color(0xFF212121) : const Color(0xFF666666),
        ),
      ),
    );
  }
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
