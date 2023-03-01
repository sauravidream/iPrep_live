import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/local_db_helper.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/user.dart';
import 'package:idream/ui/onboarding/login_options.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  Future fetchUserDetails(String userID) async {
    String? userType = await getStringValuesSF("UserType");
    String url;
    if (userType == "Student") {
      url = Constants.studentUserDetailsUrl;
    } else {
      url = Constants.teacherUserDetailsUrl;
    }
    var response = await apiHandler.getAPICall(endPointURL: url + userID);
    // AppUser appUser;

    try {
      if (response != null) {
        appUser = AppUser.fromJson(response);
        appUser!.userID = userID;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return appUser;
  }

// use for use migration

  Future savePostLoginUserInfo(value, String userType,
      {String? appleUserName}) async {
    //Save user ID
    await saveUserDetailToLocal("userID", value.user.uid.toString());
    //Save userType
    await saveUserDetailToLocal("userType", userType.toString());
    //Save displayName
    if (value.user.displayName != null) {
      await saveUserDetailToLocal(
          "fullName", value.user.displayName.toString());
    } else if (appleUserName != '') {
      await saveUserDetailToLocal("fullName", appleUserName.toString());
    }

    //Save mobileNumber
    await saveUserDetailToLocal(
        "mobileNumber", value.user.phoneNumber.toString());
    //Save fcmToken
    String? token = await (firebaseMessaging.getToken());
    await saveUserDetailToLocal("fcmToken", token.toString());
    await saveUserDetailToLocal("email", value.user.email.toString());

    //getSelectedAppLevelLanguage
    String? language = await getStringValuesSF('language');
    await userRepository.saveUserDetailToLocal(
        "userPlanStatus", "Trial".toString());
    await userRepository.saveUserDetailToLocal(
        "userPlanDuration", "7".toString());
    await userRepository.saveUserDetailToLocal(
        "userPlanDateStarted", (DateTime.now().toUtc().toString()));

    appUser!.userID = value.user.uid.toString();
    appUser!.userType = userType.toString();
    appUser!.fullName = value.user.displayName.toString();
    appUser!.mobile = value.user.phoneNumber.toString();
    appUser!.token = token.toString();
    appUser!.language = language.toString();
    appUser!.email = value.user.email.toString();

    String? _userTypeNode = await (getUserNodeName());

    dbRef
        .child("users")
        .child(_userTypeNode.toString())
        .child(value.user.uid)
        .set({
      "user_type": 'App',
      "token": token,
      "mobile": value.user.phoneNumber ?? "+91-",
      "language": language,
      "full_name": value.user.displayName,
      "email": value.user.email,
      "users_plans": {
        "date_started": DateTime.now().toUtc().toString(),
        "plan_duration": "7",
        "status": "Trial",
      }
    }).then((_) {
      debugPrint("Saved Data successfully");
    }).catchError((onError) {
      debugPrint(onError);
    });
  }

  Future saveReferralCode() async {
    //Checking if referral code already exists in Central DB
    String? referralCode = await (getUniqueReferralCode());
    debugPrint(referralCode.toString());

    //TODO: Alert - Uncomment this
    dbRef
        .child("referrals_scholarship_subscription_plans")
        .child("refer_codes")
        .push()
        .set(referralCode.toString())
        .then((_) {
      debugPrint("Saved Data successfully");
    }).catchError((onError) {
      debugPrint(onError);
    });
    // var response = await apiHandler.postAPICall(endPointURL: Constants.referralCodeInCentralDBUrl);

    String? userID = await (getStringValuesSF("userID"));

    // var response1 = await apiHandler.postAPICall(endPointURL: Constants.savingReferralCodeAgainstUserUrl + userID + "/RefereCode");
    //Referals_ScholarShip_SubscriptionPlans/Referals/
    //Constants.savingReferralCodeAgainstUserUrl + userID + "/RefereCode"
    String? userTypeNodeName = await (getUserNodeName());
    dbRef
        .child("referrals_scholarship_subscription_plans")
        .child("referrals")
        .child(userID.toString())
        .child(userTypeNodeName.toString())
        .set({"refer_code": referralCode.toString()}).then((_) {
      debugPrint("Saved Data successfully");
    }).catchError((onError) {
      debugPrint(onError);
    });

    // var response2 = await apiHandler.postAPICall(endPointURL: Constants.referralReverserUrl);
    //Referals_ScholarShip_SubscriptionPlans/ReferalsReverse
    dbRef
        .child("referrals_scholarship_subscription_plans")
        .child("referrals_reverse")
        .child(referralCode.toString())
        .set({"userId": userID.toString()}).then((_) {
      debugPrint("Saved Data successfully");
    }).catchError((onError) {
      debugPrint(onError);
    });

    dbRef
        .child("referrals_scholarship_subscription_plans")
        .child("users_plans")
        .child(userID.toString())
        .child(userTypeNodeName.toString())
        .set({
      "date_started": DateTime.now().toUtc().toString(),
      "plan_duration": "7".toString(),
      "status": "Trial".toString(),
    }).then((_) {
      debugPrint("Saved Data successfully");
    }).catchError((onError) {
      debugPrint(onError);
    });
  }

  Future sendSuccessfulSignUpNotification() async {
    String? _userID = await (getStringValuesSF("userID"));
    String? _userTypeNode = await (getUserNodeName());
    dbRef
        .child("notification")
        .child(_userTypeNode!)
        .child(_userID!)
        .child(DateTime.now().microsecondsSinceEpoch.toString())
        .set({
      "sender_name": "iPrep",
      "title": "Message from iPrep",
      "message":
          "iPrep is a learning app that allows students a single platform for all growth and learning needs. We are adding content and working on it to improve your experience. If you observe any bug or a content error, please report it to us at app@idreameducation.org. Thanks and Happy Learning!",
      "message_time": DateTime.now().toUtc().toString(),
      "show_message": true,
      "message_opened": false,
      "time": DateTime.now().toUtc().toString(),
    }).then((_) {
      debugPrint("Saved Welcome notification successfully");
    }).catchError((onError) {
      debugPrint(onError);
    });
  }

  Future saveUserDetailToLocal(
      String propertyName, String propertyValue) async {
    await addStringToSF(propertyName, propertyValue);
  }

  Future generateReferralCode() async {
    String? _userType = await (getUserNodeName());
    return (_userType![0].toUpperCase().toString() +
        randomAlphaNumeric(5).toUpperCase());
  }

  Future getUniqueReferralCode() async {
    var result;
    String? referralCode = await getStringValuesSF("referralCode");
    int index = 0;
    do {
      if (referralCode == null || index >= 1) {
        referralCode = await (userRepository.generateReferralCode());
      }
      debugPrint(referralCode.toString());
      result = await dbRef
          .child("referrals_scholarship_subscription_plans")
          .child("refer_codes")
          .orderByValue()
          .equalTo(referralCode.toString())
          .once();
      index++;
      debugPrint(result.toString());
    } while (result == null);

    await userRepository.saveUserDetailToLocal(
        "referralCode", referralCode.toString());
    return referralCode;
  }

  Future saveUserInfoPostSuccessfulOnBoarding() async {
    String? userID = await (getStringValuesSF('userID'));
    // String educationBoard = await getStringValuesSF('educationBoard');
    String? _class = await getStringValuesSF('classNumber');
    String? _fullName = await getStringValuesSF('fullName');
    String? _email = await getStringValuesSF('emailId');
    String? _stream = await getStringValuesSF('stream');
    if (_stream != null) {
      String _updatedStream =
          _stream.replaceFirstMapped("${_class!}_", (match) => "");
      await addStringToSF('stream', _updatedStream.toString());
      _class = _stream;
    }
    appUser!.email = _email;
    appUser!.userID = userID;
    appUser!.classID = _class;
    appUser!.fullName = _fullName;
    appUser!.stream = _stream;
    String? _educationBoard = await (getStringValuesSF('educationBoard'));
    appUser!.educationBoard = _educationBoard.toString();

    //TODO: this may need to update

    //Changes on 28th May 3:05 AM
    String _userTypeNode = await (userRepository.getUserNodeName());

    await dbRef
        .child("users")
        .child(_userTypeNode.toString())
        .child(userID!)
        .update({
      "board_id": _educationBoard!.toLowerCase().toString(),
      "class_id": _class,
      'profile_photo': Constants.defaultProfileImagePath,
      // "education_board": "CBSE",
      "student_class": _class,
      "full_name": _fullName,
      "email": _email,
    }).then((_) {
      debugPrint("Saved Data successfully");
    }).catchError((onError) {
      debugPrint(onError);
    });
  }

  Future initializeUserObjectFromLocallySavedInfo() async {
    appUser!.userID = await getStringValuesSF('userID');
    appUser!.userType = await getStringValuesSF('userType');
    appUser!.fullName = await getStringValuesSF('fullName');
    appUser!.mobile = await getStringValuesSF('mobileNumber');
    appUser!.token = await getStringValuesSF('fcmToken');
    appUser!.language = await getStringValuesSF('language');
    appUser!.classID = await getStringValuesSF('classNumber');
    appUser!.stream = await getStringValuesSF('stream');
    appUser!.educationBoard = await getStringValuesSF('educationBoard');
    appUser!.age = await getStringValuesSF('age');
    appUser!.gender = await getStringValuesSF('gender');
    appUser!.dateOfBirth = await getStringValuesSF('dateOfBirth');
    appUser!.parentContact = await getStringValuesSF('parentContact');
    appUser!.email = await getStringValuesSF('email');
    appUser!.address = await getStringValuesSF('address');
    appUser!.state = await getStringValuesSF('state');
    appUser!.city = await getStringValuesSF('city');
    appUser!.school = await getStringValuesSF('school');
    appUser!.profilePhoto = await getStringValuesSF('profilePhoto');

    //Set User Id for Google Firebase Analytics
    await analyticsRepository.setUserProperties(userID: appUser!.userID);
  }

  Future updateUserProfile() async {
    //Changes on 28th May 3:05 AM
    String? _userTypeNode = await (userRepository.getUserNodeName());

    String? _stream = updatedAppUser.stream;
    String? _class = updatedAppUser.classID;

    if (_userTypeNode == "students") {
      if (_class != null && _class.contains("_")) {
        _stream = updatedAppUser.classID!.substring(3);
        _class = updatedAppUser.classID!.substring(0, 2);
        if (_stream == "nonmedical_medical") {
          _stream = "Science";
          updatedAppUser.stream = _stream;
        } else {
          _stream = _stream.substring(0, 1).toUpperCase() +
              _stream.substring(2).toUpperCase();
          updatedAppUser.stream = _stream;
        }
      }
    }

    // //Save user ID
    // await saveUserDetailToLocal("userID", updatedAppUser.userID);
    // //Save userType
    // await saveUserDetailToLocal("userType", updatedAppUser.userType);
    //Save displayName
    await saveUserDetailToLocal("fullName", nameController.text);
    appUser!.fullName = nameController.text;
    //Save mobileNumber
    await saveUserDetailToLocal(
      "mobileNumber",
      mobileController.text,
    );
    appUser!.mobile = mobileController.text;

    await saveUserDetailToLocal("language", updatedAppUser.language!);
    appUser!.language = updatedAppUser.language;

    if (_userTypeNode == "students") {
      await saveUserDetailToLocal("classNumber", _class!);
      appUser!.classID = updatedAppUser.classID;

      await saveUserDetailToLocal("educationBoard",
          updatedAppUser.educationBoard ?? updatedAppUser.boardID!);
      appUser!.educationBoard =
          updatedAppUser.educationBoard ?? updatedAppUser.boardID;

      await saveUserDetailToLocal(
          "parentContact", parentContactController.text);
      appUser!.parentContact = parentContactController.text;

      await saveUserDetailToLocal("school", schoolController.text);
      appUser!.school = schoolController.text;
    }

    await saveUserDetailToLocal("email", emailController.text);
    appUser!.email = emailController.text;

    await saveUserDetailToLocal("address", addressController.text);
    appUser!.address = addressController.text;

    await saveUserDetailToLocal("city", cityController.text);
    appUser!.city = cityController.text;

    await saveUserDetailToLocal("state", stateController.text);
    appUser!.state = stateController.text;

    await saveUserDetailToLocal("age", ageController.text);
    appUser!.age = ageController.text;

    await saveUserDetailToLocal("gender", gender /*genderController.text*/);
    appUser!.gender = gender /*genderController.text*/;

    await saveUserDetailToLocal("dateOfBirth", dobController.text);
    appUser!.dateOfBirth = dobController.text;

    String? formattedClass;
    if (_userTypeNode == "students") {
      if (updatedAppUser.stream != null) {
        if (updatedAppUser.stream == "Science") {
          updatedAppUser.stream = "nonmedical_medical";
        } else if (_stream == "Commerce") {
          updatedAppUser.stream = "commerce";
        } else if (_stream == "Arts") {
          updatedAppUser.stream = "arts";
        }
        await saveUserDetailToLocal("stream", updatedAppUser.stream!);
        appUser!.stream = updatedAppUser.stream;
      }

      if (updatedAppUser.stream != null && updatedAppUser.stream!.isNotEmpty) {
        formattedClass = "${_class!}_${updatedAppUser.stream!.toLowerCase()}";
      } else {
        formattedClass = _class;
      }
    }

    dbRef
        .child("users")
        .child(_userTypeNode!)
        .child(updatedAppUser.userID!)
        .update({
      "board_id": appUser!.educationBoard != null
          ? appUser!.educationBoard!.toLowerCase()
          : null,
      "class_id": formattedClass,
      "student_class": formattedClass,
      "full_name": nameController.text,
      "age": ageController.text,
      "gender": genderController.text,
      "date_of_birth": dobController.text,
      "mobile": mobileController.text,
      "parent_contact": parentContactController.text,
      "email": emailController.text,
      "address": addressController.text,
      "state": stateController.text,
      "city": cityController.text,
      "school": schoolController.text,
      "language": updatedAppUser.language,
      "user_type": updatedAppUser.userType,
    }).then((_) {
      debugPrint("Updated $_userTypeNode Data successfully.");
    }).catchError((onError) {
      debugPrint(onError);
    });
  }

  Future getUserNodeName() async {
    String? _userType = await getStringValuesSF("UserType");
    if (_userType != null && _userType == "Coach") {
      return "teachers";
    } else {
      return "students";
    }
  }

  Future updateUserProfileAndBatchesWithProfilePhoto(
      {required String profilePhotoUrl}) async {
    await saveUserDetailToLocal("profilePhoto", profilePhotoUrl);
    appUser!.profilePhoto = profilePhotoUrl;

    //Changes on 28th May 3:05 AM
    String? _userTypeNode = await (userRepository.getUserNodeName());
    bool? _response;
    await dbRef
        .child("users")
        .child(_userTypeNode!)
        .child(updatedAppUser.userID!)
        .update({
      "profile_photo": profilePhotoUrl,
    }).then((_) async {
      if (_userTypeNode == "students") {
        var _joinedBatches = await apiHandler.getAPICall(
            endPointURL:
                "users/students/${updatedAppUser.userID}/joined_batches");
        await Future.forEach((_joinedBatches as Map).values,
            (dynamic batch) async {
          await dbRef
              .child("batch")
              .child(batch['teacher_id'])
              .child(batch['batch_id'])
              .child("students")
              .child(updatedAppUser.userID!)
              .update({
            "profile_photo": profilePhotoUrl,
          });
        }).then((value) async {
          debugPrint("Saved Profile Picture Data successfully");
          _response = true;
        }).catchError((error) {
          debugPrint(error.toString());
        });
      } else {
        var _createdBatches = await apiHandler.getAPICall(
            endPointURL: "batch/${updatedAppUser.userID}/");
        await Future.forEach((_createdBatches as Map).values,
            (dynamic batch) async {
          await dbRef
              .child("batch")
              .child(updatedAppUser.userID!)
              .child(batch['batchId'])
              .update({
            "profile_photo": profilePhotoUrl,
          });
        }).then((value) async {
          debugPrint("Saved Profile Picture Data successfully");
          _response = true;
        }).catchError((error) {
          debugPrint(error.toString());
        });
      }
    }).catchError((onError) {
      debugPrint(onError);
      _response = false;
    });
    return _response;
  }

  Future checkAndUpdateFCMTokenForCurrentUser() async {
    bool? _response;
    String userTypeNode = await (userRepository.getUserNodeName());
    String? token = await firebaseMessaging.getToken();

    await dbRef
        .child("users")
        .child(userTypeNode)
        .child(appUser!.userID!)
        .update({
      "token": token,
    }).then((_) async {
      debugPrint("Updated user's FCM token successfully.");
      await saveUserDetailToLocal("fcmToken", token!);
      selectedAppLanguage = await getStringValuesSF('language');
      _response = true;
    }).catchError((onError) {
      debugPrint(onError);
      _response = false;
    });
    return _response;
  }

  Future updateUserProfileWithSelectedLanguage({String? language}) async {
    String? userTypeNode = await (userRepository.getUserNodeName());
    bool? response;
    await dbRef
        .child("users")
        .child(userTypeNode!)
        .child(appUser!.userID!)
        .update({
      "language": language,
    }).then((_) async {
      debugPrint("Saved Selected Language successfully");
      response = true;
    }).catchError((onError) {
      debugPrint(onError);
      response = false;
    });
    return response;
  }

  Future saveCurrentDeviceInfo() async {
    try {
      String? _userID = await getStringValuesSF("userID");
      String? _deviceId = await (_getDeviceId());

      if (_deviceId != null) {
        await dbRef.child("logged_in_device_info/$_userID/$_deviceId").update({
          "device_id": _deviceId,
          "log_in_time": DateTime.now().toUtc().toString(),
        }).then((_) {
          debugPrint("Saved Device Info: $_deviceId");
        }).catchError((onError) {
          debugPrint(onError);
        });
      }
    } catch (e) {
      debugPrint("Error While Extracting Device Info: $e");
    }
  }

  Future deleteCurrentDeviceInfo() async {
    try {
      String? _userID = await getStringValuesSF("userID");
      String? _deviceId = await (_getDeviceId());

      if ((_userID != null) && (_deviceId != null)) {
        await dbRef
            .child("logged_in_device_info/$_userID/$_deviceId")
            .remove()
            .then((_) {
          debugPrint("Deleted Current Device : $_deviceId");
        }).catchError((onError) {
          debugPrint(onError);
        });
      }
    } catch (e) {
      debugPrint("Error While Extracting Device Info: $e");
    }
  }

  Future deleteAllDeviceInfo() async {
    try {
      String? _userID = await getStringValuesSF("userID");
      await dbRef.child("logged_in_device_info/$_userID").remove().then((_) {
        debugPrint("Deleted All Saved Device Info...");
      }).catchError((onError) {
        debugPrint(onError);
      });
    } catch (e) {
      debugPrint("Error While Extracting Device Info: $e");
    }
  }

  Future checkIfUserIdLoggedIn() async {
    try {
      String? _userID = await getStringValuesSF("userID");
      String? _deviceId = await (_getDeviceId());
      bool _response = false;
      if (_deviceId != null) {
        await dbRef
            .child("logged_in_device_info/$_userID/$_deviceId")
            .once()
            .then((dataSnapshot) {
          if (dataSnapshot.snapshot.value != null) _response = true;
        }).catchError((onError) {
          debugPrint(onError);
          return _response;
        });
      }
      return _response;
    } catch (e) {
      debugPrint("Error While Extracting Device Info: $e");
      return false;
    }
  }

  Future _getDeviceId() async {
    DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      return await _deviceInfo.androidInfo.then((value) => value.androidId);
    } else if (Platform.isIOS) {
      return await _deviceInfo.iosInfo
          .then((value) => value.identifierForVendor);
    }
  }

  Future logOut(BuildContext context) async {
    await userRepository.deleteCurrentDeviceInfo();
    await helper.deleteAllDataOnTableName(unreadChatHistory);
    await helper.deleteAllDataOnTableName(tableSubjects);
    await helper.deleteAllDataOnTableName(tableVideoLessons);
    await helper.deleteAllDataOnTableName(tableBooks);
    await helper.deleteAllDataOnTableName(tableNotes);
    await helper.deleteAllDataOnTableName(tableClasses);
    await helper.deleteAllDataOnTableName(tableEducationBoards);
    await helper.deleteAllDataOnTableName(tableStreams);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    appUser = AppUser();
    updatedAppUser = AppUser();
    Navigator.pop(context);
  }

  Future clearLocalDataBase(BuildContext context) async {
    await helper.deleteAllDataOnTableName(tableSubjects);
    await helper.deleteAllDataOnTableName(tableVideoLessons);
    await helper.deleteAllDataOnTableName(tableBooks);
    await helper.deleteAllDataOnTableName(tableNotes);
    await helper.deleteAllDataOnTableName(tableClasses);
    await helper.deleteAllDataOnTableName(tableEducationBoards);
    await helper.deleteAllDataOnTableName(tableStreams);
  }

  Future deleteUserAccount(BuildContext context, String userFeedback) async {
    String? userTypeNode = await (getUserNodeName());
    String? userID = await getStringValuesSF("userID");

    try {
      await Dio().post(
        "https://learn.iprep.in/api/deleteUser",
        data: {
          "uid": userID,
          "userFeedback": userFeedback,
          "userType": userTypeNode,
        },
      ).then((value) async {
        if (value.statusCode == 200) {
          await userRepository.deleteCurrentDeviceInfo();
          await helper.deleteAllDataOnTableName(unreadChatHistory);
          await helper.deleteAllDataOnTableName(tableSubjects);
          await helper.deleteAllDataOnTableName(tableVideoLessons);
          await helper.deleteAllDataOnTableName(tableBooks);
          await helper.deleteAllDataOnTableName(tableNotes);
          await helper.deleteAllDataOnTableName(tableClasses);
          await helper.deleteAllDataOnTableName(tableEducationBoards);
          await helper.deleteAllDataOnTableName(tableStreams);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          appUser = AppUser();
          updatedAppUser = AppUser();

          await Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => const LoginOptions()),
              (route) => false);
        }
      });
      // debugPrint("Last login saved ${response.toString()}");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> checkIfNumberOfLoginExceedingLimits() async {
    bool response = true;

    try {
      String? userID = await getStringValuesSF("userID");
      DataSnapshot data =
          await firebaseDatabase.ref("logged_in_device_info/$userID").get();
      if (data.value != null) {
        data.children.length;
        if (data.children.length <= Constants.numberOfAllowedUsersPerAccount) {
          return response = true;
        } else {
          return response = false;
        }
      } else {
        return response = true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return response;
  }

  Future removeSavedInstances(BuildContext context) async {
    await helper.deleteAllDataOnTableName(unreadChatHistory);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    appUser = AppUser();
    updatedAppUser = AppUser();
  }
}
