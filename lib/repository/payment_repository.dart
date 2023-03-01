import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/payment_model.dart';

Future createRequest({
  BuildContext? context,
  String? planDuration,
  String? planID,
  String? planName,
  int? payableAmount,
  bool? walletApplied,
  required String? userType,
  String? discountCode,
}) async {
  String? email = await getStringValuesSF("email") ?? "";
  String? phoneNumber = await getStringValuesSF('mobileNumber') ?? "";
  String? fullName = await getStringValuesSF("fullName");
  String? userID = await (getStringValuesSF("userID"));

  PaymentModel? paymentModel = PaymentModel(
    amount: payableAmount.toString(),
    date: DateTime.now().toString(),
    firstTimePaymentDone: false,
    planDuration: planDuration,
    planID: planID,
    planName: planName,
    referalAmount: "0", //TODO: Work on this 810.0
    referalBetween: "", //TODO: Work on this s-t
    referalCode: "", //TODO: Work on this TUGZWO
    referalTransactionType: "", //TODO: Work on this Credit
    referalUserID: "", //TODO: Work on this cZo8TwpZWcZuoGkQnCQrjJDmYHD2
    remark: "", //TODO: Work on this iPrep Plan subscription
    remarkReferal: "", //TODO: Work on this "Referal Bonus --esha manchanda"
    // transactionID: json.decode(resp.body)['payment_request']['id'],
    type: "", //TODO: Work on this Debit
    userID: userID,
    userName: fullName,
    walletApplied: walletApplied,
    userType: userType ?? "Student",
    userEmail: email,
    userMobile: phoneNumber,
    discountCode: discountCode ?? "",
  );

  dbRef
      .child("referrals_scholarship_subscription_plans")
      .child("temporary_data")
      .child(userType!.toLowerCase())
      .child(userID!)
      .set(jsonDecode(jsonEncode(paymentModel)))
      .then((_) async {
    debugPrint("Temporary Data for payment successfully");
  }).catchError((onError) {
    debugPrint(onError);
  });
}

Future checkPaymentStatus(String id) async {
  var response = await http.get(
      Uri.parse(
          Uri.encodeFull("https://t7st.instamojo.com/api/1.1/payments/$id/")),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "X-Api-Key": "Your-api-key",
        "X-Auth-Token": "Your-auth-token"
      });
  var realResponse = json.decode(response.body);
  debugPrint(realResponse);
  if (realResponse['success'] == true) {
    if (realResponse["payment"]['status'] == 'Credit') {
      return 'Credit';
    } else {
      return 'Pending';
//payment failed or pending.
    }
  } else {
    print("PAYMENT STATUS FAILED");
    return 'Failed';
  }
}

Future getUserNodeName() async {
  String? userType = await getStringValuesSF("UserType");
  if (userType != null && userType == "Coach") {
    return "teachers";
  } else {
    return "students";
  }
}

getUserPlanDetails() async* {
  String? userID = await getStringValuesSF("userID");
  String? userTypeNodeName = await (getUserNodeName());
  yield* dbRef
      .child("users/$userTypeNodeName/$userID/users_plans")
      .orderByValue()
      .onValue;
}

usedPrepaidCode({
  required String userID,
  required String usedPrepaidCode,
  required int payableAmount,
}) async {
  String email = await getStringValuesSF("email") ?? "";
  String phoneNumber = await getStringValuesSF('mobileNumber') ?? "";
  String? fullName = await getStringValuesSF("fullName");
  String? _userID = await getStringValuesSF("userID");
  String? userType = await getStringValuesSF("UserType");
  PaymentModel paymentModel = PaymentModel(
    amount: payableAmount.toString(),
    date: DateTime.now().toString(),
    firstTimePaymentDone: false,
    planDuration: "365",
    planID: "plan_30_12",
    planName: "12 Months",
    referalAmount: "0", //TODO: Work on this 810.0
    referalBetween: "", //TODO: Work on this s-t
    referalCode: "", //TODO: Work on this TUGZWO
    referalTransactionType: "", //TODO: Work on this Credit
    referalUserID: "", //TODO: Work on this cZo8TwpZWcZuoGkQnCQrjJDmYHD2
    remark: "", //TODO: Work on this iPrep Plan subscription
    remarkReferal: "", //TODO: Work on this "Referal Bonus --esha manchanda"
    // transactionID: json.decode(resp.body)['payment_request']['id'],
    type: "", //TODO: Work on this Debit
    userID: _userID,
    userName: fullName,
    walletApplied: false,
    userType: userType ?? "Student",
    userEmail: email,
    userMobile: phoneNumber,
    discountCode: usedPrepaidCode,
  );
  dbRef
      .child("referrals_scholarship_subscription_plans")
      .child("usedPrepaidCode_data")
      .child(usedPrepaidCode)
      .child(userID)
      .set(jsonDecode(jsonEncode(paymentModel)))
      .then((_) async {
    dbRef
        .child("referrals_scholarship_subscription_plans")
        .child("prepaid_codes_for_app_limited_users")
        .child(usedPrepaidCode)
        .update({'isApplied': "true"});
    debugPrint("Temporary Data for payment successfully");
  }).catchError((onError) {
    debugPrint(onError);
  });
}

userPlanActivate({
  required String userID,
  required String usedPrepaidCode,
  required int payableAmount,
  required bool walletApplied,
  required String planDuration,
  required String planID,
  required String planName,
}) async {
  String email = await getStringValuesSF("email") ?? "";
  String phoneNumber = await getStringValuesSF('mobileNumber') ?? "";
  String? fullName = await getStringValuesSF("fullName");
  String? userType = await getStringValuesSF("UserType");
  PaymentModel paymentModel = PaymentModel(
    amount: payableAmount.toString(),
    date: DateTime.now().toString(),
    firstTimePaymentDone: false,
    planDuration: planDuration,
    planID: planID,
    planName: planName,
    referalAmount: "0", //TODO: Work on this 810.0
    referalBetween: "", //TODO: Work on this s-t
    referalCode: "", //TODO: Work on this TUGZWO
    referalTransactionType: "", //TODO: Work on this Credit
    referalUserID: "", //TODO: Work on this cZo8TwpZWcZuoGkQnCQrjJDmYHD2
    remark: "", //TODO: Work on this iPrep Plan subscription
    remarkReferal: "", //TODO: Work on this "Referal Bonus --esha manchanda"
    // transactionID: json.decode(resp.body)['payment_request']['id'],
    type: "", //TODO: Work on this Debit
    userID: userID,
    userName: fullName,
    walletApplied: walletApplied,
    userType: userType ?? "Student",
    userEmail: email,
    userMobile: phoneNumber,
    discountCode: usedPrepaidCode,
  );
  dbRef
      .child("referrals_scholarship_subscription_plans")
      .child("usedPrepaidCode_data")
      .child(usedPrepaidCode)
      .child(userID)
      .set(jsonDecode(jsonEncode(paymentModel)))
      .then((_) async {
    dbRef
        .child("referrals_scholarship_subscription_plans")
        .child("prepaid_codes_for_app_limited_users")
        .child(usedPrepaidCode)
        .update({'isApplied': "true"});
    debugPrint("Temporary Data for payment successfully");
  }).catchError((onError) {
    debugPrint(onError);
  });
}
