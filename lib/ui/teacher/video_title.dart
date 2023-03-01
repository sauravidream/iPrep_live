import 'package:flutter/material.dart';

import 'package:idream/ui/Teacher/test_title.dart';

class VideoTitle extends StatefulWidget {
  @override
  _VideoTitleState createState() => _VideoTitleState();
}

class _VideoTitleState extends State<VideoTitle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Row(
                children: [
                  Image.asset(
                    "assets/images/back_icon.png",
                    height: 24,
                    width: 24,
                  ),
                ],
              ),
            );
          },
        ),
        titleSpacing: -15,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.center,
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                    color: Color(0xffD1E6FF),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Image.asset("assets/images/video_category.png")),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Video Title",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                      color: Color(0xff212121)),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Maths | Due: Thur, 7:40pm",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                      color: Color(0xff9E9E9E)),
                ),
              ],
            )
          ],
        ),
        centerTitle: false,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 10, bottom: 10),
              child: Image.asset('assets/images/3_dot.png',
                  height: 24, width: 24, color: Color(0xff212121)))
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Divider(height: 4, color: Color(0xff9E9E9E)),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Summary",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Inter",
                    color: Color(0xff666666)),
              ),
            ),
          ),
          buildData(),
          buildData(),
          buildData(),
          buildData(),
          buildData(),
          buildData(),
        ],
      )),
    );
  }

  buildData() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 10),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   CupertinoPageRoute(
          //     builder: (context) => TestTitle(),
          //   ),
          // );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                  alignment: Alignment.center,
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset('assets/images/MeMoji.png')),
              SizedBox(width: 6),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "Student Name",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      color: Color(0xff212121)),
                ),
                SizedBox(height: 5),
                Text(
                  "Watched: Thur, 7:40 Pm - batch 1",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: Color(0xff9E9E9E)),
                ),
              ]),
            ]),
            Text(
              "Progress 90%",
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 12, fontFamily: "Inter", color: Color(0xff3399FF)),
            ),
          ],
        ),
      ),
    );
  }
}
