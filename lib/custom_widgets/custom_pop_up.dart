import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/model/user.dart';
import 'package:idream/ui/menu/edit_profile_page.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../common/global_variables.dart';
import '../subscription/andriod/android_subscription.dart';
import '../subscription/iOS/iOS.dart';
import '../ui/menu/upgrade_plan_page.dart';
import '../ui/onboarding/login_options.dart';
import 'loader.dart';

Future testUserContactStatusPopUp(
    {required BuildContext context, titleHd, titleBd, buttonText}) async {
  return await showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info,
                  color: Color(0xFF3399FF),
                  size: 48,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "क्या आपको यकीन है?"
                      : titleHd,
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "एक बार चुने जाने के बाद आप प्रोफ़ाइल स्विच नहीं कर पाएंगे"
                      : titleBd,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    height: 1.4,
                    color: Color(0xFF707070),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xFF80C241),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop("Yes");
                  },
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim),
        child: child,
      );
    },
  );
}


Future userTypeConfirmationPopUp(BuildContext context) async {
  return await showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info,
                  color: Color(0xFF3399FF),
                  size: 48,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "क्या आपको यकीन है?"
                      : 'Are you sure?',
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "एक बार चुने जाने के बाद आप प्रोफ़ाइल स्विच नहीं कर पाएंगे"
                      : 'Once selected you will not be able to switch profile',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    height: 1.4,
                    color: Color(0xFF707070),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop("No");
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFC4C4C4),
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: const Size(140, 45),
                      ),
                      child: Text(selectedAppLanguage!.toLowerCase() == "hindi"
                          ? "नहीं"
                          : 'No'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop("Yes");
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF80C241),
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: const Size(140, 45),
                      ),
                      child: Text(
                        selectedAppLanguage!.toLowerCase() == "hindi"
                            ? "हाँ"
                            : 'Yes',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim),
        child: child,
      );
    },
  );
}

Future testUserNUmEmailStetUpPopUp(
    {required BuildContext context, titleHd, titleBd}) async {
  String? userMobileNo = await getStringValuesSF("mobileNumber");
  String? userEmail = await getStringValuesSF("email");
  final formKey = GlobalKey<FormState>();
  return await showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
     return StatefulBuilder(builder: (context, setState) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            margin: const EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: double.infinity,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info,
                      color: Color(0xFF3399FF),
                      size: 48,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      selectedAppLanguage!.toLowerCase() == "hindi"
                          ? "क्या आपको यकीन है?"
                          : titleHd,
                      style: const TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      selectedAppLanguage!.toLowerCase() == "hindi"
                          ? "एक बार चुने जाने के बाद आप प्रोफ़ाइल स्विच नहीं कर पाएंगे"
                          : titleBd,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        height: 1.4,
                        color: Color(0xFF707070),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    userMobileNo == ""
                        ? EditProfileTextWidget(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your mobile number";
                        }
                        return null;
                      },
                      leadingImagePath: "assets/images/telephone.png",
                      placeholder: "Mobile",
                      textController: mobileController,
                      enabled: true,
                      keyboardType: TextInputType.phone,
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                    )
                        : EditProfileTextWidget(
                      leadingImagePath: "assets/images/mail_icon.png",
                      placeholder: "Email",
                      textController: emailController,
                      enabled: true,
                      keyboardType: TextInputType.emailAddress,
                      validator: (input) {
                        if (input!.isNotEmpty && !input.isValidEmail()) {
                          profileEdited = false;
                          return "Check your email";
                        }
                        return null;
                      },
                      autoValidate: AutovalidateMode.always,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF80C241),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                      ),
                      onPressed: () async {
                        final mobileNumber =
                        await getStringValuesSF('mobileNumber');
                        final emailAdress = await getStringValuesSF('address');
                        if (formKey.currentState!.validate()) {
                          await userRepository.updateUserProfile();

                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },);
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim),
        child: child,
      );
    },
  );
}

