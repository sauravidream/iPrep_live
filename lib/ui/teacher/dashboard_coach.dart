import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/custom_widgets/app_bar.dart';
import 'package:idream/custom_widgets/TeacherBottomNavigtionBar.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/model/books_model.dart';
import 'package:idream/model/extra_book_model.dart';
import 'package:idream/model/notes_model.dart';
import 'package:idream/model/practice_model.dart';
import 'package:idream/model/test_model.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/provider/bell_animation_provider.dart';
import 'package:idream/provider/chat_input.dart';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/provider/student/coach/dashboard_coach_provider.dart';
import 'package:idream/ui/network_error_page.dart';
import 'package:idream/ui/teacher/assignments/assignment_report_page.dart';
import 'package:idream/ui/teacher/broadcast/broadcast_message_bottom_sheet_page.dart';
import 'package:idream/ui/teacher/class_top_bar.dart';
import 'package:idream/ui/teacher/create_batch.dart';
import 'package:idream/ui/teacher/iPrep_library/iPrep_library_dashboard.dart';
import 'package:idream/ui/teacher/new_message_tab_page.dart';
import 'package:idream/ui/teacher/one_to_one_messaging.dart';
import 'package:idream/ui/teacher/teacher_app_drawer.dart';
import 'package:idream/ui/teacher/utilities/bottom_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import '../../custom_widgets/dialog_box.dart';

// List<Batch> finalBatchList;

class DashboardCoach extends StatefulWidget {
  final int selectedTabIndex;
  const DashboardCoach({Key? key, this.selectedTabIndex = 0}) : super(key: key);
  @override
  DashboardCoachState createState() => DashboardCoachState();
}

