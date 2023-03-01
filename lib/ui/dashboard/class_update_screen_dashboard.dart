import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/model/class_model.dart';
import 'package:idream/model/user.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:idream/ui/dashboard/stream_update_screen_dashboard.dart';
import 'package:idream/ui/teacher/dashboard_coach.dart';

class ClassUpdateScreenDashboard extends StatefulWidget {
  final String? boardName;

  const ClassUpdateScreenDashboard({Key? key, this.boardName})
      : super(key: key);
  @override
  ClassUpdateScreenDashboardState createState() =>
      ClassUpdateScreenDashboardState();
}

class ClassUpdateScreenDashboardState
    extends State<ClassUpdateScreenDashboard> {
  int? selectedIndex;
  String? _selectedClass = "";
  final AppUser _updatedUserInfo = AppUser();
  bool _enabled = true;

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
              height: MediaQuery.of(context).size.height * 0.95,
              padding: const EdgeInsets.only(
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
                        padding: const EdgeInsets.only(top: 25),
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
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 30,
                        ),
                        child: Text(
                          "I am in Class",
                          style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xFF212121),
                              fontWeight: FontWeight.values[5]),
                        ),
                      ),
                      FutureBuilder(
                          future: classRepository.fetchClasses(
                              boardName: widget.boardName!.toLowerCase()),
                          builder: (context, classes) {
                            if (classes.connectionState ==
                                    ConnectionState.none &&
                                classes.hasData == null) {
                              return Container();
                            } else if (classes.connectionState ==
                                    ConnectionState.done &&
                                classes.data == null) {
                              return Container(
                                alignment: Alignment.center,
                                child: const Text(
                                    "No data available. Please try later."),
                              );
                            } else if (classes.hasData) {
                              List<ClassStandard>? _classStandardList =
                                  classes.data as List<ClassStandard>?;
                              if (_classStandardList == null ||
                                  _classStandardList.isEmpty) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                      "No data available. Please try later."),
                                );
                              }
                              return GridView.count(
                                crossAxisCount: 4,
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                physics: const NeverScrollableScrollPhysics(),
                                children: List.generate(
                                    _classStandardList.length, (index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (selectedIndex == index) {
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
                              );
                            } else {
                              return Container(
                                alignment: Alignment.center,
                                child: const Text("Loading..."),
                              );
                            }
                          }),
                      AbsorbPointer(
                        absorbing: !_enabled,
                        child: OnBoardingBottomButton(
                          buttonText: (_selectedClass!.isEmpty ||
                                  int.parse(_selectedClass!) < 11)
                              ? "Confirm"
                              : "Next",
                          buttonColor: (selectedIndex != null &&
                                  selectedIndex! >= 0 &&
                                  selectedIndex! <= 12)
                              ? 0xFF0077FF
                              : 0xFFDEDEDE,
                          onPressed: () async {
                            if (_selectedClass!.isNotEmpty) {
                              setState(() {
                                _enabled = false;
                              });
                              _updatedUserInfo.classID = _selectedClass;
                              _updatedUserInfo.educationBoard =
                                  widget.boardName;
                              if (int.parse(_selectedClass!) < 11) {
                                await dashboardRepository
                                    .updateUserInfoFromDashboard(
                                  updatedUserInfo: _updatedUserInfo,
                                );
                                await Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ((!usingIprepLibrary)
                                        ? const DashboardScreen()
                                        : const DashboardCoach(
                                            selectedTabIndex: 1,
                                          )),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              } else {
                                await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        StreamUpdateScreenDashboard(
                                      updateAppUserInfo: _updatedUserInfo,
                                    ),
                                  ),
                                );
                              }
                              setState(() {
                                _enabled = true;
                              });
                            }
                          },
                        ),
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

  Container getClassWidget(int questionNumber, {bool selected = false}) {
    String numberSuffix = getSuffix(questionNumber);
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
        "$questionNumber$numberSuffix",
        style: TextStyle(
          color: selected ? const Color(0xFF212121) : const Color(0xFF666666),
        ),
      ),
    );
  }
}
