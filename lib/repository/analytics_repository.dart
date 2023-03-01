import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:idream/common/references.dart';

class AnalyticsRepository {
  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

  Future setUserProperties({required String? userID}) async {
    await firebaseAnalytics.setUserId();
    await firebaseAnalytics.setUserProperty(
      name: "StudentUserID",
      value: userID,
    );
    await firebaseAnalytics.setUserProperty(
      name: "StudentUserID",
      value: userID,
    );
  }

  Future setUsername({required String? username}) async {
    await firebaseAnalytics.setUserProperty(
      name: "StudentName",
      value: username,
    );
  }

  Future setUserEmail({required String? userEmail}) async {
    await firebaseAnalytics.setUserProperty(
      name: "StudentEmail",
      value: userEmail,
    );
  }

  Future setUserMobile({required String? userMobile}) async {
    await firebaseAnalytics.setUserProperty(
      name: "StudentMobile",
      value: userMobile,
    );
  }

  Future setUserClass({required String? userClass}) async {
    await firebaseAnalytics.setUserProperty(
      name: "StudentClass",
      value: userClass,
    );
  }

  Future setUserBoard({required String? userBoard}) async {
    await firebaseAnalytics.setUserProperty(
      name: "StudentBoard",
      value: userBoard,
    );
  }

  Future setUserCity({required String? userCity}) async {
    await firebaseAnalytics.setUserProperty(
      name: "StudentCity",
      value: userCity,
    );
  }

  Future setUserState({required String? userState}) async {
    await firebaseAnalytics.setUserProperty(
      name: "StudentState",
      value: userState,
    );
  }
}
