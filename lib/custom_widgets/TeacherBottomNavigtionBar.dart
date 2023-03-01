// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TeacherBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int>? onTap;
  final int? currentIndex;

   const TeacherBottomNavigationBar({Key? key,
    this.onTap,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFFFFFFF),
      currentIndex: currentIndex!,
      elevation: 0,
      unselectedItemColor: const Color(0xFF212121),
      selectedItemColor: const Color(0xFF212121),
      unselectedFontSize: 10,
      selectedFontSize: 10,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/images/${(currentIndex == 0) ? "coach_home_blue" : "home"}.png",
            height: 24,
            width: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/images/${(currentIndex == 1) ? "iprep_library_blue" : "library"}.png",
            height: 24,
            width: 24,
          ),
          label: 'iPrep Library',
        ),
      ],
    );
  }
}