Future testUserPlanStatusPopUp(
    {required BuildContext context, titleHd, titleBd, buttonText}) async {
  return await showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info,
                  color: Color(0xFF3399FF),
                  size: 48,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "क्या आपको यकीन है?"
                      : titleHd,
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "एक बार चुने जाने के बाद आप प्रोफ़ाइल स्विच नहीं कर पाएंगे"
                      : titleBd,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    height: 1.4,
                    color: Color(0xFF707070),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xFF80C241),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop("Yes");
                  },
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim),
        child: child,
      );
    },
  );
}

Future logOutPopUp(BuildContext context) async {
  return await showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info,
                  color: Color(0xFF3399FF),
                  size: 48,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'You have been logged out.',
                  style: TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Please log in again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.4,
                    color: Color(0xFF707070),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFC4C4C4),
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: const Size(140, 45),
                      ),
                      child: const Text('Ok'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim),
        child: child,
      );
    },
  );
}

Future exceedingLoginLimitsPopUp(BuildContext context) async {
  return await showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info,
                  color: Color(0xFF3399FF),
                  size: 48,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Exceeding number of allowed login',
                  style: TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'This account is being used on ${Constants.numberOfAllowedUsersPerAccount} devices. Please log out on any of these device and retry to login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.4,
                    color: Color(0xFF707070),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop("Yes");
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF3399FF),
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: const Size(double.maxFinite, 45),
                      ),
                      child: const Text(
                        'Log Out From All Devices',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop("No");
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 0,
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                        minimumSize: const Size(140, 45),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Color(0xFF212121)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim),
        child: child,
      );
    },
  );
}

Future welcomeMessagePopUp(BuildContext context) async {
  return await showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info,
                  color: Color(0xFF3399FF),
                  size: 48,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "iPrep लर्निंग ऍप में आपका स्वागत है"
                      : 'Welcome to iPrep',
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "यहाँ पर आप एनिमेटेड वीडियो पाठ, कहानियां, कवितायेँ एवं पाठ्यक्रम की पुस्तकें और अभ्यास के प्रश्नों के उपयोग से आप हर विषय पर अपनी महारत बनाने में सक्षम हो सकते हैं।"
                      : 'iPrep Learning App provides you with unlimited access to enjoyable videos, engaging books, DIY Projects and practice assessments to master every topic. ',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    height: 1.4,
                    color: Color(0xFF707070),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "आप अपनी रूचि के अनुसार पढ़ सकते हैं, हिंदी या अंग्रेजी किसी भी भाषा में ऍप का उपयोग कर सकते हैं और अपनी कक्षा बदल कर आप कोई भी डिजिटल सामग्री को देख सकते हैं। "
                      : 'You can learn as per your interest, choose to learn in either English or Hindi medium and switch across classes to look at any content. ',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    height: 1.4,
                    color: Color(0xFF707070),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "किसी भी तरह के सपोर्ट के लिए आप इन नंबर पे हमें कॉल कर सकते हैं - 9810669749 या 9310993976"
                      : 'For any support, please reach out to us at 9810669749 or 9310993976. ',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    height: 1.4,
                    color: Color(0xFF707070),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  selectedAppLanguage!.toLowerCase() == "hindi"
                      ? ""
                      : 'Happy Learning.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    height: 1.4,
                    color: Color(0xFF707070),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFC4C4C4),
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: const Size(140, 45),
                      ),
                      child: Text(selectedAppLanguage!.toLowerCase() == "hindi"
                          ? "ठीक है"
                          : 'Ok'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim),
        child: child,
      );
    },
  );
}

