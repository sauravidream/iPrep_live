import 'package:flutter/material.dart';
import '../../../common/constants.dart';
import '../../../common/global_variables.dart';
import '../../../common/references.dart';
import '../../../common/shared_preference.dart';
import '../../../common/snackbar_messages.dart';
import '../../../custom_widgets/input_text_field.dart';
import '../../../custom_widgets/loading_widget.dart';
import '../../../custom_widgets/onboarding_bottom_button.dart';
import 'account_otp_verification_page.dart';
import 'account_verification_page.dart';
import 'package:flutter/cupertino.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const id = "sign_up_page";
  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  SignUpPageState? signUpPageState;

  void onTap() async {
    if (passwordController.text.isNotEmpty &&
        passValid == true &&
        useUserName == true) {
      if (emailController.text.length >= 6) {
        if (emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty &&
            passwordController.text.isNotEmpty) {
          setState(() {
            showLoader = true;
          });
          await loginRepository
              .registerWithEmailAndPassword(
            userName: nameController.text,
            signUpPageState: signUpPageState,
            mounted: mounted,
            context: context,
            email: emailController.text,
            password: passwordController.text,
            userLoginType:
                emailController.text.contains("@") ? "email" : "username",
          )
              .then((value) async {
            debugPrint(value.toString());
            if (value.statusCode == 200) {
              await addStringToSF("fullName", nameController.text);

              await getStringValuesSF("fullName").then((value) {
                debugPrint(value);
              });
              await addStringToSF("email", value.data["user"]['email']);

              usernameForLogin.text = value.data["user"]['email'];
              passwordForLogin.text = passwordController.text;
              if (!emailController.text.contains("@")) {
                if (!mounted) return;
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AccountVerificationPage(
                      userCreatedEmail: value.data["user"]['email'],
                      userName: nameController.text,
                      userUID: value.data["user"]['uid'],
                    ),
                  ),
                ).then((value) {
                  passwordController.clear();
                  emailController.clear();
                  usernameForLogin.clear();
                  setState(() {
                    colorIndex = 0;
                  });
                  debugPrint("pass clear");
                });
                setState(() {
                  showLoader = false;
                });
              } else {
                if (!mounted) return;
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AccountOTPVerificationPage(
                      userUseCase: "email",
                      actualUserEmail: emailController.text,
                      createdEmail: value.data["user"]['email'],
                      userName: nameController.text,
                      uid: value.data["user"]['uid'],
                    ),
                  ),
                );
              }
            } else if (value.statusCode == 400) {
              SnackbarMessages.showErrorSnackbar(
                context,
                error: Constants.emailAlreadyExist,
              );
              emailController.clear();
              nameController.clear();
              passwordController.clear();
              setState(() {
                colorIndex = 0;
              });
              setState(() {
                colorIndex = 0;
                showLoader = false;
              });
            } else {
              SnackbarMessages.showErrorSnackbar(
                context,
                error: Constants.somethingWentWong,
              );
              emailController.clear();
              nameController.clear();
              passwordController.clear();
              setState(() {
                showLoader = false;
              });
            }
          });
        } else {
          setState(() {
            showLoader = false;
          });
          SnackbarMessages.showErrorSnackbar(
            context,
            error: Constants.allField,
          );
        }
      } else {
        setState(() {
          showLoader = false;
        });
        SnackbarMessages.showErrorSnackbar(
          context,
          error: Constants.emailSi,
        );
      }
    } else {
      if (useUserName == false) {
        SnackbarMessages.showErrorSnackbar(
          context,
          error: Constants.emailSi,
        );
      } else if (passValid == false) {
        SnackbarMessages.showErrorSnackbar(
          context,
          error: Constants.passWord,
        );
      } else {
        SnackbarMessages.showErrorSnackbar(
          context,
          error: Constants.allField,
        );
      }
    }
  }

  bool showLoader = false;
  bool passValid = false;
  bool passSeg = false;
  bool emailSeg = false;
  bool useUserName = false;
  int colorIndex = 0;
  bool obscureText = true;
  late String _password;
  List colorList = const [
    Color(0xFFDEDEDE),
    Color(0xFFFFF176),
    Color(0xFFFFF9C4),
    Color(0xFF90CAF9),
    Color(0xFFC8E6C9),
    Color(0xFFEF9A9A),
  ];

  @override
  void initState() {
    controllerDataClear();

    super.initState();
  }

  controllerDataClear() {
    if (nameController.text.isNotEmpty) {
      nameController.text = "";
    }
    if (emailController.text.isNotEmpty) {
      emailController.text = "";
    }
    if (passwordController.text.isNotEmpty) {
      passwordController.text = "";
    }
  }

  //“^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)” + “(?=.*[-+_!@#$%^&*., ?]).+$”

  RegExp numReg =
      RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])");
  RegExp specialCharacters =
      RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[-+_!@#$%^&*., ?])");
  RegExp sLetterReg = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])");
  RegExp cLetterReg = RegExp(r"^(?=.*[A-Z])");
  RegExp passwordReg =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  String _displayText = 'Please enter a password';

  void _checkPassword(String value) {
    _password = value.trim();
    setState(() {
      colorIndex = 0;
    });
    if (!cLetterReg.hasMatch(_password)) {
      setState(() {
        colorIndex = 5;
      });
      setState(() {
        _displayText = "Password must contain at least one uppercase character";
      });
    } else {
      if (!sLetterReg.hasMatch(_password)) {
        setState(() {
          colorIndex = 1;
        });
        setState(() {
          _displayText =
              "Password must contain at least one lowercase character";
        });
      } else {
        if (!specialCharacters.hasMatch(_password)) {
          setState(() {
            colorIndex = 2;
          });
          setState(() {
            _displayText =
                "Password must contain at least one special character";
          });
        } else {
          if (!numReg.hasMatch(_password)) {
            setState(() {
              colorIndex = 2;
            });
            setState(() {
              _displayText =
                  "Password must contain at least one numeric character";
            });
          } else {
            if (passwordReg.hasMatch(_password)) {
              setState(() {
                _displayText = "Strong Password";
                colorIndex = 4;
              });
            } else {
              setState(() {
                colorIndex = 3;
              });
              setState(() {
                _displayText = "Password must be at least 8 characters long";
              });
            }
          }
        }
      }
    }
  }

  Widget passWordHint({Size? size}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 5,
          width: size!.width * .14,
          color: colorList[colorIndex],
        ),
        Container(
          height: 5,
          width: size.width * .14,
          color: colorIndex == 2
              ? colorList[colorIndex]
              : colorIndex == 3
                  ? colorList[colorIndex]
                  : colorIndex == 4
                      ? colorList[colorIndex]
                      : colorList[0],
        ),
        Container(
            height: 5,
            width: size.width * .14,
            color: colorIndex == 3
                ? colorList[colorIndex]
                : colorIndex == 4
                    ? colorList[colorIndex]
                    : colorList[0]),
        Container(
            height: 5,
            width: size.width * .14,
            color: colorIndex == 4 ? colorList[colorIndex] : colorList[0]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    signUpPageState = this;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "assets/images/back_icon.png",
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: showLoader
          ? const LoadingWidget()
          : GestureDetector(
              onTap: () {
                setState(() {
                  passSeg = false;
                  emailSeg = false;
                });
              },
              child: SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.34, horizontal: 0.0),
                      child: Column(
                        children: [
                          Container(
                            height: 22,
                            alignment: Alignment.topLeft,
                            child: Text(
                              selectedAppLanguage == 'english'
                                  ? "Sign Up"
                                  : "साइन अप",
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xFF424242),
                                fontWeight: FontWeight.values[5],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8.28,
                          ),
                          Container(
                            height: 20,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              selectedAppLanguage == 'english'
                                  ? "Enter the below details to sign up"
                                  : "साइन उप करने के लिए अपना विवरण दर्ज करेंं।",
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF424242),
                                fontWeight: FontWeight.values[2],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.39,
                          ),
                          TextFieldWidget(
                            keyboardType: TextInputType.name,
                            labelText: selectedAppLanguage == 'english'
                                ? "Your name"
                                : "आपका नाम",
                            hintText: selectedAppLanguage == 'english'
                                ? "Enter Your Name"
                                : "अपना नाम दर्ज करें",
                            onChanged: (value) {
                              nameController.text = value;
                            },
                          ),
                          const SizedBox(
                            height: 12.13,
                          ),
                          Stack(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 22.35,
                                  ),
                                  TextFieldWidget(
                                    validator: (value) {
                                      final validCharacters =
                                          RegExp(r'^[a-zA-Z0-9]+$');
                                      const emailRegex =
                                          r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

                                      if (validCharacters.hasMatch(value!) &&
                                          value.length <= 20 &&
                                          value.length >= 6) {
                                        emailController.text = value;
                                        useUserName = true;
                                        return null;
                                      } else if (RegExp(emailRegex)
                                          .hasMatch(value)) {
                                        emailController.text = value;
                                        useUserName = true;
                                        return null;
                                      } else {
                                        useUserName = false;
                                        return "Invalid email or username";
                                      }
                                    },
                                    // textEditingController: emailController,
                                    keyboardType: TextInputType.text,

                                    onChanged: (value) {
                                      setState(() {
                                        emailSeg = false;
                                        passSeg = false;
                                      });
                                    },

                                    info: true,
                                    labelText: selectedAppLanguage == 'english'
                                        ? "Username"
                                        : "यूज़रनेम",
                                    hintText: selectedAppLanguage == 'english'
                                        ? "Enter a User Name or Your Email ID"
                                        : "यूज़रनेम या अपनी ईमेल आईडी दर्ज करें",
                                    onTap: () {
                                      setState(() {
                                        emailSeg = !emailSeg;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              emailSeg ? userNameInfo() : const SizedBox(),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 35,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              selectedAppLanguage == 'english'
                                  ? "*You can also use your roll number as your user name"
                                  : "*आप यूज़रनेम के रूप में अपने रोल नंबर का उपयोग भी कर सकते हैं।",
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF666666),
                                fontWeight: FontWeight.values[2],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12.13,
                          ),
                          Stack(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 22.35,
                                  ),
                                  TextFieldWidget(
                                    textEditingController: passwordController,
                                    inputSuffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscureText = !obscureText;
                                        });
                                      },
                                      icon: const Icon(
                                          Icons.remove_red_eye_outlined),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: obscureText,
                                    info: true,
                                    labelText: selectedAppLanguage == 'english'
                                        ? "Password"
                                        : "पासवर्ड",
                                    hintText: selectedAppLanguage == 'english'
                                        ? "Enter password"
                                        : "पासवर्ड डालें",
                                    onChanged: _checkPassword,
                                    onTap: () {
                                      setState(() {
                                        passSeg = !passSeg;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              passSeg ? passwordInfo() : const SizedBox(),
                            ],
                          ),
                          const SizedBox(
                            height: 12.13,
                          ),
                          TextFieldWidget(
                            inputSuffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: const Icon(Icons.remove_red_eye_outlined),
                            ),
                            validator: (value) {
                              if (value == passwordController.text) {
                                return null;
                              } else {
                                return "Invalid password";
                              }
                            },
                            obscureText: obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            info: true,
                            labelText: selectedAppLanguage == 'english'
                                ? "Confirm Password"
                                : "पासवर्ड की पुष्टि कीजिये",
                            hintText: selectedAppLanguage == 'english'
                                ? "Enter confirm password"
                                : "पासवर्ड की पुष्टि दर्ज करेंं",
                            onChanged: (value) {
                              setState(() {
                                passValid = false;
                                colorIndex = 0;
                              });
                              const phoneRegex =
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                              conformPasswordController.text = value;
                              if (RegExp(phoneRegex).hasMatch(value) &&
                                  passwordController.text == value) {
                                setState(() {
                                  passValid = true;
                                  colorIndex = 4;
                                });
                              }
                            },
                            onTap: () {
                              setState(() {
                                passSeg = !passSeg;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          passWordHint(size: size),
                          const SizedBox(
                            height: 17,
                          ),
                          Container(
                            width: size.width,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: colorList[colorIndex]),
                                borderRadius: BorderRadius.circular(10),
                                color: colorList[colorIndex]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Password Tip",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF666666),
                                    fontWeight: FontWeight.values[5],
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                passwordController.text == ""
                                    ? Text(
                                        selectedAppLanguage == 'english'
                                            ? "Your Password must contain at least one uppercase character, One Special character, Lower case character."
                                            : "आपके पासवर्ड में कम से कम एक अपरकेस अक्षर, एक विशेष अक्षर और एक लोएरकेस अक्षर होना चाहिए। पासवर्ड कम से कम 8 अक्षर का होना चाहिए।",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: const Color(0xFF575757),
                                          fontWeight: FontWeight.values[2],
                                        ),
                                      )
                                    : Text(
                                        _displayText,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: const Color(0xFF575757),
                                          fontWeight: FontWeight.values[2],
                                        ),
                                      )
                              ],
                            ),
                          ),
                          OnBoardingBottomButton(
                            buttonColor: 0xFF0070FF,
                            buttonText: selectedAppLanguage == 'english'
                                ? "Sign Up"
                                : "साइनअप करें",
                            onPressed: onTap,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

Widget userNameInfo() {
  return Positioned(
    left: 85,
    top: 0,
    child: GestureDetector(
      onTap: () {},
      child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFfafafa),
            // color: Color(0xFF000000),
          ),
          child: selectedAppLanguage == 'english'
              ? RichText(
                  textAlign: TextAlign.start,
                  text: const TextSpan(
                    text: 'Your user name can be ',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter"),
                    children: [
                      TextSpan(
                        text: 'Alphanumeric between 6-20 characters ',
                        style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Inter"),
                      ),
                      TextSpan(
                        text: 'You can also use your ',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter"),
                      ),
                      TextSpan(
                        text: 'email address as username. ',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Inter"),
                      ),
                    ],
                  ),
                )
              : const Text(
                  "आपका username 6-20 अक्षर का हो सकता है। आप अपने ईमेल का उपयोग username के रूप में भी कर सकते हैं।")),
    ),
  );
}

Widget passwordInfo() {
  return Positioned(
    left: 85,
    top: 0,
    child: GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFfafafa),
          // color: Color(0xFF000000),
        ),

        //Your password must be minimum 6 digits and must contain an uppercase, a lowercase, a special character and a numeric digit.
        child: selectedAppLanguage == 'english'
            ? RichText(
                textAlign: TextAlign.start,
                text: const TextSpan(
                  text:
                      'Your password must be minimum 6 digits and must contain, ',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Inter"),
                  children: [
                    TextSpan(
                      text: ' an uppercase, a lowercase, ',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter"),
                    ),
                    TextSpan(
                      text: 'a special character and a numeric digit.',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter"),
                    ),
                  ],
                ),
              )
            : const Text(
                "आपका पासवर्ड कम से कम 6 अंकों का होना चाहिए और इसमें एक अपरकेस, एक लोअरकेस, एक विशेष अक्षर और एक अंक होना चाहिए।"),
      ),
    ),
  );
}
