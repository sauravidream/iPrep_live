import 'package:flutter/material.dart';

class ChatInput extends ChangeNotifier {
  int container1Fex=12;
   int container2Fex=2;
  int? mexLines;

  getInputFromStudentmessage(String value) {
    value=value.isEmpty ?'':value;
    int inputlength = value.length;
    if (inputlength <= 45) {
      container1Fex = 12;
      container2Fex = 1;
      mexLines = 1;
    } else if (inputlength <= 100) {
      container1Fex = 15;
      container2Fex = 2;
      mexLines = 3;
    } else if (inputlength < 200) {
      container1Fex = 12;
      container2Fex = 2;
      mexLines = 4;
    } else if (inputlength < 1000000) {
      container1Fex = 8;
      container2Fex = 2;
      mexLines = 6;
    } else if (value == '') {
      container1Fex = 12;
      container2Fex = 2;
      mexLines = 1;
      debugPrint(inputlength.runtimeType.toString());
    }
    notifyListeners();
  }

// Perfect Working
  getInputFromMyBatches(String value) {
    int inputlength = value.length;
    // print(inputlength);
    if (inputlength <= 45) {
      container1Fex = 12;
      container2Fex = 1;
      mexLines = 1;
    } else if (inputlength <= 100) {
      container1Fex = 14;
      container2Fex = 2;
      mexLines = 3;
    } else if (inputlength < 200) {
      container1Fex = 12;
      container2Fex = 2;
      mexLines = 4;
    } else if (inputlength < 1000000) {
      container1Fex = 8;
      container2Fex = 2;
      mexLines = 6;
    } else if (value == '') {
      container1Fex = 12;
      container2Fex = 2;
      mexLines = 1;
      debugPrint(inputlength.runtimeType.toString());
    }
    notifyListeners();
  }

// Perfect Working
  getInputFromRecentMessages(String value) {
    value=value.isEmpty ?'':value;
    int inputlength = value.length;
    // print(inputlength);
    if (inputlength <= 45) {
      container1Fex = 12;
      container2Fex = 1;
      mexLines = 1;
    } else if (inputlength <= 100) {
      container1Fex = 14;
      container2Fex = 2;
      mexLines = 3;
    } else if (inputlength < 200) {
      container1Fex = 10;
      container2Fex = 2;
      mexLines = 4;
    } else if (inputlength < 1000000) {
      container1Fex = 8;
      container2Fex = 2;
      mexLines = 6;
    } else if (value == '') {
      container1Fex = 7;
      container2Fex = 2;
      mexLines = 1;
      debugPrint(inputlength.runtimeType.toString());
    }
    notifyListeners();
  }
}
