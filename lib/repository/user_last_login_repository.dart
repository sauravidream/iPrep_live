import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:idream/common/shared_preference.dart';

class UserLoginRepository {
  Future userLastLogin() async {
    String? userID = await getStringValuesSF("userID");

    if (userID != null) {
      try {
        final response = await Dio().post(
          "https://learn.iprep.in/api/saveUserLastSeen",
          // "https://iprep-web.herokuapp.com/api/saveUserLastSeen",
          data: {
            "uid": userID,
          },
        );
        if (response.statusCode == 200) {
          debugPrint("Last login saved successfully");
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}
