import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/custom_pop_up.dart';
import 'package:idream/model/user.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:idream/ui/my_teachers_flies/name_enter_coach_screen.dart';
import 'package:idream/ui/onboarding/app_level_language_selection_screen.dart';
import 'package:idream/ui/onboarding/board_selection_screen.dart';
import 'package:idream/ui/onboarding/login_screen.dart';
import 'package:idream/ui/onboarding/user_type_slection_screen.dart';
import 'package:idream/ui/teacher/dashboard_coach.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../ui/onboarding/login_options.dart';
import '../ui/onboarding/sign_up/account_otp_verification_page.dart';
import '../ui/onboarding/sign_up/account_verification_page.dart';
import '../ui/onboarding/sign_up/sign_up_page.dart';

class LoginRepository {
  String? appleUserName;
  bool firstTimeLanded = false;
  Future registerUser(String mobile, BuildContext context,
      LoginScreenState? loginScreenState, bool mounted) async {
    if (mobile.length == 10) {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91$mobile",
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential authCredential) async {
            await handlingLoginResponse(context, authCredential,
                mounted: mounted);
            // ignore: invalid_use_of_protected_member
            loginScreenState!.setState(() {
              loginScreenState.showLoader = false;
            });
          },
          verificationFailed: (authException) {
            // ignore: invalid_use_of_protected_member
            loginScreenState!.setState(() {
              loginScreenState.showLoader = false;
            });
            SnackbarMessages.showErrorSnackbar(context,
                error: Constants.googleLoginError);
            debugPrint(authException.message);
          },
          codeSent: (verificationID, a) {
            debugPrint(verificationID);
            // ignore: invalid_use_of_protected_member
            loginScreenState!.setState(() {
              loginScreenState.mobileVerificationID = verificationID;
              loginScreenState.otpScreen = true;
              loginScreenState.showLoader = false;
            });
            debugPrint(a.toString());
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            debugPrint("verificationId : $verificationId");
            // ignore: invalid_use_of_protected_member
            loginScreenState?.setState(() {
              loginScreenState.showLoader = false;
            });
          },
        );
      } on FirebaseException catch (e) {
        debugPrint(e.toString());
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      // ignore: invalid_use_of_protected_member
      loginScreenState!.setState(() {
        loginScreenState.showLoader = false;
      });
      SnackbarMessages.showErrorSnackbar(context,
          error: Constants.incorrectMobileNumber);
    }
  }

  Future submitOtp(BuildContext context, bool mounted,
      {String? verificationCode,
      required String enteredPin,
      LoginScreenState? loginScreenState}) async {
    if (enteredPin.length == 6) {
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verificationCode!, smsCode: enteredPin);

      await handlingLoginResponse(
        context,
        authCredential,
        mounted: mounted,
        loginScreenState: loginScreenState,
      );
    } else {
      if (loginScreenState != null) {
        // ignore: invalid_use_of_protected_member
        loginScreenState.setState(() {
          loginScreenState.showLoader = false;
        });
      }
      SnackbarMessages.showErrorSnackbar(context, error: Constants.invalidOtp);
    }
  }

  Future handlingLoginResponse(
    BuildContext context,
    AuthCredential authCredential, {
    String appType = "App",
    LoginScreenState? loginScreenState,
    required bool mounted,
  }) async {
    firebaseAuth.signInWithCredential(authCredential).then((value) async {
      if (value.user != null) {
        await checkUserType(userID: value.user!.uid, context: context);
        String? language = await getStringValuesSF("language");
        selectedAppLanguage = language;

        String? userType = await getStringValuesSF("UserType");
        debugPrint(userType);
        if (language == null) {
          await languageSellection(context: context);
          selectedAppLanguage = 'english';
        }
        debugPrint("user__$userType");
        await analyticsRepository.setUserProperties(userID: value.user!.uid);

        if (value.additionalUserInfo!.isNewUser) {
          await triggerPostLoginInfoForNewUser(
              value: value, context: context, appType: appType);
          if (loginScreenState != null) {
            // ignore: invalid_use_of_protected_member
            loginScreenState.setState(() {
              loginScreenState.showLoader = false;
            });
          }
        } else {
          //Fetch Logged in User details
          AppUser userDetails =
              await (userRepository.fetchUserDetails(value.user!.uid));
          selectedAppLanguage = (userDetails.language);
          if (userDetails.mobile == null || userDetails.fullName == null) {
            await triggerPostLoginInfoForNewUser(
                value: value, context: context, appType: appType);
          } else if (userDetails.classID == null) {
            selectedAppLanguage = (userDetails).language;

            AppUser? appUser = userDetails;
            await userRepository.saveUserDetailToLocal(
                "userID", value.user!.uid);
            await addStringToSF("app_Version", appUser.version ?? "");
            //Save userType
            await userRepository.saveUserDetailToLocal(
                "userType", appUser.userType!);
            //Save displayName
            await userRepository.saveUserDetailToLocal(
                "fullName", appUser.fullName!);
            //Save mobileNumber
            await userRepository.saveUserDetailToLocal(
                "mobileNumber", appUser.mobile!);
            //Save fcmToken
            await userRepository.saveUserDetailToLocal(
                "fcmToken", appUser.token!);
            await userRepository.saveUserDetailToLocal(
                "email", appUser.email ?? '');
            emailController.text = appUser.email ?? '';
            if (loginScreenState != null) {
              // ignore: invalid_use_of_protected_member
              loginScreenState.setState(() {
                loginScreenState.showLoader = false;
              });
            }
            //TODO: Here we are changing the Flow...
            var _userType = await getStringValuesSF("UserType");

            //Check whether Logged in user is a teacher
            if ((_userType != null && _userType == "Coach")) {
              if ((userDetails.fullName != null) &&
                  (userDetails.fullName!.isNotEmpty)) {
                //Move to Dashboard of Teacher
                debugPrint("user__$userType");
                await userRepository.saveUserDetailToLocal(
                    "address", appUser.address.toString());
                await userRepository.saveUserDetailToLocal(
                    "state", appUser.state.toString());
                await userRepository.saveUserDetailToLocal(
                    "city", appUser.city.toString());
                await userRepository.saveUserDetailToLocal(
                    "age", appUser.age.toString());
                await userRepository.saveUserDetailToLocal(
                    "gender", appUser.gender.toString());
                await userRepository.saveUserDetailToLocal(
                    "dateOfBirth", appUser.dateOfBirth.toString());
                await userRepository.saveUserDetailToLocal(
                    "profilePhoto", appUser.profilePhoto.toString());
                await userRepository.saveUserDetailToLocal(
                    "onBoarding", "Completed");

                bool _validCoachLogin = await (userRepository
                    .checkIfNumberOfLoginExceedingLimits());

                if (_validCoachLogin == true) {
                  await userRepository.saveCurrentDeviceInfo();
                  // var data="${userDetails.fullName?? "John Doe"}|${userDetails.email?? ""}|${'1234567890'}|${userDetails.profilePhoto??'https://secure.gravatar.com/avatar/?s=96&d=mm'}";
                  //
                  // await apiHandler.getAPICallChangeWithBaseUrl(
                  //     baseURL: "https://learn.iprep.in/api/set_cookie?ip_user=",
                  //     endPointURL: data,
                  //     jsonb: false);
                  if (!mounted) return;
                  await Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const DashboardCoach(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  if (!mounted) return;
                  var _response = await exceedingLoginLimitsPopUp(context);
                  if (_response == "Yes") {
                    await userRepository.deleteAllDeviceInfo();
                    await userRepository.saveCurrentDeviceInfo();
                    // await apiHandler.getAPICallChangeWithBaseUrl(
                    //     baseURL: "https://learn.iprep.in/api/login?userid=",
                    //     endPointURL: value.user!.uid,
                    //     jsonb: false);
                    if (!mounted) return;
                    await Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const DashboardCoach(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    if (!mounted) return;
                    await userRepository.removeSavedInstances(context);
                    if (!mounted) return;
                    await Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            const AppLevelLanguageSelectionScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  }
                }
              } else {
                if (!mounted) return;
                await Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const NameEnterCoachScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              }

              //  New user Add det
            } else {
              if (!mounted) return;
              await Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => const BoardSelectionScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            }
            // await Navigator.pushAndRemoveUntil(
            //   context,
            //   CupertinoPageRoute(
            //     builder: (context) => UserTypeSelectionScreen(),
            //   ),
            //   (Route<dynamic> route) => false,
            // );
          } else {
            debugPrint(userDetails.toString());
            //SAVE ALL THE INFORMATION HERE
            await userRepository.checkAndUpdateFCMTokenForCurrentUser();
            AppUser? appUser = userDetails;
            await userRepository.saveUserDetailToLocal(
                "userID", value.user!.uid);
            await addStringToSF("app_Version", appUser.version ?? "");
            await userRepository.saveUserDetailToLocal(
                "userType", appUser.userType!);
            await userRepository.saveUserDetailToLocal(
                "fullName", appUser.fullName!);
            await userRepository.saveUserDetailToLocal(
                "mobileNumber", appUser.mobile!);
            await userRepository.saveUserDetailToLocal(
                "fcmToken", appUser.token!);

            await userRepository.saveUserDetailToLocal(
              "address",
              appUser.address.toString(),
            );
            await userRepository.saveUserDetailToLocal(
              "state",
              appUser.state.toString(),
            );
            await userRepository.saveUserDetailToLocal(
              "city",
              appUser.city.toString(),
            );

            String? address = await getStringValuesSF("address");
            String? state = await getStringValuesSF("state");
            String? city = await getStringValuesSF("city");
            debugPrint(address);
            debugPrint(state);
            debugPrint(city);

            if (address == 'null' &&
                appUser.userProfile != null &&
                appUser.userProfile!.location != null) {
              String address =
                  "${appUser.userProfile!.location!.locationName} ${appUser.userProfile!.location!.thoroughfare} ${appUser.userProfile!.location!.subLocality} ${appUser.userProfile!.location!.locality} ${appUser.userProfile!.location!.administrativeArea} ${appUser.userProfile!.location!.postalCode}";
              String state =
                  appUser.userProfile!.location!.administrativeArea.toString();
              String city = appUser.userProfile!.location!.locality.toString();
              await userRepository.saveUserDetailToLocal(
                "address",
                address,
              );
              await userRepository.saveUserDetailToLocal(
                "state",
                state,
              );
              await userRepository.saveUserDetailToLocal(
                "city",
                city,
              );
            }

            String? alreadySelectedLanguage =
                await getStringValuesSF("language");
            if ((alreadySelectedLanguage != null) &&
                (alreadySelectedLanguage != appUser.language)) {
              await userRepository.updateUserProfileWithSelectedLanguage(
                  language: alreadySelectedLanguage);
              appUser.language = alreadySelectedLanguage;
            } else {
              await userRepository.saveUserDetailToLocal(
                  'language', appUser.language!);
            }

            await userRepository.saveUserDetailToLocal(
                "educationBoard", appUser.educationBoard ?? appUser.boardID!);
            await userRepository.saveUserDetailToLocal("email", appUser.email!);
            emailController.text = appUser.email ?? '';
            await userRepository.saveUserDetailToLocal(
                "age", appUser.age.toString());
            await userRepository.saveUserDetailToLocal(
                "gender", appUser.gender.toString());
            await userRepository.saveUserDetailToLocal(
                "dateOfBirth", appUser.dateOfBirth.toString());
            await userRepository.saveUserDetailToLocal(
                "parentContact", appUser.parentContact.toString());
            await userRepository.saveUserDetailToLocal(
                "email", appUser.email.toString());
            await userRepository.saveUserDetailToLocal(
                "school", appUser.school.toString());

            if (appUser.classID!.contains("_")) {
              String _stream = appUser.classID!.substring(3);
              String _class = appUser.classID!.substring(0, 2);
              await userRepository.saveUserDetailToLocal(
                  "stream", _stream.toString());
              await userRepository.saveUserDetailToLocal(
                  "classNumber", _class.toString());
            } else {
              await userRepository.saveUserDetailToLocal(
                  "classNumber", appUser.classID.toString());
            }
            await userRepository.saveUserDetailToLocal(
                "onBoarding", "Completed");

            await userRepository.saveUserDetailToLocal(
                "userPlanStatus", appUser.userPlans!.status!);
            await userRepository.saveUserDetailToLocal(
                "userPlanDuration", appUser.userPlans!.planDuration.toString());
            await userRepository.saveUserDetailToLocal("userPlanDateStarted",
                appUser.userPlans!.dateStarted.toString());

            await userRepository.saveUserDetailToLocal(
                "profilePhoto", appUser.profilePhoto.toString());
            if (loginScreenState != null) {
              // ignore: invalid_use_of_protected_member
              loginScreenState.setState(() {
                loginScreenState.showLoader = true;
              });
            }

            bool? _validUser;
            await userRepository
                .checkIfNumberOfLoginExceedingLimits()
                .then((value) {
              _validUser = value;
            });
            if (_validUser!) {
              var response = await userRepository.saveCurrentDeviceInfo();

              debugPrint(response.toString());
              if (!mounted) return;
              await Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => DashboardScreen(
                    firstTimeLanded: firstTimeLanded,
                  ),
                ),
                (Route<dynamic> route) => false,
              );
            } else {
              if (!mounted) return;
              var _response = await exceedingLoginLimitsPopUp(context);
              if (_response == "Yes") {
                await userRepository.deleteAllDeviceInfo();
                await userRepository.saveCurrentDeviceInfo();
                await apiHandler.getAPICallChangeWithBaseUrl(
                    baseURL: "https://learn.iprep.in/api/login?userid=",
                    endPointURL: value.user!.uid,
                    jsonb: false);
                if (!mounted) return;
                await Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              } else {
                if (!mounted) return;
                await userRepository.removeSavedInstances(context);
                if (!mounted) return;
                await Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        const AppLevelLanguageSelectionScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              }
            }
          }
        }
      } else {
        if (loginScreenState != null) {
          // ignore: invalid_use_of_protected_member
          loginScreenState.setState(() {
            loginScreenState.showLoader = false;
          });
        }
        SnackbarMessages.showErrorSnackbar(context,
            error: Constants.errorValidatingOtp);
      }
    }).catchError((error) async {
      if (loginScreenState != null) {
        loginScreenState.setState(() {
          loginScreenState.showLoader = false;
        });
      }
      debugPrint(error.toString());
      SnackbarMessages.showErrorSnackbar(context,
          error: Constants.googleLoginError);

      if (error.code == "user-disabled") {
        await userActiveStatus(context);
      }
    });
  }

  updateAuthStateWithUserCredential(
      {value,
      required BuildContext context,
      String appType = "App",
      required bool mounted,
      loginScreenState}) async {
    if (value.user != null) {
      await checkUserType(userID: value.user!.uid, context: context);
      String? language = await getStringValuesSF("language");
      selectedAppLanguage = language;

      String? userType = await getStringValuesSF("UserType");
      debugPrint(userType);
      if (language == null) {
        await languageSellection(context: context);
        selectedAppLanguage = 'english';
      }
      debugPrint("user__$userType");
      await analyticsRepository.setUserProperties(userID: value.user!.uid);

      if (value.additionalUserInfo!.isNewUser) {
        await triggerPostLoginInfoForNewUser(
            value: value, context: context, appType: appType);
        if (loginScreenState != null) {
          // ignore: invalid_use_of_protected_member
          loginScreenState.setState(() {
            loginScreenState.showLoader = false;
          });
        }
      } else {
        //Fetch Logged in User details
        AppUser userDetails =
            await (userRepository.fetchUserDetails(value.user!.uid));
        selectedAppLanguage = (userDetails.language);
        if (userDetails.mobile == null || userDetails.fullName == null) {
          await triggerPostLoginInfoForNewUser(
              value: value, context: context, appType: appType);
        } else if (userDetails.classID == null) {
          selectedAppLanguage = (userDetails).language;
          debugPrint(selectedAppLanguage);
          debugPrint(userDetails.classID);
          AppUser? appUser = userDetails;
          await userRepository.saveUserDetailToLocal("userID", value.user!.uid);
          //Save userType
          await userRepository.saveUserDetailToLocal(
              "userType", appUser.userType!);
          //Save displayName
          await userRepository.saveUserDetailToLocal(
              "fullName", appUser.fullName!);
          //Save mobileNumber
          await userRepository.saveUserDetailToLocal(
              "mobileNumber", appUser.mobile!);
          //Save fcmToken
          await userRepository.saveUserDetailToLocal(
              "fcmToken", appUser.token!);
          await userRepository.saveUserDetailToLocal(
              "email", appUser.email ?? '');
          emailController.text = appUser.email ?? '';
          if (loginScreenState != null) {
            // ignore: invalid_use_of_protected_member
            loginScreenState.setState(() {
              loginScreenState.showLoader = false;
            });
          }
          //TODO: Here we are changing the Flow...
          var _userType = await getStringValuesSF("UserType");

          //Check whether Logged in user is a teacher
          if ((_userType != null && _userType == "Coach")) {
            if ((userDetails.fullName != null) &&
                (userDetails.fullName!.isNotEmpty)) {
              //Move to Dashboard of Teacher
              debugPrint("user__$userType");
              await userRepository.saveUserDetailToLocal(
                  "address", appUser.address.toString());
              await userRepository.saveUserDetailToLocal(
                  "state", appUser.state.toString());
              await userRepository.saveUserDetailToLocal(
                  "city", appUser.city.toString());
              await userRepository.saveUserDetailToLocal(
                  "age", appUser.age.toString());
              await userRepository.saveUserDetailToLocal(
                  "gender", appUser.gender.toString());
              await userRepository.saveUserDetailToLocal(
                  "dateOfBirth", appUser.dateOfBirth.toString());
              await userRepository.saveUserDetailToLocal(
                  "profilePhoto", appUser.profilePhoto.toString());
              await userRepository.saveUserDetailToLocal(
                  "onBoarding", "Completed");

              bool _validCoachLogin =
                  await (userRepository.checkIfNumberOfLoginExceedingLimits());

              if (_validCoachLogin == true) {
                await userRepository.saveCurrentDeviceInfo();
                // var data="${userDetails.fullName?? "John Doe"}|${userDetails.email?? ""}|${'1234567890'}|${userDetails.profilePhoto??'https://secure.gravatar.com/avatar/?s=96&d=mm'}";
                //
                // await apiHandler.getAPICallChangeWithBaseUrl(
                //     baseURL: "https://learn.iprep.in/api/set_cookie?ip_user=",
                //     endPointURL: data,
                //     jsonb: false);
                if (!mounted) return;
                await Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const DashboardCoach(),
                  ),
                  (Route<dynamic> route) => false,
                );
              } else {
                if (!mounted) return;
                var _response = await exceedingLoginLimitsPopUp(context);
                if (_response == "Yes") {
                  await userRepository.deleteAllDeviceInfo();
                  await userRepository.saveCurrentDeviceInfo();
                  // await apiHandler.getAPICallChangeWithBaseUrl(
                  //     baseURL: "https://learn.iprep.in/api/login?userid=",
                  //     endPointURL: value.user!.uid,
                  //     jsonb: false);
                  if (!mounted) return;
                  await Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const DashboardCoach(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  if (!mounted) return;
                  await userRepository.removeSavedInstances(context);
                  if (!mounted) return;
                  await Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          const AppLevelLanguageSelectionScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                }
              }
            } else {
              if (!mounted) return;
              await Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => const NameEnterCoachScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            }

            //  New user Add det
          } else {
            if (!mounted) return;
            await Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => const BoardSelectionScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          }
          // await Navigator.pushAndRemoveUntil(
          //   context,
          //   CupertinoPageRoute(
          //     builder: (context) => UserTypeSelectionScreen(),
          //   ),
          //   (Route<dynamic> route) => false,
          // );
        } else {
          debugPrint(userDetails.toString());
          //SAVE ALL THE INFORMATION HERE
          AppUser? appUser = userDetails;
          await userRepository.saveUserDetailToLocal("userID", value.user!.uid);
          await userRepository.saveUserDetailToLocal(
              "userType", appUser.userType!);
          await userRepository.saveUserDetailToLocal(
              "fullName", appUser.fullName!);
          await userRepository.saveUserDetailToLocal(
              "mobileNumber", appUser.mobile!);
          await userRepository.saveUserDetailToLocal(
              "fcmToken", appUser.token!);

          await userRepository.saveUserDetailToLocal(
            "address",
            appUser.address.toString(),
          );
          await userRepository.saveUserDetailToLocal(
            "state",
            appUser.state.toString(),
          );
          await userRepository.saveUserDetailToLocal(
            "city",
            appUser.city.toString(),
          );

          String? address = await getStringValuesSF("address");
          String? state = await getStringValuesSF("state");
          String? city = await getStringValuesSF("city");
          debugPrint(address);
          debugPrint(state);
          debugPrint(city);

          if (address == 'null' &&
              appUser.userProfile != null &&
              appUser.userProfile!.location != null) {
            String address =
                "${appUser.userProfile!.location!.locationName} ${appUser.userProfile!.location!.thoroughfare} ${appUser.userProfile!.location!.subLocality} ${appUser.userProfile!.location!.locality} ${appUser.userProfile!.location!.administrativeArea} ${appUser.userProfile!.location!.postalCode}";
            String state =
                appUser.userProfile!.location!.administrativeArea.toString();
            String city = appUser.userProfile!.location!.locality.toString();
            await userRepository.saveUserDetailToLocal(
              "address",
              address,
            );
            await userRepository.saveUserDetailToLocal(
              "state",
              state,
            );
            await userRepository.saveUserDetailToLocal(
              "city",
              city,
            );
          }

          String? alreadySelectedLanguage = await getStringValuesSF("language");
          if ((alreadySelectedLanguage != null) &&
              (alreadySelectedLanguage != appUser.language)) {
            await userRepository.updateUserProfileWithSelectedLanguage(
                language: alreadySelectedLanguage);
            appUser.language = alreadySelectedLanguage;
          } else {
            await userRepository.saveUserDetailToLocal(
                'language', appUser.language!);
          }

          await userRepository.saveUserDetailToLocal(
              "educationBoard", appUser.educationBoard ?? appUser.boardID!);
          await userRepository.saveUserDetailToLocal("email", appUser.email!);
          emailController.text = appUser.email ?? '';
          await userRepository.saveUserDetailToLocal(
              "age", appUser.age.toString());
          await userRepository.saveUserDetailToLocal(
              "gender", appUser.gender.toString());
          await userRepository.saveUserDetailToLocal(
              "dateOfBirth", appUser.dateOfBirth.toString());
          await userRepository.saveUserDetailToLocal(
              "parentContact", appUser.parentContact.toString());
          await userRepository.saveUserDetailToLocal(
              "email", appUser.email.toString());
          await userRepository.saveUserDetailToLocal(
              "school", appUser.school.toString());

          if (appUser.classID!.contains("_")) {
            String _stream = appUser.classID!.substring(3);
            String _class = appUser.classID!.substring(0, 2);
            await userRepository.saveUserDetailToLocal(
                "stream", _stream.toString());
            await userRepository.saveUserDetailToLocal(
                "classNumber", _class.toString());
          } else {
            await userRepository.saveUserDetailToLocal(
                "classNumber", appUser.classID.toString());
          }
          await userRepository.saveUserDetailToLocal("onBoarding", "Completed");

          await userRepository.saveUserDetailToLocal(
              "userPlanStatus", appUser.userPlans!.status!);
          await userRepository.saveUserDetailToLocal(
              "userPlanDuration", appUser.userPlans!.planDuration.toString());
          await userRepository.saveUserDetailToLocal(
              "userPlanDateStarted", appUser.userPlans!.dateStarted.toString());

          await userRepository.saveUserDetailToLocal(
              "profilePhoto", appUser.profilePhoto.toString());
          if (loginScreenState != null) {
            // ignore: invalid_use_of_protected_member
            loginScreenState.setState(() {
              loginScreenState.showLoader = true;
            });
          }

          bool? _validUser;
          await userRepository
              .checkIfNumberOfLoginExceedingLimits()
              .then((value) {
            _validUser = value;
          });
          if (_validUser!) {
            var response = await userRepository.saveCurrentDeviceInfo();
            debugPrint(response.toString());
            await userRepository.checkAndUpdateFCMTokenForCurrentUser();
            if (!mounted) return;
            await Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => DashboardScreen(
                  firstTimeLanded: firstTimeLanded,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            if (!mounted) return;
            var _response = await exceedingLoginLimitsPopUp(context);
            if (_response == "Yes") {
              await userRepository.deleteAllDeviceInfo();
              await userRepository.saveCurrentDeviceInfo();
              await apiHandler.getAPICallChangeWithBaseUrl(
                  baseURL: "https://learn.iprep.in/api/login?userid=",
                  endPointURL: value.user!.uid,
                  jsonb: false);
              if (!mounted) return;
              await Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            } else {
              if (!mounted) return;
              await userRepository.removeSavedInstances(context);
              if (!mounted) return;
              await Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => const AppLevelLanguageSelectionScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            }
          }
        }
      }
    } else {
      if (loginScreenState != null) {
        // ignore: invalid_use_of_protected_member
        loginScreenState.setState(() {
          loginScreenState.showLoader = false;
        });
      }
      SnackbarMessages.showErrorSnackbar(context,
          error: Constants.errorValidatingOtp);
    }
  }

  Future loginWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required bool mounted,
    required String password,
    required LoginOptionsState loginOptionsState,
  }) async {
    try {
      final UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        try {
          await firebaseDatabase
              .ref("verified_users/${credential.user!.uid}/isVerified")
              .get()
              .then((value) async {
            if (value.value != null && value.value == true) {
              await updateAuthStateWithUserCredential(
                context: context,
                loginScreenState: loginOptionsState,
                mounted: mounted,
                appType: "App",
                value: credential,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AccountVerificationPage(
                      userCreatedEmail: credential.user!.email!,
                      userName: credential.user!.displayName!,
                      userUID: credential.user!.uid,
                    ),
                  ),
                  (route) => false);
            }
          });
        } on FirebaseAuthException catch (e) {
          print(e);
        } catch (e) {
          print(e);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        await userActiveStatus(context);
      }

      if (e.code == 'weak-password') {
        loginOptionsState.setState(() {
          loginOptionsState.showLoader = false;
        });

        SnackbarMessages.showErrorSnackbar(context, error: e.code);
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        loginOptionsState.setState(() {
          loginOptionsState.showLoader = false;
        });
        SnackbarMessages.showErrorSnackbar(context, error: e.code);
        print('The account already exists for that email.');
      } else {
        loginOptionsState.setState(() {
          loginOptionsState.showLoader = false;
        });
        SnackbarMessages.showErrorSnackbar(context, error: e.code);
      }
    } catch (e) {
      loginOptionsState.setState(() {
        loginOptionsState.showLoader = false;
      });
      SnackbarMessages.showErrorSnackbar(context, error: e.toString());
      print(e);
    }

    /*try {
      final UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        return null;
      }

      try {
        debugPrint(credential.user.toString());

        await firebaseDatabase
            .ref("verified_users/${credential.user!.uid}/isVerified")
            .get()

        */ /*await updateAuthStateWithUserCredential(
          context: context,
          loginScreenState: loginOptionsState,
          mounted: mounted,
          appType: "App",
          value: credential,
        );*/ /*
      } catch (e) {
        debugPrint(e.toString());
      }
*/ /*
      var response = await Dio().post(
        "https://learn.iprep.in/api/custom-login",
        data: {
          "userLoginType": "email",
          "email": "dudevarun7777@gmail.com",
          "password": "Varun@123",
          "authenticationType": 'email',
        },
      );
      if (response.statusCode == 200) {}*/ /*
    } catch (e) {
      debugPrint(e.toString());
    }*/
  }

  Future<dynamic> registerWithEmailAndPassword({
    required SignUpPageState? signUpPageState,
    required bool mounted,
    required BuildContext context,
    required String email,
    required String password,
    required String userLoginType,
    required String userName,
  }) async {
    try {
      final response = await Dio().post(
        "https://learn.iprep.in/api/custom-registration",
        data: {
          "userLoginType": userLoginType,
          "email": email,
          "password": password,
          "authenticationType": 'email',
          "full_name": userName,
        },
      );
      if (response.statusCode == 200) {
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      // debugPrint(e.response.statusMessage.toString());

      signUpPageState!.setState(() {
        signUpPageState.showLoader = false;
        signUpPageState.colorIndex = 0;
        emailController.clear();
        nameController.clear();
        passwordController.clear();
      });

      SnackbarMessages.showErrorSnackbar(
        context,
        error: Constants.emailAlreadyExist,
      );

      return e;
    }
  }

  Future<dynamic> verifyEmail({
    required BuildContext context,
    required AccountVerificationPageState? accountVerificationPageState,
    required String verifyAEmail,
    required String userName,
    required String uid,
  }) async {
    try {
      final response = await Dio().post(
        "https://learn.iprep.in/api/send-verification-otp",
        data: {
          "requestType": "email",
          "email": verifyAEmail,
          "name": userName,
          "uid": uid,
        },
      );
      if (response.statusCode == 200) {
        accountVerificationPageState!.setState(() {
          accountVerificationPageState.showLoader = false;
        });
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      accountVerificationPageState!.setState(() {
        accountVerificationPageState.showLoader = false;
      });
      return e;
    }
  }

  Future<dynamic> verifyEmailOTP({
    required String actualUserEmail,
    required AccountOTPVerificationPageState? accountOTPVerificationPageState,
    required BuildContext context,
    required String verifyAEmail,
    required String userName,
    required String uid,
    required String otp,
  }) async {
    try {
      final response = await Dio().post(
        "https://learn.iprep.in/api/custom-verification",
        data: {
          "requestType": "email",
          "vemail": actualUserEmail,
          "email": verifyAEmail,
          "name": userName,
          "otp": otp,
          "uid": uid,
        },
      );
      if (response.statusCode == 200) {
        return response;
      }
    } catch (e) {
      accountOTPVerificationPageState!.setState(() {
        accountOTPVerificationPageState.showLoader = false;
      });
      SnackbarMessages.showErrorSnackbar(context, error: Constants.invalidOtp);
      debugPrint(e.toString());
      // debugPrint(e.response.data['msg'].toString());
    }
  }

  Future verifyByPhone({
    required AccountVerificationPageState? accountVerificationPageState,
    required String mobileNumber,
    required BuildContext context,
    required String uid,
    required String createdEmail,
    required String userName,
  }) async {
    try {
      String? phoneVerificationId;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$mobileNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          accountVerificationPageState!.setState(() {
            accountVerificationPageState.showLoader = false;
          });

          SnackbarMessages.showErrorSnackbar(
            context,
            error: Constants.incorrectMobileNumber,
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          if (verificationId.isNotEmpty) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AccountOTPVerificationPage(
                  verificationId: verificationId,
                  userUseCase: "mobile",
                  actualUserPhone: "+91$mobileNumber",
                  createdEmail: createdEmail,
                  userName: userName,
                  uid: uid,
                ),
              ),
            );
            accountVerificationPageState!.setState(() {
              accountVerificationPageState.showLoader = false;
            });
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return phoneVerificationId;
    } catch (e) {
      debugPrint(e.toString());
      return e;
    }
  }

  Future<UserCredential?> verifyPhoneOtp({
    required BuildContext context,
    required String verificationId,
    required AccountOTPVerificationPageState? accountOTPVerificationPageState,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      debugPrint(credential.toString());
      return FirebaseAuth.instance
          .signInWithCredential(credential)
          .catchError((e) {
        SnackbarMessages.showErrorSnackbar(context, error: e.code);
        accountOTPVerificationPageState!.setState(() {
          accountOTPVerificationPageState.showLoader = false;
        });
        debugPrint(e.toString());
      });
      // return FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool> googleSignIn({
    required BuildContext context,
    required bool mounted,
  }) async {
    // try {
    //   final GoogleSignIn googleSignIn = GoogleSignIn(
    //     scopes: [
    //       'profile',
    //       'email',
    //     ],
    //   );
    //   await googleSignIn.signIn();
    //   return true;
    // } on FirebaseAuthException catch (e) {
    //   print('Failed with error code: ${e.code}');
    //   print(e.message);
    //   return false;
    // } catch (e) {
    //   print('Failed with error code: $e');
    //   return false;
    // }

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'profile',
          'email',
        ],
      );
      googleSignIn.signOut();
      final GoogleSignInAccount? profile = await googleSignIn.signIn();

      if (profile != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await profile.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

        await handlingLoginResponse(
          context,
          credential,
          mounted: mounted,
          appType: "Google",
        );
      } else {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      SnackbarMessages.showErrorSnackbar(context,
          error: Constants.googleLoginError);
      return false;
    }
  }

  Future<bool> appleSignIn({
    required BuildContext context,
    required bool mounted,
  }) async {
    try {
      String generateNonce([int length = 32]) {
        const charset =
            '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
        final random = Random.secure();
        return List.generate(
            length, (_) => charset[random.nextInt(charset.length)]).join();
      }

      /// Returns the sha256 hash of [input] in hex notation.
      String sha256ofString(String input) {
        final bytes = utf8.encode(input);
        final digest = sha256.convert(bytes);
        return digest.toString();
      }

      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      if (appleCredential.givenName == null &&
          appleCredential.familyName == null) {
        appleUserName = "";
      } else {
        appleUserName =
            "${appleCredential.givenName!} ${appleCredential.familyName!}";
      }
      debugPrint(appleUserName);
      // Create an `OAuthCredential` from the credential returned by Apple.
      AuthCredential oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      await handlingLoginResponse(context, oauthCredential,
          appType: "Apple", mounted: mounted);
      return true;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  Future triggerPostLoginInfoForNewUser(
      {BuildContext? context, required value, String appType = "App"}) async {
    //Saving user data captured after successfulLogin locally and on Firebase
    //Save all the available data for now, considering user is using the app for the first time.

    //userType, token, mobile, language, fullName, UsersPlans
    await userRepository.savePostLoginUserInfo(value, appType,
        appleUserName: appleUserName);

    //TODO: After this Use different function for teacher.

    //Save referralCode
    ///Creating a unique 6 digit's alphanumeric code
    ///Saving it to DB at 4 different firebase locations
    ///1. ReferealCode in CenterDatabase
    ///2. Referral Code as per the user
    ///3. Referral Reverse(save userID as per the Referral code)
    ///4. Saving UserPlans in Referral Node
    var response = await userRepository.saveReferralCode();
    debugPrint(response);
    //Sending Successful sign up notification
    var response1 = await userRepository.sendSuccessfulSignUpNotification();
    debugPrint(response1);
    // redirect it to the next on-boarding screen
    //TODO: Here we are changing the Flow...
    String? _userType = await getStringValuesSF("UserType");
    String? language = await getStringValuesSF("language");

    selectedAppLanguage = language;
    if (_userType == "Student") {
      await Navigator.pushAndRemoveUntil(
        context!,
        CupertinoPageRoute(
          builder: (context) => BoardSelectionScreen(
            language: selectedAppLanguage.toString(),
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      String? _userFullName = await getStringValuesSF("fullName");
      String? _email = await getStringValuesSF("email");
      await Navigator.pushAndRemoveUntil(
        context!,
        CupertinoPageRoute(
          builder: (context) => NameEnterCoachScreen(
            email: _email == 'null' ? '' : _email,
            userFullName: _userFullName == 'null' ? '' : _userFullName,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }
}

Future languageSellection({required context}) async {
  await Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (context) => const AppLevelLanguageSelectionScreen(),
    ),
  );
}

// Auto user selection use is a coach or student
Future checkUserType({userID, context}) async {
  var student = Constants.studentUserDetailsUrl;
  var teacher = Constants.teacherUserDetailsUrl;
  var stu = 'Student';
  var tea = "Coach";

  List<String> userType = [student, teacher];
  List<String> userIs = [stu, tea];

  try {
    for (int i = 0; i < 2; i++) {
      var response =
          await apiHandler.getAPICall(endPointURL: userType[i] + userID);
      debugPrint("----------$response==========");
      if (response != null &&
          response["full_name"] != null &&
          response["language"] != null) {
        await userRepository.saveUserDetailToLocal("UserType", userIs[i]);
        await userRepository.saveUserDetailToLocal(
            "language", response['language']);
        String? language = await getStringValuesSF("language");
        String? isUserType = await getStringValuesSF("UserType");
        debugPrint("$language user language check ");
        debugPrint("$isUserType user type check ");
        break;
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  String? language = await getStringValuesSF("language");
  String? isUserType = await getStringValuesSF("UserType");

  if (isUserType == null || language == null) {
    await languageSellection(context: context);
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => UserTypeSelectionScreen(
          appLevelLanguage: language,
        ),
      ),
    );
  }
}

Future<String> checkUserType1({userID, context}) async {
  var student = Constants.studentUserDetailsUrl;
  var teacher = Constants.teacherUserDetailsUrl;

  final String userType;
  final String languges;

  try {
    final response = await Future.wait([
      apiHandler.getAPICall(endPointURL: student),
      apiHandler.getAPICall(endPointURL: teacher)
    ]);

    if (response[0] != null) {
      userType = "students";
    } else if (response[0] != null) {
      userType = "teachers";
    } else {
      userType = null!;
    }
    return userType;
  } catch (e) {
    debugPrint(e.toString());
    return null!;
  }

  String? language = await getStringValuesSF("language");
  String? isUserType = await getStringValuesSF("UserType");

  if (isUserType == null || language == null) {
    await languageSellection(context: context);
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => UserTypeSelectionScreen(
          appLevelLanguage: language,
        ),
      ),
    );
  }
}
