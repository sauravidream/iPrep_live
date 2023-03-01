import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idream/ui/onboarding/login_options.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:flutter/cupertino.dart';
import '../../../common/constants.dart';
import '../../../common/global_variables.dart';
import '../../../common/references.dart';
import '../../../common/shared_preference.dart';
import '../../../common/snackbar_messages.dart';
import '../../../custom_widgets/loading_widget.dart';
import '../../../custom_widgets/onboarding_bottom_button.dart';

class AccountOTPVerificationPage extends StatefulWidget {
  final String? verificationId;
  final String? userUseCase;
  final String? createdEmail;
  final String? actualUserEmail;
  final String? actualUserPhone;
  final String? uid;
  final String? userName;

  const AccountOTPVerificationPage({
    Key? key,
    this.verificationId,
    this.createdEmail,
    this.actualUserEmail,
    this.uid,
    this.userName,
    this.actualUserPhone,
    this.userUseCase,
  }) : super(key: key);

  static const id = "account_otp_verification_page";

  @override
  State<AccountOTPVerificationPage> createState() =>
      AccountOTPVerificationPageState();
}

class AccountOTPVerificationPageState
    extends State<AccountOTPVerificationPage> {
  AccountOTPVerificationPageState? accountOTPVerificationPageState;
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

  _onTap() {
    if (pinEditingController.text.length == 6 &&
        widget.userUseCase == "mobile") {
      setState(() {
        showLoader = true;
      });
      loginRepository
          .verifyPhoneOtp(
        context: context,
        accountOTPVerificationPageState: accountOTPVerificationPageState,
        smsCode: pinEditingController.text,
        verificationId: widget.verificationId!,
      )
          .then((value) async {
        if (value != null) {
          UserCredential? userCredential = value;

          ///mapped_users
          ////verified_users

          await firebaseDatabase
              .ref("mapped_users/${widget.actualUserPhone}/${widget.uid}")
              .update({
            "full_name": widget.userName,
            "userName": widget.createdEmail,
          });
          await firebaseDatabase.ref("verified_users/${widget.uid}").update({
            "isVerified": true,
          });

          await addStringToSF("mobileNumber", widget.actualUserPhone!);
          FirebaseAuth.instance
              .signInWithEmailAndPassword(
            email: usernameForLogin.text,
            password: passwordForLogin.text,
          )
              .then((value) async {
            await loginRepository.updateAuthStateWithUserCredential(
              context: context,
              mounted: mounted,
              appType: "App",
              value: value,
            );
          });

          // if (!mounted) return;
          /*  Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => const LoginOptions()),
              (route) => false);*/
        } else {
          setState(() {
            showLoader = false;
          });
          SnackbarMessages.showErrorSnackbar(context,
              error: Constants.invalidOtp);
        }
      });
    } else if (pinEditingController.text.length == 6 &&
        widget.userUseCase == "email") {
      setState(() {
        showLoader = true;
      });
      loginRepository
          .verifyEmailOTP(
        accountOTPVerificationPageState: accountOTPVerificationPageState,
        actualUserEmail: widget.actualUserEmail!,
        uid: widget.uid!,
        verifyAEmail: widget.createdEmail!,
        userName: widget.userName!,
        context: context,
        otp: pinEditingController.text,
      )
          .then((value) async {
        if (value.statusCode == 200) {
          setState(() {
            showLoader = true;
          });

          await addStringToSF("email", widget.actualUserEmail!);
          FirebaseAuth.instance
              .signInWithEmailAndPassword(
            email: usernameForLogin.text,
            password: passwordForLogin.text,
          )
              .then((value) async {
            await loginRepository.updateAuthStateWithUserCredential(
              context: context,
              mounted: mounted,
              appType: "App",
              value: value,
            );
          });
        } else {
          SnackbarMessages.showErrorSnackbar(context,
              error: Constants.invalidOtp);
          setState(() {
            showLoader = false;
          });
        }
      });
    }
  }

  @override
  void initState() {
    pinEditingController.clear();
    super.initState();
  }

  Future<bool> _onBackPressed() {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    accountOTPVerificationPageState = this;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => const LoginOptions()),
                (route) => false);
          },
          icon: Image.asset(
            "assets/images/back_icon.png",
          ),
        ),
        elevation: 0,
      ),
      body: showLoader
          ? const LoadingWidget()
          : WillPopScope(
              onWillPop: _onBackPressed,
              child: SingleChildScrollView(
                child: Container(
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
                      const SizedBox(
                        height: 139.36,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          selectedAppLanguage == 'english'
                              ? "Enter OTP"
                              : "OTP दर्ज करें",
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF000C1A),
                            fontWeight: FontWeight.values[5],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(bottom: 6),
                        child: selectedAppLanguage == 'english'
                            ? widget.userUseCase == "email"
                                ? Text(
                                    "Verification OTP has been sent\n to your ${widget.actualUserEmail}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF666666),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Inter"),
                                  )
                                : Text(
                                    "Verification OTP has been sent\n to your ${widget.actualUserPhone}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF666666),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Inter"),
                                  )
                            : widget.userUseCase == "email"
                                ? Text(
                                    "OTP, ${widget.actualUserEmail} पर भेजा गया है।",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF666666),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Inter"),
                                  )
                                : Text(
                                    "OTP, ${widget.actualUserPhone} पर भेजा गया है।",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF666666),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Inter"),
                                  ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 10,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 338,
                          minHeight: 55,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFDEDEDE)),
                        ),
                        child: PinInputTextField(
                          pinLength: 6,
                          controller: pinEditingController,
                          autofillHints: const [AutofillHints.oneTimeCode],
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
                          onSubmit: (pin) {},
                        ),
                      ),
                      const SizedBox(
                        height: 34.50,
                      ),
                      OnBoardingBottomButton(
                        topPadding: 10,
                        buttonColor: 0xFF0070FF,
                        buttonText: selectedAppLanguage == 'english'
                            ? "Sign in"
                            : "साइन इन करें",
                        onPressed: _onTap,
                      ),
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
                                return selectedAppLanguage == 'english'
                                    ? Text(
                                        'Resend OTP in 00:${snapshot.data} Seconds',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0077FF),
                                        ),
                                      )
                                    : Text(
                                        '00:${snapshot.data} सेकंड में OTP दोबारा भेजें ',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0077FF),
                                        ),
                                      );

                              case ConnectionState.done:
                                return GestureDetector(
                                  onTap: () {},
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: selectedAppLanguage == 'english'
                                          ? 'Don’t receive OTP? '
                                          : "OTP नहीं मिला ? ",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF666666),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Inter"),
                                      children: [
                                        TextSpan(
                                          text: selectedAppLanguage == 'english'
                                              ? 'Resend.'
                                              : " दोबारा भेजें",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(
                                                0xFF0070FF,
                                              ),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Inter"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                            }
                          },
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
