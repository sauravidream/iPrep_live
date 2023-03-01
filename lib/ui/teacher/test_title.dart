import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TestTitle extends StatefulWidget {
  @override
  _TestTitleState createState() => _TestTitleState();
}

class _TestTitleState extends State<TestTitle> {
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
                  "Test Title",
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
          showBottomSheet(context);
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
                  "Attempted: Thur, 7:40 Pm",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: Color(0xff9E9E9E)),
                ),
              ]),
            ]),
            Text(
              "Score 04/10",
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 12, fontFamily: "Inter", color: Color(0xff3399FF)),
            ),
          ],
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * .20,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      height: 3,
                      width: 40,
                      color: Color(0xffDEDEDE),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      "Edit",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Inter",
                          color: Color(0xff666666)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Text(
                      "Date and TIme",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF212121),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Text(
                      "Delete Assignment",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFF6F6F),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
