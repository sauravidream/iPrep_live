import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int? _currentIndex;
  @override
  void initState() {
    _currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_currentIndex);
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFFFFFFF),
      currentIndex: _currentIndex!,
      showUnselectedLabels: true,
      unselectedItemColor: const Color(0xFF212121),
      selectedItemColor: const Color(0xFF212121),
      selectedIconTheme: const IconThemeData(
        color: Color(0xFF3399ff),
      ),
      unselectedIconTheme: const IconThemeData(color: Color(0xFF212121)),
      unselectedFontSize: 10,
      selectedFontSize: 10,
      onTap: (index) async {
        await Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => DashboardScreen(
              dashboardTabIndex: index,
            ),
          ),
          (Route<dynamic> route) => false,
        );
        // setState(() {
        //   _currentIndex = index;
        // });
      },
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/images/home.png",
            height: 24,
            width: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/images/my_batch_icon.png",
            color: ((_currentIndex == 1) ? const Color(0xFF3399ff) : null),
            height: 24,
            width: 24,
          ),
          label: 'My Batch',
        ),
        //TODO: Commenting out below code for postponing this functionality for future
        // BottomNavigationBarItem(
        //   icon: Image.asset(
        //     "assets/images/saved.png",
        //     height: ScreenUtil().setSp(24, ),
        //     width: ScreenUtil().setSp(24, ),
        //   ),
        //   label: 'Saved',
        // ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/images/my_report_icon.png",
            height: 24,
            width: 24,
          ),
          label: 'My Reports',
        ),
      ],
    );
  }
}
