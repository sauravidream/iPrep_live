import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/local_db_helper.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/my_reports_model.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:http/http.dart' as http;

class VideoLessonRepository {
  Future fetchVideoLessons(String? subjectID) async {
    if ((subjectID == "english_grammar_basic") ||
        (subjectID == "english_grammar_intermediate") ||
        (subjectID == "english_grammar_advanced")) {
      subjectID = "english_grammar";
    }
    try {
      String? _educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      // if (_educationBoard == "CBSE") _educationBoard = "C_E_B";
      String? _language = (await getStringValuesSF("language"))!.toLowerCase();
      String? _classNumber = await (getStringValuesSF("classNumber"));
      if (int.parse(_classNumber!) > 10) {
        String? _stream = await getStringValuesSF("stream");
        _classNumber = "${_classNumber}_$_stream";
      }

      //Check if we already saved the data
      var localData = await helper
          .fetchChapterListBasisOnSubjectNameClassNameBoardNameLanguage(
        boardName: _educationBoard.toString(),
        className: _classNumber.toString(),
        subjectName: subjectID.toString(),
        language: _language.toString(),
      );

      if (localData.length > 0) {
        List<String?> chapterList = [];
        for (var data in (localData as List<Map>)) {
          chapterList.add(data["chapterName"]);
        }
        return chapterList;
      }

      var response = await apiHandler.getAPICall(
          endPointURL: /*"Test1/topics/" +*/ "topics/"
              "$_educationBoard/"
              "$_language/"
              "$_classNumber/"
              "subjects/"
              "$subjectID/"
              "video_lessons/");

      List<String?> chapterList = [];

      await Future.forEach(response as List, (dynamic videoList) async {
        chapterList.add(videoList['name']);
        await Future.forEach(videoList['topics'] as List,
            (dynamic video) async {
          VideoLessons _videoLessons = VideoLessons(
            boardID: _educationBoard,
            classID: _classNumber,
            language: _language,
            subjectName: subjectID,
            chapterName: video["topicName"],
            videoType: "videoLessons",
            videoDetails: video["detail"],
            videoID: video["id"],
            videoName: video["name"],
            videoOfflineLink: video["offlineLink"],
            videoOfflineThumbnail: video["offlineThumbnail"],
            videoOnlineLink: video["onlineLink"],
            videoThumbnail: video["thumbnail"],
            videoTopicName: video["topicName"],
          );
          String dataString =
              "INSERT Into $tableVideoLessons (boardID, classID, language, subjectName, chapterName, videoType, videoDetails, videoID, videoName, videoOfflineLink, videoOfflineThumbnail, videoOnlineLink, videoThumbnail, videoTopicName   )"
              " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

          var rowID = await helper.rawInsertVideoLessons(
              tableData: dataString, videoLessons: _videoLessons);
          debugPrint(rowID.toString());
        });
      }) /*;
      })*/
          .then((value) {
        return chapterList;
      }).catchError((error) {
        debugPrint(error.toString());
      });
      return chapterList;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future fetchVideoLessonsFromLocal({
    String? subjectName,
    String? chapterName,
    required List? chapterList,
  }) async {
    if ((subjectName == "english_grammar_basic") ||
        (subjectName == "english_grammar_intermediate") ||
        (subjectName == "english_grammar_advanced")) {
      subjectName = "english_grammar";
    }
    String _educationBoard =
        (await getStringValuesSF("educationBoard"))!.toLowerCase();
    String? _language = (await getStringValuesSF("language"))!.toLowerCase();
    String? _classNumber = await (getStringValuesSF("classNumber"));
    if (int.parse(_classNumber!) > 10) {
      String? _stream = await getStringValuesSF("stream");
      _classNumber = "${_classNumber}_$_stream";
    }

    Map<String, List<VideoLessonModel>?> _map = {};
    await Future.forEach(chapterList!, (dynamic chapterTitle) async {
      var response = await helper
          .fetchVideoLessonsBasisOnSubjectNameClassNameBoardNameLanguage(
        subjectName: subjectName,
        chapterName: chapterTitle,
        boardName: _educationBoard,
        className: _classNumber,
        language: _language,
      );
      List<VideoLessonModel>? _videoList = [];
      _videoList = response
          .map<VideoLessonModel>((i) => VideoLessonModel.fromJson(i))
          .toList();
      _map[chapterTitle] = _videoList;
    });
    // chapterList.forEach((chapterTitle) async {
    //   var response = await helper
    //       .fetchVideoLessonsBasisOnSubjectNameClassNameBoardNameLanguage(
    //     subjectName: subjectName,
    //     chapterName: chapterTitle,
    //   );
    //   List<VideoLessonModel> _videoList = [];
    //   _videoList = response
    //       .map<VideoLessonModel>((i) => VideoLessonModel.fromJson(i))
    //       .toList();
    //   _map[chapterTitle] = _videoList;
    // });

    // List<VideoLessonModel> _videoList = List<VideoLessonModel>();
    // _videoList = response
    //     .map<VideoLessonModel>((i) => VideoLessonModel.fromJson(i))
    //     .toList();
    return _map;
  }

  Future getVimeoVideoDetails(String? videoUrl) async {
    var vimeoJson = await http
        .get(Uri.parse('https://vimeo.com/api/oembed.json?url=$videoUrl'));
    return json.decode(vimeoJson.body);
  }

  Future saveUsersVideoWatchingData(
    String? subjectName, {
    int? duration,
    DateTime? videoStartTime,
    required String subjectID,
    String? videoID,
    String? thumbnail,
    String? videoUrl,
    int? videoTotalDuration,
    String? videoName,
    required String topicName,
    String? batchId,
    String? assignmentId,
    String? teacherId,
    String? assignmentIndex,
    String? boardID, //Change for saving assignment's progress
    String? classID, //Change for saving assignment's progress
    String? language, //Change for saving assignment's progress
  }) async {
    try {
      debugPrint(teacherId);
      String? stream;
      String? userID = await (getStringValuesSF("userID"));
      String? educationBoard =
          boardID ?? (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String? _language =
          language ?? (await getStringValuesSF("language"))!.toLowerCase();
      String? classNumber = classID;
      if (classNumber == null) {
        classNumber = await getStringValuesSF("classNumber");
        if ((int.parse(classNumber!)) > 10) {
          stream = await getStringValuesSF("stream"); //2
          classNumber = "${classNumber}_${stream!}";
        } else {
          classNumber = classNumber;
        }
      }

      if (topicName.contains("/")) {
        topicName = topicName.replaceAll('/', "-");
      }

      await dbRef
          .child("reports")
          .child("app_reports")
          .child(userID!)
          .child("data")
          .child(classNumber)
          .child(educationBoard)
          .child(_language)
          .child(subjectID)
          .child("video_lessons")
          .child(topicName)
          .push()
          .set({
        "updated_time": DateTime.now().toUtc().toString(),
        "video_id": videoID,
        "video_url": videoUrl,
        "video_total_duration": videoTotalDuration.toString(),
        "video_name": videoName,
        "topic_name": topicName,
        "thumbnail": thumbnail,
        "duration": duration.toString(),
        "subject_name": subjectName,
        'user_name': appUser!.fullName,
        'class_name': classNumber,
      }).then((_) async {
        debugPrint("Saved UsersVideoWatched Data successfully");
        await myReportsRepository.saveOverallAppUses(
            subjectID: subjectID,
            categoryName: "animated_videos",
            className: classNumber,
            userId: userID,
            boardName: educationBoard,
            language: _language,
            appUsesDuration: duration.toString());
        if (batchId != null) {
          await assignmentTrackingRepository.trackAssignedVideos(
            teacherId: teacherId,
            batchId: batchId,
            assignmentId: assignmentId!,
            assignmentIndex: assignmentIndex!,
            videoTotalDuration: videoTotalDuration!,
            watchedDuration: duration!,
          );
        }
        return true;
      }).catchError((onError) {
        debugPrint(onError.toString());
        return true;
      });
      return true;
    } catch (error) {
      debugPrint(error.toString());
      return true;
    }
  }

  Future fetchAlreadyWatchedVideoData() async {
    try {
      String? _stream;
      String? _userID = await getStringValuesSF("userID");
      String _educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String _language = (await getStringValuesSF("language"))!.toLowerCase();
      String? _classNumber = await getStringValuesSF("classNumber");
      if ((int.parse(_classNumber!)) > 10) {
        _stream = await getStringValuesSF("stream"); //2
        _classNumber = "${_classNumber}_${_stream!}";
      } else {
        _classNumber = _classNumber;
      }
      var _response = await apiHandler.getAPICall(
        endPointURL: "reports/app_reports/"
            "$_userID/"
            "data/"
            "$_classNumber/"
            "$_educationBoard/"
            "$_language/",
      );
      if (_response == null) return _response;

      int _subjectLevelIndex = 0;
      List<MyReportVideoLessonsModel> _videoLessonList = [];

      if ((_response as Map).containsKey("books")) {
        _response.remove("books");
      }

      await Future.forEach(_response.values, (dynamic myReportModelList) async {
        if ((myReportModelList as Map)["video_lessons"] != null) {
          await Future.forEach((myReportModelList["video_lessons"]).values,
              (dynamic myReportBookModelList) {
            List<MyReportVideoLessonsModel> _myReportsVideoLessonsModelList =
                [];
            (myReportBookModelList as Map).values.forEach((reportBookModel) {
              if ((reportBookModel["video_total_duration"] != "null") &&
                  ((int.parse(reportBookModel["duration"]) /
                          int.parse(reportBookModel["video_total_duration"])) <
                      0.9)) {
                MyReportVideoLessonsModel _videoLesson =
                    MyReportVideoLessonsModel(
                  duration: reportBookModel["duration"],
                  videoID: reportBookModel["video_id"],
                  videoName: reportBookModel["video_name"],
                  videoUrl: reportBookModel["video_url"],
                  videoTotalDuration: reportBookModel["video_total_duration"],
                  topicName: reportBookModel["topic_name"],
                  updatedTime: reportBookModel["updated_time"],
                  subjectID:
                      _response.keys.toList().elementAt(_subjectLevelIndex),
                );

                _myReportsVideoLessonsModelList.removeWhere((element) =>
                    ((element.videoUrl == _videoLesson.videoUrl) &&
                        ((element.videoUrl == _videoLesson.videoUrl) &&
                            (DateTime.parse(element.updatedTime!).compareTo(
                                    DateTime.parse(_videoLesson.updatedTime!)) <
                                0))));
                _myReportsVideoLessonsModelList.add(_videoLesson);
              }
            });

            _videoLessonList.addAll(_myReportsVideoLessonsModelList);
            _videoLessonList.sort((a, b) => DateTime.parse(b.updatedTime!)
                .compareTo(DateTime.parse(a.updatedTime!)));
          });
          _subjectLevelIndex++;
        }
      }).then((value) {
        return _videoLessonList;
      });
      return _videoLessonList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getUserVideoWatchDetails() async* {
    try {
      String? _stream;
      String? _userID = await getStringValuesSF("userID");
      String _educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String _language = (await getStringValuesSF("language"))!.toLowerCase();
      String? _classNumber = await getStringValuesSF("classNumber");
      if ((int.parse(_classNumber!)) > 10) {
        _stream = await getStringValuesSF("stream"); //2
        _classNumber = "${_classNumber}_${_stream!}";
      } else {
        _classNumber = _classNumber;
      }

      yield* dbRef
          .child("reports/app_reports/"
              "$_userID/"
              "data/"
              "$_classNumber/"
              "$_educationBoard/"
              "$_language/")
          .orderByValue()
          .onValue;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
