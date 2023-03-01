

import 'package:flutter/foundation.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';

class CoachOnBoardingRepository {
  Future saveTeachersName({String? fullName}) async {
    //Here we are going to save user data
    String? _userTypeNode = await (userRepository.getUserNodeName() );
    String? _userID = await (getStringValuesSF("userID") );
    await dbRef.child("users").child(_userTypeNode!).child(_userID!).update({
      "full_name": fullName,
      'profile_photo': Constants.defaultProfileImagePath,
    }).then((_) {
      debugPrint("Saved Data successfully");
    }).catchError((onError) {
      debugPrint(onError.toString());
    });
  }
}
