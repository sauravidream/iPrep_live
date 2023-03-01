import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/custom_widgets/dialog_box.dart';
import 'package:idream/model/user.dart';
import 'package:idream/repository/app_rating.dart';
import 'package:idream/repository/payment_repository.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:idream/ui/menu/contact_us_page.dart';
import 'package:idream/ui/menu/edit_profile_page.dart';
import 'package:idream/ui/menu/how_app_works_page.dart';
import 'package:idream/ui/menu/share_and_earn_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/ui/onboarding/app_level_language_selection_screen.dart';
import '../../common/global_variables.dart';
import '../../subscription/andriod/android_subscription.dart';
import '../../subscription/iOS/iOS.dart';
import '../../test_page.dart';
import '../onboarding/login_options.dart';

class AppDrawer extends StatefulWidget {
  final DashboardScreenState? dashboardScreenState;

  const AppDrawer({Key? key, this.dashboardScreenState}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool userAlreadyLoggedIn = false;
  Size? _screenSize;

  Future _getSavedFullName() async {
    return await getStringValuesSF("fullName");
  }

  Future _getClassAndBoard() async {
    String? classNumber = await getStringValuesSF("classNumber");
    String? board = await getStringValuesSF("educationBoard");
    return "Class $classNumber | $board Board";
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Drawer(
      elevation: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Column(
          children: [
            Expanded(
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
                      bottom: 26,
                    ),
                    child: Image.asset(
                      'assets/images/app_logo_menu.png',
                      height: 40,
                      // width: ScreenUtil().setSp(24, ),
                    ),
                  ),
                  userPlanWidget(),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.0),
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
                            builder: (BuildContext context) =>
                                const EditProfilePage(),
                          ),
                        );
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                          (context, url, downloadProgress) =>
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
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder(
                                          future: _getSavedFullName(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              // print(
                                              //     'itemNo in FutureBuilder: ${snapshot.data}');
                                              return Text(
                                                snapshot.data ?? '',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xFF000000),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.values[5]),
                                              );
                                            } else {
                                              return const Text('Loading...');
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        FutureBuilder(
                                          future: _getClassAndBoard(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              // print(
                                              //     'itemNo in FutureBuilder: ${snapshot.data}');
                                              return Text(
                                                snapshot.data,
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xFF9E9E9E),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.values[4]),
                                              );
                                            } else {
                                              return const Text('Loading...');
                                            }
                                          },
                                        ),
                                      ],
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 16,
                      bottom: 16,
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
                          int duration = int.parse(
                              snapshot.data.snapshot.value['plan_duration']);
                          DateTime startingDate = DateTime.parse(
                              snapshot.data.snapshot.value['date_started']);
                          bool planExpired = DateTime.now().compareTo(
                                  startingDate.add(Duration(days: duration))) >
                              0;
                          if ((snapshot.data.snapshot.value['status'] ==
                                  "Trial") ||
                              planExpired) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 22,
                              ),
                              child: upgradeProfileButton(context),
                            );
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
                          imageColor: const Color(0xFF212121),
                          trailingWidget: Text(
                            snapshot.data
                                    .toString()
                                    .substring(0, 1)
                                    .toUpperCase() +
                                snapshot.data.toString().substring(
                                    1, snapshot.data.toString().length),
                            style: const TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 12,
                            ),
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const AppLevelLanguageSelectionScreen(
                                  isCoachSection: true,
                                ),
                              ),
                            );
                            if (!mounted) return;
                            await Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const DashboardScreen(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                            // widget.dashboardScreenState.setState(() {});
                          },
                          imageHeight: 14.67,
                          imageWidth: 11,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  DrawerOption(
                    screenSize: _screenSize,
                    imagePath: 'assets/images/share_and_earn.png',
                    optionName: 'Share and Earn',
                    imageColor: const Color(0xFF212121),
                    onTap: () async {
                      String? appLevelLanguage =
                          await getStringValuesSF('language');
                      if (!mounted) return;
                      await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (BuildContext context) => ShareAndEarnPage(
                              appLevelLanguage: appLevelLanguage),
                        ),
                      );
                    },
                    imageHeight: 14.67,
                    imageWidth: 11,
                  ),
                  DrawerOption(
                    screenSize: _screenSize,
                    imageColor: const Color(0xFF212121),
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
                  DrawerOption(
                    screenSize: _screenSize,
                    imagePath: 'assets/images/app_tour.png',
                    optionName: 'How the app works',
                    imageColor: const Color(0xFF212121),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const HowAppWorks(),
                        ),
                      );
                    },
                    imageHeight: 12,
                    imageWidth: 12,
                  ),
                  DrawerOption(
                    screenSize: _screenSize,
                    imagePath: "assets/images/contact_us.png",
                    optionName: 'Contact Us',
                    imageColor: const Color(0xFF212121),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const ContactUsPage(),
                        ),
                      );
                    },
                    imageHeight: 14.6,
                    imageWidth: 13,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
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
                          imageColor: const Color(0xFF212121),
                          optionName: 'Logout',
                          onTap: () async {
                            displayLogout(context);
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
                            children: const [
                              SizedBox(
                                height: 12,
                              ),
                              Text(
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
                        ),
                  if (kDebugMode) ...[
                    DrawerOption(
                      screenSize: _screenSize,
                      imagePath: "assets/images/contact_us.png",
                      optionName: 'Working',
                      imageColor: const Color(0xFF212121),
                      onTap: () async {
                        String? userType = await getStringValuesSF("UserType");
                        print(userType);
                        // await Navigator.push(
                        //   context,
                        //   CupertinoPageRoute(
                        //     builder: (context) => const DevelopmentPage(),
                        //   ),
                        // );
                      },
                      imageHeight: 14.6,
                      imageWidth: 13,
                    ),
                  ]
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Version: ",
                  style: TextStyle(fontSize: 10),
                ),
                Text(
                  packageInfoP?.version.toString() ?? '',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget userPlanWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 26,
      ),
      child: StreamBuilder(
          stream: getUserPlanDetails(),
          builder: (context, AsyncSnapshot snapshot) {
            List<Widget> planWidgetList = [
              const CircularProgressIndicator(
                strokeWidth: .1,
              )
            ];
            if (snapshot.hasData && snapshot.data != null) {
              int duration =
                  int.parse(snapshot.data.snapshot.value['plan_duration']);
              DateTime startingDate =
                  DateTime.parse(snapshot.data.snapshot.value['date_started']);
              bool planExpired = DateTime.now()
                      .compareTo(startingDate.add(Duration(days: duration))) >
                  0;

              if ((snapshot.data.snapshot.value['status'] == "Trial")) {
                planWidgetList = <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        left: 6, right: 6, top: 2, bottom: 2),
                    decoration: BoxDecoration(
                        color: const Color(0xFFD1E6FF),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text(
                      'Free Trial',
                      style: TextStyle(
                        color: Color(0xFF0077FF),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Days left: ${Constants.daysBetween(from: startingDate, duration: duration)} Days ",
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 12,
                    ),
                  ),
                ];
              } else if (!planExpired) {
                planWidgetList = <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        left: 6, right: 6, top: 2, bottom: 2),
                    decoration: BoxDecoration(
                        color: const Color(0xFF22C55E).withOpacity(.2),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text(
                      "Pro",
                      style: TextStyle(
                        color: Color(0xFF22C55E),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Days left: ${Constants.daysBetween(from: startingDate, duration: duration)} Days ",
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 12,
                    ),
                  ),
                ];
              } else {
                planWidgetList = <Widget>[
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 6, right: 6, top: 2, bottom: 2),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(5)),
                        child: const Text(
                          "Plan Expired",
                          style: TextStyle(
                            color: Color(0xFF334155),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Days left: ${Constants.daysBetween(from: startingDate, duration: duration)} Days ",
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ];
              }
            }
            return Column(children: planWidgetList);
          }),
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
        borderRadius: BorderRadius.circular(10.0),
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

Widget upgradeProfileButton(
  BuildContext context,
) {
  return Center(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onLongPress: () {
          userRepository.clearLocalDataBase(context);
        },
        onTap: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (BuildContext context) => Platform.isAndroid
                    ? const AndroidSubscriptionPlan()
                    // const AndroidSubscriptionPlan()
                    // : const UpgradePlan()
                    : const UpgradePlan()
                // const UpgradePlan()
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

displayLogout(context) {
  AlertPopUp(
    context: context,
    title: "Log Out",
    desc: "Are you sure?",
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
          await userRepository.logOut(context);
          await Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => const LoginOptions(),
            ),
          );
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
}
