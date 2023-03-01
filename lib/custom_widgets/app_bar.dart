import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/custom_widgets/custom_tile.dart';
import 'package:idream/model/app_language.dart';
import 'package:idream/model/streams_model.dart';
import 'package:idream/model/user.dart';
import 'package:idream/provider/bell_animation_provider.dart';
import 'package:idream/test_page.dart';
import 'package:idream/ui/dashboard/class_update_screen_dashboard.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:idream/ui/dashboard/notification_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/ui/onboarding/app_level_language_selection_screen.dart';
import 'package:idream/ui/teacher/dashboard_coach.dart';
import 'package:idream/ui/test_prep/test_prep_provider/test_proivider.dart';
import 'package:provider/provider.dart';

import '../common/constants.dart';
import '../common/snackbar_messages.dart';
import '../model/class_model.dart';
import '../ui/dashboard/stream_update_screen_dashboard.dart';
import '../ui/menu/edit_profile_page.dart';
import 'onboarding_bottom_button.dart';

Widget teacherCustomAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Image.asset(
            "assets/images/menu.png",
            height: 24,
            width: 24,
          ),
        );
      },
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [],
    ),
    centerTitle: false,
    actions: [
      Consumer<BellAnimationProvider>(builder: (_, bellAnimation, __) {
        return StreamBuilder(
          stream: dbRef
              .child("notification/teachers/${appUser!.userID}/")
              .orderByValue()
              .onValue,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              DataSnapshot dataValues = snapshot.data.snapshot;
              Map<dynamic, dynamic>? _values =
                  dataValues.value as Map<dynamic, dynamic>?;
              if (_values != null) {
                var _list = _values.entries.toList();
                bool _anyoneNotRead =
                    _list.any((element) => !element.value['message_opened']);
                if (!_anyoneNotRead &&
                    ((bellAnimation.localChatList != null) &&
                        (bellAnimation.localChatList.length > 0))) {
                  _anyoneNotRead = true;
                }
                if (bellAnimation.heartAnimationController.isAnimating) {
                  return AnimatedBuilder(
                    animation: bellAnimation.heartAnimationController,
                    builder: (context, child) {
                      return IconButton(
                        icon: Image.asset(
                          "assets/images/${_anyoneNotRead ? "notification" : "notification_bell_icon"}.png",
                          height: (_anyoneNotRead ? 32 : 28) *
                              bellAnimation.heartAnimationController.value,
                          width: (_anyoneNotRead ? 32 : 28) *
                              bellAnimation.heartAnimationController.value,
                        ),
                        onPressed: () async {
                          String? _userID = await getStringValuesSF("userID");
                          String? _userTypeNode =
                              await (userRepository.getUserNodeName());
                          await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => NotificationPage(
                                userId: _userID.toString(),
                                userType: _userTypeNode,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return IconButton(
                    icon: Image.asset(
                      "assets/images/${_anyoneNotRead ? "notification" : "notification_bell_icon"}.png",
                      height: _anyoneNotRead ? 24 : 19,
                      width: _anyoneNotRead ? 24 : 18,
                    ),
                    onPressed: () async {
                      String? _userID = await getStringValuesSF("userID");
                      String? _userTypeNode =
                          await (userRepository.getUserNodeName());
                      await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => NotificationPage(
                            userId: _userID,
                            userType: _userTypeNode,
                          ),
                        ),
                      );
                    },
                  );
                }
              }
            }
            return Container(
              height: 0,
              width: 0,
            );
          },
        );
      }),
    ],
  );
}