class DashboardCoachState extends State<DashboardCoach>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  int? _currentTabIndex;
  Timer? _timerLink;
  DashboardCoachState? _dashboardOneState;

  Future checkFirebaseMessagingNotification() async {
    notificationRepository.handleNotificationOnTapEvent(context);
    String? _token = await firebaseMessaging.getToken();
    debugPrint(_token);
  }

  @override
  void initState() {
    usingIprepLibrary = true;
    Provider.of<BellAnimationProvider>(context, listen: false)
        .initialiseHearAnimation(this);
    Provider.of<BellAnimationProvider>(context, listen: false)
        .fetchLocallySavedUnreadMessages();
    Provider.of<DashboardCoachProvider>(context, listen: false)
        .fetchLoggedInCoachBatches();
    _currentTabIndex = widget.selectedTabIndex;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // finalBatchList = null;
    checkFirebaseMessagingNotification();
    newVersion.newUpdateCheck(context);
    newVersion.checkVersionCode();
    upgradePlanRepository.checkIfFunctionalityNeedsToBeBlocked().then(
          (value) => print("hgdvc"),
        );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink!.cancel();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = Timer(
        const Duration(seconds: 1),
        () {
          initDynamicLinks(context);
        },
      );
    }

    WidgetsBinding.instance.addObserver(this);
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
    String? _referUserID = queryParams!['userID'];
    String? _referralCode = queryParams['referralCode'];
    String? _referUsername = queryParams['fullName'];
    String? _referUserType = queryParams['userType'];
    if (_referralCode != null) {
      await shareEarnRepository.depositEarningAmount(
        referUserID: _referUserID,
        referralUserCode: _referralCode,
        referUsername: _referUsername,
        referUserType: _referUserType,
      );
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
    _dashboardOneState = this;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Consumer<DashboardCoachProvider>(
          builder: (context, dashboardCoachProviderModel, child) => Scaffold(
                appBar: (_currentTabIndex == 0)
                    ? teacherCustomAppBar(context) as PreferredSizeWidget?
                    : customAppBar(mounted, context, null)
                        as PreferredSizeWidget?,
                backgroundColor: Colors.white,
                drawer: TeacherAppDrawer(),
                bottomNavigationBar: TeacherBottomNavigationBar(
                  onTap: (index) async {
                    if (index == 1) {
                      String? _classNumber =
                          await getStringValuesSF("classNumber");
                      if (_classNumber == null) {
                        await userRepository.saveUserDetailToLocal(
                            "classNumber", "1");
                        await userRepository.saveUserDetailToLocal(
                            "educationBoard", "cbse");
                      }
                      usingIprepLibrary = true;
                    } else {
                      usingIprepLibrary = false;
                    }
                    setState(() {
                      _currentTabIndex = index;
                    });
                  },
                  currentIndex: _currentTabIndex,
                ),
                body: _getCurrentPageWidget(dashboardCoachProviderModel),
              )),
    );
  }

  _getCurrentPageWidget(DashboardCoachProvider dashboardCoachProviderModel) {
    switch (_currentTabIndex) {
      case 0:
        return _mainDashboardCoachScreen(dashboardCoachProviderModel);

      case 1:
        return const IprepLibraryDashboard();
    }
  }

  _mainDashboardCoachScreen(
      DashboardCoachProvider dashboardCoachProviderModel) {
    return Consumer<NetworkProvider>(
      builder: (BuildContext context, NetworkProvider networkProvider,
          Widget? child) {
        return networkProvider.isAvailable == true
            ? Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        getBatchContainer(dashboardCoachProviderModel),
                      ],
                    ),
                  ),
                  if (dashboardCoachProviderModel.batchList?.isNotEmpty ??
                      false)
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0, bottom: 15),
                      child: SizedBox(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              await showBroadcastMessageBottomSheet(
                                  context: context,
                                  batchListInfo:
                                      dashboardCoachProviderModel.batchList);
                            },
                            child: Image.asset(
                              'assets/images/broadcast.png',
                              width: 90,
                              height: 44,
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              )
            : const NetworkError();
      },
    );
  }

  batchWidget(Batch batchInfo) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        Provider.of<ChatInput>(context, listen: false)
            .getInputFromRecentMessages('');
        var _response = await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (BuildContext context) => ClassTopBar(
              batch: batchInfo,
              dashboardOneState: _dashboardOneState,
            ),
          ),
        );
      },
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 44,
                    width: 44,
                    decoration: const BoxDecoration(
                        color: Color(0xffD1E6FF),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Text(
                      (batchInfo.batchClass!.length > 2)
                          ? batchInfo.batchClass!.substring(0, 2)
                          : batchInfo.batchClass!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff0070FF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          batchInfo.batchName!,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff212121),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${batchInfo.batchSubject!.map((e) => e.subjectName).toList()}",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff666666),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              "${batchInfo.joinedStudentsList!.length} Students",
              style: const TextStyle(fontSize: 12, color: Color(0xff212121)),
            ),
          ],
        ),
      ),
    );
  }

  shimmerBatchWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Shimmer(
                  gradient: Constants.shimmerGradient,
                  child: Container(
                    alignment: Alignment.center,
                    height: 44,
                    width: 44,
                    decoration: const BoxDecoration(
                        color: Color(0xffD1E6FF),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: const Text(
                      "??",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff0070FF),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Shimmer(
                        gradient: Constants.shimmerGradient,
                        child: Text(
                          "BatchName!",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff212121),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Shimmer(
                        gradient: Constants.shimmerGradient,
                        child: Text(
                          "Batch Subjects Name",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          const Shimmer(
            gradient: Constants.shimmerGradient,
            child: Text(
              "No Of Students",
              style: TextStyle(fontSize: 12, color: Color(0xff212121)),
            ),
          ),
        ],
      ),
    );
  }

  Padding getRecentMessageWidget(
      {required String profilePhoto, required String fullName}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: profilePhoto,
            imageBuilder: (context, imageProvider) => Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
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
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(
            width: 6,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 14, color: Color(0xff212121)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getBatchContainer(DashboardCoachProvider dashboardCoachProviderModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          StreamBuilder(
              stream: batchRepository.getBatchList(),
              builder: (context, snapshot) {
                return /*Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  enabled: true,
                  period: const Duration(seconds: 2),
                  child:ShaderMask(
                    shaderCallback: (bounds) {
                      return _shimmerGradient.createShader(bounds);
                    },
                  )

                  */ /*Container(
                    height: MediaQuery.of(context).size.height * .85,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: shimmerBatchWidget(),
                  ),*/ /*
                );*/

                    FutureBuilder(
                        future: batchRepository.fetchBatchList(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            List<Batch>? batchList =
                                snapshot.data as List<Batch>;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "My Batches",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () async {
                                        var _response = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                CreateBatch(),
                                          ),
                                        );
                                        debugPrint(_response);
                                        if (_response != null && _response) {
                                          Provider.of<DashboardCoachProvider>(
                                                  context,
                                                  listen: false)
                                              .fetchLoggedInCoachBatches();
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.add_circle_outline,
                                              size: 15.0,
                                              color: Color(0xff0070FF),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "New",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xff0070FF)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: batchList.length,
                                  itemBuilder: (context, index) {
                                    return batchWidget(batchList[index]);
                                  },
                                ),
                                getRecentMessagesContainer(batchList),
                                getRecentAssignmentContainer(batchList),
                              ],
                            );
                          } else if (snapshot.data == null &&
                              snapshot.connectionState !=
                                  ConnectionState.waiting) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appUser!.fullName ?? "",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const Text(
                                    "To get started, you have to create a new batch. Click on the Create Batch button below.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      height: 1.6,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 41,
                                  ),
                                  Center(
                                    child: InkWell(
                                      highlightColor: Colors.white,
                                      onTap: () async {
                                        var _response = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                CreateBatch(),
                                          ),
                                        );
                                        debugPrint(_response.toString());
                                        if (_response != null && _response) {
                                          Provider.of<DashboardCoachProvider>(
                                                  context,
                                                  listen: false)
                                              .fetchLoggedInCoachBatches();
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 15),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          border: Border.all(
                                            color: const Color(0xff0070FF),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(
                                              Icons.add_circle_outline,
                                              size: 18.0,
                                              color: Color(0xff0070FF),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "Create Batch",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xff0070FF)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 54,
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return getShimmer();
                          }
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: true,
                            period: const Duration(seconds: 0),
                            child: Container(
                              height: 80,
                              width: double.maxFinite,
                              color: Colors.grey,
                            ),
                          );
                        });
              }),
        ],
      ),
    );
  }

  getRecentMessagesContainer(List<Batch>? batchList) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Messages",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              if (batchList?.isNotEmpty ?? false)
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (BuildContext context) => NewMessageTabPage(
                          batchList: batchList,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.add_circle_outline,
                          size: 15.0,
                          color: Color(0xff0070FF),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "New",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff0070FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
          if (batchList?.isEmpty ?? true)
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
              period: const Duration(seconds: 2),
              child: Container(
                height: 80,
                width: double.maxFinite,
                color: Colors.grey,
              ),
            )
          else if (batchList?.isEmpty ?? true)
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: Text(
                Constants.noRecentMessageText,
                style: Constants.noDataTextStyle,
              ),
            )
          else
            StreamBuilder(
              stream: dbRef
                  .child("recent_chats/teachers/${appUser!.userID}/")
                  .orderByChild('time')
                  .onValue,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.snapshot.value != null) {
                    DataSnapshot dataValues = snapshot.data.snapshot;
                    Map<dynamic, dynamic> _values =
                        dataValues.value as Map<dynamic, dynamic>;
                    List _chatList = _values.values.toList();
                    if (_chatList.length > 3) {
                      _chatList.removeRange(2, _chatList.length - 1);
                    }
                    if (_values.isNotEmpty) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: ListView.builder(
                          itemCount: _chatList.length,
                          shrinkWrap: true,
                          reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                                future: dbRef
                                    .child(
                                        'users/students/${_chatList[index]['user_id']}')
                                    .once(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.data != null) {
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () async {
                                        String? _loggedInUserId =
                                            await getStringValuesSF('userID');
                                        Provider.of<ChatInput>(context,
                                                listen: false)
                                            .getInputFromRecentMessages('');
                                        await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                OneToOneMessagingPage(
                                              loggedInUserId: _loggedInUserId,
                                              selectedBatchModel: Batch(
                                                teacherName: appUser!.fullName,
                                              ),
                                              joinedStudentModel:
                                                  JoinedStudents(
                                                userID: _chatList[index]
                                                    ['user_id'],
                                                fullName: snapshot.data.snapshot
                                                        .value['full_name'] ??
                                                    "",
                                                profileImage: snapshot.data
                                                            .snapshot.value[
                                                        'profile_photo'] ??
                                                    Constants
                                                        .defaultProfileImagePath,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: getRecentMessageWidget(
                                          fullName: snapshot
                                                      .data.snapshot.value[
                                                  'full_name'] /*_chatList[index]['name']*/ ??
                                              "",
                                          profilePhoto: snapshot
                                                      .data.snapshot.value[
                                                  'profile_photo'] /*_chatList[index]
                                                  ['image'] */
                                              ??
                                              Constants
                                                  .defaultProfileImagePath),
                                    );
                                  }
                                  return Container();
                                });
                          },
                        ),
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                        child: Text(
                          "No message history found.",
                          style: Constants.noDataTextStyle,
                        ),
                      );
                    }
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 20, top: 10),
                      child: Text(
                        Constants.noRecentMessageTextBatchCreated,
                        style: Constants.noDataTextStyle
                            .copyWith(color: const Color(0xFF212121)),
                      ),
                    );
                  }
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                    period: const Duration(seconds: 2),
                    child: Container(
                      height: 80,
                      width: double.maxFinite,
                      color: Colors.grey,
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }

  getRecentAssignmentContainer(List<Batch>? batchList) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Assignments",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              if (batchList?.isNotEmpty ?? false)
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    showBatchBottomSheet(context, batchList);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.add_circle_outline,
                          size: 15.0,
                          color: Color(0xff0070FF),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Add",
                          style:
                              TextStyle(fontSize: 16, color: Color(0xff0070FF)),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
          if (batchList?.isEmpty ?? true)
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
              period: const Duration(seconds: 2),
              child: Container(
                height: 80,
                width: double.maxFinite,
                color: Colors.grey,
              ),
            )
          else if (batchList?.isEmpty ?? true)
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: Text(
                Constants.noRecentAssignmentText,
                style: Constants.noDataTextStyle,
              ),
            )
          else
            StreamBuilder(
                stream: dbRef
                    .child("/recent_assignment/${appUser!.userID}/")
                    .onValue,
                builder: (context, snapshot) {
                  return FutureBuilder(
                    initialData: null,
                    future: assignmentRepository.recentAssignments(),
                    builder: (context, assignments) {
                      if (assignments.connectionState == ConnectionState.none &&
                          !assignments.hasData) {
                        return Container();
                      } else if (assignments.connectionState ==
                              ConnectionState.done &&
                          assignments.data == null) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                Constants.noRecentAssignmentTextBatchCreated,
                                style: Constants.noDataTextStyle
                                    .copyWith(color: const Color(0xFF212121)),
                              ),
                            ),
                          ],
                        );
                      } else if (assignments.hasData) {
                        List<dynamic>? assignmentdata =
                            assignments.data as List<dynamic>?;
                        List<dynamic> assignment = [];
                        for (var element in assignmentdata!) {
                          if (element["extra_books"] != null) {
                            int _assignmentItemIndex = 0;
                            element["extra_books"].forEach((ebooks) {
                              assignment.add({
                                'assignment_image_url':
                                    'assets/images/books_category.png',
                                'assignment_category': 'extra_books',
                                'assignment_sub_category': 'extra_books',
                                'subject_name': element['subject_name'],
                                'subject_id': element['subject_id'],
                                'time': element['time'],
                                'batch_id': element['batch_id'],
                                // 'due': element['time'],
                                'due_date': element['due_date'],
                                'data': Topics(
                                  id: ebooks['assignment_details']["id"],
                                  name: ebooks['assignment_details']["name"],
                                  onlineLink: ebooks['assignment_details']
                                      ["onlineLink"],
                                  topicName: ebooks['assignment_details']
                                      ["topicName"],
                                ),
                                'student_report': ebooks['student_report']
                                    .values
                                    .map<JoinedStudents>(
                                        (i) => JoinedStudents.fromJson(i))
                                    .toList(),
                                "item_index": _assignmentItemIndex.toString(),
                                "assignment_id": element['assignment_id'],
                                // 'data': Topics(
                                //     id: ebooks['assignment_details']["id"],
                                //     name: ebooks['assignment_details']["name"])
                              });
                              _assignmentItemIndex++;
                            });
                          }
                          if (element["stem_videos"] != null) {
                            int _assignmentItemIndex = 0;
                            element["stem_videos"].forEach((svids) {
                              assignment.add({
                                'assignment_image_url':
                                    'assets/images/video_category.png',
                                'assignment_category': 'stem_videos',
                                'assignment_sub_category': 'stem_videos',
                                'time': element['time'],
                                'subject_name': element['subject_name'],
                                'subject_id': element['subject_id'],
                                'due_date': element['due_date'],
                                'data': VideoLessonModel(
                                  detail: svids['assignment_details']["detail"],
                                  id: svids['assignment_details']["id"],
                                  name: svids['assignment_details']["name"],
                                  offlineLink: svids['assignment_details']
                                      ["offlineLink"],
                                  offlineThumbnail: svids['assignment_details']
                                      ["offlineThumbnail"],
                                  onlineLink: svids['assignment_details']
                                      ["onlineLink"],
                                  thumbnail: svids['assignment_details']
                                      ["thumbnail"],
                                  topicName: svids['assignment_details']
                                      ["topicName"],
                                ),
                                'student_report': svids['student_report']
                                    .values
                                    .map<JoinedStudents>(
                                        (i) => JoinedStudents.fromJson(i))
                                    .toList(),
                                // 'assignment_progress': svids['student_report'][appUser.userID]
                                // ['progress'],
                                // if (svids['student_report'][appUser.userID]['progress'] !=
                                //     null)
                                //   "progress_text": svids['student_report'][appUser.userID]
                                //   ['progress']
                                //       .values
                                //       .last['progress_text'],
                                // if (svids['student_report'][appUser.userID]['progress'] !=
                                //     null)
                                //   "progress_text_color": svids['student_report']
                                //   [appUser.userID]['progress']
                                //       .values
                                //       .last['progress_text_color'],
                                "item_index": _assignmentItemIndex.toString(),
                                "assignment_id": element['assignment_id'],
                              });
                              _assignmentItemIndex++;
                            });
                          }
                          if (element["videos"] != null) {
                            int _assignmentItemIndex = 0;
                            element["videos"].forEach((svids) {
                              assignment.add({
                                'assignment_image_url':
                                    'assets/images/video_category.png',
                                'assignment_category': 'subjects',
                                'assignment_sub_category': 'videos',
                                'time': element['time'],
                                'subject_name': element['subject_name'],
                                'subject_id': element['subject_id'],
                                'due_date': element['due_date'],
                                'data': VideoLessonModel(
                                  detail: svids['assignment_details']["detail"],
                                  id: svids['assignment_details']["id"],
                                  name: svids['assignment_details']["name"],
                                  offlineLink: svids['assignment_details']
                                      ["offlineLink"],
                                  offlineThumbnail: svids['assignment_details']
                                      ["offlineThumbnail"],
                                  onlineLink: svids['assignment_details']
                                      ["onlineLink"],
                                  thumbnail: svids['assignment_details']
                                      ["thumbnail"],
                                  topicName: svids['assignment_details']
                                      ["topicName"],
                                ),
                                'student_report': svids['student_report']
                                    .values
                                    .map<JoinedStudents>(
                                        (i) => JoinedStudents.fromJson(i))
                                    .toList(),
                                // 'assignment_progress': svids['student_report'][appUser.userID]
                                // ['progress'],
                                // if (svids['student_report'][appUser.userID]['progress'] !=
                                //     null)
                                //   "progress_text": svids['student_report'][appUser.userID]
                                //   ['progress']
                                //       .values
                                //       .last['progress_text'],
                                // if (svids['student_report'][appUser.userID]['progress'] !=
                                //     null)
                                //   "progress_text_color": svids['student_report']
                                //   [appUser.userID]['progress']
                                //       .values
                                //       .last['progress_text_color'],
                                "item_index": _assignmentItemIndex.toString(),
                                "assignment_id": element['assignment_id'],
                              });
                              _assignmentItemIndex++;
                            });
                          }
                          if (element["practice"] != null) {
                            int _assignmentItemIndex = 0;
                            element["practice"].forEach((practice) {
                              assignment.add({
                                'assignment_image_url':
                                    'assets/images/practice_category.png',
                                'assignment_category': 'subjects',
                                'assignment_sub_category': 'practice',
                                'time': element['time'],
                                'subject_name': element['subject_name'],
                                'subject_id': element['subject_id'],
                                'class_number': element['class_number'],
                                "language": element['language'],
                                'due_date': element['due_date'],
                                'data': PracticeModel.fromJson(
                                    practice['assignment_details']),
                                'student_report': practice['student_report']
                                    .values
                                    .map<JoinedStudents>(
                                        (i) => JoinedStudents.fromJson(i))
                                    .toList(),
                                // 'assignment_progress': practice['student_report']
                                // [appUser.userID]['progress'],
                                // if (practice['student_report'][appUser.userID]['progress'] !=
                                //     null)
                                //   "progress_text": practice['student_report'][appUser.userID]
                                //   ['progress']
                                //       .values
                                //       .last['progress_text'],
                                // if (practice['student_report'][appUser.userID]['progress'] !=
                                //     null)
                                //   "progress_text_color": practice['student_report']
                                //   [appUser.userID]['progress']
                                //       .values
                                //       .last['progress_text_color'],
                                "item_index": _assignmentItemIndex.toString(),
                                "assignment_id": element['assignment_id'],

                                // PracticeModel(
                                //   foundationalTopicID: practice["foundationalTopicID"],
                                //   isAlternateLanguageAvailable:
                                //       practice["isAlternateLanguageAvailable"],
                                //   tName: practice["tName"],
                                //   tNameAlt: practice["tNameAlt"],
                                //   topicID: practice["topicID"],
                                // )
                              });
                              _assignmentItemIndex++;
                            });
                            // element["practice"].forEach((practice) {
                            //   assignment.add({
                            //     'assignment_image_url':
                            //     'assets/images/practice_category.png',
                            //     'time': element['time'],
                            //     'due': element['time'],
                            //     'data': PracticeModel.fromJson(
                            //         practice['assignment_details'])
                            //
                            //     // PracticeModel(
                            //     //   foundationalTopicID:
                            //     //       practice["foundationalTopicID"],
                            //     //   isAlternateLanguageAvailable:
                            //     //       practice["isAlternateLanguageAvailable"],
                            //     //   tName: practice["tName"],
                            //     //   tNameAlt: practice["tNameAlt"],
                            //     //   topicID: practice["topicID"],
                            //     // )
                            //   });
                            // });
                          }

                          if (element["notes"] != null) {
                            int _assignmentItemIndex = 0;
                            element["notes"].forEach((notes) {
                              assignment.add({
                                'assignment_image_url':
                                    'assets/images/notes_category.png',
                                'assignment_category': 'subjects',
                                'assignment_sub_category': 'notes',
                                'time': element['time'],
                                'subject_name': element['subject_name'],
                                'subject_id': element['subject_id'],
                                'due_date': element['due_date'],
                                'data': NotesModel(
                                  id: notes['assignment_details']["id"],
                                  boardID: notes['assignment_details']
                                      ["boardID"],
                                  classID: notes['assignment_details']
                                      ["classID"],
                                  language: notes['assignment_details']
                                      ["language"],
                                  subjectName: notes['assignment_details']
                                      ["subjectName"],
                                  chapterName: notes['assignment_details']
                                      ["chapterName"],
                                  noteDetails: notes['assignment_details']
                                      ["bookDetails"],
                                  noteID: notes['assignment_details']["bookID"],
                                  noteName: notes['assignment_details']
                                      ["bookName"],
                                  noteOfflineLink: notes['assignment_details']
                                      ["bookOfflineLink"],
                                  noteOfflineThumbnail:
                                      notes['assignment_details']
                                          ["bookOfflineThumbnail"],
                                  noteOnlineLink: notes['assignment_details']
                                      ["bookOnlineLink"],
                                  noteThumbnail: notes['assignment_details']
                                      ["bookThumbnail"],
                                  noteTopicName: notes['assignment_details']
                                      ["bookTopicName"],
                                ),
                                'student_report': notes['student_report']
                                    .values
                                    .map<JoinedStudents>(
                                        (i) => JoinedStudents.fromJson(i))
                                    .toList(),
                                "item_index": _assignmentItemIndex.toString(),
                                "assignment_id": element['assignment_id'],
                              });
                              _assignmentItemIndex++;
                            });
                          }
                          if (element["books"] != null) {
                            int _assignmentItemIndex = 0;
                            element["books"].forEach((books) {
                              assignment.add({
                                'assignment_image_url':
                                    'assets/images/books_category.png',
                                'assignment_category': 'subjects',
                                'assignment_sub_category': 'books',
                                'time': element['time'],
                                'subject_name': element['subject_name'],
                                'subject_id': element['subject_id'],
                                'due_date': element['due_date'],
                                'data': BooksModel(
                                  id: books['assignment_details']["id"],
                                  boardID: books['assignment_details']
                                      ["boardID"],
                                  classID: books['assignment_details']
                                      ["classID"],
                                  language: books['assignment_details']
                                      ["language"],
                                  subjectName: books['assignment_details']
                                      ["subjectName"],
                                  chapterName: books['assignment_details']
                                      ["chapterName"],
                                  bookDetails: books['assignment_details']
                                      ["bookDetails"],
                                  bookID: books['assignment_details']["bookID"],
                                  bookName: books['assignment_details']
                                      ["bookName"],
                                  bookOfflineLink: books['assignment_details']
                                      ["bookOfflineLink"],
                                  bookOfflineThumbnail:
                                      books['assignment_details']
                                          ["bookOfflineThumbnail"],
                                  bookOnlineLink: books['assignment_details']
                                      ["bookOnlineLink"],
                                  bookThumbnail: books['assignment_details']
                                      ["bookThumbnail"],
                                  bookTopicName: books['assignment_details']
                                      ["bookTopicName"],
                                ),
                                'student_report': books['student_report']
                                    .values
                                    .map<JoinedStudents>(
                                        (i) => JoinedStudents.fromJson(i))
                                    .toList(),
                                "item_index": _assignmentItemIndex.toString(),
                                "assignment_id": element['assignment_id'],
                              });
                              _assignmentItemIndex++;
                            });
                          }
                        }
                        if (assignment.length >= 6) {
                          assignment = assignment.sublist(
                              assignment.length - 6, assignment.length);
                        }
                        assignment = List.from(assignment.reversed);
                        return Column(
                          children: List.generate(assignment.length, (index) {
                            return InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                    builder: (_) => AssignmentReportPage(
                                      assignment: assignment[index],
                                      batchId: assignment[index]['batch_id'],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  Constants
                                                      .months[DateTime.parse(
                                                              assignment[index]
                                                                  ['time'])
                                                          .month -
                                                      1],
                                                  style: const TextStyle(
                                                      fontSize: 10.0,
                                                      color: Color(0xFF9E9E9E)),
                                                ),
                                                Text(
                                                  (DateTime.parse(
                                                              assignment[index]
                                                                  ['time'])
                                                          .day /*+
                                                  1*/
                                                      )
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 10.0,
                                                      color: Color(0xFF9E9E9E)),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.0),
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 8, right: 12.0),
                                                child: Image.asset(
                                                  assignment[index]
                                                      ['assignment_image_url'],
                                                  height: 36.0,
                                                  width: 36.0,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    assignment[index]['data']
                                                                is VideoLessonModel ||
                                                            assignment[index]
                                                                    ['data']
                                                                is Topics
                                                        ? assignment[index]['data']
                                                            .name
                                                        : assignment[index]
                                                                        ['data']
                                                                    is PracticeModel ||
                                                                assignment[index]
                                                                        ['data']
                                                                    is TestModel
                                                            ? assignment[index]
                                                                    ['data']
                                                                .tName
                                                            : assignment[index]
                                                                        ['data']
                                                                    is NotesModel
                                                                ? assignment[index]
                                                                        ['data']
                                                                    .chapterName
                                                                : assignment[index]
                                                                            ['data']
                                                                        is BooksModel
                                                                    ? assignment[index]['data'].bookName
                                                                    : '',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .values[5],
                                                        fontSize: 14,
                                                        color: const Color(
                                                            0xFF212121)),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    '${assignment[index]['subject_name']} | Due: ${DateTime.parse(assignment[index]['due_date']).day} ${Constants.months[DateTime.parse(assignment[index]['due_date']).month - 1]} ${DateTime.parse(assignment[index]['due_date']).year}',
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF9E9E9E),
                                                        fontSize: 12.0),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                  // Text(
                                                  //   'Maths | Due: ${DateTime.parse(assignment[index]['due']).day + 3} ${Constants.months[DateTime.parse(assignment[index]['due']).month - 1]} ${DateTime.parse(assignment[index]['due']).year}',
                                                  //   // Due Thur, 7:40 PM
                                                  //   style: TextStyle(
                                                  //       color: Color(0xFFB1B1B1),
                                                  //       fontWeight: FontWeight.w100,
                                                  //       fontSize: 11.0),
                                                  //   overflow: TextOverflow.clip,
                                                  // )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(left: 30.0),
                                        child: const Icon(
                                          Icons.chevron_right_outlined,
                                          color: Color(0xFFB1B1B1),
                                        ),
                                      )
                                    ]),
                              ),
                            );
                          }),
                        );
                      } else {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: true,
                          period: const Duration(seconds: 2),
                          child: Container(
                            height: 80,
                            width: double.maxFinite,
                            color: Colors.grey,
                          ),
                        );
                      }
                    },
                  );
                }),
        ],
      ),
    );
  }

  getShimmer() {
    return Column(
      children: [
        myBatchShimmer(),
        shimmerBatchWidget(),
        shimmerBatchWidget(),
        shimmerBatchWidget(),
        shimmerBatchWidget(),
        shimmerBatchWidget(),
        shimmerBatchWidget(),
      ],
    );
  }
}

