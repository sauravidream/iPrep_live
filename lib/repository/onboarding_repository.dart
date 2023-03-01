import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:idream/model/app_language.dart';
import '../common/shared_preference.dart';

class OnBoardingRepository {
  Future<List<AppLanguage>> fetchAppLanguages() async {
    try {
      // var response =
      //     await apiHandler.getAPICall(endPointURL: Constants.language);
      List<AppLanguage> appLanguagesList = [];
      // int index = 0;
      // (response as List).forEach((element) {
      //   appLanguagesList.add(AppLanguage.fromJson(element));
      // });

      // /languages

      appLanguagesList.add(AppLanguage(
        languageName: "English",
      ));
      appLanguagesList.add(AppLanguage(
        languageName: "Hindi",
      ));
      return appLanguagesList;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null!;
  }

  Future<LanguageModel?> fetchAllLanguages() async {
    LanguageModel? languageModel;

    try {
      var response =
          await Dio().get("https://i-prep.firebaseio.com/languages.json");

      languageModel = LanguageModel.fromJson(response.data);

      return languageModel;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<LanguageModel?> fetchContentLanguages() async {
    LanguageModel? languageModel;

    List<String>? language = [];

    try {
      String educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      final response = await Future.wait([
        Dio().get(
            "https://i-prep.firebaseio.com/topics/$educationBoard/.json?shallow=true"),
        Dio().get("https://i-prep.firebaseio.com/languages.json"),
      ]);
      languageModel = LanguageModel.fromJson(response[1].data);
      if (response[0].statusCode == 200 && response[0].statusCode == 200) {
        await Future.forEach((response.first.data as Map).keys,
            (subjects) async {
          language.add(subjects);
          language.toSet();
        }).then((value) {
          languageModel?.language
              ?.removeWhere((element) => !language.contains(element.id));
        });
      }

      return languageModel;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
