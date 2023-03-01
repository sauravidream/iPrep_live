import 'package:flutter/foundation.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/practice_model.dart';
import 'package:idream/model/practice_question_model.dart';

class PracticeRepository {
  String? subjectID;
  Future fetchPracticeTopicList(String? subjectID) async {
    try {
      this.subjectID = subjectID;
      String _educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String? _language = (await getStringValuesSF("language"))!.toLowerCase();
      String? _classNumber = await (getStringValuesSF("classNumber"));
      if (int.parse(_classNumber!) > 10) {
        String? _stream = await getStringValuesSF("stream");
        _classNumber = "${_classNumber}_$_stream";
      }
      var response = await apiHandler.getAPICall(
          endPointURL: /*"Test1/topics/" +*/ "topics/$_educationBoard/$_language/$_classNumber/subjects/$subjectID/practice/");

      if (response == null) {
        // content not available status update on firebase console
        basicContentsTexting.contentsStatus(
          topicName: "",
          subject: subjectID!,
          classNo: _classNumber,
          language: _language,
          board: _educationBoard.toLowerCase(),
          dataNotFoundIn: 'Practice',
        );
        // return response;
      }

      String? _userID = await getStringValuesSF("userID");

      var _practiceHistory = await apiHandler.getAPICall(
          endPointURL:
              "reports/app_reports/$_userID/data/$_classNumber/$_educationBoard/$_language/$subjectID/practice/");

      if (response == null) return response;

      List<PracticeModel>? _practiceList = [];
      List<PracticeReports> _practiceReportList = [];
      if (_practiceHistory != null) {
        await Future.forEach((_practiceHistory as Map).values,
            (dynamic practiceSet) async {
          await Future.forEach((practiceSet as Map).values,
              (dynamic practice) async {
            _practiceReportList.add(PracticeReports.fromJson(practice));
          });
        }).then((value) async {
          _practiceList = response
              .map<PracticeModel>((i) => PracticeModel.fromJson(i))
              .toList();

          await Future.forEach(_practiceList!, (dynamic practiceModel) async {
            var _practicesReports = _practiceReportList.where((element) {
              return (element.topicID == practiceModel.topicID);
            });
            practiceModel.attempts = _practicesReports.length;
            if (_practicesReports.isNotEmpty) {
              practiceModel.mastery = _practicesReports.last.mastery;
              practiceModel.masteryLevel = _practicesReports.last.topicLevel;
            } else {
              practiceModel.mastery = 0.0;
            }
          }).then((value) {
            return _practiceList;
          });
        });
      } else {
        _practiceList = response
            .map<PracticeModel>((i) => PracticeModel.fromJson(i))
            .toList();
      }
      return _practiceList;
      /*await Future.forEach((response as Map).values, (chapterList) async {*/
      // await Future.forEach(response as List, (videoList) async {
      //   chapterList.add(videoList['name']);
      //   await Future.forEach(videoList['topics'] as List, (video) async {
      //     VideoLessons _videoLessons = VideoLessons(
      //       boardID: _educationBoard,
      //       classID: _classNumber,
      //       language: _language,
      //       subjectName: subjectID,
      //       chapterName: video["topicName"],
      //       videoType: "videoLessons",
      //       videoDetails: video["detail"],
      //       videoID: video["id"],
      //       videoName: video["name"],
      //       videoOfflineLink: video["offlineLink"],
      //       videoOfflineThumbnail: video["offlineThumbnail"],
      //       videoOnlineLink: video["onlineLink"],
      //       videoThumbnail: video["thumbnail"],
      //       videoTopicName: video["topicName"],
      //     );
      //     String dataString =
      //         "INSERT Into $tableVideoLessons (boardID, classID, language, subjectName, chapterName, videoType, videoDetails, videoID, videoName, videoOfflineLink, videoOfflineThumbnail, videoOnlineLink, videoThumbnail, videoTopicName   )"
      //         " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
      //
      //     var rowID = await helper.rawInsertVideoLessons(
      //         tableData: dataString, videoLessons: _videoLessons);
      //     print(rowID.toString());
      //   });
      // })/*;
      // })*/
      //     .then((value) {
      //   return chapterList;
      // }).catchError((error) {
      //   print(error.toString());
      // });
    } catch (error) {
      print(error);
    }
  }

