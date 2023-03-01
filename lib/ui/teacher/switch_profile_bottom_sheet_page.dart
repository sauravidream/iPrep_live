import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/model/user.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:idream/ui/my_teachers_flies/name_enter_coach_screen.dart';
import 'package:idream/ui/onboarding/board_selection_screen.dart';
import 'package:idream/ui/teacher/dashboard_coach.dart';
import 'package:shared_preferences/shared_preferences.dart';

AppUser _fetchedUserDetails = AppUser();

String? _fetchedUserType;

Future _switchUserProfile(
    AppUser? userDetails, BuildContext context, String? userType) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  appUser = AppUser();
  updatedAppUser = AppUser();
  appUser = userDetails;

  if (userDetails == null || (userDetails).mobile == null) {
    await Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => BoardSelectionScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  } else if ((userDetails).classID == null) {
    if (userType == "Student") {
      await userRepository.saveUserDetailToLocal("UserType", userType!);
    } else {
      await userRepository.saveUserDetailToLocal("UserType", "Coach");
    }
    AppUser _appUser = userDetails;
    await userRepository.saveUserDetailToLocal("userID", _appUser.userID!);
    //Save userType
    await userRepository.saveUserDetailToLocal("userType", _appUser.userType!);
    //Save displayName
    await userRepository.saveUserDetailToLocal("fullName", _appUser.fullName!);
    //Save mobileNumber
    await userRepository.saveUserDetailToLocal(
        "mobileNumber", _appUser.mobile!);
    //Save fcmToken
    await userRepository.saveUserDetailToLocal("fcmToken", _appUser.token!);
    await userRepository.saveUserDetailToLocal("email", _appUser.email!);
    // if (loginScreenState != null) {
    //   loginScreenState.setState(() {
    //     loginScreenState.showLoader = false;
    //   });
    // }
    //TODO: Here we are changing the Flow...
    String? _userType = await getStringValuesSF("UserType");
    //Check whether Logged in user is a teacher
    if ((_userType != null && _userType == "Coach")) {
      if (((userDetails).fullName != null) &&
          ((userDetails).fullName!.isNotEmpty)) {
        //Move to Dashboard of Teacher
        await userRepository.saveUserDetailToLocal("age", _appUser.age!);
        await userRepository.saveUserDetailToLocal(
            "address", _appUser.address!);
        await userRepository.saveUserDetailToLocal("gender", _appUser.gender!);
        await userRepository.saveUserDetailToLocal("city", _appUser.city!);
        await userRepository.saveUserDetailToLocal(
            "dateOfBirth", _appUser.dateOfBirth!);
        await userRepository.saveUserDetailToLocal(
            'language', _appUser.language!);
        await userRepository.saveUserDetailToLocal(
            "parentContact", _appUser.parentContact!);
        await userRepository.saveUserDetailToLocal("school", _appUser.school!);
        await userRepository.saveUserDetailToLocal("state", _appUser.state!);
        await userRepository.saveUserDetailToLocal(
            "userType", _appUser.userType!);
        await userRepository.saveUserDetailToLocal(
            "userPlanStatus", _appUser.userPlans!.status!);
        await userRepository.saveUserDetailToLocal(
            "userPlanDuration", _appUser.userPlans!.planDuration!);
        await userRepository.saveUserDetailToLocal(
            "userPlanDateStarted", _appUser.userPlans!.dateStarted!);
        await userRepository.saveUserDetailToLocal(
            "profilePhoto", _appUser.profilePhoto!);
        await userRepository.saveUserDetailToLocal("onBoarding", "Completed");
        await Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => DashboardCoach(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        await Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => NameEnterCoachScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => BoardSelectionScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  } else {
    //SAVE ALL THE INFORMATION HERE
    if (userType == "Student") {
      await userRepository.saveUserDetailToLocal("UserType", userType!);
    } else {
      await userRepository.saveUserDetailToLocal("UserType", "Coach");
    }
    AppUser _appUser = userDetails;
    await userRepository.saveUserDetailToLocal("userID", _appUser.userID!);
    await userRepository.saveUserDetailToLocal("userType", _appUser.userType!);
    await userRepository.saveUserDetailToLocal("fullName", _appUser.fullName!);
    await userRepository.saveUserDetailToLocal(
        "mobileNumber", _appUser.mobile!);
    await userRepository.saveUserDetailToLocal("fcmToken", _appUser.token!);
    await userRepository.saveUserDetailToLocal('language', _appUser.language!);
    await userRepository.saveUserDetailToLocal(
        "educationBoard", _appUser.educationBoard ?? _appUser.boardID!);
    await userRepository.saveUserDetailToLocal("email", _appUser.email!);
    await userRepository.saveUserDetailToLocal("age", _appUser.age!);
    await userRepository.saveUserDetailToLocal("gender", _appUser.gender!);
    await userRepository.saveUserDetailToLocal(
        "dateOfBirth", _appUser.dateOfBirth!);
    await userRepository.saveUserDetailToLocal(
        "parentContact", _appUser.parentContact!);
    await userRepository.saveUserDetailToLocal("email", _appUser.email!);
    await userRepository.saveUserDetailToLocal("address", _appUser.address!);
    await userRepository.saveUserDetailToLocal("state", _appUser.state!);
    await userRepository.saveUserDetailToLocal("city", _appUser.city!);
    await userRepository.saveUserDetailToLocal("school", _appUser.school!);
    await userRepository.saveUserDetailToLocal(
        "profilePhoto", _appUser.profilePhoto!);

    if (_appUser.classID!.contains("_")) {
      String _stream = _appUser.classID!.substring(3);
      String _class = _appUser.classID!.substring(0, 2);
      await userRepository.saveUserDetailToLocal("stream", _stream);
      await userRepository.saveUserDetailToLocal("classNumber", _class);
    } else {
      await userRepository.saveUserDetailToLocal(
          "classNumber", _appUser.classID!);
    }
    await userRepository.saveUserDetailToLocal("onBoarding", "Completed");

    await userRepository.saveUserDetailToLocal(
        "userPlanStatus", _appUser.userPlans!.status!);
    await userRepository.saveUserDetailToLocal(
        "userPlanDuration", _appUser.userPlans!.planDuration!);
    await userRepository.saveUserDetailToLocal(
        "userPlanDateStarted", _appUser.userPlans!.dateStarted!);

    if (userType == "Student") {
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => DashboardScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => DashboardCoach(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }
}

Future _getUserProfiles() async {
  _fetchedUserDetails = AppUser();
  _fetchedUserType = null;

  String? _userType = await getStringValuesSF("UserType");
  String? _userID = await (getStringValuesSF("userID"));
  String? _url;
  //fetch information of other profile from the one user is logged in...
  if (_userType == "Student") {
    _fetchedUserType = "Teacher";
    _url = Constants.teacherUserDetailsUrl;
  } else {
    _fetchedUserType = "Student";
    _url = Constants.studentUserDetailsUrl;
  }
  var response = await apiHandler.getAPICall(endPointURL: _url + _userID!);
  // AppUser appUser;
  if (response != null) {
    _fetchedUserDetails = AppUser.fromJson(response);
    _fetchedUserDetails.userID = _userID;
  }
  return _fetchedUserDetails;
}

Future showSwitchProfileBottomSheet({
  required BuildContext context,
}) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    isScrollControlled: true,
    builder: (builder) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        child: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 20,
              ),
              child: Center(
                child: Image.asset(
                  "assets/images/line.png",
                  width: 40,
                ),
              ),
            ),
            Center(
              child: Text(
                "Switch Profile",
                style: TextStyle(color: Color(0xff666666), fontSize: 16),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: getStringValuesSF("UserType"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SwitchProfileTileWidget(
                          selected: true,
                          leadingImagePath: appUser!.profilePhoto ??
                              Constants.defaultProfileImagePath,
                          streamText: appUser!.fullName,
                          selectedColor: 0xFF46B6E9,
                          userType: (snapshot.data == "Coach")
                              ? "Teacher"
                              : "Student",
                        );
                      } else
                        return Container();
                    },
                  ),
                  FutureBuilder(
                    future: _getUserProfiles(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (((snapshot.data) as AppUser).userID != null) {
                          return InkWell(
                            onTap: () async {
                              usingIprepLibrary = !usingIprepLibrary;
                              await _switchUserProfile(
                                  (snapshot.data) as AppUser?,
                                  context,
                                  _fetchedUserType);
                            },
                            child: SwitchProfileTileWidget(
                              selected: false,
                              leadingImagePath:
                                  ((snapshot.data) as AppUser).profilePhoto,
                              streamText: ((snapshot.data) as AppUser).fullName,
                              selectedColor: 0xFF46B6E9,
                              userType: _fetchedUserType,
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 31,
                              bottom: 31,
                            ),
                            child: InkWell(
                              onTap: () async {
                                if (_fetchedUserType == "Teacher") {
                                  await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          NameEnterCoachScreen(
                                        switchProfile: true,
                                      ),
                                    ),
                                  );
                                } else {
                                  await Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          BoardSelectionScreen(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              },
                              child: Center(
                                child: Text(
                                  "Create $_fetchedUserType Profile",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF0070FF),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      } else
                        return Center(
                          child: Container(
                            height: 100,
                            width: double.maxFinite,
                            padding: EdgeInsets.only(bottom: 30, top: 30),
                            child: Loader(),
                          ),
                        );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class SwitchProfileTileWidget extends StatelessWidget {
  final bool selected;
  final String? streamText;
  final String? subtitle;
  final String? leadingImagePath;
  final int selectedColor;
  final bool trainingWidgetRequired;
  final double topMargin;
  final String? userType;

  SwitchProfileTileWidget({
    this.selected = false,
    this.streamText,
    this.subtitle,
    this.leadingImagePath = Constants.defaultProfileImagePath,
    this.selectedColor = 0xFF0077FF,
    this.trainingWidgetRequired = true,
    this.topMargin = 20.0,
    this.userType = "Teacher",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      constraints: BoxConstraints(
        minWidth: 338,
        minHeight: 68,
      ),
      decoration: BoxDecoration(
        color: selected
            ? Color(selectedColor).withOpacity(0.05)
            : Color(0xFFFFFFFF),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(
          12,
        ),
        border: Border.all(
            color: selected ? Color(selectedColor) : Color(0xFFDEDEDE)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(
                left: 16,
                right: 13,
              ),
              decoration: BoxDecoration(
                color: selected ? Color(0xFF2121210D) : Color(0xFFDBDBDB),
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF212121)),
              ),
              child: CachedNetworkImage(
                imageUrl: leadingImagePath ?? Constants.defaultProfileImagePath,
                imageBuilder: (context, imageProvider) => Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
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
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),

              // CircleAvatar(
              //   backgroundImage: NetworkImage(
              //     leadingImagePath,
              //   ),
              //   radius: ScreenUtil().setSp(25, ),
              // ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streamText ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  userType!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(
                right: 20,
              ),
              child: (selected && trainingWidgetRequired)
                  ? Image.asset(
                      (selectedColor == 0xFF22C59B)
                          ? "assets/images/checked_image.png"
                          : (selectedColor == 0xFF46B6E9)
                              ? "assets/images/checked_image_light_blue.png"
                              : "assets/images/checked_image_blue.png",
                      height: 20,
                    )
                  : Container(
                      width: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
