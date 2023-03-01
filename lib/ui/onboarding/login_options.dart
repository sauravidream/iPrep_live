import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idream/ui/onboarding/login_screen.dart';
import 'package:idream/ui/onboarding/sign_up/sign_up_page.dart';
import '../../common/constants.dart';
import '../../common/global_variables.dart';
import '../../common/references.dart';
import '../../common/shared_preference.dart';
import '../../common/snackbar_messages.dart';
import '../../custom_widgets/auth_provider_widget.dart';
import '../../custom_widgets/input_text_field.dart';
import '../../custom_widgets/loader.dart';
import '../../custom_widgets/loading_widget.dart';
import '../../custom_widgets/onboarding_bottom_button.dart';

class LoginOptions extends StatefulWidget {
  const LoginOptions({Key? key}) : super(key: key);
  static const id = 'login_select_lang';
  @override
  State<LoginOptions> createState() => LoginOptionsState();
}

class LoginOptionsState extends State<LoginOptions> {
  bool checkBoxValue = false;
  bool showLoader = false;
  bool obscureText = true;
  LoginOptionsState? loginOptionsState;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    selectedAppLanguage = "english";
    addLanguage();
    super.initState();
  }

  addLanguage() async {
    await addStringToSF("language", selectedAppLanguage!.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    loginOptionsState = this;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: showLoader
              ? const LoadingWidget()
              : Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                if (selectedAppLanguage == 'hindi') {
                                  selectedAppLanguage = 'english';
                                } else if (selectedAppLanguage == 'english') {
                                  selectedAppLanguage = 'hindi';
                                }
                              });
                              await addStringToSF("language",
                                  selectedAppLanguage!.toLowerCase());
                              debugPrint(await getStringValuesSF("language"));
                            },
                            child: Container(
                              alignment: Alignment.bottomRight,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFF0077FF)),
                                  color: const Color(0xFFF2F7FF),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/language_icon.png',
                                    height: 24,
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    (selectedAppLanguage!.toLowerCase() !=
                                            "english")
                                        ? "Change the\n language to English "
                                        : "भाषा को हिंदी में बदलें",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF0077FF),
                                      fontSize: 12,
                                      fontWeight: FontWeight.values[5],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 80,
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          selectedAppLanguage == 'english'
                              ? "Please enter your details"
                              : "कृपया अपनी जानकारी दर्ज़ कीजिए।",
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF000C1A),
                            fontWeight: FontWeight.values[5],
                          ),
                        ),
                      ),
                      Container(
                        height: 46,
                        alignment: Alignment.bottomCenter,
                        child: Text(selectedAppLanguage == 'english'
                            ? "Sign in"
                            : "साइन इन करें"),
                      ),
                      const SizedBox(
                        height: 10.5,
                      ),
                      AuthProviderWidget(
                        titleText: selectedAppLanguage == 'english'
                            ? "Continue with Google"
                            : "Google से शुरू करें",
                        imagePath: "google.svg",
                        onTap: () async {
                          setState(() {
                            showLoader = true;
                          });
                          await loginRepository
                              .googleSignIn(
                            mounted: mounted,
                            context: context,
                          )
                              .then((value) {
                            if (value != true) {
                              setState(() {
                                showLoader = false;
                              });
                            }
                          });
                        },

                        /*onTap: () async {
                          await showDialog<void>(
                            context: context,
                            barrierDismissible: true,
                            useSafeArea: true,
                            // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                insetPadding:
                                    const EdgeInsets.symmetric(horizontal: 17),
                                backgroundColor: const Color(0xFFFFFFFF),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                alignment: Alignment.center,
                                titleTextStyle:
                                    Constants.noDataTextStyle.copyWith(
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF565657),
                                ),
                                title: const Loader(),
                                content: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 31),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Access Denied",
                                            style: Constants.noDataTextStyle
                                                .copyWith(
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
                                            style: Constants.noDataTextStyle
                                                .copyWith(
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
                                              foregroundColor:
                                                  const Color(0xFFF1F5F9),
                                              backgroundColor:
                                                  const Color(0xFFF1F5F9),
                                              minimumSize: const Size(185, 45),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                            ),
                                            child: Text(
                                              "Okay",
                                              style: TextStyle(
                                                color: const Color(0xFF212121),
                                                fontWeight:
                                                    FontWeight.values[5],
                                                fontSize: 14,
                                              ),
                                            ),
                                            onPressed: () async {
                                              await Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const LoginOptions(),
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
                        },*/
                      ),
                      Platform.isIOS
                          ? AuthProviderWidget(
                              titleText: selectedAppLanguage == 'english'
                                  ? "Continue with Apple"
                                  : "Apple से शुरू करें",
                              imagePath: "apple.svg",
                              onTap: () async {
                                setState(() {
                                  showLoader = true;
                                });

                                await loginRepository
                                    .appleSignIn(
                                        mounted: mounted, context: context)
                                    .then((value) {
                                  if (value != true) {
                                    setState(() {
                                      showLoader = false;
                                    });
                                  }
                                });
                              },
                            )
                          : const SizedBox(),
                      AuthProviderWidget(
                        titleText: selectedAppLanguage == 'english'
                            ? "Continue with Phone"
                            : "फ़ोन से शुरू करे",
                        imagePath: "phone.svg",
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (context) => const LoginScreen(),
                          //   ),
                          // );
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                      ),
                      Container(
                        height: 34.85,
                        alignment: Alignment.bottomCenter,
                        child: Text(
                            selectedAppLanguage == 'english' ? "Or" : "या"),
                      ),
                      TextFieldWidget(
                        keyboardType: TextInputType.emailAddress,
                        textEditingController: _emailController,
                        hintText: selectedAppLanguage == 'english'
                            ? "User name"
                            : "यूज़रनेम",
                        onChanged: (va) {},
                      ),
                      TextFieldWidget(
                        keyboardType: TextInputType.visiblePassword,
                        inputSuffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined),
                        ),
                        obscureText: obscureText,
                        textEditingController: _passwordController,
                        hintText: selectedAppLanguage == 'english'
                            ? "Password"
                            : "पासवर्ड ",
                      ),
                      OnBoardingBottomButton(
                        topPadding: 30,
                        buttonColor: 0xFF0070FF,
                        buttonText: selectedAppLanguage == 'english'
                            ? "Sign in"
                            : "साइन इन करें",
                        onPressed: () async {
                          setState(() {
                            showLoader = true;
                          });

                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            if (!_emailController.text.contains("@")) {
                              emailController.text =
                                  "${emailController.text}@iprep.org";
                              _emailController.text =
                                  "${_emailController.text}@iprep.org";
                            }

                            await loginRepository.loginWithEmailAndPassword(
                              mounted: mounted,
                              context: context,
                              email: _emailController.text,
                              password: _passwordController.text,
                              loginOptionsState: loginOptionsState!,
                            );
                          } else {
                            emailController.clear();
                            setState(() {
                              showLoader = false;
                            });
                            SnackbarMessages.showErrorSnackbar(context,
                                error: Constants.email);
                          }
                          _emailController.clear();
                          _passwordController.clear();
                        },
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: selectedAppLanguage == 'english'
                                ? 'Don’t have an account?  '
                                : "अकाउंट नहीं है? अभी ",
                            style: const TextStyle(
                              color: Color(0xFF000000),
                            ),
                            children: [
                              TextSpan(
                                text: selectedAppLanguage == 'english'
                                    ? 'Sign up'
                                    : "साइनअप ",
                                style: const TextStyle(
                                  color: Color(
                                    0xFF0070FF,
                                  ),
                                ),
                              ),
                              TextSpan(
                                  text: selectedAppLanguage == 'english'
                                      ? ' now!'
                                      : "करें"),
                            ],
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
}
