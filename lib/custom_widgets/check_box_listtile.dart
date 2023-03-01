import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({Key? key}) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: checkBoxValue
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF0070FF),
                border: Border.all(
                  color: checkBoxValue ? Colors.grey : const Color(0xFF0070FF),
                ),
                shape: BoxShape.rectangle,
              ),
              height: 30,
              width: 30,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 5,
              bottom: 0,
              child: IconButton(
                iconSize: 15,
                onPressed: () {
                  setState(() {
                    checkBoxValue = !checkBoxValue;
                  });
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        Text(
          "Remember me",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(
            0xFF0070FF,
          )),
        ),
      ],
    );
  }
}
