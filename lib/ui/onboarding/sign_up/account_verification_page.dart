import 'package:flutter/material.dart';
import 'package:idream/ui/onboarding/login_options.dart';
import '../../../common/constants.dart';
import '../../../common/global_variables.dart';
import '../../../common/references.dart';
import '../../../common/snackbar_messages.dart';
import '../../../custom_widgets/input_text_field.dart';
import '../../../custom_widgets/loading_widget.dart';
import '../../../custom_widgets/onboarding_bottom_button.dart';
import 'account_otp_verification_page.dart';
import 'package:flutter/cupertino.dart';

class AccountVerificationPage extends StatefulWidget {
  const AccountVerificationPage({
    Key? key,
    required this.userName,
    required this.userUID,
    required this.userCreatedEmail,
  }) : super(key: key);
  final String userName;
  final String userUID;
  final String userCreatedEmail;

  static const id = "account_verification_page";

  @override
  State<AccountVerificationPage> createState() =>
      AccountVerificationPageState();
}

class AccountVerificationPageState extends State<AccountVerificationPage> {
  AccountVerificationPageState? accountVerificationPageState;
  bool showLoader = false;
  bool enabledEmail = true;
  bool enabledPhone = true;

  @override
  void initState() {
    verifyPhone.text = '';
    verifyEmail.text = '';
    super.initState();
  }

  onTap() async {
    if (verifyEmail.text.isNotEmpty) {
      const emailRegex =
          r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
      if (RegExp(emailRegex).hasMatch(verifyEmail.text)) {
        setState(() {
          showLoader = true;
        });
        await loginRepository
            .verifyEmail(
          accountVerificationPageState: accountVerificationPageState,
          context: context,
          userName: widget.userName,
          verifyAEmail: verifyEmail.text,
          uid: widget.userUID,
        )
            .then((value) {
          debugPrint(value.toString());
          if (value.statusCode == 200) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AccountOTPVerificationPage(
                  userUseCase: "email",
                  actualUserEmail: verifyEmail.text,
                  createdEmail: widget.userCreatedEmail,
                  userName: widget.userName,
                  uid: widget.userUID,
                ),
              ),
            );
          } else {
            SnackbarMessages.showErrorSnackbar(context,
                error: Constants.googleLoginError);
          }
        });
      } else {
        SnackbarMessages.showErrorSnackbar(context,
            error: Constants.incorrectEmail);
      }
    } else if (verifyPhone.text.length == 10) {
      setState(() {
        showLoader = true;
      });

      await loginRepository.verifyByPhone(
        createdEmail: widget.userCreatedEmail,
        uid: widget.userUID,
        userName: widget.userName,
        accountVerificationPageState: accountVerificationPageState,
        context: context,
        mobileNumber: verifyPhone.text,
      );
    } else {
      setState(() {
        showLoader = false;
      });
      SnackbarMessages.showErrorSnackbar(
        context,
        error: Constants.verificationField,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    accountVerificationPageState = this;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => const LoginOptions(),
                ),
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
          : SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
                padding: const EdgeInsets.symmetric(
                    vertical: 12.34, horizontal: 0.0),
                child: Column(
                  children: [
                    Container(
                      height: 22,
                      alignment: Alignment.topLeft,
                      child: Text(
                        selectedAppLanguage == 'english'
                            ? "Verify Your Account"
                            : "अपने अकाउंट को सत्यापित करें",
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF000C1A),
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
                            ? "Enter the below details for Authentication"
                            : "प्रमाणीकरण के लिए नीचे विवरण दाखिल करें",
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF000C1A),
                          fontWeight: FontWeight.values[2],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.39,
                    ),
                    TextFieldWidget(
                      keyboardType: TextInputType.text,
                      enabled: enabledEmail,
                      textEditingController: verifyEmail,
                      labelText: selectedAppLanguage == 'english'
                          ? "Email Address"
                          : "ईमेल एड्रेस",
                      hintText: selectedAppLanguage == 'english'
                          ? "Enter Your Email ID"
                          : "अपनी ईमेल आईडी दर्ज करें",
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            enabledPhone = false;
                          });
                        } else {
                          setState(() {
                            enabledPhone = true;
                          });
                        }
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 75,
                      child:
                          Text(selectedAppLanguage == 'english' ? "Or" : "या"),
                    ),
                    TextFieldWidget(
                      inputFormatters: 10,
                      keyboardType: TextInputType.phone,
                      enabled: enabledPhone,
                      textEditingController: verifyPhone,
                      labelText: selectedAppLanguage == 'english'
                          ? "Phone number"
                          : "फ़ोन नंबर",
                      hintText: selectedAppLanguage == 'english'
                          ? "Enter Your Phone number"
                          : "अपनी फ़ोन नंबर दर्ज करे",
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            enabledEmail = false;
                          });
                        } else {
                          setState(() {
                            enabledEmail = true;
                          });
                        }
                      },
                    ),
                    OnBoardingBottomButton(
                        topPadding: 112,
                        buttonColor: 0xFF0070FF,
                        buttonText: selectedAppLanguage == 'english'
                            ? "Verify"
                            : "सत्यापित करें",
                        onPressed: onTap),
                  ],
                ),
              ),
            ),
    );
  }
}