  Future fetchPracticeQuestions(String? topicID,
      {String? classNumber, String? language}) async {
    try {
      String? _classNumber = classNumber;

      if (_classNumber == null) {
        _classNumber = await getStringValuesSF("classNumber");
        if (int.parse(_classNumber!) > 10) {
          String? _stream = await getStringValuesSF("stream");
          _classNumber = "${_classNumber}_$_stream";
        }
      }
      String _educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String _language =
          language ?? (await getStringValuesSF("language"))!.toLowerCase();
      String _questionBankNode = "qu_db_classwise";
      if (_language == "hindi") {
        _questionBankNode = "qu_db_classwise_hindi";
      }
      var response = await apiHandler.getAPICall(
          endPointURL: "$_questionBankNode/" "$_classNumber/" "$topicID");

      if (response == null) {
        // content not available status update on firebase console
        basicContentsTexting.contentsStatus(
          topicName: topicID,
          subject: subjectID!,
          classNo: _classNumber,
          language: _language,
          board: _educationBoard.toLowerCase(),
          dataNotFoundIn: 'Practice',
        );
        // return response;
      }

      List<List<PracticeQuestionModel>> _questionModelList = [];
      await Future.forEach(response as List,
          (dynamic practiceQuestionsList) async {
        List<PracticeQuestionModel> _questionList = [];
        await Future.forEach(practiceQuestionsList as List, (dynamic practice) {
          (practice as Map).values.forEach((element) {
            List<Map<String, dynamic>?> _optionsList = [
              element['A'],
              element['B'],
              element['C'],
              element['D']
            ];
            _optionsList.shuffle();

            _questionList.add(PracticeQuestionModel(
                questionID: practice.keys.first,
                option1: Option.fromJson(_optionsList[0]!),
                option2: Option.fromJson(_optionsList[1]!),
                option3: Option.fromJson(_optionsList[2]!),
                option4: Option.fromJson(_optionsList[3]!),
                correctAnswer: element['A']['value'],
                correctFeedback: element['correct_feedback'],
                incorrectFeedback: element['incorrect_feedback'],
                question: element['q'],
                questionImage: element['questionImage'],
                feedbackImage: element['feedbackImage']));
          });
        });
        _questionModelList.add(_questionList);
      });
      return _questionModelList;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future saveUsersPracticeMastery(
    String? subjectName, {
    required String subjectID,
    required String topicID,
    String? topicName,
    int? topicLevel,
    double? mastery,
    String? correctStreakCount,
    required DateTime practiceStartTime,
    String? batchId,
    String? teacherId,
    String? assignmentId,
    String? assignmentIndex,
    String? boardID, //Change for saving assignment's progress
    String? classID, //Change for saving assignment's progress
    String? language, //Change for saving assignment's progress
  }) async {
    try {
      String? _stream;
      String? _userID = await (getStringValuesSF("userID"));
      String? _educationBoard =
          boardID ?? (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String? _language =
          language ?? (await getStringValuesSF("language"))!.toLowerCase();
      String? _classNumber = classID;
      if (_classNumber == null) {
        _classNumber = await getStringValuesSF("classNumber");
        if ((int.parse(_classNumber!)) > 10) {
          _stream = await getStringValuesSF("stream"); //2
          _classNumber = "${_classNumber}_${_stream!}";
        } else {
          _classNumber = _classNumber;
        }
      }

      String _duration = DateTime.now()
          .toUtc()
          .difference(practiceStartTime)
          .inSeconds
          .toString();

      await dbRef
          .child("reports")
          .child("app_reports")
          .child(_userID!)
          .child("data")
          .child(_classNumber)
          .child(_educationBoard)
          .child(_language)
          .child(subjectID)
          .child("practice")
          .child(topicID)
          .push()
          .set({
        "updated_time": DateTime.now().toUtc().toString(),
        "topic_id": topicID,
        "topic_name": topicName,
        "topic_level": topicLevel,
        "mastery": mastery,
        "duration": _duration,
        "correct_streak_count": correctStreakCount,
        "subject_name": subjectName,
        'user_name': appUser!.fullName,
        'class_name': _classNumber,
      }).then((_) async {
        await myReportsRepository.saveOverallAppUses(
            subjectID: subjectID,
            categoryName: "practice",
            className: _classNumber,
            userId: _userID,
            boardName: _educationBoard,
            language: _language,
            appUsesDuration: _duration.toString());
        if (batchId != null) {
          await assignmentTrackingRepository.trackAssignedPractice(
            masteryAchieved: mastery!,
            teacherId: teacherId,
            assignmentIndex: assignmentIndex!,
            assignmentId: assignmentId!,
            batchId: batchId,
          );
        }
        debugPrint("Saved UsersPracticeMastery Data successfully");
      }).catchError((onError) {
        debugPrint(onError.toString());
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
