

import 'package:flutter/foundation.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';

class MyIprepReferralsRepository {
  Future saveDetailsForIprepReferrals({
    String? name,
    String? mobileNumber,
    String? email,
    String? organisation,
    String? numberOfStudents,
    String? state,
  }) async {
    try {
      String? _userID = await (getStringValuesSF("userID") );

      var _response =
          await dbRef.child("partner_code_enquiry_details").child(_userID!).set({
        "name": name,
        "mobile_number": mobileNumber,
        "email": email,
        "organisation": organisation,
        "student_count": numberOfStudents,
        "state": state,
        "updated_time": DateTime.now().toUtc().toString(),
      }).then((_) {
            debugPrint("Saved Partner Code Request Data successfully");
        return true;
      }).catchError((onError) {
            debugPrint(onError.toString());
        return false;
      });
      return _response;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }
}
