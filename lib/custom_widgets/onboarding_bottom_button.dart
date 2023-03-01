import 'package:flutter/material.dart';

class OnBoardingBottomButton extends StatelessWidget {
  final String? buttonText;
  final VoidCallback? onPressed;
  final double topPadding;
  final int buttonColor;
  final Color? buttonTextColor;
  final int buttonTextFontWeight;

  const OnBoardingBottomButton({
    Key? key,
    this.buttonText,
    this.onPressed,
    this.topPadding = 40,
    this.buttonColor = 0xFF0077FF,
    this.buttonTextColor,
    this.buttonTextFontWeight = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(buttonColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            minimumSize: const Size(double.maxFinite, 60),
          ),
          onPressed: onPressed,
          child: Text(
            buttonText!,
            style: TextStyle(
              color:
                  buttonTextColor ?? const Color(0xFFFFFFFF),
              fontSize: 17,
              fontWeight: FontWeight.values[buttonTextFontWeight],
            ),
          ),
        ),
      ),
    );
  }
}
