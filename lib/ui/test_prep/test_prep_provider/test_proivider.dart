import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/test_prep_model/test_prep_model.dart';
import 'package:idream/model/user_plan_status_model/user_plan_status_model.dart';
import 'package:idream/repository/user_activation_repository/user_activation_repository.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../custom_widgets/custom_pop_up.dart';
import '../../dashboard/test_prep_web_page.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class TestProvider extends ChangeNotifier {
  bool? isLoading = false;
  ActivationResponseModel? statusResponse;
  late WebViewCookie? sessionCookie;
  CookieManager? cookieManager = CookieManager();

  onTapTestContainer({packageName, context, testWebLink}) async {
    String? userName = await getStringValuesSF("fullName");
    String? userEmail = await getStringValuesSF("email");
    String? userMobileNo = await getStringValuesSF("mobileNumber");
    String? userProfileImage = await getStringValuesSF("profilePhoto");
    userMobileNo = userMobileNo!.replaceAll("+91-", "");

    if ((userMobileNo.isEmpty || userEmail!.isEmpty) ||
        (userMobileNo.length < 5 ||
            userEmail.length < 5 ||
            userMobileNo == "" ||
            userEmail == "" ||
            userMobileNo == "null" ||
            userEmail == "null")) {
      testUserContactStatusPopUp(
        context: context,
        titleHd: "Contact information not available",
        titleBd: "To access and move further, Kindly add your contact details",
        buttonText: "Ok",
      );
    } else {
      isLoading = true;
      notifyListeners();
      final cookieVariable =
          "${userName?.trim() ?? "John Doe"}|${userEmail ?? "${userMobileNo ?? "1234567890"} @random.com"}|${userMobileNo ?? '1234567890'}|${userProfileImage ?? 'https://secure.gravatar.com/avatar/?s=96&d=mm'}|${userEmail != null ? "email" : "phone"}";
      final cookieData = dashboardRepository.encryption(cookieVariable);
      statusResponse = await UserActivationRepository().userActivation(
          ActivationModel(
            packageName: packageName,
            userData: "ip_user=$cookieData",
          ),
          context);
      isLoading = false;
      log(statusResponse.toString());
      notifyListeners();
      CookieManager? cookieManager = CookieManager();
      sessionCookie = WebViewCookie(
        name: 'ip_user',
        value:
            "${userName?.trim() ?? "John Doe"}|${userEmail ?? ""}|${userMobileNo ?? '1234567890'}|${userProfileImage ?? 'https://secure.gravatar.com/avatar/?s=96&d=mm'}|${userEmail != null ? "email" : "phone"}",
        domain: '.iprep.in',
        path: "/",
      );
      cookieManager.setCookie(sessionCookie!);
      notifyListeners();
      if (statusResponse != null) {
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => TestPrepWebPage(
              link: testWebLink,
              cookieManager: cookieManager,
            ),
          ),
        );
      }
    }

    bool enabled = true;
  }

  // int? length = 0;
  // schoolLevelLength({List<Others?>? testPrepData}) {
  //   List<SubCategory?>? testPrepDataSchool = [];
  //   length = testPrepData?.length;
  //   testPrepData?.forEach((element) {
  //     if (element != null) {
  //       if (element.id == "school_level_all_india") {
  //         for (int i = 0; i < element.subCategory!.length; i++) {
  //           testPrepDataSchool.add(element.subCategory![i]);
  //           testPrepDataSchool.contains(null)
  //               ? testPrepDataSchool.remove(null)
  //               : debugPrint("null not found");
  //         }
  //       }
  //     } else {
  //     //  debugPrint("null found");
  //     }
  //   });
  // }
}
