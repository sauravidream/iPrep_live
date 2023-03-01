import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/input_text_field.dart';

import '../../../custom_widgets/onboarding_bottom_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);
  static const id = "forgot_password_page";
  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
            padding:
                const EdgeInsets.symmetric(vertical: 12.34, horizontal: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Password Assistance",
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xFF424242),
                      fontWeight: FontWeight.values[8],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Enter the email associated with your account and we will send an email with instructions",
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF424242),
                      fontWeight: FontWeight.values[2],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 42,
                ),
                TextFieldWidget(
                  textEditingController: emailController,
                  labelText: "Username",
                  hintText: "Enter a User Name or Your Email ID",
                ),
                const SizedBox(
                  height: 52,
                ),
                OnBoardingBottomButton(
                  buttonColor: 0xFF0070FF,
                  buttonText: "Send Instructions",
                  onPressed: () {},
                ),
                SizedBox(
                  height: 150,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
