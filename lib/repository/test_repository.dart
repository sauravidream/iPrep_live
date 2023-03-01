import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/test_model.dart';
import 'package:idream/model/test_prep_model/test_prep_model.dart';
import 'package:idream/model/test_question_model.dart';
import 'package:idream/ui/subject_home/test_pop_up_page.dart';

class TestRepository {
  Future fetchTestQuestions(String? subjectID) async {
    try {
      try {
        String? educationBoard =
            (await getStringValuesSF("educationBoard"))!.toLowerCase();
        String? language = (await getStringValuesSF("language"))!.toLowerCase();
        String? classNumber = await (getStringValuesSF("classNumber"));
        if (int.parse(classNumber!) > 10) {
          String? stream = await getStringValuesSF("stream");
          classNumber = "${classNumber}_$stream";
        }

        var response = await apiHandler.getAPICall(
            endPointURL:
                "topics/$educationBoard/$language/$classNumber/subjects/$subjectID/practice/");

        if (response == null) return response;

        List<TestModel>? testList = [];
        testList =
            response.map<TestModel>((i) => TestModel.fromJson(i)).toList();

        String? userID = await getStringValuesSF("userID");
        var testReports = await apiHandler.getAPICall(
            endPointURL:
                "reports/app_reports/$userID/data/$classNumber/$educationBoard/$language/$subjectID/test/");
        if (testReports != null) {
          (testReports as Map).forEach((key1, topicWiseReports) {
            List<TestReports> testReport = [];
            (topicWiseReports as Map).forEach((key2, topicWiseReport) {
              testReport.add(TestReports.fromJson(topicWiseReport));
            });
            testList!.firstWhere((test) => test.topicID == key1).testReports =
                testReport;
          });
        }

        return testList;
      } catch (error) {
        debugPrint(error.toString());
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<List<TestQuestionModel>?> fetchTotalTestQuestions(
      String? topicID) async {
    List<TestQuestionModel> testQuestionModelList = [];
    String? classNumber = await getStringValuesSF("classNumber");
    if (int.parse(classNumber!) > 10) {
      String? stream = await getStringValuesSF("stream");
      classNumber = "${classNumber}_$stream";
    }

    String language = (await getStringValuesSF("language"))!.toLowerCase();
    String questionBankNode = "qu_db_classwise";
    if (language == "hindi") {
      questionBankNode = "qu_db_classwise_hindi";
    }
    var response = await apiHandler.getAPICall(
        endPointURL: "$questionBankNode/$classNumber/$topicID");

    if (response == null) return response;

    try {
      await Future.forEach(response, (dynamic testQuestionList) {
        Future.forEach(testQuestionList, (dynamic testQuestion) {
          for (var element in (testQuestion as Map).values) {
            List<Map<String, dynamic>?> optionsList = [
              element['A'],
              element['B'],
              element['C'],
              element['D']
            ];
            optionsList.shuffle();
            testQuestionModelList.add(
              TestQuestionModel(
                option1: Option.fromJson(optionsList[0]!),
                option2: Option.fromJson(optionsList[1]!),
                option3: Option.fromJson(optionsList[2]!),
                option4: Option.fromJson(optionsList[3]!),
                questionID: testQuestion.keys.first,
                correctFeedback: element["correct_feedback"],
                correctAnswer: element['A']["value"],
                feedbackImage: element['feedbackImage'],
                incorrectFeedback: element["incorrect_feedback"],
                question: element['q'],
                questionImage: element['questionImage'],
              ),
            );
          }
        });
      });
      if (testQuestionModelList.length > 15) {
        testQuestionModelList.removeRange(15, testQuestionModelList.length);
      }
      testQuestionModelList.shuffle();
      return testQuestionModelList;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future saveUsersTestReport({
    required TestPopUpPageState testPopUpPageStatePageWidget,
    String? boardID, //Change for saving assignment's progress
    String? classID, //Change for saving assignment's progress
    String? language, //Change for saving assignment's progress
  }) async {
    try {
      String? stream;
      String? userID = await (getStringValuesSF("userID"));
      String? educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String? language = (await getStringValuesSF("language"))!.toLowerCase();
      String? classNumber = await (getStringValuesSF("classNumber"));

      if ((int.parse(classNumber!)) > 10) {
        stream = await getStringValuesSF("stream"); //2
        classNumber = "${classNumber}_${stream!}";
      } else {
        classNumber = classNumber;
      }

      List<TestQuestionModel> testSetWithUserAnswer =
          testPopUpPageStatePageWidget.totalQuestionsList;
      int testIndex = 0;
      testSetWithUserAnswer.forEach((test) {
        testSetWithUserAnswer[testIndex].userResponse =
            testPopUpPageStatePageWidget.providedAnsweredList[testIndex];
        testIndex++;
      });

      dbRef
          .child("reports")
          .child("app_reports")
          .child(userID!)
          .child("data")
          .child(classNumber)
          .child(educationBoard)
          .child(language)
          .child(testPopUpPageStatePageWidget
              .widget.testPageWidget!.subjectHome!.subjectWidget!.subjectID!)
          .child("test")
          .child(testPopUpPageStatePageWidget.widget.testModel!.topicID!)
          .push()
          .set({
        "updated_time": DateTime.now().toUtc().toString(),
        "topic_id": testPopUpPageStatePageWidget.widget.testModel!.topicID,
        "topic_name": testPopUpPageStatePageWidget.widget.testModel!.tName,
        "correct_count": testPopUpPageStatePageWidget
            .correctAnswerIndexList.length
            .toString(),
        "incorrect_count": testPopUpPageStatePageWidget
            .incorrectAnswerIndexList.length
            .toString(),
        "unattempted_count": testPopUpPageStatePageWidget
            .skippedQuestionsIndexList.length
            .toString(),
        "duration":
            testPopUpPageStatePageWidget.stopwatch.elapsed.inSeconds.toString(),
        "marks": ((testPopUpPageStatePageWidget.correctAnswerIndexList.length /
                    testPopUpPageStatePageWidget.totalQuestionsList.length) *
                100)
            .toStringAsFixed(1),
        "test_questionnaire": jsonDecode(
            jsonEncode(testPopUpPageStatePageWidget.totalQuestionsList)),
      }).then((_) {
        debugPrint("Saved UsersTest Data successfully");
      }).catchError((onError) {
        debugPrint(onError);
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future <List<Others?>?> fetchTestPrepPopularExamsList(context) async {
    try {
      String? classNumber = await (getStringValuesSF("classNumber"));
      if(int.tryParse(classNumber!)!>10){
        String? stream = await getStringValuesSF("stream");
        classNumber = "${classNumber}_$stream";
      }
      Dio dio = Dio();
      final response = await dio.get("https://i-prep.firebaseio.com/testPrep_segregated_data/$classNumber.json");
      log(response.data.toString());
      if (response.statusCode == 200) {
        final examAllData = AllExamModel.fromJson(response.data);
        return examAllData.allExam;
      }
    }on DioError catch (e) {
      debugPrint(e.toString());
    }
    catch (e) {
      debugPrint(e.toString());
    }
    return null;
    // try {
    //   String? classNumber = await (getStringValuesSF("classNumber"));
    //   if ((classNumber!.length > 2
    //           ? int.parse(classNumber.substring(0, 2))
    //           : int.parse(classNumber)) >
    //       10) {
    //     classNumber = classNumber.replaceAll("_", "");
    //     String? stream = await getStringValuesSF("stream");
    //     if (stream != "null" && stream!.isNotEmpty) {
    //       classNumber = "${classNumber}_$stream";
    //     }
    //
    //     String? educationBoard = (await getStringValuesSF("educationBoard"));
    //     if (educationBoard != null) {
    //       educationBoard = educationBoard.toLowerCase();
    //     } else {
    //       educationBoard = "cbse";
    //     }
    //
    //     String? language = (await getStringValuesSF("language"))!.toLowerCase();
    //     // test_prep for some time and using in test education board replace by cbs in place of cbse
    //
    //     var testData = await apiHandler.getAPICall(
    //         endPointURL:
    //             "test_prep_categories_5/$educationBoard/$language/$classNumber");
    //
    //     if (testData != null) {
    //       List<TestPrepModel>? _testList = testData
    //           .map<TestPrepModel>((i) => TestPrepModel.fromJson(i))
    //           .toList();
    //       return _testList;
    //     } else {
    //       return null;
    //     }
    //   } else {
    //     return null;
    //   }
    // } catch (e) {
    //   debugPrint("Error while fetching Test Prep Data: $e");
    //   return null;
    // }
  }

  /*Future userTestReport({
    String? subjectID,
    String? topicID,
  }) async {
    String? educationBoard =
        (await getStringValuesSF("educationBoard"))!.toLowerCase();
    String? language = (await getStringValuesSF("language"))!.toLowerCase();
    String? classNumber = await (getStringValuesSF("classNumber"));
    if (int.parse(classNumber!) > 10) {
      String? stream = await getStringValuesSF("stream");
      classNumber = "${classNumber}_$stream";
    }

    try {
      String? userID = await getStringValuesSF("userID");
      var testReports = await apiHandler.getAPICall(
          endPointURL:
              "reports/app_reports/$userID/data/$classNumber/$educationBoard/$language/$subjectID/test/");

      if (testReports != null) {
        (testReports as Map).forEach((key1, topicWiseReports) {
          List<TestReports> testReport = [];
          (topicWiseReports as Map).forEach((key2, topicWiseReport) {
            testReport.add(TestReports.fromJson(topicWiseReport));
          });
          testList!.firstWhere((test) => test.topicID == key1).testReports =
              testReport;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }*/
}