myBatchShimmer() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Shimmer(
        gradient: Constants.shimmerGradient,
        child: Text(
          "My Batches",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: const [
            Shimmer(
              gradient: Constants.shimmerGradient,
              child: Icon(
                Icons.add_circle_outline,
                size: 15.0,
                color: Color(0xff0070FF),
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Shimmer(
              gradient: Constants.shimmerGradient,
              child: Text(
                "New",
                style: TextStyle(fontSize: 16, color: Color(0xff0070FF)),
              ),
            ),
          ],
        ),
      )
    ],
  );
}

showBatchBottomSheet(BuildContext context, List<Batch>? batchList) async {
  showMaterialModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    ),
    context: context,
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .50,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  height: 3,
                  width: 40,
                  color: const Color(0xffDEDEDE),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  "Select a Batch",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, color: Color(0xff666666)),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: batchList!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          showClassBottomSheet(context, batchList[index]);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 44,
                                      width: 44,
                                      decoration: const BoxDecoration(
                                          color: Color(0xffD1E6FF),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                      child: Text(
                                        batchList[index].batchClass!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xff0070FF)),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            batchList[index].batchName!,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff212121)),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            batchList[index]
                                                .batchSubject!
                                                .map((e) => e.subjectName)
                                                .toList()
                                                .toString(),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff666666)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                "${batchList[index].joinedStudentsList!.length} Students",
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xff212121)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      );
    },
  );
}