Widget customAppBar(
  mounted,
  BuildContext context,
  DashboardScreenState? dashboardScreenState,
) {
  Future getSavedAppLanguage() async {
    return await getStringValuesSF("language");
  }

  Future getClassAndBoard() async {
    String? classNumber = await (getStringValuesSF("classNumber"));
    return "Class ${classNumber!.padLeft(2, "0")}";
  }

  getPopup() async {
    String? classNumber = await (getStringValuesSF("classNumber"));
    final classNumb = (int.tryParse(classNumber!));
    int? selectedIndex = 12 - classNumb!.toInt();
    String? selectedClass = "";
    String? selectedStream;
    List<StreamsModel>? streamsList;
    bool isStreamSelect = false;
    final AppUser updatedUserInfo = AppUser();
    bool enabled = false;
    String? educationBoard =
        (await getStringValuesSF("educationBoard"))!.toLowerCase();
    updatedUserInfo.educationBoard = educationBoard;
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 17),
              backgroundColor: const Color(0xFFFFFFFF),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              alignment: Alignment.center,
              titleTextStyle: Constants.noDataTextStyle.copyWith(
                fontSize: 18,
                fontFamily: 'Inter',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF565657),
              ),
              title: Text(
                enabled == false ? "Select a class" : "Select your Stream",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF212121),
                    fontWeight: FontWeight.values[5]),
              ),
              content: Container(
                padding: const EdgeInsets.only(bottom: 5),

                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isStreamSelect == false) ...[
                      FutureBuilder(
                          future: classRepository.fetchClasses(
                              boardName: educationBoard.toLowerCase()),
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
                              List<ClassStandard>? classStandardList =
                                  classes.data as List<ClassStandard>?;
                              if (classStandardList == null ||
                                  classStandardList.isEmpty) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                      "No data available. Please try later."),
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

                              Container getClassWidget(int questionNumber,
                                  {bool selected = false}) {
                                String numberSuffix = getSuffix(questionNumber);
                                return Container(
                                  alignment: Alignment.center,
                                  constraints: const BoxConstraints(
                                    minWidth: 70,
                                    minHeight: 55,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xFF0077FF)
                                            .withOpacity(0.05)
                                        : const Color(0xFFFFFFFF),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: selected
                                            ? const Color(0xFF0077FF)
                                            : const Color(0xFFDEDEDE)),
                                  ),
                                  child: Text(
                                    "$questionNumber$numberSuffix",
                                    style: TextStyle(
                                      color: selected
                                          ? const Color(0xFF212121)
                                          : const Color(0xFF666666),
                                    ),
                                  ),
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
                                    classStandardList.length, (index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (selectedIndex == index) {
                                        setState(() {
                                          selectedIndex = -1;
                                          selectedClass = "";
                                        });
                                      } else {
                                        setState(() {
                                          selectedIndex = index;
                                          selectedClass = classStandardList[
                                                  classStandardList.length -
                                                      index -
                                                      1]
                                              .classID;
                                        });
                                      }

                                      if (selectedClass!.isNotEmpty) {
                                        setState(() {
                                          enabled = false;
                                        });
                                        updatedUserInfo.classID = selectedClass;
                                        updatedUserInfo.educationBoard =
                                            educationBoard;
                                        if (int.parse(selectedClass!) < 11) {
                                          await dashboardRepository
                                              .updateUserInfoFromDashboard(
                                            updatedUserInfo: updatedUserInfo,
                                          );
                                          if (!mounted) return;
                                          await Navigator.pushAndRemoveUntil(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  ((!usingIprepLibrary)
                                                      ? const DashboardScreen()
                                                      : const DashboardCoach(
                                                          selectedTabIndex: 1,
                                                        )),
                                            ),
                                            (Route<dynamic> route) => false,
                                          );
                                        } else {
                                          setState(() {
                                            enabled = true;
                                          });
                                          streamSelectionRepository
                                              .fetchStreams(
                                                  boardName: updatedUserInfo
                                                      .educationBoard!
                                                      .toLowerCase(),
                                                  classID:
                                                      updatedUserInfo.classID)
                                              .then((value) {
                                            setState(() {
                                              streamsList = value;
                                              isStreamSelect = true;
                                            });
                                          });

                                          // await Navigator.push(
                                          //   context,
                                          //   CupertinoPageRoute(
                                          //     builder: (context) =>
                                          //         StreamUpdateScreenDashboard(
                                          //       updateAppUserInfo:
                                          //           updatedUserInfo,
                                          //     ),
                                          //   ),
                                          // );
                                        }
                                        if (mounted) {
                                          setState(() {
                                            enabled = true;
                                          });
                                        }
                                      }
                                    },
                                    child: getClassWidget(
                                        int.parse(classStandardList[
                                                classStandardList.length -
                                                    index -
                                                    1]
                                            .classID!),
                                        selected: classNumb ==
                                                int.parse(classStandardList[
                                                        classStandardList
                                                                .length -
                                                            index -
                                                            1]
                                                    .classID!)
                                            ? true
                                            : false),
                                  );
                                }),
                              );
                            } else {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * .10,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(),
                              );
                            }
                          }),
                    ],
                    if (isStreamSelect == true && streamsList != null) ...[
                      ListView.builder(
                          itemCount: streamsList!.length,
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                setState(() {
                                  selectedStream =
                                      streamsList![index].streamName;
                                });
                                if (selectedStream!.isNotEmpty) {
                                  updatedUserInfo.stream = selectedStream;

                                  await dashboardRepository
                                      .updateUserInfoFromDashboard(
                                    updatedUserInfo: updatedUserInfo,
                                  );

                                  if (!mounted) return;
                                  await Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            ((!usingIprepLibrary)
                                                ? const DashboardScreen()
                                                : const DashboardCoach(
                                                    selectedTabIndex: 1,
                                                  ))),
                                    (Route<dynamic> route) => false,
                                  );
                                } else {
                                  SnackbarMessages.showErrorSnackbar(context,
                                      error: Constants.streamAlert);
                                }

                                // if (selectedStream ==
                                //     _streamsList![index]
                                //         .streamName) {
                                //   setState(() {
                                //     selectedStream = "";
                                //   });
                                // } else {
                                //   setState(() {
                                //     selectedStream =
                                //         _streamsList![index]
                                //             .streamName;
                                //   });
                                // }
                              },
                              child: CustomTileWidget(
                                selected: selectedStream ==
                                        streamsList![index].streamName
                                    ? true
                                    : false,
                                leadingWidgetRequired: true,
                                streamText: streamsList![index]
                                    .streamName /*"Science"*/,
                                selectedColor:
                                    ((streamsList![index].streamName ==
                                            'Science')
                                        ? 0xFF46B6E9
                                        : ((streamsList![index].streamName ==
                                                'Commerce')
                                            ? 0xFF9fb22D
                                            : 0xFFE39700)),
                                leadingImagePath: "assets/images/science.png",
                                dynamicLeadingImagePath:
                                    streamsList![index].icon,
                                checkImagePath:
                                    'assets/images/${((streamsList![index].streamName == 'Science') ? 'checked_image_blue' : ((streamsList![index].streamName == 'Commerce') ? 'check_commerce' : 'check_arts'))}.png',
                              ),
                            );
                          }),
                      // FutureBuilder(
                      //   future: fetchStreams,
                      //   builder: (context, streams) {
                      //     String? selectedStream = "";
                      //     if (streams.connectionState ==
                      //             ConnectionState.none &&
                      //         streams.hasData == null) {
                      //       return Container();
                      //     } else if (streams.hasData) {
                      //       List<StreamsModel>? _streamsList =
                      //           streams.data
                      //               as List<StreamsModel>?;
                      //       return ListView.builder(
                      //           itemCount: _streamsList!.length,
                      //           padding: const EdgeInsets.all(0),
                      //           shrinkWrap: true,
                      //           itemBuilder: (context, index) {
                      //             return GestureDetector(
                      //               onTap: () async {
                      //                 if (selectedStream ==
                      //                     _streamsList[index]
                      //                         .streamName) {
                      //                   setState(() {
                      //                     selectedStream = "";
                      //                   });
                      //                 } else {
                      //                   setState(() {
                      //                     selectedStream =
                      //                         _streamsList[index]
                      //                             .streamName;
                      //                   });
                      //                 }
                      //               },
                      //               child: CustomTileWidget(
                      //                 selected: selectedStream ==
                      //                         _streamsList[index]
                      //                             .streamName
                      //                     ? true
                      //                     : false,
                      //                 leadingWidgetRequired: true,
                      //                 streamText: _streamsList[
                      //                         index]
                      //                     .streamName /*"Science"*/,
                      //                 selectedColor: ((_streamsList[
                      //                                 index]
                      //                             .streamName ==
                      //                         'Science')
                      //                     ? 0xFF46B6E9
                      //                     : ((_streamsList[index]
                      //                                 .streamName ==
                      //                             'Commerce')
                      //                         ? 0xFF9fb22D
                      //                         : 0xFFE39700)),
                      //                 leadingImagePath:
                      //                     "assets/images/science.png",
                      //                 dynamicLeadingImagePath:
                      //                     _streamsList[index]
                      //                         .icon,
                      //                 checkImagePath:
                      //                     'assets/images/${((_streamsList[index].streamName == 'Science') ? 'checked_image_blue' : ((_streamsList[index].streamName == 'Commerce') ? 'check_commerce' : 'check_arts'))}.png',
                      //               ),
                      //             );
                      //           });
                      //     } else {
                      //       return Container();
                      //     }
                      //   },
                      // ),
                    ],
                    Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: customButton(
                          width: 152,
                          bText: isStreamSelect == true ? "Back" : "Cancel",
                          onTap: () {
                            if (isStreamSelect == false) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                              getPopup();
                            }
                          },
                        )

                        // Row(
                        //   mainAxisAlignment:
                        //       MainAxisAlignment.spaceAround,
                        //   children: [
                        //     AbsorbPointer(
                        //       absorbing: !_enabled,
                        //       child: customButton(
                        //         width: 152,
                        //         color: selectedClass!.isEmpty
                        //             ? null
                        //             : const Color(0xFF0077FF),
                        //         bText: (selectedClass!.isEmpty ||
                        //                 int.parse(selectedClass!) <
                        //                     11)
                        //             ? "Confirm"
                        //             : "Next",
                        //         onTap: () async {
                        //           if (selectedClass!.isNotEmpty) {
                        //             setState(() {
                        //               _enabled = false;
                        //             });
                        //             updatedUserInfo.classID =
                        //                 selectedClass;
                        //             updatedUserInfo.educationBoard =
                        //                 educationBoard;
                        //             if (int.parse(selectedClass!) <
                        //                 11) {
                        //               await dashboardRepository
                        //                   .updateUserInfoFromDashboard(
                        //                 updatedUserInfo:
                        //                     updatedUserInfo,
                        //               );
                        //               if (!mounted) return;
                        //               await Navigator
                        //                   .pushAndRemoveUntil(
                        //                 context,
                        //                 CupertinoPageRoute(
                        //                   builder: (context) =>
                        //                       ((!usingIprepLibrary)
                        //                           ? const DashboardScreen()
                        //                           : const DashboardCoach(
                        //                               selectedTabIndex:
                        //                                   1,
                        //                             )),
                        //                 ),
                        //                 (Route<dynamic> route) =>
                        //                     false,
                        //               );
                        //             } else {
                        //               streamSelectionRepository
                        //                   .fetchStreams(
                        //                       boardName:
                        //                           updatedUserInfo
                        //                               .educationBoard!
                        //                               .toLowerCase(),
                        //                       classID:
                        //                           updatedUserInfo
                        //                               .classID)
                        //                   .then((value) {
                        //                 setState(() {
                        //                   _streamsList = value;
                        //                   isStreamSelect = true;
                        //                 });
                        //               });
                        //
                        //               // await Navigator.push(
                        //               //   context,
                        //               //   CupertinoPageRoute(
                        //               //     builder: (context) =>
                        //               //         StreamUpdateScreenDashboard(
                        //               //       updateAppUserInfo:
                        //               //           updatedUserInfo,
                        //               //     ),
                        //               //   ),
                        //               // );
                        //             }
                        //             setState(() {
                        //               _enabled = true;
                        //             });
                        //           }
                        //         },
                        //       ),
                        //     ),
                        //     customButton(
                        //       width: 152,
                        //       onTap: () => Navigator.pop(context),
                        //       bText: "Cancel",
                        //     )
                        //   ],
                        // ),
                        ),
                  ],
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //
                //     FutureBuilder(
                //         future: classRepository.fetchClasses(
                //             boardName:
                //                 educationBoard.toLowerCase()),
                //         builder: (context, classes) {
                //           if (classes.connectionState ==
                //                   ConnectionState.none &&
                //               classes.hasData == null) {
                //             return Container();
                //           } else if (classes.connectionState ==
                //                   ConnectionState.done &&
                //               classes.data == null) {
                //             return Container(
                //               alignment: Alignment.center,
                //               child: const Text(
                //                   "No data available. Please try later."),
                //             );
                //           } else if (classes.hasData) {
                //             List<ClassStandard>?
                //                 _classStandardList = classes.data
                //                     as List<ClassStandard>?;
                //             if (_classStandardList == null ||
                //                 _classStandardList.isEmpty) {
                //               return Container(
                //                 alignment: Alignment.center,
                //                 child: const Text(
                //                     "No data available. Please try later."),
                //               );
                //             }
                //             getSuffix(int classNumber) {
                //               if (classNumber >= 11 &&
                //                   classNumber <= 13) {
                //                 return "th";
                //               }
                //               switch (classNumber % 10) {
                //                 case 1:
                //                   return "st";
                //                 case 2:
                //                   return "nd";
                //                 case 3:
                //                   return "rd";
                //                 default:
                //                   return "th";
                //               }
                //             }
                //
                //             Container getClassWidget(
                //                 int questionNumber,
                //                 {bool selected = false}) {
                //               String numberSuffix =
                //                   getSuffix(questionNumber);
                //               return Container(
                //                 alignment: Alignment.center,
                //                 constraints: const BoxConstraints(
                //                   minWidth: 70,
                //                   minHeight: 55,
                //                 ),
                //                 decoration: BoxDecoration(
                //                   color: selected
                //                       ? const Color(0xFF0077FF)
                //                           .withOpacity(0.05)
                //                       : const Color(0xFFFFFFFF),
                //                   shape: BoxShape.rectangle,
                //                   borderRadius:
                //                       BorderRadius.circular(12),
                //                   border: Border.all(
                //                       color: selected
                //                           ? const Color(
                //                               0xFF0077FF)
                //                           : const Color(
                //                               0xFFDEDEDE)),
                //                 ),
                //                 child: Text(
                //                   "$questionNumber$numberSuffix",
                //                   style: TextStyle(
                //                     color: selected
                //                         ? const Color(0xFF212121)
                //                         : const Color(0xFF666666),
                //                   ),
                //                 ),
                //               );
                //             }
                //
                //             return GridView.count(
                //               crossAxisCount: 4,
                //               shrinkWrap: true,
                //               padding: const EdgeInsets.symmetric(
                //                   horizontal: 18),
                //               crossAxisSpacing: 12,
                //               mainAxisSpacing: 12,
                //               physics:
                //                   const NeverScrollableScrollPhysics(),
                //               children: List.generate(
                //                   _classStandardList.length,
                //                   (index) {
                //                 return GestureDetector(
                //                   onTap: () async {
                //                     if (selectedIndex == index) {
                //                       setState(() {
                //                         selectedIndex = -1;
                //                         _selectedClass = "";
                //                       });
                //                     } else {
                //                       setState(() {
                //                         selectedIndex = index;
                //                         _selectedClass =
                //                             _classStandardList[
                //                                     _classStandardList
                //                                             .length -
                //                                         index -
                //                                         1]
                //                                 .classID;
                //                       });
                //                     }
                //                   },
                //                   child: getClassWidget(
                //                       int.parse(_classStandardList[
                //                               _classStandardList
                //                                       .length -
                //                                   index -
                //                                   1]
                //                           .classID!),
                //                       selected:
                //                           selectedIndex == index
                //                               ? true
                //                               : false),
                //                 );
                //               }),
                //             );
                //           } else {
                //             return Container(
                //               alignment: Alignment.center,
                //               child: const Text("Loading..."),
                //             );
                //           }
                //         }),
                //     AbsorbPointer(
                //       absorbing: !_enabled,
                //       child: OnBoardingBottomButton(
                //         buttonText: (_selectedClass!.isEmpty ||
                //                 int.parse(_selectedClass!) < 11)
                //             ? "Confirm"
                //             : "Next",
                //         buttonColor: (selectedIndex != null &&
                //                 selectedIndex! >= 0 &&
                //                 selectedIndex! <= 12)
                //             ? 0xFF0077FF
                //             : 0xFFDEDEDE,
                //         onPressed: () async {
                //           if (_selectedClass!.isNotEmpty) {
                //             setState(() {
                //               _enabled = false;
                //             });
                //             _updatedUserInfo.classID =
                //                 _selectedClass;
                //             _updatedUserInfo.educationBoard =
                //                 educationBoard;
                //             if (int.parse(_selectedClass!) < 11) {
                //               await dashboardRepository
                //                   .updateUserInfoFromDashboard(
                //                 updatedUserInfo: _updatedUserInfo,
                //               );
                //               await Navigator.pushAndRemoveUntil(
                //                 context,
                //                 CupertinoPageRoute(
                //                   builder: (context) =>
                //                       ((!usingIprepLibrary)
                //                           ? const DashboardScreen()
                //                           : const DashboardCoach(
                //                               selectedTabIndex: 1,
                //                             )),
                //                 ),
                //                 (Route<dynamic> route) => false,
                //               );
                //             } else {
                //               await Navigator.push(
                //                 context,
                //                 CupertinoPageRoute(
                //                   builder: (context) =>
                //                       StreamUpdateScreenDashboard(
                //                     updateAppUserInfo:
                //                         _updatedUserInfo,
                //                   ),
                //                 ),
                //               );
                //             }
                //             setState(() {
                //               _enabled = true;
                //             });
                //           }
                //         },
                //       ),
                //     ),
                //   ],
                // ),
              ),
            );
          },
        );
      },
    );
  }

  return AppBar(
    scrolledUnderElevation: 2,
    elevation: 0,
    backgroundColor: Colors.white,
    leading: Builder(
      builder: (BuildContext context) {
        return Stack(
          children: [
            Container(
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Image.asset(
                  "assets/images/menu.png",
                  height: 24,
                  width: 24,
                  // color: const Color(0xFF212121),
                ),
              ),
            ),
            Provider.of<TestProvider>(context).isLoading == true
                ? Container(
                    height: 35,
                    color: Colors.transparent,
                  )
                : const SizedBox(),
          ],
        );
      },
    ),
    title: Stack(
      children: [
        SizedBox(
          child: Row(
            children: [
              FutureBuilder(
                future: getClassAndBoard(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GestureDetector(
                      onTap: () async {
                        getPopup();
                      },
                      child: Container(
                        height: 32,
                        width: 86,
                        decoration: BoxDecoration(
                            color: const Color(0xFF0077FF).withOpacity(0.1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data,
                              style: TextStyle(
                                color: const Color(0xFF0077FF),
                                fontSize: 12,
                                fontWeight: FontWeight.values[5],
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            RotationTransition(
                              turns: const AlwaysStoppedAnimation(90 / 360),
                              child: Image.asset(
                                'assets/images/forward_arrow.png',
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              const SizedBox(width: 10),
              // FutureBuilder(
              //   future: getSavedAppLanguage(),
              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //     if (snapshot.connectionState == ConnectionState.done) {
              //       return GestureDetector(
              //         onTap: () async {
              //           bool isLanguageSelected = false;
              //           await showDialog<void>(
              //             context: context,
              //             barrierDismissible: true,
              //             useSafeArea: true,
              //             // user must tap button!
              //             builder: (BuildContext context) {
              //               return AlertDialog(
              //                 insetPadding:
              //                     const EdgeInsets.symmetric(horizontal: 17),
              //                 backgroundColor: const Color(0xFFFFFFFF),
              //                 shape: const RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.all(
              //                     Radius.circular(20),
              //                   ),
              //                 ),
              //                 alignment: Alignment.center,
              //                 titleTextStyle: Constants.noDataTextStyle.copyWith(
              //                   fontSize: 18,
              //                   fontFamily: 'Inter',
              //                   fontStyle: FontStyle.normal,
              //                   fontWeight: FontWeight.w600,
              //                   color: const Color(0xFF565657),
              //                 ),
              //                 title: Text(
              //                   selectedAppLanguage!.toLowerCase() == 'hindi'
              //                       ? "अपनी पसंदीदा भाषा चुनें"
              //                       : 'Choose your preferred language',
              //                   textAlign: TextAlign.center,
              //                 ),
              //                 content: StatefulBuilder(
              //                   builder:
              //                       (BuildContext context, StateSetter setState) {
              //                     return Container(
              //                       padding: const EdgeInsets.only(bottom: 31),
              //                       width: MediaQuery.of(context).size.width,
              //                       child: FutureBuilder<List<AppLanguage>>(
              //                         future:
              //                             onBoardingRepository.fetchAppLanguages(),
              //                         builder: (context, languages) {
              //                           if (languages.connectionState ==
              //                                   ConnectionState.none &&
              //                               languages.hasData == null) {
              //                             return Container();
              //                           } else if (languages.hasData) {
              //                             return ListView.builder(
              //                                 physics:
              //                                     const NeverScrollableScrollPhysics(),
              //                                 itemCount: languages.data!.length,
              //                                 padding: const EdgeInsets.all(0),
              //                                 shrinkWrap: true,
              //                                 itemBuilder: (context, index) {
              //                                   if (languages.data!.length == 1) {
              //                                     selectedAppLanguage = "English";
              //                                   }
              //
              //                                   getLanguageTile(
              //                                       {required AppLanguage list,
              //                                       int? listLength}) {
              //                                     return GestureDetector(
              //                                       onTap: () async {
              //                                         setState(() {
              //                                           isLanguageSelected = true;
              //                                         });
              //
              //                                         if ((listLength! > 1)) {
              //                                           setState(() {
              //                                             list.isSelected =
              //                                                 !list.isSelected;
              //                                           });
              //                                           if (list.isSelected) {
              //                                             selectedAppLanguage =
              //                                                 list.languageName;
              //
              //                                             if (selectedAppLanguage !=
              //                                                 null) {
              //                                               await userRepository
              //                                                   .saveUserDetailToLocal(
              //                                                       'language',
              //                                                       selectedAppLanguage!
              //                                                           .toLowerCase());
              //
              //                                               appUser!.language =
              //                                                   selectedAppLanguage!
              //                                                       .toLowerCase();
              //                                               await userRepository
              //                                                   .updateUserProfileWithSelectedLanguage(
              //                                                       language:
              //                                                           selectedAppLanguage!
              //                                                               .toLowerCase());
              //                                               if (!mounted) return;
              //                                               Navigator.pop(context);
              //                                               return;
              //                                             } else {
              //                                               SnackbarMessages
              //                                                   .showErrorSnackbar(
              //                                                       context,
              //                                                       error: Constants
              //                                                           .languageSelectionAlert);
              //                                             }
              //                                           }
              //                                         }
              //                                       },
              //                                       child: CustomTile(
              //                                         selected: (listLength == 1)
              //                                             ? true
              //                                             : (list.languageName ==
              //                                                     selectedAppLanguage
              //                                                 ? true
              //                                                 : false),
              //                                         streamText: ((list
              //                                                     .languageName ==
              //                                                 "English")
              //                                             ? "English is my preferred language"
              //                                             : (list.languageName ==
              //                                                     "Hindi"
              //                                                 ? "हिंदी मेरी पसंदीदा भाषा है"
              //                                                 : list.languageName)),
              //                                         leadingWidgetRequired: true,
              //                                         leadingImagePath: ((list
              //                                                     .languageName ==
              //                                                 "English")
              //                                             ? "assets/images/english_char.png"
              //                                             : ((list.languageName ==
              //                                                     "Hindi")
              //                                                 ? "assets/images/hindi_char.png"
              //                                                 : null)),
              //                                         selectedColor: 0xFF22C59B,
              //                                       ),
              //                                     );
              //                                   }
              //
              //                                   return getLanguageTile(
              //                                     list: languages.data![index],
              //                                     listLength: languages.data!.length,
              //                                   );
              //                                 });
              //                           } else {
              //                             return Container(
              //                               alignment: Alignment.center,
              //                               child: const Text("Loading..."),
              //                             );
              //                           }
              //                         },
              //                       ),
              //                     );
              //                   },
              //                 ),
              //               );
              //             },
              //           ).then((value) async {
              //             if (isLanguageSelected == true) {
              //               await Navigator.pushAndRemoveUntil(
              //                 context,
              //                 CupertinoPageRoute(
              //                   builder: (context) => ((!usingIprepLibrary)
              //                       ? const DashboardScreen()
              //                       : const DashboardCoach(
              //                           selectedTabIndex: 1,
              //                         )),
              //                 ),
              //                 (Route<dynamic> route) => false,
              //               );
              //             }
              //           });
              //         },
              //         child: Container(
              //           height: 32,
              //           // width: 86,
              //           width: 60,
              //           decoration: BoxDecoration(
              //               color: const Color(0xFF0077FF).withOpacity(0.1),
              //               borderRadius: const BorderRadius.all(
              //                 Radius.circular(16),
              //               )),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               const SizedBox(
              //                 width: 3,
              //               ),
              //               Text(
              //                 (snapshot.data == "English" ||
              //                         snapshot.data == "english")
              //                     ? "Eng"
              //                     : "हिंदी",
              //                 style: TextStyle(
              //                   color: const Color(0xFF0077FF),
              //                   fontSize: 12,
              //                   fontWeight: FontWeight.values[5],
              //                 ),
              //               ),
              //               const SizedBox(
              //                 width: 2,
              //               ),
              //               RotationTransition(
              //                 turns: const AlwaysStoppedAnimation(90 / 360),
              //                 child: Image.asset(
              //                   'assets/images/forward_arrow.png',
              //                   height: 20,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     } else {
              //       return Container();
              //     }
              //   },
              // ),
              FutureBuilder(
                future: onBoardingRepository.fetchContentLanguages(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GestureDetector(
                      onTap: () async {
                        final isLanguageSelected =
                            selectedAppLanguage!.toLowerCase();
                        await showDialog<void>(
                          context: context,
                          barrierDismissible: true,

                          useSafeArea: true,
                          // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding:
                                  const EdgeInsets.symmetric(horizontal: 17),
                              backgroundColor: const Color(0xFFFFFFFF),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              alignment: Alignment.center,
                              titleTextStyle:
                                  Constants.noDataTextStyle.copyWith(
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF565657),
                              ),
                              title: Text(
                                selectedAppLanguage!.toLowerCase() == 'hindi'
                                    ? "अपनी पसंदीदा भाषा चुनें"
                                    : 'Choose your preferred language',
                                textAlign: TextAlign.center,
                              ),
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Container(
                                    padding: const EdgeInsets.only(bottom: 31),
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.width * .55,
                                    child: FutureBuilder<LanguageModel?>(
                                      future: onBoardingRepository
                                          .fetchContentLanguages(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<LanguageModel?>
                                              language) {
                                        Widget languageWidget;
                                        if (language.hasData) {
                                          String? selectedLanguage =
                                              selectedAppLanguage!
                                                  .toLowerCase();
                                          languageWidget = LanguageTile(
                                            language: language.data!.language,
                                            selectedLanguage: selectedLanguage,
                                            isOnBoarding: false,
                                          );
                                        } else if (!language.hasData) {
                                          languageWidget = Container(
                                            alignment: Alignment.center,
                                            child: const Text("Loading..."),
                                          );
                                        } else if (language.hasError) {
                                          languageWidget = Container(
                                            alignment: Alignment.center,
                                            child: const Text(
                                                "Something went wrong..."),
                                          );
                                        } else {
                                          languageWidget = Container(
                                            alignment: Alignment.center,
                                            child: const Text(
                                                "Something went wrong..."),
                                          );
                                        }
                                        return languageWidget;
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ).then((value) async {
                          if (isLanguageSelected !=
                              selectedAppLanguage!.toLowerCase()) {
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
                          }
                        });
                      },
                      child: Container(
                        height: 32,
                        // width: 86,
                        width: 60,
                        decoration: BoxDecoration(
                            color: const Color(0xFF0077FF).withOpacity(0.1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              selectedAppLanguage!.length > 3
                                  ? selectedAppLanguage
                                          ?.substring(0, 3)
                                          .toUpperCase() ??
                                      ""
                                  : selectedAppLanguage?.toUpperCase() ?? "",
                              style: TextStyle(
                                color: const Color(0xFF0077FF),
                                fontSize: 12,
                                fontWeight: FontWeight.values[5],
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            RotationTransition(
                              turns: const AlwaysStoppedAnimation(90 / 360),
                              child: Image.asset(
                                'assets/images/forward_arrow.png',
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
        Provider.of<TestProvider>(context).isLoading == true
            ? Container(
                height: 30,
                color: Colors.transparent,
              )
            : const SizedBox()
      ],
    ),
    centerTitle: false,
    actions: [
      Consumer<BellAnimationProvider>(builder: (_, bellAnimation, __) {
        return StreamBuilder(
          stream: dbRef
              .child("notification/students/${appUser!.userID}/")
              .orderByValue()
              .onValue,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              DataSnapshot dataValues = snapshot.data.snapshot;
              Map<dynamic, dynamic>? _values =
                  dataValues.value as Map<dynamic, dynamic>?;
              if (_values != null) {
                var _list = _values.entries.toList();
                bool _anyoneNotRead =
                    _list.any((element) => !element.value['message_opened']);

                if (!_anyoneNotRead &&
                    ((bellAnimation.localChatList != null) &&
                        (bellAnimation.localChatList.length > 0))) {
                  _anyoneNotRead = true;
                }

                if (bellAnimation.heartAnimationController.isAnimating) {
                  return AnimatedBuilder(
                    animation: bellAnimation.heartAnimationController,
                    builder: (context, child) {
                      return IconButton(
                        icon: Image.asset(
                          "assets/images/${_anyoneNotRead ? "notification" : "notification_bell_icon"}.png",
                          height: (_anyoneNotRead ? 32 : 28) *
                              bellAnimation.heartAnimationController.value,
                          width: (_anyoneNotRead ? 32 : 28) *
                              bellAnimation.heartAnimationController.value,
                        ),
                        onPressed: () async {
                          String? _userID = await getStringValuesSF("userID");
                          String? _userTypeNode =
                              await (userRepository.getUserNodeName());
                          if (!mounted) return;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NotificationPage(
                                userId: _userID,
                                userType: _userTypeNode,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return IconButton(
                    icon: Image.asset(
                      "assets/images/${_anyoneNotRead ? "notification" : "notification_bell_icon"}.png",
                      height: _anyoneNotRead ? 24 : 19,
                      width: _anyoneNotRead ? 24 : 18,
                    ),
                    onPressed: () async {
                      String? _userID = await getStringValuesSF("userID");
                      String? _userTypeNode =
                          await (userRepository.getUserNodeName());
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationPage(
                            userId: _userID,
                            userType: _userTypeNode,
                          ),
                        ),
                      );
                    },

                    /* onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => ChewieDemo()));
                    },*/
                  );
                }
              }
            }
            return Container(
              height: 0,
              width: 0,
            );
          },
        );
      })
    ],
  );
}
