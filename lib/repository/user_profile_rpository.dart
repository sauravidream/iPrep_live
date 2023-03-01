import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/repository/payment_repository.dart';

class UserProfileRepository {
  Future setUserProfile() async {
    try {
      String? classNumber;
      String? userTypeNode = await (getUserNodeName());
      String? userID = await getStringValuesSF("userID");
      String? stream = await getStringValuesSF('stream');
      classNumber = await getStringValuesSF('classNumber');
      String? language = await getStringValuesSF('language');
      String? educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();

      if ((int.parse(classNumber!)) > 10) {
        stream = await getStringValuesSF("stream"); //2
        classNumber = "${classNumber}_${stream!}";
      } else {
        classNumber = classNumber;
      }
      dbRef
          .child("users")
          .child(userTypeNode.toString())
          .child(userID!)
          .update({
        "users_profile": {
          "user_registration_date": DateTime.now().toUtc().toString(),
          "user_class": classNumber,
          "user_board": educationBoard,
          "user_language": language,
        }
      }).then((_) {
        debugPrint("Saved User Profile data successfully");
      }).catchError((onError) {
        debugPrint(onError);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveUserLocation() async {
    try {
      String? userTypeNode = await (getUserNodeName());
      String? userID = await getStringValuesSF("userID");

      String? locationName = await getStringValuesSF("locationName");
      String? street = await getStringValuesSF("street");
      String? isoCountryCode = await getStringValuesSF("isoCountryCode");
      String? postalCode = await getStringValuesSF("postalCode");
      String? administrativeArea =
          await getStringValuesSF("administrativeArea");
      String? locality = await getStringValuesSF("locality");
      String? subLocality = await getStringValuesSF("subLocality");
      String? thoroughfare = await getStringValuesSF("thoroughfare");
      String? subThoroughfare = await getStringValuesSF("subThoroughfare");

      firebaseDatabase.ref("users/$userTypeNode/$userID/users_profile").update({
        "location": {
          "locationName": locationName,
          "street": street,
          "isoCountryCode": isoCountryCode,
          "postalCode": postalCode,
          "administrativeArea": administrativeArea,
          "locality": locality,
          "subLocality": subLocality,
          "thoroughfare": thoroughfare,
          "subThoroughfare": subThoroughfare,
        }
      }).then(
        (value) => debugPrint(
            "========= Saved User Profile Location data successfully =========="),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool?> checkUserProfileData() async {
    bool status = false;

    try {
      String? userTypeNode = await (getUserNodeName());
      String? userID = await getStringValuesSF("userID");

      final response = await Future.wait([
        firebaseDatabase.ref("users/$userTypeNode/$userID").get(),
        firebaseDatabase.ref("temp_class").get()
      ]);

      if (response.isNotEmpty &&
          response[0].value != null &&
          response[1].value != null) {
        DataSnapshot response0 = response[0];
        DataSnapshot response1 = response[1];
        if (response0.value != null &&
            (response0.value! as Map)["users_profile"] != null) {
          for (var element in (response1.value as List)) {
            if (element ==
                (response0.value! as Map)["users_profile"]["user_class"]) {
              return Future.value(status = false);
            }
            status = true;
          }
        }
        return Future.value(status = true);
      }

      return Future.value(status);
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }

  Future<bool> updateUserProfile({
    required String classNumber,
    String? stream,
    required String language,
    required String board,
  }) async {
    try {
      String? userID = await getStringValuesSF("userID");
      String? userTypeNode = await (getUserNodeName());
      if ((int.parse(classNumber)) > 10) {
        classNumber = "${classNumber}_$stream";
      } else {
        classNumber = classNumber;
      }

      /// users/students/bpIXsLUfsnb6k9nvunsKYw6R3pk1/users_profile/user_registration_date
      /// users/students/bpIXsLUfsnb6k9nvunsKYw6R3pk1/users_plans/date_started
      await firebaseDatabase
          .ref("users/$userTypeNode/$userID")
          .get()
          .then((value) {
        final reaponse = (value.value as Map);

        if (reaponse["users_profile"] != null &&
            reaponse["users_profile"]["user_registration_date"] != null) {
          if (reaponse["users_profile"]["location"] != null) {
            dbRef
                .child("users")
                .child(userTypeNode.toString())
                .child(userID!)
                .update({
              "users_profile": {
                "location": reaponse["users_profile"]["location"],
                "user_registration_date": reaponse["users_profile"]
                    ["user_registration_date"],
                "user_class": classNumber,
                "user_board": board,
                "user_language": language,
              }
            }).then((_) {
              debugPrint("Saved User Profile data successfully");
              return true;
            });
          } else {
            dbRef
                .child("users")
                .child(userTypeNode.toString())
                .child(userID!)
                .update({
              "users_profile": {
                "location": {
                  "locationName": "",
                  "street": "",
                  "isoCountryCode": "",
                  "postalCode": "",
                  "administrativeArea": "",
                  "locality": "",
                  "subLocality": "",
                  "thoroughfare": "",
                  "subThoroughfare": "",
                },
                "user_registration_date": reaponse["users_profile"]
                    ["user_registration_date"],
                "user_class": classNumber,
                "user_board": board,
                "user_language": language,
              }
            }).then((_) {
              debugPrint("Saved User Profile data successfully");
              return true;
            });
          }
        } else {
          dbRef
              .child("users")
              .child(userTypeNode.toString())
              .child(userID!)
              .update({
            "users_profile": {
              "user_registration_date": reaponse["users_plans"]["date_started"],
              "user_class": classNumber,
              "user_board": board,
              "user_language": language,
            }
          }).then((_) {
            debugPrint("Saved User Profile data successfully");
            return true;
          });
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
