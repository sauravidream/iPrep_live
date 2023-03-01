import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuthProviderWidget extends StatelessWidget {
  final String titleText;
  final String imagePath;
  final Function() onTap;
  const AuthProviderWidget(
      {Key? key,
      required this.titleText,
      required this.imagePath,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String assets = "assets/image";
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: const Color(0xFFF6F6F6),
      child: ListTile(
        selectedColor: const Color(0xFFF6F6F6),
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Text(
            titleText,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 13.2,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter"),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SvgPicture.asset(
            "$assets/$imagePath",
            height: 27.5,
            width: 27.5,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
