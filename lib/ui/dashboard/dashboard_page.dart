// import 'dart:async';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:idream/common/references.dart';
// import 'package:idream/common/shared_preference.dart';
// import 'package:idream/common/snackbar_messages.dart';
// import 'package:idream/custom_widgets/app_bar.dart';
// import 'package:idream/custom_widgets/custom_pop_up.dart';
// import 'package:idream/custom_widgets/dashboard_test_widget.dart';
// import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
// import 'package:idream/custom_widgets/student_dashboard/continue_learning.dart';
// import 'package:idream/custom_widgets/subject_home_page_widget.dart';
// import 'package:idream/custom_widgets/web_view_page.dart';
// import 'package:idream/model/subject_model.dart';
// import 'package:idream/model/test_model.dart';
// import 'package:idream/provider/bell_animation_provider.dart';
// import 'package:idream/provider/network_provider.dart';
// import 'package:idream/provider/student/joined_batches_provider.dart';
// import 'package:idream/ui/bottom_bar_pages/joined_batches_page.dart';
// import 'package:idream/ui/dashboard/extra_books/extra_book_widget.dart';
// import 'package:idream/ui/dashboard/stem_videos/stem_projects_widget.dart';
// import 'package:idream/ui/iprep_store/iprep_store_page.dart';
// import 'package:idream/ui/menu/app_drawer.dart';
// import 'package:idream/ui/menu/my_reports_page.dart';
// import 'package:idream/common/constants.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../../common/global_variables.dart';
// import '../../custom_widgets/dialog_box.dart';
// import '../../model/boards_model.dart';
// import '../../model/extra_book_model.dart';
// import '../../model/streams_model.dart';
// import '../network_error_page.dart';
// import 'test_prep_web_page.dart';
//
// class DashboardScreen extends StatefulWidget {
//   final int dashboardTabIndex;
//   final bool firstTimeLanded;
//   const DashboardScreen(
//       {Key? key, this.firstTimeLanded = false, this.dashboardTabIndex = 0})
//       : super(key: key);
//
//   @override
//   DashboardScreenState createState() => DashboardScreenState();
// }
//
// class DashboardScreenState extends State<DashboardScreen>
//     with WidgetsBindingObserver, TickerProviderStateMixin {
//   late AnimationController animation;
//   late Animation<double> _fadeInFadeOut;
//
//   late int _currentIndex;
//   Timer? _timerLink;
//   Future? _subjectList;
//   Future? alreadyWatchedVideosData;
//   Future? _testPrepData;
//   late NetworkProvider networkProvider;
//   String? _userID;
//   Future _setGoogleAnalyticsProperties() async {
//     String? _userBoard = await getStringValuesSF('educationBoard');
//     String? _userID = await getStringValuesSF("userID");
//     setState(() {
//       this._userID = _userID;
//     });
//     analyticsRepository.setUserBoard(userBoard: _userBoard);
//
//     String? _username = await getStringValuesSF('fullName');
//     analyticsRepository.setUsername(username: _username);
//
//     String? _userEmail = await getStringValuesSF('email');
//     analyticsRepository.setUserEmail(userEmail: _userEmail);
//
//     String? _userMobile = await getStringValuesSF('mobileNumber');
//     analyticsRepository.setUserMobile(userMobile: _userMobile);
//
//     String? _userClass = await getStringValuesSF('classNumber');
//     analyticsRepository.setUserClass(userClass: _userClass);
//
//     String? _userCity = await getStringValuesSF('city');
//     debugPrint(_userCity);
//     analyticsRepository.setUserCity(userCity: _userCity);
//
//     String? _userState = await getStringValuesSF('state');
//     debugPrint(_userState);
//     analyticsRepository.setUserState(userState: _userState);
//   }
//
//   Future _checkUsersPlan() async {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       // String _planDuration = await getStringValuesSF("userPlanDuration");
//       // String _planStartDate = await getStringValuesSF("userPlanDateStarted");
//       // print(_planDuration + "\n" + _planStartDate);
//       // DateTime _dateTime = DateTime.parse(_upStartDate)
//       //     .add(Duration(days: int.parse(_upDuration)));
//
//       //TODO: Uncomment this line
//       // if (_dateTime.compareTo(DateTime.now()) < 0)
//       //   showTestSubmitBottomSheet(context: context);
//
//       await upgradePlanRepository.checkIfFunctionalityNeedsToBeBlocked();
//
//       //Check Deep Link Firebase Messaging
//       notificationRepository.handleNotificationOnTapEvent(context);
//       String? _token = await firebaseMessaging.getToken();
//       debugPrint(_token);
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     userRepository.clearLocalDataBase(context);
//     selectedAppLanguage = selectedAppLanguage ?? "english";
//     networkProvider = Provider.of<NetworkProvider>(context, listen: false);
//
//     if (!firstTimeLanded) firstTimeLanded = widget.firstTimeLanded;
//     usingIprepLibrary = false;
//
//     Provider.of<BellAnimationProvider>(context, listen: false)
//         .initialiseHearAnimation(this);
//
//     Provider.of<JoinedBatchesProvider>(context, listen: false)
//         .fetchJoinedBatches();
//     animation = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     );
//     _fadeInFadeOut =
//         Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//       parent: animation,
//       curve: Curves.easeIn,
//       reverseCurve: Curves.easeOut,
//     ));
//     animation.forward();
//
//     _currentIndex = 0;
//     _setGoogleAnalyticsProperties();
//     _checkUsersPlan();
//     _subjectList = dashboardRepository.fetchSubjectList();
//     userPermissions.notification();
//     newVersion.newUpdateCheck(context);
//     alreadyWatchedVideosData =
//         videoLessonRepository.fetchAlreadyWatchedVideoData();
//     _testPrepData = testRepository.fetchTestPrepPopularExamsList();
//     debugPrint(_testPrepData.toString());
//     WidgetsBinding.instance.addObserver(this);
//
//     dashboardRepository.fetchSubjectData()?.then((value) {
//       print(value);
//     });
//
//     if (widget.firstTimeLanded) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         welcomeMessagePopUp(context);
//         getUserLocation();
//       });
//     } else {
//       userProfileRepository.checkUserProfileData().then((value) async {
//         if (value != null && value == true) {
//           String languageValue = "Select Language";
//           String boardValue = "Select Board";
//           String classValue = "Select Class";
//           String streamValue = "Select Stream";
//
//           //
//           String? boardId;
//           String? streamId;
//           String? classId;
//
//           bool lisValid = false;
//           bool bisValid = false;
//           bool cisValid = false;
//           bool sisValid = false;
//
//           Future.wait([
//             classRepository.fetchClasses(),
//             apiHandler.getAPICall(endPointURL: "temp_boards"),
//             boardSelectionRepository.fetchLanuageList(),
//             apiHandler.getAPICall(endPointURL: "classes/cbse/english"),
//             apiHandler.getAPICall(endPointURL: "temp_streams"),
//           ]).then((value) async {
//             List<dynamic>? boardList = value[1];
//             List<String> languageList = value[2];
//             List<dynamic> classList = value[3];
//             List<dynamic>? boardsStreamList = value[4];
//
//             String? username = await getStringValuesSF('fullName');
//             Future.delayed(const Duration(milliseconds: 1)).then((value) {
//               bool streamEnable = false;
//               showDialog<void>(
//                 context: context,
//                 barrierDismissible: false, // user must tap button!
//                 builder: (BuildContext context) {
//                   return StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Scaffold(
//                           body: SingleChildScrollView(
//                             padding: const EdgeInsets.all(19.0),
//                             child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(
//                                     height: 41,
//                                   ),
//                                   Text(
//                                     "Hello ${username ?? " "}",
//                                     style: TextStyle(
//                                       color: const Color(0xFF212121),
//                                       fontWeight: FontWeight.values[5],
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   const Text(
//                                     'Kindly provide the following information to continue.',
//                                     style: TextStyle(
//                                         color: Color(0xFF575756), fontSize: 14),
//                                   ),
//                                   Container(
//                                     padding: const EdgeInsets.only(bottom: 5),
//                                     alignment: Alignment.bottomLeft,
//                                     height: 58,
//                                     child: const Text(
//                                       "What is your preferred language?",
//                                       style: TextStyle(
//                                           fontFamily: "Inter",
//                                           fontSize: 14,
//                                           color: Color(0xFF212121)),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 60,
//                                     child: DropdownButtonFormField(
//                                       dropdownColor: const Color(0xFFF4F4F4),
//                                       decoration: InputDecoration(
//                                         border: const OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10)),
//                                         ),
//                                         floatingLabelBehavior:
//                                             FloatingLabelBehavior.never,
//                                         labelText: 'Select your board',
//                                         labelStyle: TextStyle(
//                                           color:
//                                               const Color(0xFF9E9E9E), //#212121
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.values[4],
//                                         ),
//                                       ),
//                                       hint: Text(
//                                         languageValue.toUpperCase(),
//                                         style: TextStyle(
//                                           color: const Color(0xFF212121),
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.values[3],
//                                         ),
//                                       ),
//                                       isExpanded: true,
//                                       // iconSize: 10.0,
//                                       style: TextStyle(
//                                         color: const Color(0xFF212121),
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.values[3],
//                                       ),
//                                       elevation: 0,
//                                       items: languageList.map(
//                                         (val) {
//                                           return DropdownMenuItem<String>(
//                                             value: val.toUpperCase(),
//                                             child: Text(val.toUpperCase()),
//                                           );
//                                         },
//                                       ).toList(),
//                                       onChanged: (dynamic val) {
//                                         setState(() {
//                                           languageValue = val.toString();
//                                           lisValid = true;
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                   Container(
//                                     padding: const EdgeInsets.only(bottom: 5),
//                                     alignment: Alignment.bottomLeft,
//                                     height: 58,
//                                     child: const Text(
//                                       "Select your board",
//                                       style: TextStyle(
//                                           fontFamily: "Inter",
//                                           fontSize: 14,
//                                           color: Color(0xFF212121)),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 60,
//                                     child: DropdownButtonFormField(
//                                       dropdownColor: const Color(0xFFF4F4F4),
//                                       decoration: InputDecoration(
//                                         border: const OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10)),
//                                         ),
//                                         floatingLabelBehavior:
//                                             FloatingLabelBehavior.never,
//                                         labelStyle: TextStyle(
//                                           color:
//                                               const Color(0xFF9E9E9E), //#212121
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.values[4],
//                                         ),
//                                       ),
//                                       hint: Text(
//                                         boardValue.toUpperCase(),
//                                         style: TextStyle(
//                                           color: const Color(0xFF212121),
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.values[3],
//                                         ),
//                                       ),
//                                       isExpanded: true,
//                                       // iconSize: 10.0,
//                                       style: TextStyle(
//                                         color: const Color(0xFF212121),
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.values[3],
//                                       ),
//                                       elevation: 0,
//                                       items: boardList!.map(
//                                         (val) {
//                                           return DropdownMenuItem<String>(
//                                             value: val['name'].toUpperCase(),
//                                             child:
//                                                 Text(val['name'].toUpperCase()),
//                                           );
//                                         },
//                                       ).toList(),
//                                       onChanged: (dynamic val) {
//                                         setState(() {
//                                           boardValue = val.toString();
//                                           bisValid = true;
//                                         });
//
//                                         for (var element in boardList) {
//                                           if (element['name']!.toUpperCase() ==
//                                               boardValue) {
//                                             boardId = element['abbr'];
//                                           }
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                   Container(
//                                     padding: const EdgeInsets.only(bottom: 5),
//                                     alignment: Alignment.bottomLeft,
//                                     height: 58,
//                                     child: const Text(
//                                       "Which class do you study in ",
//                                       style: TextStyle(
//                                           fontFamily: "Inter",
//                                           fontSize: 14,
//                                           color: Color(0xFF212121)),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 60,
//                                     child: DropdownButtonFormField(
//                                       dropdownColor: const Color(0xFFF4F4F4),
//
//                                       // dropdownColor: Colors.transparent,
//
//                                       decoration: InputDecoration(
//                                         border: const OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10)),
//                                         ),
//                                         floatingLabelBehavior:
//                                             FloatingLabelBehavior.never,
//                                         labelText:
//                                             'Which class do you study in ',
//                                         labelStyle: TextStyle(
//                                           color:
//                                               const Color(0xFF9E9E9E), //#212121
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.values[4],
//                                         ),
//                                       ),
//
//                                       hint: Text(
//                                         classValue.toUpperCase(),
//                                         style: TextStyle(
//                                           color: const Color(0xFF212121),
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.values[3],
//                                         ),
//                                       ),
//                                       isExpanded: true,
//                                       // iconSize: 10.0,
//                                       style: TextStyle(
//                                         color: const Color(0xFF212121),
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.values[3],
//                                       ),
//                                       elevation: 0,
//                                       items: classList.map(
//                                         (val) {
//                                           return DropdownMenuItem<String>(
//                                               value: val['name'].toUpperCase(),
//                                               child: Text(
//                                                   val['name'].toUpperCase()));
//                                         },
//                                       ).toList(),
//                                       onChanged: (dynamic val) {
//                                         setState(() {
//                                           classValue = val.toString();
//                                           cisValid = true;
//                                         });
//
//                                         setState(() {
//                                           streamEnable = false;
//                                         });
//
//                                         for (var element in classList) {
//                                           if (element['name'].toUpperCase() ==
//                                               val) {
//                                             classId = element['id'];
//                                             if (int.tryParse(classId!)! > 10) {
//                                               setState(() {
//                                                 streamEnable = true;
//                                               });
//                                             }
//                                           }
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                   if (streamEnable == true) ...[
//                                     Container(
//                                       padding: const EdgeInsets.only(bottom: 5),
//                                       alignment: Alignment.bottomLeft,
//                                       height: 58,
//                                       child: const Text(
//                                         "Select your stream",
//                                         style: TextStyle(
//                                             fontFamily: "Inter",
//                                             fontSize: 14,
//                                             color: Color(0xFF212121)),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 60,
//                                       child: DropdownButtonFormField(
//                                         dropdownColor: const Color(0xFFF4F4F4),
//                                         decoration: InputDecoration(
//                                           enabled: streamEnable,
//                                           border: const OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(10)),
//                                           ),
//                                           floatingLabelBehavior:
//                                               FloatingLabelBehavior.never,
//                                           labelText:
//                                               'Which class do you study in ',
//                                           labelStyle: TextStyle(
//                                             color: const Color(
//                                                 0xFF9E9E9E), //#212121
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.values[4],
//                                           ),
//                                         ),
//                                         hint: Text(
//                                           streamValue.toUpperCase(),
//                                           style: TextStyle(
//                                             color: const Color(0xFF212121),
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.values[3],
//                                           ),
//                                         ),
//                                         isExpanded: true,
//                                         // iconSize: 10.0,
//                                         style: TextStyle(
//                                           color: const Color(0xFF212121),
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.values[3],
//                                         ),
//                                         elevation: 0,
//                                         items: boardsStreamList!.map(
//                                           (val) {
//                                             return DropdownMenuItem<String>(
//                                               value: val["name"]!.toUpperCase(),
//                                               child: Text(
//                                                   val["name"]!.toUpperCase()),
//                                             );
//                                           },
//                                         ).toList(),
//                                         onChanged: (dynamic val) {
//                                           setState(() {
//                                             streamValue = val.toString();
//                                             sisValid = true;
//                                           });
//
//                                           for (var element
//                                               in boardsStreamList) {
//                                             if (element["name"].toUpperCase() ==
//                                                 val) {
//                                               streamId = element["id"];
//                                             }
//                                           }
//                                         },
//                                       ),
//                                     )
//                                   ],
//                                   OnBoardingBottomButton(
//                                     buttonColor: (lisValid == true &&
//                                                 bisValid == true &&
//                                                 cisValid == true) ==
//                                             true
//                                         ? (streamEnable == sisValid)
//                                             ? 0xFF0077FF
//                                             : 0xFFFFFFF
//                                         : 0xFFFFFFF,
//                                     topPadding: 40,
//                                     onPressed: () {
//                                       if (lisValid == true &&
//                                           bisValid == true &&
//                                           cisValid == true &&
//                                           (streamEnable == sisValid)) {
//                                         debugPrint(languageValue);
//                                         debugPrint(boardId);
//                                         debugPrint(classId);
//                                         debugPrint(streamId);
//                                         userProfileRepository
//                                             .updateUserProfile(
//                                           classNumber: classId!,
//                                           stream: streamId.toString(),
//                                           language: languageValue.toLowerCase(),
//                                           board: boardId!,
//                                         )
//                                             .then((value) {
//                                           if (value == true) {
//                                             Navigator.pop(context);
//                                           }
//                                         });
//                                       } else {
//                                         SnackbarMessages.showErrorSnackbar(
//                                           context,
//                                           error: Constants.allField,
//                                         );
//                                       }
//                                     },
//                                     buttonText: "Finish",
//                                   )
//                                 ]),
//                           ),
//                         ),
//                       ),
//                     );
//                   });
//                 },
//               );
//             });
//           });
//         }
//       });
//     }
//     initDynamicLinks(context);
//   }
//
//   getUserLocation() async {
//     try {
//       await userProfileRepository.setUserProfile();
//       await userLocationRepository.determinePosition().then((value) async {
//         await userProfileRepository.saveUserLocation();
//       });
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       debugPrint('videoProvider');
//       _timerLink = Timer(
//         const Duration(seconds: 1),
//         () {
//           initDynamicLinks(context);
//         },
//       );
//     } else {}
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     if (_timerLink != null) {
//       _timerLink?.cancel();
//     }
//
//     super.dispose();
//   }
//
//   @override
//   void deactivate() {
//     print("Deactivate");
//     super.deactivate();
//   }
//
//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//
//   initDynamicLinks(BuildContext context) async {
//     dynamicLinks.onLink.listen((dynamicLinkData) {
//       Uri deepLinkData = dynamicLinkData.link;
//       var queryParams = deepLinkData.queryParameters;
//       if (queryParams.isNotEmpty) {
//         _fetchParameters(queryParams: queryParams);
//       }
//     }).onError((error) {
//       debugPrint('onLink error');
//       debugPrint(error.message);
//     });
//   }
//
//   Future _fetchParameters({Map? queryParams}) async {
//     String? referUserID = queryParams!['userID'];
//     String? referralCode = queryParams['referralCode'];
//     String? referUsername = queryParams['fullName'];
//     String? referUserType = queryParams['userType'];
//     if (referralCode != null) {
//       await shareEarnRepository.depositEarningAmount(
//           referUserID: referUserID,
//           referralUserCode: referralCode,
//           referUsername: referUsername,
//           referUserType: referUserType);
//     } else {
//       String? batchId = queryParams['batchId'];
//       String? teacherId = queryParams['teacherId'];
//       String? teacherName = queryParams['teacherName'];
//       debugPrint(teacherName.toString());
//       if (batchId != null) {
//         //Save student join info...
//         var response = await batchRepository.addStudentToSelectedBatch(
//             batchId: batchId, teacherId: teacherId!);
//         if (response != null && response) {
//           if (!mounted) return;
//           Provider.of<JoinedBatchesProvider>(context, listen: false)
//               .fetchJoinedBatches();
//           if (!mounted) return;
//           SnackbarMessages.showSuccessSnackbar(
//             context,
//             message: Constants.studentBatchJoiningSuccess,
//           );
//         }
//       }
//     }
//   }
//
//   mainDashboardPageWidget() {
//     return Container(
//       padding: const EdgeInsets.only(
//         // top: 24,
//         left: 16,
//         right: 15,
//       ),
//       child: ListView(
//         padding: const EdgeInsets.all(0),
//         children: [
//           const SizedBox(
//             height: 20,
//           ),
//           RichText(
//             text: TextSpan(
//               style: TextStyle(
//                 fontFamily: GoogleFonts.inter().fontFamily,
//                 color: const Color(0xFF212121),
//                 fontSize: 17,
//               ),
//               children: [
//                 TextSpan(
//                   text: selectedAppLanguage!.toLowerCase() == 'hindi'
//                       ? "आपका "
//                       : 'Your ',
//                   style: TextStyle(
//                     fontWeight: FontWeight.values[4],
//                   ),
//                 ),
//                 TextSpan(
//                   text: selectedAppLanguage!.toLowerCase() == 'hindi'
//                       ? " विषय"
//                       : ' Subjects',
//                   style: TextStyle(
//                     fontWeight: FontWeight.values[5],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           getSubjectListWidgets(dashboardScreenState),
//           FutureBuilder(
//             future: _testPrepData,
//             builder: (context, testData) {
//               List<Widget> testPrepWidget = [];
//               CookieManager cookieManager = CookieManager();
//
//               if (testData.hasData) {
//                 testPrepWidget.add(
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           RichText(
//                             text: TextSpan(
//                               style: TextStyle(
//                                 fontFamily: GoogleFonts.inter().fontFamily,
//                                 color: const Color(0xFF212121),
//                                 fontSize: 17,
//                               ),
//                               children: [
//                                 TextSpan(
//                                   text: selectedAppLanguage!.toLowerCase() ==
//                                           'hindi'
//                                       ? "आपका "
//                                       : 'Your ',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.values[4],
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: selectedAppLanguage!.toLowerCase() ==
//                                           'hindi'
//                                       ? "परीक्षण की तैयारी"
//                                       : 'Test Preparations',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.values[5],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           InkWell(
//                             borderRadius: BorderRadius.circular(7),
//                             onTap: () async {
//                               // String? _baseUrlParam = await (dashboardRepository
//                               //     .prepQueryParameterStringForTestPrep());
//
//                               String? userName =
//                                   await getStringValuesSF("fullName");
//                               String? userEmail =
//                                   await getStringValuesSF("email");
//                               String? userMobileNo =
//                                   await getStringValuesSF("mobileNumber");
//                               String? userProfileImage =
//                                   await getStringValuesSF("profilePhoto");
//
//                               userMobileNo =
//                                   userMobileNo!.replaceAll("+91-", "");
//
//                               CookieManager? cookieManager = CookieManager();
//
//                               late WebViewCookie? sessionCookie = WebViewCookie(
//                                   name: 'ip_user',
//                                   value:
//                                       "${userName?.trim() ?? "John Doe"}|${userEmail ?? ""}|${userMobileNo ?? '1234567890'}|${userProfileImage ?? 'https://secure.gravatar.com/avatar/?s=96&d=mm'}|${userEmail != null ? "email" : "phone"}",
//                                   domain: '.iprep.in',
//                                   path: "/");
//
//                               cookieManager.setCookie(sessionCookie);
//
//                               if (!mounted) return;
//                               await Navigator.push(
//                                 context,
//                                 CupertinoPageRoute(
//                                   builder: (context) => TestPrepWebPage(
//                                     link: Constants.testPrepBaseUrl,
//                                     cookieManager: cookieManager,
//                                   ),
//                                 ),
//                               );
//                               // if (!mounted) return;
//                               // await Navigator.push(
//                               //   context,
//                               //   CupertinoPageRoute(
//                               //     builder: (context) => WebViewExample(
//                               //       link: Constants.testPrepBaseUrl,
//                               //       cookieManager: cookieManager,
//                               //     ),
//                               //   ),
//                               // );
//                             },
//                             child: Image.asset(
//                               "assets/images/forward_icon.png",
//                               height: 25,
//                               width: 25,
//                             ),
//                           ),
//                         ],
//                       ),
//                       getTestWidgets(
//                           testPrepData: testData.data as List<TestPrepModel>?),
//                     ],
//                   ),
//                 );
//               } else if (testData.connectionState == ConnectionState.waiting ||
//                   testData.connectionState == ConnectionState.none) {
//                 testPrepWidget.add(
//                   Shimmer.fromColors(
//                     baseColor: Colors.grey[300]!,
//                     highlightColor: Colors.grey[100]!,
//                     enabled: true,
//                     period: const Duration(seconds: 1),
//                     child: Container(
//                       margin: const EdgeInsets.only(
//                         bottom: 18,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                               bottom: 18,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Test Preparations',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.values[5],
//                                     fontFamily: GoogleFonts.inter().fontFamily,
//                                     color: const Color(0xFF212121),
//                                     fontSize: 17,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Wrap(
//                             children: List.generate(6, (index) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 4, top: 8, right: 8),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.grey[100]!,
//                                   ),
//                                   height: 40,
//                                   width: 150,
//                                 ),
//                               );
//
//                               /*  ExtraBooksWidget(
//                               extraBookModel: ExtraBookModel(
//                                   subjectName: "Subject Name",
//                                   bookList: [
//                                     ExtraBooks(topics: [Topics()])
//                                   ]),
//                               subjectImagePath: "assets/images/physics.png",
//                               subjectColor: 0xFFFCAC52,
//                             );*/
//                             }),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               } /*else if (!testData.hasData) {
//                 testPrepWidget.add(
//                   Container(
//                     margin: const EdgeInsets.only(
//                       bottom: 18,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(
//                             bottom: 18,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Test Preparations',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.values[5],
//                                   fontFamily: GoogleFonts.inter().fontFamily,
//                                   color: const Color(0xFF212121),
//                                   fontSize: 17,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Wrap(
//                           children: List.generate(
//                             6,
//                             (index) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 4, top: 8, right: 8),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.grey[100]!,
//                                   ),
//                                   height: 40,
//                                   width: 150,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }*/
//               return Column(
//                 children: testPrepWidget,
//               );
//             },
//           ),
//           ExtraBooksContainer(),
//           StemProjectsWidget(),
//           StatefulBuilder(
//               builder: (BuildContext context, StateSetter _setState) {
//             return StreamBuilder(
//                 stream: videoLessonRepository.getUserVideoWatchDetails(),
//                 builder: (context, snapshot) {
//                   return FutureBuilder(
//                     future:
//                         videoLessonRepository.fetchAlreadyWatchedVideoData(),
//                     builder: (BuildContext context, AsyncSnapshot snapshot) {
//                       if (snapshot.connectionState == ConnectionState.done &&
//                           snapshot.data != null) {
//                         return FadeTransition(
//                           opacity: _fadeInFadeOut,
//                           child: ContinueLearningVideosWidget(
//                             videoData: snapshot.data,
//                             dashboardScreenState: dashboardScreenState,
//                             stateSetter: _setState,
//                           ),
//                         );
//                       } else {
//                         return Container();
//                       }
//                     },
//                   );
//                 });
//           }),
//           FutureBuilder(
//             future: alreadyWatchedVideosData,
//             builder: (context, subjects) {
//               if (subjects.connectionState == ConnectionState.done) {
//                 return FadeTransition(
//                   opacity: _fadeInFadeOut,
//                   child: getShareAppWidget(),
//                 );
//               } else {
//                 return Container();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   getCurrentPageWidget() {
//     switch (_currentIndex) {
//       case 0:
//         return mainDashboardPageWidget();
//       case 1:
//         return const JoinedBatchesPage();
//       case 2:
//         return const MyReportsPage();
//       case 3:
//         return const IPrepStorePage();
//     }
//   }
//
//   getCurrentPageWidgetWithoutBatch() {
//     switch (_currentIndex) {
//       case 0:
//         return mainDashboardPageWidget();
//       case 1:
//         return const MyReportsPage();
//       case 2:
//         return const IPrepStorePage();
//     }
//   }
//
//   Future<bool> _onBackPressed() {
//     AlertPopUp(
//       context: context,
//       title: "",
//       desc: "Are you sure you want to exit?",
//       buttons: [
//         DialogButton(
//           onPressed: () async {
//             Navigator.pop(context);
//           },
//           gradient: const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF0077FF), Color(0xFF0077FF)],
//           ),
//           child: const Text(
//             "No",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ),
//         DialogButton(
//           onPressed: () async {
//             userLoginRepository.userLastLogin();
//             SystemNavigator.pop();
//           },
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.blueGrey[400]!,
//               Colors.blueGrey[400]!,
//             ],
//           ),
//           child: const Text(
//             "Yes",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         )
//       ],
//     ).show();
//
//     return Future.value(true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     dashboardScreenState = this;
//     return WillPopScope(
//       onWillPop: _onBackPressed,
//       child: Container(
//         color: Colors.white,
//         child: Consumer<NetworkProvider>(
//           builder: (context, networkProvider, child) => networkProvider
//                       .isAvailable ==
//                   true
//               ? SafeArea(
//                   top: false,
//                   bottom: false,
//                   child: Consumer<JoinedBatchesProvider>(
//                     builder: (context, joinedBatchesProviderModel, child) =>
//                         Scaffold(
//                       backgroundColor: Colors.white,
//                       drawer: AppDrawer(
//                         dashboardScreenState: dashboardScreenState,
//                       ),
//                       // appBar: customAppBar(mounted, context, this)
//                       //     as PreferredSizeWidget?,
//                       appBar: (joinedBatchesProviderModel.joinedBatches == null)
//                           ? _currentIndex == 2
//                               ? null
//                               : customAppBar(mounted, context, this)
//                                   as PreferredSizeWidget?
//                           : customAppBar(mounted, context, this)
//                               as PreferredSizeWidget?,
//                       body: (joinedBatchesProviderModel.joinedBatches != null)
//                           ? getCurrentPageWidget()
//                           : getCurrentPageWidgetWithoutBatch(),
//                       bottomNavigationBar: BottomNavigationBar(
//                         backgroundColor: const Color(0xFFFFFFFF),
//                         currentIndex: _currentIndex,
//                         showUnselectedLabels: true,
//                         unselectedItemColor: const Color(0xFF212121),
//                         selectedItemColor: const Color(0xFF212121),
//                         selectedIconTheme: const IconThemeData(
//                           color: Color(0xFF3399ff),
//                         ),
//                         unselectedIconTheme:
//                             const IconThemeData(color: Color(0xFF212121)),
//                         unselectedFontSize: 10,
//                         selectedFontSize: 10,
//                         onTap: (index) async {
//                           setState(() {
//                             _currentIndex = index;
//                           });
//                         },
//                         items: [
//                           BottomNavigationBarItem(
//                             icon: Image.asset(
//                               "assets/images/home.png",
//                               height: 24,
//                               width: 24,
//                             ),
//                             label: 'Home',
//                             activeIcon: Image.asset(
//                               "assets/images/home_selected.png",
//                               height: 24,
//                               width: 24,
//                             ),
//                           ),
//                           if (joinedBatchesProviderModel.joinedBatches != null)
//                             BottomNavigationBarItem(
//                               icon: Image.asset(
//                                 "assets/images/my_batch_icon.png",
//                                 height: 24,
//                                 width: 24,
//                               ),
//                               label: 'My Batch',
//                               activeIcon: Image.asset(
//                                 "assets/images/my_batch_icon_selected.png",
//                                 height: 24,
//                                 width: 24,
//                               ),
//                             ),
//                           //TODO: Commenting out below code for postponing this functionality for future
//
//                           BottomNavigationBarItem(
//                             icon: Image.asset(
//                               "assets/images/my_report_icon.png",
//                               height: 24,
//                               width: 24,
//                             ),
//                             label: 'My Reports',
//                             activeIcon: Image.asset(
//                               "assets/images/my_report_icon_selected.png",
//                               height: 24,
//                               width: 24,
//                             ),
//                           ),
//                           BottomNavigationBarItem(
//                             icon: SvgPicture.asset(
//                               "assets/image/iPrep_Store.svg",
//                               height: 24,
//                               width: 24,
//                             ),
//                             label: 'iPrep Store',
//                             activeIcon: SvgPicture.asset(
//                               "assets/image/s_iPrep_Store.svg",
//                               // height: 24,
//                               // width: 24,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ) /*CustomBottomNavigationBar()*/,
//                   ),
//                 )
//               : const NetworkError(),
//         ),
//       ),
//     );
//   }
//
//   getSubjectListWidgets(DashboardScreenState? dashboardScreenState) {
//     return ResponsiveBuilder(
//       builder: (context, sizingInformation) {
//         // Check the sizing information here and return your UI
//         if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
//           return Container(color: Colors.blue);
//         }
//
//         if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
//           return Container(
//             padding: const EdgeInsets.only(top: 10, bottom: 10),
//             child: Column(
//               children: [
//                 FutureBuilder(
//                   initialData: 0,
//                   future: _subjectList,
//                   builder: (context, subjects) {
//                     Widget? subjectWidget;
//                     if (subjects.connectionState == ConnectionState.none) {
//                       subjectWidget = Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         enabled: true,
//                         period: const Duration(seconds: 2),
//                         child: Wrap(
//                           crossAxisAlignment: WrapCrossAlignment.start,
//                           alignment: WrapAlignment.start,
//                           children: List.generate(
//                               8,
//                               (index) => SubjectWidget(
//                                     dashboardScreenState: dashboardScreenState,
//                                     subjectImagePath:
//                                         Constants.defaultSubjectImagePath,
//                                     subjectName: "",
//                                     subjectColor:
//                                         Constants.defaultSubjectHexColor,
//                                     subjectID: "",
//                                     subjectShortName: "",
//                                   )
//
//                               /* Padding(
//                               padding: const EdgeInsets.only(
//                                   right: 8, bottom: 8, top: 4),
//                               child: Container(
//                                 height: 70,
//                                 width: 70,
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey.shade100,
//                                     borderRadius: BorderRadius.circular(10)),
//                               ),
//                             ),*/
//                               ),
//                         ),
//                       );
//                     } else if (subjects.connectionState ==
//                         ConnectionState.waiting) {
//                       subjectWidget = Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         enabled: true,
//                         period: const Duration(seconds: 2),
//                         child: Wrap(
//                           crossAxisAlignment: WrapCrossAlignment.start,
//                           alignment: WrapAlignment.start,
//                           children: List.generate(
//                               8,
//                               (index) => SubjectWidget(
//                                     dashboardScreenState: dashboardScreenState,
//                                     subjectImagePath:
//                                         Constants.defaultSubjectImagePath,
//                                     subjectName: "",
//                                     subjectColor:
//                                         Constants.defaultSubjectHexColor,
//                                     subjectID: "",
//                                     subjectShortName: "",
//                                   )
//
//                               /* Padding(
//                               padding: const EdgeInsets.only(
//                                   right: 8, bottom: 8, top: 4),
//                               child: Container(
//                                 height: 70,
//                                 width: 70,
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey.shade100,
//                                     borderRadius: BorderRadius.circular(10)),
//                               ),
//                             ),*/
//                               ),
//                         ),
//                       );
//                     } else if (!subjects.hasData) {
//                       subjectWidget = Container(
//                         alignment: Alignment.center,
//                         child:
//                             const Text("No data available. Please try later."),
//                       );
//                     } else if (subjects.hasData) {
//                       List<SubjectModel>? subjectList =
//                           subjects.data as List<SubjectModel>?;
//                       // subjectWidget = Wrap(
//                       //   crossAxisAlignment: WrapCrossAlignment.start,
//                       //   alignment: WrapAlignment.start,
//                       //
//                       //   // spacing: 10,
//                       //   // runSpacing: 10,
//                       //   // crossAxisAlignment: WrapCrossAlignment.start,
//                       //   children: List.generate(
//                       //     subjectList!.length,
//                       //     (index) {
//                       //       return SubjectWidget(
//                       //         dashboardScreenState: dashboardScreenState,
//                       //         subjectImagePath:
//                       //             (subjectList[index].subjectIconPath != null &&
//                       //                     subjectList[index]
//                       //                         .subjectIconPath!
//                       //                         .isNotEmpty)
//                       //                 ? subjectList[index].subjectIconPath
//                       //                 : Constants.defaultSubjectImagePath,
//                       //         subjectName: subjectList[index].subjectName,
//                       //         subjectColor:
//                       //             (subjectList[index].subjectColor != null &&
//                       //                     subjectList[index]
//                       //                         .subjectColor!
//                       //                         .isNotEmpty)
//                       //                 ? (int.parse(
//                       //                         subjectList[index]
//                       //                             .subjectColor!
//                       //                             .substring(1, 7),
//                       //                         radix: 16) +
//                       //                     0xFF000000)
//                       //                 : Constants.defaultSubjectHexColor,
//                       //         subjectID: subjectList[index].subjectID,
//                       //         subjectShortName:
//                       //             subjectList[index].shortName ?? "",
//                       //       );
//                       //     },
//                       //     growable: true,
//                       //   ),
//                       // );
//                       subjectWidget = Wrap(
//                         crossAxisAlignment: WrapCrossAlignment.start,
//                         alignment: WrapAlignment.start,
//
//                         // spacing: 10,
//                         // runSpacing: 10,
//                         // crossAxisAlignment: WrapCrossAlignment.start,
//                         children: List.generate(
//                           subjectList!.length,
//                           (index) {
//                             return SubjectWidget(
//                               dashboardScreenState: dashboardScreenState,
//                               subjectImagePath:
//                                   (subjectList[index].subjectIconPath != null &&
//                                           subjectList[index]
//                                               .subjectIconPath!
//                                               .isNotEmpty)
//                                       ? subjectList[index].subjectIconPath
//                                       : Constants.defaultSubjectImagePath,
//                               subjectName: subjectList[index].subjectName,
//                               subjectColor:
//                                   (subjectList[index].subjectColor != null &&
//                                           subjectList[index]
//                                               .subjectColor!
//                                               .isNotEmpty)
//                                       ? (int.parse(
//                                               subjectList[index]
//                                                   .subjectColor!
//                                                   .substring(1, 7),
//                                               radix: 16) +
//                                           0xFF000000)
//                                       : Constants.defaultSubjectHexColor,
//                               subjectID: subjectList[index].subjectID,
//                               subjectShortName:
//                                   subjectList[index].shortName ?? "",
//                             );
//                           },
//                           growable: true,
//                         ),
//                       );
//                     }
//
//                     return Container(
//                       child: subjectWidget,
//                     );
//                     return Wrap(
//                       crossAxisAlignment: WrapCrossAlignment.start,
//                       alignment: WrapAlignment.start,
//                       spacing: 25,
//                       runSpacing: 10,
//                       children: List.generate(
//                         10,
//                         (index) => Container(
//                           height: 70,
//                           width: 70,
//                           decoration: BoxDecoration(
//                               color: Colors.grey.shade100,
//                               borderRadius: BorderRadius.circular(10)),
//                         ),
//                         growable: true,
//                       ),
//                     );
//                   },
//                 )
//               ],
//             ),
//           );
//         }
//         if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
//           return Container(
//             padding: const EdgeInsets.only(top: 10, bottom: 10),
//             child: Column(
//               children: [
//                 FutureBuilder(
//                   initialData: 0,
//                   future: _subjectList,
//                   builder: (context, subjects) {
//                     Widget? subjectWidget;
//                     if (subjects.connectionState == ConnectionState.none) {
//                       subjectWidget = Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         enabled: true,
//                         period: const Duration(seconds: 2),
//                         child: Wrap(
//                           crossAxisAlignment: WrapCrossAlignment.start,
//                           alignment: WrapAlignment.start,
//                           children: List.generate(
//                             8,
//                             (index) => Padding(
//                               padding: const EdgeInsets.only(
//                                   right: 8, bottom: 8, top: 4),
//                               child: Container(
//                                 height: 70,
//                                 width: 70,
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey.shade100,
//                                     borderRadius: BorderRadius.circular(10)),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     } else if (subjects.connectionState ==
//                         ConnectionState.waiting) {
//                       subjectWidget = Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         enabled: true,
//                         period: const Duration(seconds: 2),
//                         child: Wrap(
//                           crossAxisAlignment: WrapCrossAlignment.start,
//                           alignment: WrapAlignment.start,
//                           children: List.generate(
//                             8,
//                             (index) => Padding(
//                               padding: const EdgeInsets.only(
//                                   right: 8, bottom: 8, top: 4),
//                               child: Container(
//                                 height: 70,
//                                 width: 70,
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey.shade100,
//                                     borderRadius: BorderRadius.circular(10)),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     } else if (!subjects.hasData) {
//                       subjectWidget = Container(
//                         alignment: Alignment.center,
//                         child:
//                             const Text("No data available. Please try later."),
//                       );
//                     } else if (subjects.hasData) {
//                       List<SubjectModel>? subjectList =
//                           subjects.data as List<SubjectModel>?;
//                       subjectWidget = GridView.builder(
//                         padding: const EdgeInsets.all(0),
//                         physics: const NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: subjectList!.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 4,
//                           mainAxisSpacing: 0,
//                           crossAxisSpacing: 0,
//                           childAspectRatio: 0.75,
//                         ),
//                         itemBuilder: (BuildContext context, index) {
//                           return SubjectWidget(
//                             dashboardScreenState: dashboardScreenState,
//                             subjectImagePath:
//                                 (subjectList[index].subjectIconPath != null &&
//                                         subjectList[index]
//                                             .subjectIconPath!
//                                             .isNotEmpty)
//                                     ? subjectList[index].subjectIconPath
//                                     : Constants.defaultSubjectImagePath,
//                             subjectName: subjectList[index].subjectName,
//                             subjectColor: (subjectList[index].subjectColor !=
//                                         null &&
//                                     subjectList[index].subjectColor!.isNotEmpty)
//                                 ? (int.parse(
//                                         subjectList[index]
//                                             .subjectColor!
//                                             .substring(1, 7),
//                                         radix: 16) +
//                                     0xFF000000)
//                                 : Constants.defaultSubjectHexColor,
//                             subjectID: subjectList[index].subjectID,
//                             subjectShortName:
//                                 subjectList[index].shortName ?? "",
//                           );
//                         },
//                       );
//                     }
//
//                     return Container(
//                       child: subjectWidget,
//                     );
//                     /* return Wrap(
//                 crossAxisAlignment: WrapCrossAlignment.start,
//                 alignment: WrapAlignment.start,
//                 spacing: 25,
//                 runSpacing: 10,
//                 children: List.generate(
//                   10,
//                   (index) => Container(
//                     height: 70,
//                     width: 70,
//                     decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   growable: true,
//                 ),
//               );*/
//                   },
//                 )
//               ],
//             ),
//           );
//         }
//
//         return Container(color: Colors.purple);
//       },
//     );
//   }
//
//   getTestWidgets({List<TestPrepModel>? testPrepData}) {
//     return Container(
//       padding: const EdgeInsets.only(
//         top: 18,
//         bottom: 18,
//       ),
//       child: GridView.count(
//         shrinkWrap: true,
//         crossAxisCount: 2,
//         mainAxisSpacing: 16,
//         crossAxisSpacing: 16,
//         physics: const NeverScrollableScrollPhysics(),
//         childAspectRatio: 164 / 66,
//         children: List.generate(
//           testPrepData!.length,
//           (index) {
//             return TestWidget(
//               testName: testPrepData[index].name,
//               testId: testPrepData[index].id,
//               testImagePath: testPrepData[index].icon,
//               testWebLink: testPrepData[index].href,
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget getShareAppWidget() {
//     return Padding(
//       padding: const EdgeInsets.only(
//         bottom: 0,
//       ),
//       child: Stack(
//         children: [
//           Image.asset(
//             "assets/images/share_image.png",
//             height: 212,
//             width: double.maxFinite,
//             fit: BoxFit.scaleDown,
//           ),
//           InkWell(
//             onTap: () async {
//               var _deepLinkUrl =
//                   await shareEarnRepository.prepareDeepLinkForAppDownload();
//               await shareEarnRepository.shareContent(
//                   context: context, content: _deepLinkUrl.toString());
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(
//                 top: 15,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     selectedAppLanguage!.toLowerCase() == 'hindi'
//                         ? "iPrep . डाउनलोड करने के लिए अपने दोस्तों को आमंत्रित करें"
//                         : "Invite your friends to download iPrep",
//                     style: TextStyle(
//                         color: const Color(0xFF212121),
//                         fontSize: 16,
//                         fontWeight: FontWeight.values[5]),
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   Text(
//                     selectedAppLanguage!.toLowerCase() == 'hindi'
//                         ? "रुपये प्राप्त करें। 100 iPrep कैश के रूप में और\n अनलिमिटेड सीखने का आनंद साझा करें"
//                         : "Get Rs. 100 as iPrep Cash & share the joy\n of Learning Unlimited",
//                     style: TextStyle(
//                         color: const Color(0xFF9E9E9E),
//                         fontSize: 12,
//                         fontWeight: FontWeight.values[4]),
//                   ),
//                   getShareButton(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget getShareButton() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           elevation: 0,
//           primary: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(19.0),
//           ),
//           minimumSize: const Size(90, 38),
//           side: const BorderSide(
//             color: Color(0xFF0070FF),
//           ),
//         ),
//         child: Text(
//           selectedAppLanguage!.toLowerCase() == 'hindi' ? "शेयर करना" : "Share",
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.values[4],
//             color: const Color(0xFF212121),
//           ),
//         ),
//         onPressed: () async {
//           var _deepLinkUrl =
//               await shareEarnRepository.prepareDeepLinkForAppDownload();
//           await shareEarnRepository.shareContent(
//               context: context, content: _deepLinkUrl.toString());
//         },
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/app_bar.dart';
import 'package:idream/custom_widgets/custom_pop_up.dart';
import 'package:idream/custom_widgets/dashboard_test_widget.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/custom_widgets/student_dashboard/continue_learning.dart';
import 'package:idream/custom_widgets/subject_home_page_widget.dart';
import 'package:idream/custom_widgets/web_view_page.dart';
import 'package:idream/model/category_model.dart';
import 'package:idream/model/subject_model.dart';
import 'package:idream/model/test_model.dart';
import 'package:idream/model/test_prep_model/test_prep_model.dart';
import 'package:idream/provider/bell_animation_provider.dart';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/provider/student/joined_batches_provider.dart';
import 'package:idream/ui/bottom_bar_pages/joined_batches_page.dart';
import 'package:idream/ui/dashboard/extra_books/extra_book_widget.dart';
import 'package:idream/ui/dashboard/stem_videos/stem_projects_widget.dart';
import 'package:idream/ui/menu/app_drawer.dart';
import 'package:idream/ui/menu/my_reports_page.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/ui/test_prep/all_test_prep_page.dart';
import 'package:idream/ui/test_prep/test_prep_provider/test_proivider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../common/global_variables.dart';
import '../../custom_widgets/dialog_box.dart';
import '../../model/boards_model.dart';
import '../../model/extra_book_model.dart';
import '../../model/streams_model.dart';
import '../network_error_page.dart';
import 'test_prep_web_page.dart';

class DashboardScreen extends StatefulWidget {
  final int dashboardTabIndex;
  final bool firstTimeLanded;
  const DashboardScreen(
      {Key? key, this.firstTimeLanded = false, this.dashboardTabIndex = 0})
      : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;

  late int _currentIndex;
  Timer? _timerLink;
  Future? _subjectList;
  Future? alreadyWatchedVideosData;
  Future? _testPrepData;
  late NetworkProvider networkProvider;
  String? _userID;
  Future _setGoogleAnalyticsProperties() async {
    String? _userBoard = await getStringValuesSF('educationBoard');
    String? _userID = await getStringValuesSF("userID");
    setState(() {
      this._userID = _userID;
    });
    analyticsRepository.setUserBoard(userBoard: _userBoard);

    String? _username = await getStringValuesSF('fullName');
    analyticsRepository.setUsername(username: _username);

    String? _userEmail = await getStringValuesSF('email');
    analyticsRepository.setUserEmail(userEmail: _userEmail);

    String? _userMobile = await getStringValuesSF('mobileNumber');
    analyticsRepository.setUserMobile(userMobile: _userMobile);

    String? _userClass = await getStringValuesSF('classNumber');
    analyticsRepository.setUserClass(userClass: _userClass);

    String? _userCity = await getStringValuesSF('city');
    debugPrint(_userCity);
    analyticsRepository.setUserCity(userCity: _userCity);

    String? _userState = await getStringValuesSF('state');
    debugPrint(_userState);
    analyticsRepository.setUserState(userState: _userState);
  }

  Future _checkUsersPlan() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // String _planDuration = await getStringValuesSF("userPlanDuration");
      // String _planStartDate = await getStringValuesSF("userPlanDateStarted");
      // print(_planDuration + "\n" + _planStartDate);
      // DateTime _dateTime = DateTime.parse(_upStartDate)
      //     .add(Duration(days: int.parse(_upDuration)));

      //TODO: Uncomment this line
      // if (_dateTime.compareTo(DateTime.now()) < 0)
      //   showTestSubmitBottomSheet(context: context);

      await upgradePlanRepository.checkIfFunctionalityNeedsToBeBlocked();

      //Check Deep Link Firebase Messaging
      notificationRepository.handleNotificationOnTapEvent(context);
      String? _token = await firebaseMessaging.getToken();
      debugPrint(_token);
    });
  }

  @override
  void initState() {
    super.initState();
    userRepository.clearLocalDataBase(context);
    selectedAppLanguage = selectedAppLanguage ?? "english";
    networkProvider = Provider.of<NetworkProvider>(context, listen: false);

    if (!firstTimeLanded) firstTimeLanded = widget.firstTimeLanded;
    usingIprepLibrary = false;

    Provider.of<BellAnimationProvider>(context, listen: false)
        .initialiseHearAnimation(this);

    Provider.of<JoinedBatchesProvider>(context, listen: false)
        .fetchJoinedBatches();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeInFadeOut =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    ));
    animation.forward();

    _currentIndex = 0;
    _setGoogleAnalyticsProperties();
    _checkUsersPlan();
    _subjectList = dashboardRepository.fetchSubjectList();
    userPermissions.notification();
    newVersion.newUpdateCheck(context);
    newVersion.checkVersionCode();

    alreadyWatchedVideosData =
        videoLessonRepository.fetchAlreadyWatchedVideoData();
    _testPrepData = testRepository.fetchTestPrepPopularExamsList(context);
    debugPrint(_testPrepData.toString());
    WidgetsBinding.instance.addObserver(this);

    dashboardRepository.fetchSubjectData()?.then((value) {
      print(value);
    });

    if (widget.firstTimeLanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        welcomeMessagePopUp(context);
        getUserLocation();
      });
    } else {
      userProfileRepository.checkUserProfileData().then((value) async {
        if (value != null && value == true) {
          String languageValue = "Select Language";
          String boardValue = "Select Board";
          String classValue = "Select Class";
          String streamValue = "Select Stream";

          //
          String? boardId;
          String? streamId;
          String? classId;

          bool lisValid = false;
          bool bisValid = false;
          bool cisValid = false;
          bool sisValid = false;

          Future.wait([
            classRepository.fetchClasses(),
            apiHandler.getAPICall(endPointURL: "temp_boards"),
            boardSelectionRepository.fetchLanuageList(),
            apiHandler.getAPICall(endPointURL: "classes/cbse/english"),
            apiHandler.getAPICall(endPointURL: "temp_streams"),
          ]).then((value) async {
            List<dynamic>? boardList = value[1];
            List<String> languageList = value[2];
            List<dynamic> classList = value[3];
            List<dynamic>? boardsStreamList = value[4];

            String? username = await getStringValuesSF('fullName');
            Future.delayed(const Duration(milliseconds: 1)).then((value) {
              bool streamEnable = false;
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Scaffold(
                          body: SingleChildScrollView(
                            padding: const EdgeInsets.all(19.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 41,
                                  ),
                                  Text(
                                    "Hello ${username ?? " "}",
                                    style: TextStyle(
                                      color: const Color(0xFF212121),
                                      fontWeight: FontWeight.values[5],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Kindly provide the following information to continue.',
                                    style: TextStyle(
                                        color: Color(0xFF575756), fontSize: 14),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    alignment: Alignment.bottomLeft,
                                    height: 58,
                                    child: const Text(
                                      "What is your preferred language?",
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 14,
                                          color: Color(0xFF212121)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: DropdownButtonFormField(
                                      dropdownColor: const Color(0xFFF4F4F4),
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        labelText: 'Select your board',
                                        labelStyle: TextStyle(
                                          color:
                                              const Color(0xFF9E9E9E), //#212121
                                          fontSize: 12,
                                          fontWeight: FontWeight.values[4],
                                        ),
                                      ),
                                      hint: Text(
                                        languageValue.toUpperCase(),
                                        style: TextStyle(
                                          color: const Color(0xFF212121),
                                          fontSize: 12,
                                          fontWeight: FontWeight.values[3],
                                        ),
                                      ),
                                      isExpanded: true,
                                      // iconSize: 10.0,
                                      style: TextStyle(
                                        color: const Color(0xFF212121),
                                        fontSize: 12,
                                        fontWeight: FontWeight.values[3],
                                      ),
                                      elevation: 0,
                                      items: languageList.map(
                                        (val) {
                                          return DropdownMenuItem<String>(
                                            value: val.toUpperCase(),
                                            child: Text(val.toUpperCase()),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (dynamic val) {
                                        setState(() {
                                          languageValue = val.toString();
                                          lisValid = true;
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    alignment: Alignment.bottomLeft,
                                    height: 58,
                                    child: const Text(
                                      "Select your board",
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 14,
                                          color: Color(0xFF212121)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: DropdownButtonFormField(
                                      dropdownColor: const Color(0xFFF4F4F4),
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        labelStyle: TextStyle(
                                          color:
                                              const Color(0xFF9E9E9E), //#212121
                                          fontSize: 12,
                                          fontWeight: FontWeight.values[4],
                                        ),
                                      ),
                                      hint: Text(
                                        boardValue.toUpperCase(),
                                        style: TextStyle(
                                          color: const Color(0xFF212121),
                                          fontSize: 12,
                                          fontWeight: FontWeight.values[3],
                                        ),
                                      ),
                                      isExpanded: true,
                                      // iconSize: 10.0,
                                      style: TextStyle(
                                        color: const Color(0xFF212121),
                                        fontSize: 12,
                                        fontWeight: FontWeight.values[3],
                                      ),
                                      elevation: 0,
                                      items: boardList!.map(
                                        (val) {
                                          return DropdownMenuItem<String>(
                                            value: val['name'].toUpperCase(),
                                            child:
                                                Text(val['name'].toUpperCase()),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (dynamic val) {
                                        setState(() {
                                          boardValue = val.toString();
                                          bisValid = true;
                                        });

                                        for (var element in boardList) {
                                          if (element['name']!.toUpperCase() ==
                                              boardValue) {
                                            boardId = element['abbr'];
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    alignment: Alignment.bottomLeft,
                                    height: 58,
                                    child: const Text(
                                      "Which class do you study in ",
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 14,
                                          color: Color(0xFF212121)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: DropdownButtonFormField(
                                      dropdownColor: const Color(0xFFF4F4F4),

                                      // dropdownColor: Colors.transparent,

                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        labelText:
                                            'Which class do you study in ',
                                        labelStyle: TextStyle(
                                          color:
                                              const Color(0xFF9E9E9E), //#212121
                                          fontSize: 12,
                                          fontWeight: FontWeight.values[4],
                                        ),
                                      ),

                                      hint: Text(
                                        classValue.toUpperCase(),
                                        style: TextStyle(
                                          color: const Color(0xFF212121),
                                          fontSize: 12,
                                          fontWeight: FontWeight.values[3],
                                        ),
                                      ),
                                      isExpanded: true,
                                      // iconSize: 10.0,
                                      style: TextStyle(
                                        color: const Color(0xFF212121),
                                        fontSize: 12,
                                        fontWeight: FontWeight.values[3],
                                      ),
                                      elevation: 0,
                                      items: classList.map(
                                        (val) {
                                          return DropdownMenuItem<String>(
                                              value: val['name'].toUpperCase(),
                                              child: Text(
                                                  val['name'].toUpperCase()));
                                        },
                                      ).toList(),
                                      onChanged: (dynamic val) {
                                        setState(() {
                                          classValue = val.toString();
                                          cisValid = true;
                                        });

                                        setState(() {
                                          streamEnable = false;
                                        });

                                        for (var element in classList) {
                                          if (element['name'].toUpperCase() ==
                                              val) {
                                            classId = element['id'];
                                            if (int.tryParse(classId!)! > 10) {
                                              setState(() {
                                                streamEnable = true;
                                              });
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  if (streamEnable == true) ...[
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      alignment: Alignment.bottomLeft,
                                      height: 58,
                                      child: const Text(
                                        "Select your stream",
                                        style: TextStyle(
                                            fontFamily: "Inter",
                                            fontSize: 14,
                                            color: Color(0xFF212121)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: DropdownButtonFormField(
                                        dropdownColor: const Color(0xFFF4F4F4),
                                        decoration: InputDecoration(
                                          enabled: streamEnable,
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          labelText:
                                              'Which class do you study in ',
                                          labelStyle: TextStyle(
                                            color: const Color(
                                                0xFF9E9E9E), //#212121
                                            fontSize: 12,
                                            fontWeight: FontWeight.values[4],
                                          ),
                                        ),
                                        hint: Text(
                                          streamValue.toUpperCase(),
                                          style: TextStyle(
                                            color: const Color(0xFF212121),
                                            fontSize: 12,
                                            fontWeight: FontWeight.values[3],
                                          ),
                                        ),
                                        isExpanded: true,
                                        // iconSize: 10.0,
                                        style: TextStyle(
                                          color: const Color(0xFF212121),
                                          fontSize: 12,
                                          fontWeight: FontWeight.values[3],
                                        ),
                                        elevation: 0,
                                        items: boardsStreamList!.map(
                                          (val) {
                                            return DropdownMenuItem<String>(
                                              value: val["name"]!.toUpperCase(),
                                              child: Text(
                                                  val["name"]!.toUpperCase()),
                                            );
                                          },
                                        ).toList(),
                                        onChanged: (dynamic val) {
                                          setState(() {
                                            streamValue = val.toString();
                                            sisValid = true;
                                          });

                                          for (var element
                                              in boardsStreamList) {
                                            if (element["name"].toUpperCase() ==
                                                val) {
                                              streamId = element["id"];
                                            }
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                  OnBoardingBottomButton(
                                    buttonColor: (lisValid == true &&
                                                bisValid == true &&
                                                cisValid == true) ==
                                            true
                                        ? (streamEnable == sisValid)
                                            ? 0xFF0077FF
                                            : 0xFFFFFFF
                                        : 0xFFFFFFF,
                                    topPadding: 40,
                                    onPressed: () {
                                      if (lisValid == true &&
                                          bisValid == true &&
                                          cisValid == true &&
                                          (streamEnable == sisValid)) {
                                        debugPrint(languageValue);
                                        debugPrint(boardId);
                                        debugPrint(classId);
                                        debugPrint(streamId);
                                        userProfileRepository
                                            .updateUserProfile(
                                          classNumber: classId!,
                                          stream: streamId.toString(),
                                          language: languageValue.toLowerCase(),
                                          board: boardId!,
                                        )
                                            .then((value) {
                                          if (value == true) {
                                            Navigator.pop(context);
                                          }
                                        });
                                      } else {
                                        SnackbarMessages.showErrorSnackbar(
                                          context,
                                          error: Constants.allField,
                                        );
                                      }
                                    },
                                    buttonText: "Finish",
                                  )
                                ]),
                          ),
                        ),
                      ),
                    );
                  });
                },
              );
            });
          });
        }
      });
    }
    initDynamicLinks(context);
  }

  getUserLocation() async {
    try {
      await userProfileRepository.setUserProfile();
      await userLocationRepository.determinePosition().then((value) async {
        await userProfileRepository.saveUserLocation();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('videoProvider');
      _timerLink = Timer(
        const Duration(seconds: 1),
        () {
          initDynamicLinks(context);
        },
      );
    } else {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink?.cancel();
    }

    super.dispose();
  }

  @override
  void deactivate() {
    print("Deactivate");
    super.deactivate();
  }

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  initDynamicLinks(BuildContext context) async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      Uri deepLinkData = dynamicLinkData.link;
      var queryParams = deepLinkData.queryParameters;
      if (queryParams.isNotEmpty) {
        _fetchParameters(queryParams: queryParams);
      }
    }).onError((error) {
      debugPrint('onLink error');
      debugPrint(error.message);
    });
  }

  Future _fetchParameters({Map? queryParams}) async {
    String? referUserID = queryParams!['userID'];
    String? referralCode = queryParams['referralCode'];
    String? referUsername = queryParams['fullName'];
    String? referUserType = queryParams['userType'];
    if (referralCode != null) {
      await shareEarnRepository.depositEarningAmount(
          referUserID: referUserID,
          referralUserCode: referralCode,
          referUsername: referUsername,
          referUserType: referUserType);
    } else {
      String? batchId = queryParams['batchId'];
      String? teacherId = queryParams['teacherId'];
      String? teacherName = queryParams['teacherName'];
      debugPrint(teacherName.toString());
      if (batchId != null) {
        //Save student join info...
        var response = await batchRepository.addStudentToSelectedBatch(
            batchId: batchId, teacherId: teacherId!);
        if (response != null && response) {
          if (!mounted) return;
          Provider.of<JoinedBatchesProvider>(context, listen: false)
              .fetchJoinedBatches();
          if (!mounted) return;
          SnackbarMessages.showSuccessSnackbar(
            context,
            message: Constants.studentBatchJoiningSuccess,
          );
        }
      }
    }
  }

  mainDashboardPageWidget() {
    final testPro = Provider.of<TestProvider>(context);
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(
            // top: 24,
            left: 16,
            right: 15,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(0),
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children:  [
                  Text( selectedAppLanguage!.toLowerCase() == "hindi"
                  ?"आपका"
                   : "Your",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    selectedAppLanguage!.toLowerCase() == "hindi"
                    ? "विषयों" :
                    "Subjects",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              // RichText(
              //   text: TextSpan(
              //     style: TextStyle(
              //       fontFamily: GoogleFonts.inter().fontFamily,
              //       color: const Color(0xFF212121),
              //       fontSize: 17,
              //     ),
              //     children: [
              //       TextSpan(
              //         text: selectedAppLanguage!.toLowerCase() == 'hindi'
              //             ? "आपका "
              //             : 'Your ',
              //         style: const TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.w400,
              //         ),
              //       ),
              //       TextSpan(
              //         text: selectedAppLanguage!.toLowerCase() == 'hindi'
              //             ? " विषय"
              //             : ' Subjects',
              //         style: const TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.w700,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              getSubjectListWidgets(dashboardScreenState),
              FutureBuilder(
                future: testRepository.fetchTestPrepPopularExamsList(context),
                builder: (context, testData) {
                  List<Widget> testPrepWidget = [];
                  CookieManager cookieManager = CookieManager();

                  if (testData.hasData) {
                    List<Others?>? exams = testData.data;
                    List<SubCategory>? subCategoryList = exams
                        ?.expand((e) => e?.subCategory ?? [])
                        .map((s) => SubCategory(
                              name: s?.name,
                              id: s?.id,
                              icon: s?.icon,
                              href: s?.href,
                              category: s?.category,
                              categoryId: s?.categoryId,
                            ))
                        .toList();

                    print(subCategoryList?.length);

                    testPrepWidget.add(
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    selectedAppLanguage!.toLowerCase() == "hindi"
                                    ? "आपका" :
                                    "Your",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                 const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    selectedAppLanguage!.toLowerCase() == "hindi"
                                        ? "परीक्षा"
                                        : "Test",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                const  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    selectedAppLanguage!.toLowerCase() ==
                                            "hindi"
                                        ? "की तैयारी"
                                        : "Preparations",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     RichText(
                              //       text: TextSpan(
                              //         style: TextStyle(
                              //           fontFamily:
                              //               GoogleFonts.inter().fontFamily,
                              //           color: const Color(0xFF212121),
                              //           fontSize: 17,
                              //         ),
                              //         children: [
                              //           TextSpan(
                              //             text: selectedAppLanguage!
                              //                         .toLowerCase() ==
                              //                     'hindi'
                              //                 ? "आपका "
                              //                 : 'Your ',
                              //             style: const TextStyle(
                              //               fontSize: 18,
                              //               fontWeight: FontWeight.w400,
                              //             ),
                              //           ),
                              //           TextSpan(
                              //             text: selectedAppLanguage!
                              //                         .toLowerCase() ==
                              //                     'hindi'
                              //                 ? " विषय"
                              //                 : ' Test Preparations',
                              //             style: const TextStyle(
                              //               fontSize: 18,
                              //               fontWeight: FontWeight.w700,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              if ((subCategoryList!.length > 4)) ...[
                                InkWell(
                                  borderRadius: BorderRadius.circular(7),
                                  onTap: () async {
                                    // String? _baseUrlParam = await (dashboardRepository
                                    //     .prepQueryParameterStringForTestPrep());

                                    String? userName =
                                        await getStringValuesSF("fullName");
                                    String? userEmail =
                                        await getStringValuesSF("email");
                                    String? userMobileNo =
                                        await getStringValuesSF("mobileNumber");
                                    String? userProfileImage =
                                        await getStringValuesSF("profilePhoto");

                                    userMobileNo =
                                        userMobileNo!.replaceAll("+91-", "");

                                    CookieManager? cookieManager =
                                        CookieManager();

                                    late WebViewCookie? sessionCookie =
                                        WebViewCookie(
                                      name: 'ip_user',
                                      value:
                                          "${userName?.trim() ?? "John Doe"}|${userEmail ?? ""}|${userMobileNo ?? '1234567890'}|${userProfileImage ?? 'https://secure.gravatar.com/avatar/?s=96&d=mm'}|${userEmail != null ? "email" : "phone"}",
                                      domain: '.iprep.in',
                                      path: "/",
                                    );

                                    cookieManager.setCookie(sessionCookie);

                                    if (!mounted) return;
                                    await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => TestSeeAllPage(
                                          testPrepData: testData.data,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Image.asset(
                                    "assets/images/forward_icon.png",
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: subCategoryList.length > 4
                                ? 4
                                : subCategoryList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1 / .4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  testPro.onTapTestContainer(
                                    context: context,
                                    packageName:
                                        subCategoryList[index]!.categoryId!,
                                    testWebLink: subCategoryList[index].href,
                                  );
                                },
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                child:
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFDEDEDE),
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: ImageWidget(
                                            imageUrl:
                                                subCategoryList[index].icon!,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Flexible(
                                            child: Text(
                                          subCategoryList[index].name!,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                          // ListView.separated(
                          //   separatorBuilder: (context, index) =>
                          //       const SizedBox(
                          //     height: 10,
                          //   ),
                          //   shrinkWrap: true,
                          //   physics: const NeverScrollableScrollPhysics(),
                          //   itemCount: subCategoryList!.length > 4
                          //       ? 4
                          //       : subCategoryList.length,
                          //   itemBuilder: (context, index) {
                          //     return Wrap(
                          //       spacing: 10,
                          //       runSpacing: 10,
                          //       children: [
                          //         InkWell(
                          //           onTap: () {
                          //             testPro.onTapTestContainer(
                          //               context: context,
                          //               packageName:
                          //                   testData.data![index]?.name,
                          //               testWebLink:
                          //                   subCategoryList[index].href,
                          //             );
                          //           },
                          //           borderRadius: BorderRadius.circular(7.0),
                          //           child: Container(
                          //             padding: const EdgeInsets.symmetric(
                          //                 horizontal: 10, vertical: 5),
                          //             // margin: const EdgeInsets.only(right: 10, bottom: 10),
                          //             decoration: BoxDecoration(
                          //               border: Border.all(
                          //                 width: 1.0,
                          //                 color: const Color(0xFFD1D1D1),
                          //               ),
                          //               borderRadius:
                          //                   BorderRadius.circular(8.0),
                          //             ),
                          //             child: Row(
                          //               mainAxisSize: MainAxisSize.min,
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.center,
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.start,
                          //               children: [
                          //                 CachedNetworkImage(
                          //                   height: 70,
                          //                   imageUrl:
                          //                       subCategoryList[index].icon!,
                          //                   placeholder: (BuildContext context,
                          //                           String url) =>
                          //                       const Center(
                          //                           child:
                          //                               CircularProgressIndicator(
                          //                                   strokeWidth: 1)),
                          //                   errorWidget: (BuildContext context,
                          //                           String url,
                          //                           dynamic error) =>
                          //                       const Center(
                          //                     child: SizedBox(
                          //                       width: 15,
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 const SizedBox(width: 10),
                          //                 Flexible(
                          //                   child: Column(
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                     children: [
                          //                       Text(
                          //                         subCategoryList![index]!
                          //                             .name!,
                          //                         textAlign: TextAlign.center,
                          //                         maxLines: 1,
                          //                         style: const TextStyle()
                          //                             .copyWith(
                          //                           fontSize: 16.4,
                          //                           fontWeight: FontWeight.w400,
                          //                           // color: book.color.getOrCrash(),
                          //                           overflow:
                          //                               TextOverflow.ellipsis,
                          //                         ),
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 10,
                          //                       ),
                          //                       // Text(
                          //                       //   "${subCategoryList.length} Exams",
                          //                       //   textAlign: TextAlign.center,
                          //                       //   style: const TextStyle()
                          //                       //       .copyWith(
                          //                       //     fontSize: 16.4,
                          //                       //     fontWeight: FontWeight.w400,
                          //                       //     // color: book.color.getOrCrash(),
                          //                       //     overflow:
                          //                       //         TextOverflow.ellipsis,
                          //                       //   ),
                          //                       // ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // ),
                          //
                        ],
                      ),
                    );
                  } else if (testData.connectionState ==
                          ConnectionState.waiting ||
                      testData.connectionState == ConnectionState.none) {
                    testPrepWidget.add(
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                        period: const Duration(seconds: 1),
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 18,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 18,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Test Preparations',
                                      style: TextStyle(
                                        fontWeight: FontWeight.values[5],
                                        fontFamily:
                                            GoogleFonts.inter().fontFamily,
                                        color: const Color(0xFF212121),
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Wrap(
                                children: List.generate(6, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, top: 8, right: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[100]!,
                                      ),
                                      height: 40,
                                      width: 150,
                                    ),
                                  );

                                  /*  ExtraBooksWidget(
                                      extraBookModel: ExtraBookModel(
                                          subjectName: "Subject Name",
                                          bookList: [
                                            ExtraBooks(topics: [Topics()])
                                          ]),
                                      subjectImagePath: "assets/images/physics.png",
                                      subjectColor: 0xFFFCAC52,
                                    );*/
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } /*else if (!testData.hasData) {
                        testPrepWidget.add(
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 18,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 18,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Test Preparations',
                                        style: TextStyle(
                                          fontWeight: FontWeight.values[5],
                                          fontFamily: GoogleFonts.inter().fontFamily,
                                          color: const Color(0xFF212121),
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Wrap(
                                  children: List.generate(
                                    6,
                                    (index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, top: 8, right: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.grey[100]!,
                                          ),
                                          height: 40,
                                          width: 150,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }*/
                  return Column(
                    children: testPrepWidget,
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ExtraBooksContainer(),
              StemProjectsWidget(),
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter _setState) {
                return StreamBuilder(
                    stream: videoLessonRepository.getUserVideoWatchDetails(),
                    builder: (context, snapshot) {
                      return FutureBuilder(
                        future: videoLessonRepository
                            .fetchAlreadyWatchedVideoData(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.data != null) {
                            return FadeTransition(
                              opacity: _fadeInFadeOut,
                              child: ContinueLearningVideosWidget(
                                videoData: snapshot.data,
                                dashboardScreenState: dashboardScreenState,
                                stateSetter: _setState,
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    });
              }),
              FutureBuilder(
                future: alreadyWatchedVideosData,
                builder: (context, subjects) {
                  if (subjects.connectionState == ConnectionState.done) {
                    return FadeTransition(
                      opacity: _fadeInFadeOut,
                      child: getShareAppWidget(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
        testPro.isLoading == true
            ? Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  getCurrentPageWidget() {
    switch (_currentIndex) {
      case 0:
      // return mainDashboardPageWidget();
      case 1:
        return const JoinedBatchesPage();
      case 2:
        return const MyReportsPage();
    }
  }

  getCurrentPageWidgetWithoutBatch() {
    switch (_currentIndex) {
      case 0:
        return mainDashboardPageWidget();
      case 1:
        return const MyReportsPage();
    }
  }

  Future<bool> _onBackPressed() {
    AlertPopUp(
      context: context,
      title: "",
      desc: "Are you sure you want to exit?",
      buttons: [
        DialogButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0077FF), Color(0xFF0077FF)],
          ),
          child: const Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        DialogButton(
          onPressed: () async {
            userLoginRepository.userLastLogin();
            SystemNavigator.pop();
          },
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueGrey[400]!,
              Colors.blueGrey[400]!,
            ],
          ),
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    dashboardScreenState = this;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        color: Colors.white,
        child: Consumer<NetworkProvider>(
          builder: (context, networkProvider, child) =>
              networkProvider.isAvailable == true
                  ? SafeArea(
                      top: false,
                      bottom: false,
                      child: Consumer<JoinedBatchesProvider>(
                        builder: (context, joinedBatchesProviderModel, child) =>
                            Scaffold(
                          backgroundColor: Colors.white,
                          drawer: AppDrawer(
                            dashboardScreenState: dashboardScreenState,
                          ),
                          appBar: customAppBar(mounted, context, this)
                              as PreferredSizeWidget?,
                          body:
                              (joinedBatchesProviderModel.joinedBatches != null)
                                  ? getCurrentPageWidget()
                                  : getCurrentPageWidgetWithoutBatch(),
                          bottomNavigationBar: BottomNavigationBar(
                            backgroundColor: const Color(0xFFFFFFFF),
                            currentIndex: _currentIndex,
                            showUnselectedLabels: true,
                            unselectedItemColor: const Color(0xFF212121),
                            selectedItemColor: const Color(0xFF212121),
                            selectedIconTheme: const IconThemeData(
                              color: Color(0xFF3399ff),
                            ),
                            unselectedIconTheme:
                                const IconThemeData(color: Color(0xFF212121)),
                            unselectedFontSize: 10,
                            selectedFontSize: 10,
                            onTap: (index) async {
                              // await Navigator.pushAndRemoveUntil(
                              //   context,
                              //   CupertinoPageRoute(
                              //     builder: (context) => DashboardScreen(
                              //       dashboardTabIndex: index,
                              //     ),
                              //   ),
                              //       (Route<sdynamic> route) => false,
                              // );
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            items: [
                              BottomNavigationBarItem(
                                icon: Image.asset(
                                  "assets/images/home.png",
                                  height: 24,
                                  width: 24,
                                ),
                                label: 'Home',
                                activeIcon: Image.asset(
                                  "assets/images/home_selected.png",
                                  height: 24,
                                  width: 24,
                                ),
                              ),
                              if (joinedBatchesProviderModel.joinedBatches !=
                                  null)
                                BottomNavigationBarItem(
                                  icon: Image.asset(
                                    "assets/images/my_batch_icon.png",
                                    height: 24,
                                    width: 24,
                                  ),
                                  label: 'My Batch',
                                  activeIcon: Image.asset(
                                    "assets/images/my_batch_icon_selected.png",
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              //TODO: Commenting out below code for postponing this functionality for future
                              // BottomNavigationBarItem(
                              //   icon: Image.asset(
                              //     "assets/images/saved.png",
                              //     height: ScreenUtil().setSp(24, ),
                              //     width: ScreenUtil().setSp(24, ),
                              //   ),
                              //   label: 'Saved',
                              // ),
                              BottomNavigationBarItem(
                                icon: Image.asset(
                                  "assets/images/my_report_icon.png",
                                  height: 24,
                                  width: 24,
                                ),
                                label: 'My Reports',
                                activeIcon: Image.asset(
                                  "assets/images/my_report_icon_selected.png",
                                  height: 24,
                                  width: 24,
                                ),
                              ),
                            ],
                          ),
                        ) /*CustomBottomNavigationBar()*/,
                      ),
                    )
                  : const NetworkError(),
        ),
      ),
    );
  }

  getSubjectListWidgets(DashboardScreenState? dashboardScreenState) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Check the sizing information here and return your UI
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return Container(color: Colors.blue);
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          return Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: [
                FutureBuilder(
                  initialData: 0,
                  future: _subjectList,
                  builder: (context, subjects) {
                    Widget? subjectWidget;
                    if (subjects.connectionState == ConnectionState.none) {
                      subjectWidget = Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                        period: const Duration(seconds: 2),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          children: List.generate(
                              8,
                              (index) => SubjectWidget(
                                    dashboardScreenState: dashboardScreenState,
                                    subjectImagePath:
                                        Constants.defaultSubjectImagePath,
                                    subjectName: "",
                                    subjectColor:
                                        Constants.defaultSubjectHexColor,
                                    subjectID: "",
                                    subjectShortName: "",
                                  )

                              /* Padding(
                              padding: const EdgeInsets.only(
                                  right: 8, bottom: 8, top: 4),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),*/
                              ),
                        ),
                      );
                    } else if (subjects.connectionState ==
                        ConnectionState.waiting) {
                      subjectWidget = Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                        period: const Duration(seconds: 2),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          children: List.generate(
                              8,
                              (index) => SubjectWidget(
                                    dashboardScreenState: dashboardScreenState,
                                    subjectImagePath:
                                        Constants.defaultSubjectImagePath,
                                    subjectName: "",
                                    subjectColor:
                                        Constants.defaultSubjectHexColor,
                                    subjectID: "",
                                    subjectShortName: "",
                                  )

                              /* Padding(
                              padding: const EdgeInsets.only(
                                  right: 8, bottom: 8, top: 4),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),*/
                              ),
                        ),
                      );
                    } else if (!subjects.hasData) {
                      subjectWidget = Container(
                        alignment: Alignment.center,
                        child:
                            const Text("No data available. Please try later."),
                      );
                    } else if (subjects.hasData) {
                      List<SubjectModel>? subjectList =
                          subjects.data as List<SubjectModel>?;
                      // subjectWidget = Wrap(
                      //   crossAxisAlignment: WrapCrossAlignment.start,
                      //   alignment: WrapAlignment.start,
                      //
                      //   // spacing: 10,
                      //   // runSpacing: 10,
                      //   // crossAxisAlignment: WrapCrossAlignment.start,
                      //   children: List.generate(
                      //     subjectList!.length,
                      //     (index) {
                      //       return SubjectWidget(
                      //         dashboardScreenState: dashboardScreenState,
                      //         subjectImagePath:
                      //             (subjectList[index].subjectIconPath != null &&
                      //                     subjectList[index]
                      //                         .subjectIconPath!
                      //                         .isNotEmpty)
                      //                 ? subjectList[index].subjectIconPath
                      //                 : Constants.defaultSubjectImagePath,
                      //         subjectName: subjectList[index].subjectName,
                      //         subjectColor:
                      //             (subjectList[index].subjectColor != null &&
                      //                     subjectList[index]
                      //                         .subjectColor!
                      //                         .isNotEmpty)
                      //                 ? (int.parse(
                      //                         subjectList[index]
                      //                             .subjectColor!
                      //                             .substring(1, 7),
                      //                         radix: 16) +
                      //                     0xFF000000)
                      //                 : Constants.defaultSubjectHexColor,
                      //         subjectID: subjectList[index].subjectID,
                      //         subjectShortName:
                      //             subjectList[index].shortName ?? "",
                      //       );
                      //     },
                      //     growable: true,
                      //   ),
                      // );
                      subjectWidget = Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,

                        // spacing: 10,
                        // runSpacing: 10,
                        // crossAxisAlignment: WrapCrossAlignment.start,
                        children: List.generate(
                          subjectList!.length,
                          (index) {
                            return SubjectWidget(
                              dashboardScreenState: dashboardScreenState,
                              subjectImagePath:
                                  (subjectList[index].subjectIconPath != null &&
                                          subjectList[index]
                                              .subjectIconPath!
                                              .isNotEmpty)
                                      ? subjectList[index].subjectIconPath
                                      : Constants.defaultSubjectImagePath,
                              subjectName: subjectList[index].subjectName,
                              subjectColor:
                                  (subjectList[index].subjectColor != null &&
                                          subjectList[index]
                                              .subjectColor!
                                              .isNotEmpty)
                                      ? (int.parse(
                                              subjectList[index]
                                                  .subjectColor!
                                                  .substring(1, 7),
                                              radix: 16) +
                                          0xFF000000)
                                      : Constants.defaultSubjectHexColor,
                              subjectID: subjectList[index].subjectID,
                              subjectShortName:
                                  subjectList[index].shortName ?? "",
                            );
                          },
                          growable: true,
                        ),
                      );
                    }

                    return Container(
                      child: subjectWidget,
                    );
                    return Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      spacing: 25,
                      runSpacing: 10,
                      children: List.generate(
                        10,
                        (index) => Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        growable: true,
                      ),
                    );
                  },
                )
              ],
            ),
          );
        }
        if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
          return Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: [
                FutureBuilder(
                  initialData: 0,
                  future: _subjectList,
                  builder: (context, subjects) {
                    Widget? subjectWidget;
                    if (subjects.connectionState == ConnectionState.none) {
                      subjectWidget = Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                        period: const Duration(seconds: 2),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          children: List.generate(
                            8,
                            (index) => Padding(
                              padding: const EdgeInsets.only(
                                  right: 8, bottom: 8, top: 4),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (subjects.connectionState ==
                        ConnectionState.waiting) {
                      subjectWidget = Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                        period: const Duration(seconds: 2),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          children: List.generate(
                            8,
                            (index) => Padding(
                              padding: const EdgeInsets.only(
                                  right: 8, bottom: 8, top: 4),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (!subjects.hasData) {
                      subjectWidget = Container(
                        alignment: Alignment.center,
                        child:
                            const Text("No data available. Please try later."),
                      );
                    } else if (subjects.hasData) {
                      List<SubjectModel>? subjectList =
                          subjects.data as List<SubjectModel>?;
                      subjectWidget = GridView.builder(
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: subjectList!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 0,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (BuildContext context, index) {
                          return SubjectWidget(
                            dashboardScreenState: dashboardScreenState,
                            subjectImagePath:
                                (subjectList[index].subjectIconPath != null &&
                                        subjectList[index]
                                            .subjectIconPath!
                                            .isNotEmpty)
                                    ? subjectList[index].subjectIconPath
                                    : Constants.defaultSubjectImagePath,
                            subjectName: subjectList[index].subjectName,
                            subjectColor: (subjectList[index].subjectColor !=
                                        null &&
                                    subjectList[index].subjectColor!.isNotEmpty)
                                ? (int.parse(
                                        subjectList[index]
                                            .subjectColor!
                                            .substring(1, 7),
                                        radix: 16) +
                                    0xFF000000)
                                : Constants.defaultSubjectHexColor,
                            subjectID: subjectList[index].subjectID,
                            subjectShortName:
                                subjectList[index].shortName ?? "",
                          );
                        },
                      );
                    }

                    return Container(
                      child: subjectWidget,
                    );
                    /* return Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                spacing: 25,
                runSpacing: 10,
                children: List.generate(
                  10,
                  (index) => Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  growable: true,
                ),
              );*/
                  },
                )
              ],
            ),
          );
        }

        return Container(color: Colors.purple);
      },
    );
  }

  getTestWidgets({List<Others?>? testPrepData, userPlan}) {
    //List<SubCategory?>? testPrepDataOthers = [];
    // List<SubCategory?>? testPrepDataSchool = [];
    // List<SubCategory?> testPrepDataGovt = [];
    // testPrepData?.forEach((element) {
    //   if (element != null) {
    //     if (element.id == "others") {
    //       for (int i = 0; i < element.subCategory!.length; i++) {
    //         testPrepDataOthers.add(element.subCategory![i]);
    //         testPrepDataOthers.contains(null)
    //             ? testPrepDataOthers.remove(null)
    //             : debugPrint("null not found");
    //       }
    //     } else if (element.id == "government_exams") {
    //       for (int i = 0; i < element.subCategory!.length; i++) {
    //         testPrepDataGovt.add(element.subCategory![i]);
    //         testPrepDataGovt.contains(null)
    //             ? testPrepDataGovt.remove(null)
    //             : debugPrint("null not found");
    //       }
    //     } else if (element.id == "school_level_all_india") {
    //       for (int i = 0; i < element.subCategory!.length; i++) {
    //         testPrepDataSchool.add(element.subCategory![i]);
    //         testPrepDataSchool.contains(null)
    //             ? testPrepDataSchool.remove(null)
    //             : debugPrint("null not found");
    //       }
    //     }
    //   } else {
    //     debugPrint("null found");
    //   }
    // });
    //
    // return Container(
    //   padding: const EdgeInsets.only(
    //     top: 18,
    //     bottom: 18,
    //   ),
    //   child: GridView.count(
    //     shrinkWrap: true,
    //     crossAxisCount: 2,
    //     mainAxisSpacing: 16,
    //     crossAxisSpacing: 16,
    //     physics: const NeverScrollableScrollPhysics(),
    //     childAspectRatio: 164 / 66,
    //     children: List.generate(
    //       testPrepDataSchool.length > 4 ? 4 : testPrepDataSchool.length,
    //       (index) {
    //         // return TestWidget(
    //         //   testName: testPrepDataSchool[index]?.name.toString() ?? "",
    //         //   testId: testPrepDataSchool[index]?.id.toString() ?? "",
    //         //   testImagePath: testPrepDataSchool[index]?.icon.toString() ?? "",
    //         //   testWebLink: testPrepDataSchool[index]?.href.toString() ?? "",
    //         //   packageName:
    //         //       testPrepDataGovt.isNotEmpty || testPrepDataOthers.isNotEmpty
    //         //           ? testPrepData![1]!.name.toString()
    //         //           : testPrepData![0]!.name.toString(),
    //         // );
    //         return Container(
    //             decoration: BoxDecoration(
    //                 borderRadius: const BorderRadius.all(
    //                   Radius.circular(10),
    //                 ),
    //                 border: Border.all(color: Colors.grey.shade400)),
    //             child: Padding(
    //               padding: const EdgeInsets.all(12),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   ImageWidget(
    //                     imageUrl: testPrepDataSchool[index]!.icon!,
    //                   ),
    //                   const SizedBox(
    //                     width: 15,
    //                   ),
    //                   Flexible(
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Text(
    //                           testPrepDataSchool[index]!.name!,
    //                           maxLines: 2,
    //                           style: const TextStyle(
    //                             overflow: TextOverflow.ellipsis,
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w600,
    //                           ),
    //                         ),
    //                         Text(
    //                           "${testPrepDataSchool.length} Exams",
    //                           maxLines: 1,
    //                           style: const TextStyle(
    //                             overflow: TextOverflow.ellipsis,
    //                             fontSize: 12,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ));
    //       },
    //     ),
    //   ),
    // );
  }

  Widget getShareAppWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 0,
      ),
      child: Stack(
        children: [
          Image.asset(
            "assets/images/share_image.png",
            height: 212,
            width: double.maxFinite,
            fit: BoxFit.scaleDown,
          ),
          InkWell(
            onTap: () async {
              var _deepLinkUrl =
                  await shareEarnRepository.prepareDeepLinkForAppDownload();
              await shareEarnRepository.shareContent(
                  context: context, content: _deepLinkUrl.toString());
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedAppLanguage!.toLowerCase() == 'hindi'
                        ? "iPrep . डाउनलोड करने के लिए अपने दोस्तों को आमंत्रित करें"
                        : "Invite your friends to download iPrep",
                    style: TextStyle(
                        color: const Color(0xFF212121),
                        fontSize: 16,
                        fontWeight: FontWeight.values[5]),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    selectedAppLanguage!.toLowerCase() == 'hindi'
                        ? "रुपये प्राप्त करें। 100 iPrep कैश के रूप में और\n अनलिमिटेड सीखने का आनंद साझा करें"
                        : "Get Rs. 100 as iPrep Cash & share the joy\n of Learning Unlimited",
                    style: TextStyle(
                        color: const Color(0xFF9E9E9E),
                        fontSize: 12,
                        fontWeight: FontWeight.values[4]),
                  ),
                  getShareButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getShareButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19.0),
          ),
          minimumSize: const Size(90, 38),
          side: const BorderSide(
            color: Color(0xFF0070FF),
          ),
        ),
        child: Text(
          selectedAppLanguage!.toLowerCase() == 'hindi' ? "शेयर करना" : "Share",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.values[4],
            color: const Color(0xFF212121),
          ),
        ),
        onPressed: () async {
          var _deepLinkUrl =
              await shareEarnRepository.prepareDeepLinkForAppDownload();
          await shareEarnRepository.shareContent(
              context: context, content: _deepLinkUrl.toString());
        },
      ),
    );
  }
}
