import 'dart:io';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final int? buttonColor;
  final String? buttonImage;
  final VoidCallback? onPressed;

  const LoginButton({this.buttonColor, this.buttonImage, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Image.asset(
        buttonImage!,
        height: 22,
      ),
      style: ElevatedButton.styleFrom(
        primary: Color(buttonColor!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        minimumSize: Size(
          Platform.isAndroid
              ? MediaQuery.of(context).size.width * 0.5
              : MediaQuery.of(context).size.width * 0.35,
          Platform.isAndroid ? 60 : 50,
        ),
      ),
      // textColor: Color(buttonColor),//212121//
      onPressed: onPressed,
    );
  }
}
