import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/repository/payment_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
// ignore: library_prefixes
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../common/global_variables.dart';

class NewVersion {
  Future newUpdateCheck(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    packageInfoP = packageInfo;
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    debugPrint(appName);
    debugPrint(packageName);
    debugPrint(version);
    debugPrint(buildNumber);

    var response =
        await apiHandler.getAPICall(endPointURL: "iprep_version_update");
    debugPrint(response.toString());
    try {
      if (response != null && response['version_check'] != true) {
        if (Platform.isIOS) {
          if (version != response['ios']['package_version'] ||
              buildNumber != response['ios']['package_buildNumber']) {
            _showMyDialog(context);
          }
        }
        if (Platform.isAndroid) {
          if (version != response['android']['package_version'] ||
              buildNumber != response['android']['package_buildNumber']) {
            _showMyDialog(context);
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future checkVersionCode() async {
    try {
      final appVersion = await getStringValuesSF("app_Version");
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String? userID = await (getStringValuesSF("userID"));
      String? userType = await await (getUserNodeName());

      userType = userType?.toLowerCase();

      if (userType == "student" || userType == "students") {
        userType = "students";
      } else {
        userType = "teachers";
      }

      String version = packageInfo.version;
      Platform.isIOS ? version = "I$version" : version = "A$version";

      if (version != appVersion) {
        DatabaseReference versionRef =
            firebaseDatabase.ref("users/$userType/$userID/");
        await versionRef.update({
          "version": version,
        }).then((value) async {
          DatabaseReference versionHistoryRef = firebaseDatabase
              .ref("iprep_app_version_history/$userType/$userID/");

          await versionHistoryRef.push().update({
            "version": version,
            "date": DateTime.now().toString(),
          });
        }).whenComplete(() async {
          await addStringToSF("app_Version", version);
          debugPrint(" App version saved");
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Row(
          children: [
            const Icon(
              CupertinoIcons.arrow_up_circle,
              color: Color(0xFF0077FF),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Update Available',
              style: TextStyle(
                color: const Color(0xFF212121),
                fontWeight: FontWeight.values[5],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text('A new version of iPrep is available for update'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  'About Update:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 35),
                child: Text('1.  Bug fixes'),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 35),
                child: Text('2. UI fixes'),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 35),
                child: Text('3. New features'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  'Please update your app for a better experience',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF0077FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    minimumSize: const Size(double.maxFinite, 60),
                  ),
                  onPressed: () async {
                    String _url;
                    if (Platform.isIOS) {
                      _url = Constants.appStoreUrl;
                      Navigator.pop(context);
                    } else {
                      _url = Constants.playStoreUrl;
                    }

                    if (await UrlLauncher.launch(_url)) {
                      await UrlLauncher.launch(_url);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Update",
                    style: TextStyle(
                      color: const Color(0xFFFFFFFF),
                      fontSize: 18,
                      fontWeight: FontWeight.values[5],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
