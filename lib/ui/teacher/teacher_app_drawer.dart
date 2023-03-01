import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/user.dart';
import 'package:idream/repository/app_rating.dart';
import 'package:idream/repository/in_app.dart';
import 'package:idream/repository/payment_repository.dart';
import 'package:idream/ui/menu/app_drawer.dart';
import 'package:idream/ui/menu/contact_us_page.dart';
import 'package:idream/ui/menu/edit_profile_page.dart';
import 'package:idream/ui/menu/upgrade_plan_page.dart';
import 'package:idream/ui/onboarding/app_level_language_selection_screen.dart';
import 'package:idream/ui/teacher/my_iprep_referrals_page.dart';
import 'package:idream/ui/teacher/switch_profile_bottom_sheet_page.dart';

import '../../subscription/andriod/android_subscription.dart';

class TeacherAppDrawer extends StatefulWidget {
  @override
  _TeacherAppDrawerState createState() => _TeacherAppDrawerState();
}

class _TeacherAppDrawerState extends State<TeacherAppDrawer> {
  bool userAlreadyLoggedIn = false;
  Size? _screenSize;

  Future _getSavedFullName() async {
    return await getStringValuesSF("fullName");
  }

  Future _getUserPlans() async {
    // String userPlans = await getStringValuesSF("userPlanStatus");
    // if (userPlans == null) {
    //   await upgradePlanRepository.checkUserSubscriptionPlan();
    // }
    // if (userPlans != "trial") {
    //   String _planStartDate = await getStringValuesSF("userPlanDateStarted");
    //
    //   DateTime _dateTime =
    //       DateTime.parse(_planStartDate).add(Duration(days: 365));
    //
    //   if (_dateTime.compareTo(DateTime.now()) > 0) {
    //     return true;
    //   }
    // }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Drawer(
      elevation: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          left: 6,
          right: 6,
        ),
        child: ListView(
          shrinkWrap: true,
          physics: (_screenSize!.height > 700.0)
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 62,
                bottom: 62,
              ),
              child: Image.asset(
                'assets/images/app_logo_menu.png',
                height: 40,
                // width: ScreenUtil().setSp(24, ),
              ),
            ),
            FutureBuilder(
              future: upgradePlanRepository.getUserPlans(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    if (!snapshot.data) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: Image.asset(
                          'assets/images/free_trial.png',
                          height: 14,
                          // width: ScreenUtil().setSp(24, ),
                        ),
                      );
                    }
                  }
                }
                return Container();
              },
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  updatedAppUser = AppUser(
                    userID: appUser!.userID,
                    boardID: appUser!.boardID,
                    classID: appUser!.classID,
                    educationBoard: appUser!.educationBoard,
                    studentClass: appUser!.studentClass,
                    stream: appUser!.stream,
                    fullName: appUser!.fullName,
                    age: appUser!.age,
                    gender: appUser!.gender,
                    dateOfBirth: appUser!.dateOfBirth,
                    mobile: appUser!.mobile,
                    parentContact: appUser!.parentContact,
                    email: appUser!.email,
                    address: appUser!.address,
                    state: appUser!.state,
                    city: appUser!.city,
                    school: appUser!.school,
                    deviceID: appUser!.deviceID,
                    language: appUser!.language,
                    packageLanguage: appUser!.packageLanguage,
                    token: appUser!.token,
                    totalTime: appUser!.totalTime,
                    userType: appUser!.userType,
                    userPlans: appUser!.userPlans,
                  );
                  profileEdited = false;
                  await Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (BuildContext context) => const EditProfilePage(
                        coachApp: true,
                      ),
                    ),
                  );
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, top: 10, bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl: (appUser!.profilePhoto != null)
                                    ? appUser!.profilePhoto!
                                    : Constants.defaultProfileImagePath,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 50,
                                  height: 50,
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
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      strokeWidth: 0.5,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              FutureBuilder(
                                future: _getSavedFullName(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    debugPrint(
                                        'itemNo in FutureBuilder: ${snapshot.data}');
                                    return Text(
                                      snapshot.data ?? '',
                                      style: TextStyle(
                                          color: const Color(0xFF000000),
                                          fontSize: 16,
                                          fontWeight: FontWeight.values[5]),
                                    );
                                  } else {
                                    return const Text('Loading...');
                                  }
                                },
                              ),
                            ],
                          ),
                          Image.asset(
                            'assets/images/forward_arrow.png',
                            height: 24,
                            // width: ScreenUtil().setSp(24, ),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       width: 62,
                      //     ),
                      //     InkWell(
                      //       onTap: () async {
                      //         await showSwitchProfileBottomSheet(
                      //             context: context);
                      //       },
                      //       child: Text(
                      //         "Switch Profile",
                      //         style: TextStyle(
                      //           color: Color(0xFF0077FF),
                      //           fontSize: 10,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 14,
                bottom: 24,
              ),
              color: const Color(0xFFBDBDBD),
              child: const SizedBox(
                height: 0.5,
              ),
            ),
            StreamBuilder(
                stream: getUserPlanDetails(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    int _duration = int.parse(
                        snapshot.data.snapshot.value['plan_duration']);
                    DateTime _startingDate = DateTime.parse(
                        snapshot.data.snapshot.value['date_started']);
                    bool _planExpired = DateTime.now().compareTo(
                            _startingDate.add(Duration(days: _duration))) >
                        0;
                    if ((snapshot.data.snapshot.value['status'] == "Trial") ||
                        _planExpired) {
                      if (Platform.isAndroid || Platform.isIOS) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: upgradeProfileButton(context),
                        );
                      } else {
                        // return DrawerOption(
                        //   screenSize: _screenSize,
                        //   imagePath: 'assets/images/ios_plans.png',
                        //   optionName: 'My iPrep Plan',
                        //   onTap: () async {
                        //     Navigator.of(context).push(CupertinoPageRoute(
                        //         builder: (context) => IosPlansPage()));
                        //   },
                        //   imageHeight: 10.14,
                        //   imageColor:const Color(0xFF9E9E9E),
                        //   imageWidth: 10.6,
                        // );

                      }
                    }
                  }
                  return Container();
                }),
            FutureBuilder(
              future: getStringValuesSF("language"),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return DrawerOption(
                    screenSize: _screenSize,
                    imagePath: 'assets/images/language_icon.png',
                    optionName: 'Language',
                    imageColor: const Color(0xFF9E9E9E),
                    trailingWidget: Text(
                      snapshot.data.toString().substring(0, 1).toUpperCase() +
                          snapshot.data
                              .toString()
                              .substring(1, snapshot.data.toString().length),
                      style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 12,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              const AppLevelLanguageSelectionScreen(
                            isCoachSection: true,
                          ),
                        ),
                      );
                    },
                    imageHeight: 14.67,
                    imageWidth: 11,
                  );
                } else {
                  return Container();
                }
              },
            ),
            // const SizedBox(
            //   height: 12,
            // ),
            DrawerOption(
              screenSize: _screenSize,
              imagePath: 'assets/images/share_and_earn.png',
              optionName: 'My iPrep Referrals',
              onTap: () async {
                // await Navigator.push(
                //   context,
                //   CupertinoPageRoute(
                //     builder: (BuildContext context) => ZeroStateDashboard(),
                //   ),
                // );
                await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        const MyIprepReferralsPage(),
                  ),
                );
              },
              imageHeight: 14.67,
              imageWidth: 11,
            ),
            // const SizedBox(
            //   height: 12,
            // ),
            DrawerOption(
              screenSize: _screenSize,
              imagePath: 'assets/images/share_and_earn.png',
              optionName: 'Share and Earn',
              onTap: () async {
                var _deepLinkUrl =
                    await shareEarnRepository.prepareDeepLinkForAppDownload();
                await shareEarnRepository.shareContent(
                    context: context, content: _deepLinkUrl.toString());
                // await Navigator.push(
                //   context,
                //   CupertinoPageRoute(
                //     builder: (BuildContext context) => ShareAndEarnPage(),
                //   ),
                // );
              },
              imageHeight: 14.67,
              imageWidth: 11,
            ),
            // const SizedBox(
            //   height: 22,
            // ),
            DrawerOption(
              screenSize: _screenSize,
              imagePath:
                  'assets/images/${Platform.isAndroid ? 'play_store.png' : 'app_store.png'}',
              optionName:
                  'Rate us on ${Platform.isAndroid ? "Play store" : "App store"}',
              onTap: () async {
                AppRatingRepository.rateApp(Constants.rateMyApp, context,
                    ignoreNativeAppRating: false);
              },
              imageHeight: 13.14,
              imageWidth: 14.6,
            ),
            // const SizedBox(
            //   height: 22,
            // ),
            DrawerOption(
              screenSize: _screenSize,
              imagePath: "assets/images/contact_us.png",
              optionName: 'Contact Us',
              onTap: () async {
                await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ContactUsPage(),
                  ),
                );
              },
              imageHeight: 14.6,
              imageWidth: 13,
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              color: const Color(0xFFBDBDBD),
              child: const SizedBox(
                height: 0.5,
              ),
            ),
            !userAlreadyLoggedIn
                ? DrawerOption(
                    screenSize: _screenSize,
                    imagePath: 'assets/images/logout.png',
                    optionName: 'Logout',
                    onTap: () async {
                      displayLogout(context);
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // await prefs.clear();
                      // appUser = AppUser();
                      // updatedAppUser = AppUser();
                      // await Navigator.pushReplacement(
                      //   context,
                      //   CupertinoPageRoute(
                      //     builder: (context) =>
                      //         AppLevelLanguageSelectionScreen(),
                      //   ),
                      // );
                    },
                    imageHeight: 14.6,
                    imageWidth: 14.6,
                  )
                : Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 10 / 640,
                      right: MediaQuery.of(context).size.width * 21 / 360,
                      left: MediaQuery.of(context).size.width * 21 / 360,
                    ),
                    child: Column(
                      children: [
                        Container(),
                        if (Platform.isIOS)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Container(),
                          ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          "(Helps bookmark stories)",
                          //ToDo: Update this styling
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF111111),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.14,
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class DrawerOption extends StatelessWidget {
  final Size? screenSize;
  final String imagePath;
  final String optionName;
  final Function onTap;
  final Widget? trailingWidget;
  final double imageHeight;
  final double imageWidth;
  final Color? imageColor;

  const DrawerOption({
    Key? key,
    required this.screenSize,
    required this.imagePath,
    required this.optionName,
    required this.onTap,
    this.trailingWidget,
    required this.imageHeight,
    required this.imageWidth,
    this.imageColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap as void Function()?,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    imagePath,
                    height: 24,
                    width: 24,
                    color: imageColor,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    optionName,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF212121),
                      fontWeight: FontWeight.values[4],
                    ),
                  ),
                ],
              ),
              if (trailingWidget != null) trailingWidget!,
            ],
          ),
        ),
      ),
    );
  }
}

Widget upgradeProfileButton(BuildContext _context) {
  return Center(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            _context,
            CupertinoPageRoute(
              builder: (BuildContext context) => Platform.isAndroid
                  ? const AndroidSubscriptionPlan()
                  : const UpgradePlan(),
            ),
          );
        },
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 48,
            maxWidth: 248,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(
                12.0,
              ),
            ),
            border: Border.all(
              color: const Color(0xFF3D99FF),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  right: 5,
                ),
                child: Image.asset(
                  'assets/images/star.png',
                  height: 12,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 5,
                ),
                child: Text(
                  "Upgrade",
                  style: TextStyle(
                    color: const Color(0xFF3D99FF),
                    fontWeight: FontWeight.values[4],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
