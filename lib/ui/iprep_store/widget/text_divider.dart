import 'package:flutter/material.dart';

class TextDivider extends StatefulWidget {
  const TextDivider({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  State<TextDivider> createState() => _TextDividerState();
}

class _TextDividerState extends State<TextDivider> {
  String? firstHalf;
  String? secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 50) {
      firstHalf = widget.text.substring(0, 50);
      secondHalf = widget.text.substring(50, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf!.isEmpty
          ? Text(firstHalf!)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  flag ? ("$firstHalf...") : (firstHalf! + secondHalf!),
                  style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF5C5C5C)),
                ),
                InkWell(
                  child: Text(
                    flag ? "more" : "less",
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0077FF)),
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
