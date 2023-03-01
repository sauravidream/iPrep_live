import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/repository/login_repository.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../../common/global_variables.dart';
import '../../custom_widgets/loading_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  late final TextEditingController _pinEditingController =
      TextEditingController();

  final LoginRepository _loginRepository = LoginRepository();
  LoginScreenState? _loginScreenState;
  bool otpScreen = false;
  String? mobileVerificationID;
  bool showLoader = false;

  Stream<int> _stream() {
    Duration interval = const Duration(seconds: 1);
    Stream<int> stream = Stream<int>.periodic(interval, transform);
    stream = stream.take(30);
    return stream;
  }

  int transform(int value) {
    return (30 - value);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loginScreenState = this;
    Size size = MediaQuery.of(context).size;
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 221,
                        width: 221,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/phone_otp.png",
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: otpScreen ? 13 : 0),
                        child: Text(
                          otpScreen ? "Enter OTP" : "",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF212121),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 139.36,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: selectedAppLanguage!.toLowerCase() == 'hindi'
                            ? Text(
                                otpScreen
                                    ? "सत्यापन ओटीपी भेजा गया +91${_mobileController.text}"
                                    : "अपना मोबाइल नंबर दर्ज करें",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF767676),
                                ),
                              )
                            : Text(
                                otpScreen
                                    ? "Verification OTP sent to +91${_mobileController.text}"
                                    : "Enter your mobile number",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF767676),
                                ),
                              ),
                      ),
                      otpScreen
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 120,
                                vertical: 10,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 338,
                                minHeight: 55,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(3),
                                border:
                                    Border.all(color: const Color(0xFFDEDEDE)),
                              ),
                              child: PinInputTextField(
                                pinLength: 6,
                                controller: _pinEditingController,
                                autofillHints: const [
                                  AutofillHints.oneTimeCode
                                ],
                                autoFocus: true,
                                textInputAction: TextInputAction.done,
                                autocorrect: true,
                                keyboardType: TextInputType.number,
                                enabled: true,
                                decoration: UnderlineDecoration(
                                  colorBuilder: PinListenColorBuilder(
                                    const Color(0xFF3399FF),
                                    const Color(0xFF3B3B3B),
                                  ),
                                ),
                                onSubmit: (pin) {
                                  _loginRepository.submitOtp(context, mounted,
                                      verificationCode: mobileVerificationID,
                                      enteredPin: _pinEditingController.text,
                                      loginScreenState: _loginScreenState);
                                },
                              ),
                            )
                          : TextFormField(
                              autocorrect: false,
                              textInputAction: TextInputAction.done,
                              controller: _mobileController,
                              autofocus: false,
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.black87,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: "00000 00000",
                                prefixText: "+91 - ",
                                focusedBorder: Constants.inputTextOutline,
                                enabledBorder: Constants.inputTextOutline,
                                border: Constants.inputTextOutline,
                              ),
                            ),
                      if (otpScreen)
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                            top: 12,
                          ),
                          child: StreamBuilder(
                            stream: _stream(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return const Text(
                                      'Not abe to establish connection');
                                case ConnectionState.waiting:
                                  return const Text(
                                    'Resend OTP in 00:30 Seconds',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0077FF),
                                    ),
                                  );
                                case ConnectionState.active:
                                  return Text(
                                    'Resend OTP in 00:${snapshot.data} Seconds',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0077FF),
                                    ),
                                  );
                                case ConnectionState.done:
                                  return GestureDetector(
                                    onTap: () async {
                                      await _loginRepository.registerUser(
                                          _mobileController.text,
                                          context,
                                          _loginScreenState!,
                                          mounted);
                                    },
                                    child: const Text(
                                      'Resend OTP',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0077FF),
                                      ),
                                    ),
                                  );
                              }
                            },
                          ),
                        ),
                      OnBoardingBottomButton(
                        buttonText: otpScreen
                            ? selectedAppLanguage!.toLowerCase() == 'hindi'
                                ? "अगला"
                                : "Next"
                            : selectedAppLanguage!.toLowerCase() == 'hindi'
                                ? "जारी रखना"
                                : "Continue",
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (!showLoader) {
                            try {
                              if (!otpScreen) {
                                setState(() {
                                  showLoader = true;
                                });
                                await _loginRepository.registerUser(
                                    _mobileController.text,
                                    context,
                                    _loginScreenState!,
                                    mounted);
                                // setState(() {
                                //   showLoader = false;
                                // });
                              } else {
                                setState(() {
                                  showLoader = true;
                                });
                                await _loginRepository.submitOtp(
                                  context,
                                  mounted,
                                  verificationCode: mobileVerificationID,
                                  enteredPin: _pinEditingController.text,
                                  loginScreenState: _loginScreenState,
                                );
                              }
                            } catch (e) {
                              setState(() {
                                showLoader = false;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