Future planExpiryPopUpForStudent(BuildContext context) async {
  return await showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info,
                  color: Color(0xFF3399FF),
                  size: 48,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Plan Expires',
                  style: TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  usingIprepLibrary
                      ? "You don't have any active subscription plan to use iPrep Library. "
                          "This restriction is only applicable for iPrep Library content. However, all the Coach "
                          "functions are available to use."
                      : Platform.isAndroid
                          ? "You don't have any active subscription plan."
                          : "You don't have any active plan.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    height: 1.4,
                    color: Color(0xFF707070),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                Platform.isAndroid
                                    ? const AndroidSubscriptionPlan()
                                    : const UpgradePlan(),
                          ),
                        );

                        return Navigator.of(context).pop("Yes");
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF3399FF),
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: const Size(double.maxFinite, 45),
                      ),
                      child: Text(
                        usingIprepLibrary
                            ? "I wish to Upgrade"
                            : Platform.isAndroid
                                ? 'Upgrade Now'
                                : "Update Now",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop("No");
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 0,
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                        minimumSize: const Size(140, 45),
                      ),
                      child: const Text(
                        'Later',
                        style: TextStyle(color: Color(0xFF707070)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim),
        child: child,
      );
    },
  );
}

Future userActiveStatus(BuildContext context) async {
  return await showDialog<void>(
    context: context,
    barrierDismissible: true,
    useSafeArea: true,
    // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 17),
        backgroundColor: const Color(0xFFFFFFFF),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        alignment: Alignment.center,
        titleTextStyle: Constants.noDataTextStyle.copyWith(
          fontSize: 18,
          fontFamily: 'Inter',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF565657),
        ),
        title: Lottie.asset("assets/json/user-disabled.json",
            height: 92, width: 90),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.only(bottom: 31),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Access Denied",
                    style: Constants.noDataTextStyle.copyWith(
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF565657),
                    ),
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  Text(
                    "Your access has been revoked. Please contact your [Partner] for more information.",
                    style: Constants.noDataTextStyle.copyWith(
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF565657),
                    ),
                  ),
                  const SizedBox(
                    height: 43,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: const Color(0xFFF1F5F9),
                      backgroundColor: const Color(0xFFF1F5F9),
                      minimumSize: const Size(185, 45),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    child: Text(
                      "Okay",
                      style: TextStyle(
                        color: const Color(0xFF212121),
                        fontWeight: FontWeight.values[5],
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const LoginOptions(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

// Future planExpiryPopUpForCoach(BuildContext context) async {
//   return await showGeneralDialog(
//     barrierLabel: "Barrier",
//     barrierDismissible: true,
//     barrierColor: Colors.black.withOpacity(0.5),
//     transitionDuration: Duration(milliseconds: 700),
//     context: context,
//     pageBuilder: (_, __, ___) {
//       return Align(
//         alignment: Alignment.center,
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//           margin: EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           width: double.infinity,
//           child: Material(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.info,
//                   color: Color(0xFF3399FF),
//                   size: 48,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   'Plan Expires',
//                   style: TextStyle(
//                     color: Color(0xFF212121),
//                     fontSize: 18,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   "You don't have any active subscription plan to use iPrep Library. This restriction is only applicable on iPrep Library screens and all the Coach functions are available to use.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     height: 1.4,
//                     color: Color(0xFF707070),
//                     fontSize: 16,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Column(
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).pop("Yes");
//                       },
//                       style: ElevatedButton.styleFrom(
//                         primary: Color(0xFF3399FF),
//                         textStyle: TextStyle(
//                           fontSize: 18,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         minimumSize: Size(double.maxFinite, 45),
//                       ),
//                       child: const Text(
//                         'Upgrade Now',
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).pop("No");
//                       },
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.white,
//                         elevation: 0,
//                         textStyle: TextStyle(
//                           fontSize: 18,
//                         ),
//                         minimumSize: Size(140, 45),
//                       ),
//                       child: Text(
//                         'Later',
//                         style: TextStyle(color: Color(0xFF707070)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//     transitionBuilder: (_, anim, __, child) {
//       return SlideTransition(
//         position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
//         child: child,
//       );
//     },
//   );
// }
