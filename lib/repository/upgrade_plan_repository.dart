import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/repository/payment_repository.dart';
import 'package:intl/intl.dart';

import '../common/snackbar_messages.dart';
import '../model/subscription_plan_code_model.dart';

class UpgradePlanRepository {
// TODO: This function is use in new User plans

  Future<CodeInfoModel?> checkDiscountValidation({String? discountCode}) async {
    CodeInfoModel? codeInfoModel;

    try {
      codeInfoModel = await apiHandler
          .getAPICall(
              endPointURL: "/coupon_codes/app_codes/${discountCode!}/info/")
          .then((value) {
        return codeInfoModel =
            value != null ? CodeInfoModel.fromJson(value) : null;
      });
      return codeInfoModel;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /* Future checkDiscountValidation({String? discountCode}) async {
    try {
      var value = await apiHandler.getAPICall(
          endPointURL:
              "/referrals_scholarship_subscription_plans/prepaid_codes_for_app_limited_users/$discountCode");
      return value;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }*/

  Future<int?> applyDiscountCode(
      {mounted,
      BuildContext? context,
      TextEditingController? discountEditingController,
      List? products,
      int? index}) async {
    int? discountAmount;
    String? userID = await getStringValuesSF("userID");
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.mmm");
    String dateTime =
        dateFormat.parse("2022-06-22T04:34:47.644Z").toIso8601String();
    CodeInfoModel? codeInfoModel;
    UseByUser? useByUser;

    await upgradePlanRepository
        .checkDiscountValidation(discountCode: discountEditingController!.text)
        .then((value) async {
      codeInfoModel = value;

      if (codeInfoModel != null &&
          (codeInfoModel!.userPlan!.id == products![index!.toInt()]["id"])) {
        if (codeInfoModel != null && codeInfoModel!.isApplied != true) {
          if (codeInfoModel!.oneTime == false) {
            await upgradePlanRepository
                .checkUserValidationForCode(
                    discountCode: discountEditingController.text)
                .then((value) {
              useByUser = value;
              if (useByUser!.length == 0) {
                OfferCodeData? offerCodeData = OfferCodeData(
                  codeInfoModel: codeInfoModel,
                  useByUser: useByUser,
                );
                try {
                  if (offerCodeData.codeInfoModel!.validity!.time!.endDate ==
                      "") {
                    int? discountPercent =
                        offerCodeData.codeInfoModel!.discountPercent;
                    int? userPlanPrice =
                        offerCodeData.codeInfoModel!.userPlan!.rawPrice;
                    discountAmount =
                        ((userPlanPrice! / 100) * discountPercent!).ceil();

                    return discountAmount!.ceil();
                  } else {
                    DateFormat dateFormat =
                        DateFormat("yyyy-MM-ddTHH:mm:ss.mmm");
                    String dateTime = dateFormat
                        .parse(
                            "${offerCodeData.codeInfoModel!.validity!.time!.endDate}")
                        .toIso8601String();
                    DateTime now = DateTime.now();

                    DateTime endDateTime = DateTime.parse(dateTime);
                    DateTime startDate = DateTime.parse(now.toIso8601String());

                    if (endDateTime.compareTo(startDate) < 0) {
                      SnackbarMessages.showErrorSnackbar(context!,
                          error: Constants.discountCodeExpiryAlert);
                    } else {
                      int? discountPercent =
                          offerCodeData.codeInfoModel!.discountPercent;
                      int? userPlanPrice =
                          offerCodeData.codeInfoModel!.userPlan!.rawPrice;
                      discountAmount =
                          ((userPlanPrice! / 100) * discountPercent!).ceil();

                      return discountAmount!.ceil();
                    }
                  }

                  DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.mmm");
                  String dateTime = dateFormat
                      .parse(
                          "${offerCodeData.codeInfoModel!.validity!.time!.endDate}")
                      .toIso8601String();
                  DateTime now = DateTime.now();

                  DateTime endDateTime = DateTime.parse(dateTime);
                  DateTime startDate = DateTime.parse(now.toIso8601String());

                  if (endDateTime.compareTo(startDate) < 0) {
                    SnackbarMessages.showErrorSnackbar(context,
                        error: Constants.discountCodeExpiryAlert);
                  } else {
                    int? discountPercent =
                        offerCodeData.codeInfoModel!.discountPercent;
                    int? userPlanPrice =
                        offerCodeData.codeInfoModel!.userPlan!.rawPrice;
                    discountAmount =
                        ((userPlanPrice! / 100) * discountPercent!).ceil();

                    return discountAmount!.ceil();
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              } else if (useByUser!.length! <
                      (codeInfoModel!.validity!.userLimit)!.toInt() &&
                  useByUser!.userId != userID) {
                OfferCodeData? offerCodeData = OfferCodeData(
                  codeInfoModel: codeInfoModel,
                  useByUser: useByUser,
                );
                try {
                  if (offerCodeData.codeInfoModel!.validity!.time!.endDate ==
                      "") {
                    int? discountPercent =
                        offerCodeData.codeInfoModel!.discountPercent;
                    int? userPlanPrice =
                        offerCodeData.codeInfoModel!.userPlan!.rawPrice;
                    discountAmount =
                        ((userPlanPrice! / 100) * discountPercent!).ceil();

                    return discountAmount!.ceil();
                  } else {
                    DateFormat dateFormat =
                        DateFormat("yyyy-MM-ddTHH:mm:ss.mmm");
                    String dateTime = dateFormat
                        .parse(
                            "${offerCodeData.codeInfoModel!.validity!.time!.endDate}")
                        .toIso8601String();
                    DateTime now = DateTime.now();

                    DateTime endDateTime = DateTime.parse(dateTime);
                    DateTime startDate = DateTime.parse(now.toIso8601String());

                    if (endDateTime.compareTo(startDate) < 0) {
                      SnackbarMessages.showErrorSnackbar(context!,
                          error: Constants.discountCodeExpiryAlert);
                    } else {
                      int? discountPercent =
                          offerCodeData.codeInfoModel!.discountPercent;
                      int? userPlanPrice =
                          offerCodeData.codeInfoModel!.userPlan!.rawPrice;
                      discountAmount =
                          ((userPlanPrice! / 100) * discountPercent!).ceil();

                      return discountAmount!.ceil();
                    }
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              } else {
                SnackbarMessages.showErrorSnackbar(context!,
                    error: Constants.discountCodeExpiryAlert);
              }
            });
          } else {
            int? discountPercent = codeInfoModel!.discountPercent;
            int? userPlanPrice = codeInfoModel!.userPlan!.rawPrice;
            discountAmount = ((userPlanPrice! / 100) * discountPercent!).ceil();
          }
        } else {
          if (!mounted) return;
          SnackbarMessages.showErrorSnackbar(context!,
              error: Constants.discountCodeExpiryAlert);
        }
      } else {
        if (!mounted) return;
        SnackbarMessages.showErrorSnackbar(context!,
            error: Constants.incorrectDiscountCodeForPlan);
      }
    });
    return discountAmount;
  }

  userAndCodeRelation({
    String? discountCode,
  }) async {
    UseByUser? useByUser;
    try {
      String? userID = await (getStringValuesSF("userID"));
      DatabaseReference usedByRef = firebaseDatabase
          .ref("/coupon_codes/app_codes/$discountCode/used_by/");

      await usedByRef.update({
        "$userID": discountCode,
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      CodeInfoModel? codeInfoModel;
      String? userID = await (getStringValuesSF("userID"));

      // String? userType = await await (getUserNodeName());
      String? userType = await getStringValuesSF("UserType");

      await apiHandler
          .getAPICall(
              endPointURL: "/coupon_codes/app_codes/${discountCode!}/info/")
          .then((value) async {
        codeInfoModel = value != null ? CodeInfoModel.fromJson(value) : null;

        if (codeInfoModel!.oneTime == false) {
          await upgradePlanRepository
              .checkUserValidationForCode(discountCode: discountCode)
              .then((value) async {
            useByUser = value;
            if (useByUser != null &&
                useByUser!.length == codeInfoModel!.validity!.userLimit) {
              try {
                DatabaseReference usedByRef = firebaseDatabase
                    .ref("/coupon_codes/app_codes/$discountCode/info/");
                await usedByRef.update({"isApplied": true});
              } catch (e) {
                debugPrint(e.toString());
              }
            }
          });
        } else if (codeInfoModel!.oneTime == true) {
          try {
            DatabaseReference usedByRef = firebaseDatabase
                .ref("/coupon_codes/app_codes/$discountCode/info/");
            await usedByRef.update({"isApplied": true});
          } catch (e) {
            debugPrint(e.toString());
          }
        }

        DatabaseReference codeRef =
            firebaseDatabase.ref("/users/${userType!.toLowerCase()}s/$userID");

        await codeRef.update({
          "project_id": codeInfoModel!.projectId ?? "",
          "school_id": codeInfoModel!.schools!.schoolId ?? "",
        });

        DatabaseReference codeDataRef = firebaseDatabase.ref(
            "/users/${userType.toLowerCase()}s/$userID/code/$discountCode/");

        codeDataRef.update({
          "district": codeInfoModel!.district ?? "",
          "state": codeInfoModel!.state ?? "",
          "project_id": codeInfoModel!.projectId ?? "",
          "timeStamp": DateTime.now().toIso8601String(),
          "school_id": codeInfoModel!.schools!.schoolId ?? "",
        });

        DatabaseReference administrativeArea = firebaseDatabase.ref(
            "/users/${userType.toLowerCase()}s/$userID/users_profile/location/");
        administrativeArea
            .update({"administrativeArea": codeInfoModel!.state ?? ""});
        DatabaseReference locality = firebaseDatabase.ref(
            "/users/${userType.toLowerCase()}s/$userID/users_profile/location/");
        locality.update({"locality": codeInfoModel!.district ?? ""});
        DatabaseReference updateProjectRef =
            firebaseDatabase.ref("/reports/app_reports/$userID/");
        await updateProjectRef.update({
          "project_id": codeInfoModel!.projectId ?? "",
          "school_id": codeInfoModel!.schools!.schoolId ?? "",
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  calculateAmount({OfferCodeData? offerCodeData, BuildContext? context}) {
    double? discountAmount = 0.0;

    try {
      DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.mmm");
      String dateTime = dateFormat
          .parse("${offerCodeData!.codeInfoModel!.validity!.time!.endDate}")
          .toIso8601String();
      DateTime now = DateTime.now();

      DateTime endDateTime = DateTime.parse(dateTime);
      DateTime startDate = DateTime.parse(now.toIso8601String());

      if (endDateTime.compareTo(startDate) < 0) {
        SnackbarMessages.showErrorSnackbar(context!,
            error: Constants.discountCodeExpiryAlert);
      } else {
        int? discountPercent = offerCodeData.codeInfoModel!.discountPercent;
        int? userPlanPrice = offerCodeData.codeInfoModel!.userPlan!.rawPrice;
        discountAmount = (userPlanPrice! / 100) * discountPercent!;
        debugPrint(discountAmount.toString());
        return discountAmount;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return discountAmount;
  }

  Future<UseByUser?> checkUserValidationForCode({String? discountCode}) async {
    String? userID = await getStringValuesSF("userID");
    UseByUser? useByUser;
    try {
      await apiHandler
          .getAPICall(
        endPointURL: "/coupon_codes/app_codes/$discountCode/used_by/",
      )
          .then((value) {
        if (value != null) {
          (value as Map).forEach((usedUserID, discountCode) {
            useByUser = UseByUser(
              userId: usedUserID == userID ? userID : null,
              length: (value).length,
            );
          });
        } else {
          useByUser = UseByUser(
            userId: null,
            length: 0,
          );
        }
        return useByUser;
      });
      return useByUser;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future getUserPlans() async {
    String? userPlans = await getStringValuesSF("userPlanStatus");
    userPlans ??= await (upgradePlanRepository.checkUserSubscriptionPlan());
    String? planStartDate = await getStringValuesSF("userPlanDateStarted");
    DateTime? expiryDateTime;
    if (userPlans!.toLowerCase() != "trial") {
      expiryDateTime =
          DateTime.parse(planStartDate!).add(const Duration(days: 365));
      if (expiryDateTime.compareTo(DateTime.now()) > 0) {
        return true;
      }
    }
    // else
    //   _expiryDateTime = DateTime.parse(_planStartDate).add(Duration(days: 30));

    return false;
  }

  Future checkIfFunctionalityNeedsToBeBlocked() async {
    String? userPlans = await getStringValuesSF("userPlanStatus");

    await (upgradePlanRepository.checkUserSubscriptionPlan()).then((value) {
      debugPrint(value.toString());
    });

    userPlans ??= await (upgradePlanRepository.checkUserSubscriptionPlan());

    String? planDuration = await (getStringValuesSF("userPlanDuration"));
    String? planStartDate = await (getStringValuesSF("userPlanDateStarted"));

    DateTime expiryDateTime = DateTime.parse(planStartDate!)
        .add(Duration(days: int.parse(planDuration!)));
    if (expiryDateTime.compareTo(DateTime.now()) > 0) {
      restrictUser = false;
    }
  }

  Future checkUserSubscriptionPlan() async {
    String? _userType = await getStringValuesSF("UserType");
    String? _userID = await (getStringValuesSF("userID"));
    String? _url;
    if (_userType == "Student") {
      _url = Constants.studentUserDetailsUrl;
    } else {
      _url = Constants.teacherUserDetailsUrl;
    }
    var _response = await apiHandler.getAPICall(endPointURL: _url + _userID!);
    // AppUser appUser;
    await userRepository.saveUserDetailToLocal(
        "userPlanStatus", _response['users_plans']["status"]);
    await userRepository.saveUserDetailToLocal(
        "userPlanDuration", _response['users_plans']["plan_duration"]);
    await userRepository.saveUserDetailToLocal(
        "userPlanDateStarted", _response['users_plans']["date_started"]);

    return _response['users_plans']["status"];
  }
}
