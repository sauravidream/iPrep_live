import 'package:flutter/material.dart';

class Physics extends StatefulWidget {
  @override
  _PhysicsState createState() => _PhysicsState();
}

class _PhysicsState extends State<Physics> {
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
                    height: 25,
                    width: 25,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Physics",
                        style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            fontSize: 32,
                            color: Color(0xffFB9E36)),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "16 Chapters",
                        style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color(0xff666666)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset("assets/images/search.png",
                            height: 28, width: 28, color: Color(0xff666666)),
                        onPressed: () {},
                      ),
                      SizedBox(width: 8),
                      Image.asset('assets/images/orange_magnet.png',
                          height: 50, width: 50)
                    ],
                  )
                ],
              ),
            ),
            buildChapters("01.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("02.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("03.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("04.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("05.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("06.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("07.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("08.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("09.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("10.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("11.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("12.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("13.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("14.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("15.", "Electrostatic Potential & Capacitense 1"),
            buildChapters("16.", "Electrostatic Potential & Capacitense 1"),
          ],
        ),
      ),
    );
  }

  buildChapters(String number, String name) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
      child: Row(
        children: [
          Text(
            number,
            style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xffFB9E36)),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            name,
            style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xff212121)),
          ),
        ],
      ),
    );
  }
}
