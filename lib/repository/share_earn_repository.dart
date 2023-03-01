import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:share/share.dart';

class ShareEarnRepository {
  //TODO: In progress

  Future debitEarningAmountFromUser(int? iPrepRemainingAmount) async {
    String? userID = await (getStringValuesSF("userID"));
    String? userTypeNode = await (userRepository.getUserNodeName());
    try {
      await firebaseDatabase
          .ref(
            "iprep_cash/$userID/$userTypeNode/balance/current_amount/",
          )
          .get()
          .then((iprepCashAmount) async {
        await firebaseDatabase
            .ref("iprep_cash/$userID/$userTypeNode/balance/")
            .set(
          {
            "current_amount": (int.parse(iprepCashAmount.value.toString()) -
                    iPrepRemainingAmount!.toInt())
                .toString(),
          },
        );
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future depositEarningAmountInReferUser({
    List? planList,
    required int electedIndex,
  }) async {
    //Saving history for the person who has installed the app on tapping shared link
    String? userID = await (getStringValuesSF("userID"));
    String? userTypeNode = await (userRepository.getUserNodeName());
    try {
      String? referredUserId;
      String? referredUserType;
      double creditAmount;

      creditAmount = ((planList![electedIndex]['rawPrice']) / 100) * 20;

      await firebaseDatabase
          .ref("iprep_cash/$userID/$userTypeNode/history/referred_by/")
          .get()
          .then((value) async {
        if (value.exists) {
          referredUserId = value.children.first.key;

          await firebaseDatabase
              .ref("users/students/$referredUserId/")
              .get()
              .then((value) async {
            if (value.exists) {
              (value.value as Map)['full_name'];
              referredUserType = 'students';
            } else {
              await firebaseDatabase
                  .ref("users/teachers/$referredUserId/")
                  .get()
                  .then((value) {
                if (value.exists) {
                  (value.value as Map)['full_name'];
                  referredUserType = 'teachers';
                }
              });
            }
          }).then((value) async {
            await firebaseDatabase
                .ref(
                  "iprep_cash/$referredUserId/$referredUserType/balance/current_amount/",
                )
                .get()
                .then((iprepCashAmount) async {
              await firebaseDatabase
                  .ref("iprep_cash/$referredUserId/$referredUserType/balance/")
                  .set(
                {
                  "current_amount": (((iprepCashAmount.value == null)
                          ? (referredUserType == 'teachers'
                              ? creditAmount
                              : 100)
                          : (int.parse(iprepCashAmount.value.toString()) +
                              (referredUserType == 'teachers'
                                  ? creditAmount
                                  : 100))))
                      .toString(),
                },
              );
            });
          });
        } else {}
      });

      /*await firebaseDatabase
          .ref(
          "iprep_cash/$userID/$userTypeNode/history/referred_by/")
          .set({
        "refer_user_id": referUserID.toString(),
        "referral_code": referralUserCode.toString(),
        "refer_username": referUsername.toString(),
        "time": DateTime.now().toUtc().toString(),
        "type": "credit",
        "amount": referUserType == "students"
            ? "100"
            : userTypeNode == "students"
            ? "0"
            : "100",
      }).then((value) async {
        debugPrint("Saved Data successfully in the $userName ");

        await firebaseDatabase
            .ref(
          "iprep_cash/$userID/$userTypeNode/balance/current_amount/",
        )
            .get()
            .then((iprepCashAmount) async{
          await firebaseDatabase
              .ref("iprep_cash/$userID/$userTypeNode/balance/").set({
            "current_amount": (((iprepCashAmount.value == null)
                ? 0
                : int.parse(iprepCashAmount.value.toString())) +
                100)
                .toString(),
          },);

        }).then((value)async {
          await firebaseDatabase
              .ref(
              "iprep_cash/$referUserID/$userTypeNode/history/referred_to/$userID/")
              .set({
            "refer_user_id": userID.toString(),
            "referral_code": userReferralCode.toString(),
            "refer_username": userName.toString(),
            "time": DateTime.now().toUtc().toString(),
            "type": "credit",
            "amount": referUserType == "students"
                ? "100"
                : userTypeNode == "students"
                ? "0"
                : "100",
          });
        });
      });*/
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future depositEarningAmount(
      {String? referUserID,
      String? referralUserCode,
      String? referUsername,
      String? referUserType}) async {
    //Saving history for the person who has installed the app on tapping shared link
    String? userID = await (getStringValuesSF("userID"));
    String? userName = await getStringValuesSF("fullName");
    String? userReferralCode = await getStringValuesSF("referralCode");
    String? userTypeNode = await (userRepository.getUserNodeName());
    try {
      await firebaseDatabase
          .ref(
              "iprep_cash/$userID/$userTypeNode/history/referred_by/$referUserID/")
          .set({
        "refer_user_id": referUserID.toString(),
        "referral_code": referralUserCode.toString(),
        "refer_username": referUsername.toString(),
        "time": DateTime.now().toUtc().toString(),
        "type": "credit",
        "amount": referUserType == "students"
            ? "100"
            : userTypeNode == "students"
                ? "0"
                : "100",
      }).then((value) async {
        debugPrint("Saved Data successfully in the $userName ");

        await firebaseDatabase
            .ref(
              "iprep_cash/$userID/$userTypeNode/balance/current_amount/",
            )
            .get()
            .then((iprepCashAmount) async {
          await firebaseDatabase
              .ref("iprep_cash/$userID/$userTypeNode/balance/")
              .set(
            {
              "current_amount": (((iprepCashAmount.value == null)
                          ? 0
                          : int.parse(iprepCashAmount.value.toString())) +
                      100)
                  .toString(),
            },
          );
        }).then((value) async {
          await firebaseDatabase
              .ref(
                  "iprep_cash/$referUserID/$userTypeNode/history/referred_to/$userID/")
              .set({
            "refer_user_id": userID.toString(),
            "referral_code": userReferralCode.toString(),
            "refer_username": userName.toString(),
            "time": DateTime.now().toUtc().toString(),
            "type": "credit",
            "amount": referUserType == "students"
                ? "100"
                : userTypeNode == "students"
                    ? "0"
                    : "100",
          });
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future prepareDeepLinkForAppDownload() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    String packageName = "org.idreameducation.iprepapp";

    String? userID = await getStringValuesSF("userID");
    String? fullName = await getStringValuesSF("fullName");
    String? userTypeNodeName = await (userRepository.getUserNodeName());

    String storeUrl = Platform.isIOS
        ? Constants.appStoreUrl
        : "https://play.google.com/store/apps/details?id=org.idreameducation.iprepapp&hl=en";
    String? referralCode = await getStringValuesSF("referralCode");
    if (referralCode == null) {
      var referCode = await apiHandler.getAPICall(
          endPointURL:
              "referrals_scholarship_subscription_plans/referrals/$userID/$userTypeNodeName");
      referralCode = referCode["refer_code"];
      await userRepository.saveUserDetailToLocal("referralCode", referralCode!);
    }

    var parameters = DynamicLinkParameters(
        uriPrefix: 'https://iprepteacher.page.link',
        link: Uri.parse(
            '$storeUrl&referralCode=$referralCode&userID=$userID&fullName=$fullName&userType=$userTypeNodeName'),
        androidParameters: AndroidParameters(
          packageName: packageName,
        ),
        iosParameters: IOSParameters(
          bundleId: packageName,
          appStoreId: '1532244186',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: "Learn Unlimited with iPrep",
          description: "Learning App for 1st to 12th all Subjects",
          imageUrl: Uri.parse(
              "https://drive.google.com/file/d/1tUv3DzqnmNrqR3pTQLBr3NV_4Mbqndp_/view?usp=sharing"),
          // imageUrl: Uri.parse(news.imageSrc ??
          //     "https://i.picsum.photos/id/352/500/500.jpg?hmac=-E0Zo7evjUyTTEVC4YJW-pUDmGC2dMDxBvGZjWR7yv4")),
        ));
    // var dynamicUrl = await parameters.buildUrl();
    // final ShortDynamicLink shortenedLink =
    //     await DynamicLinkParameters.shortenUrl(
    //   dynamicUrl,
    //   DynamicLinkParametersOptions(
    //       shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short),
    // );
    // late var shortenedLink;

    final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
    Uri url = shortLink.shortUrl;
    var shortUrl = url;

    return (Constants.downloadLinkText + shortUrl.toString());
  }

  Future shareContent({BuildContext? context, required String content}) async {
    // final RenderBox box = context.findRenderObject();
    await Share.share(
      content,
      subject: "iPrep App",
      // sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
    );
  }

  Future fetchNumberOfInvitedPeopleAndEarnedAmount() async {
    String? userID = await getStringValuesSF("userID");
    String userTypeNode = await (userRepository.getUserNodeName());
    var response = await apiHandler.getAPICall(
        endPointURL: "iprep_cash/$userID/$userTypeNode/");
    return response;
  }
}
