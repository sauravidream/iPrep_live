import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/rendering.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/local_db_helper.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/extra_book_model.dart';
import 'package:idream/model/stem.dart';
import 'package:idream/model/subject_model.dart';
import 'package:idream/model/user.dart';
import 'package:idream/model/video_lesson.dart';
import '../model/subject_report_model.dart';

bool appIsBeingUser = false;

class DashboardRepository {
  Future fetchSubjectList(
      {bool? batch = false,
      String? selectedClass,
      String? educationBoard}) async {
    appIsBeingUser = true;
    try {
      await helper.deleteAllDataOnTableName(tableSubjects);
      String? classNumber = "";
      String? stream;
      if (batch!) {
        classNumber = selectedClass;
      } else {
        classNumber = selectedClass ?? await (getStringValuesSF("classNumber"));
        if ((int.parse(classNumber!)) > 10) {
          stream = await getStringValuesSF("stream"); //2
          classNumber = "${classNumber}_${stream!}";
        } else {
          classNumber = classNumber;
        }
      }

      String? _educationBoard = educationBoard;
      _educationBoard ??= (await getStringValuesSF("educationBoard"));
      if (_educationBoard != null) {
        _educationBoard = _educationBoard.toLowerCase();
      } else {
        _educationBoard = "cbse";
      }
      String? _language = (await getStringValuesSF("language"))!.toLowerCase();

      var locallySavedSubjects =
          await helper.fetchSubjectsBasisEducationBoardClassAndLanguage(
        boardName: _educationBoard.toString(),
        classID: classNumber.toString(),
        language: _language.toString(),
      );

      if (locallySavedSubjects != null && locallySavedSubjects.isNotEmpty) {
        List<SubjectModel>? subjectsModelList = [];
        subjectsModelList = locallySavedSubjects
            .map<SubjectModel>((i) => SubjectModel.fromJson(i))
            .toList();

        if (subjectsModelList!.isNotEmpty) return subjectsModelList;
      }

      var response = await apiHandler.getAPICall(
          endPointURL:
              "subjects/${_educationBoard.toLowerCase()}/$_language/$classNumber");
      if (response == null) {
        // content not available status update on firebase console
        basicContentsTexting.contentsStatus(
          subject: "dashboard",
          classNo: classNumber!,
          language: _language,
          board: _educationBoard.toLowerCase(),
          dataNotFoundIn: 'dashboard Subjects Not found',
        );
        return response;
      }
      //Adding this code increase of multiple subjects fetch request
      var _subjectsAlreadySaved =
          await helper.fetchSubjectsBasisEducationBoardClassAndLanguage(
        boardName: _educationBoard,
        classID: classNumber,
        language: _language,
      );

      if (_subjectsAlreadySaved != null) {
        List<SubjectModel>? _subjectsModelList = [];
        _subjectsModelList = locallySavedSubjects
            .map<SubjectModel>((i) => SubjectModel.fromJson(i))
            .toList();

        if (_subjectsModelList!.length > 0) return _subjectsModelList;
      }

      List<SubjectModel> _subjectList = [];
      await Future.forEach(response as List, (dynamic subject) async {
        SubjectModel? _subjectModel = SubjectModel(
          boardName: _educationBoard.toString(),
          classID: classNumber.toString(),
          subjectID: subject['id'],
          subjectName: subject['name'],
          subjectIconPath: subject['icon'],
          subjectColor: subject['color'],
          language: _language.toString(),
          shortName: subject['short_name'],
        );
        String _dataString =
            "INSERT Into $tableSubjects (boardName, classID, subjectID, subjectName, subjectIconPath, subjectColor, language, shortName)"
            " VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        var rowID = await helper.rawInsertSubjects(
            tableData: _dataString, subjectModel: _subjectModel);
        _subjectList.add(_subjectModel);
        // debugPrint(rowID.toString());
      }).then((value) {
        return _subjectList;
      }).catchError((error) {
        debugPrint(error.toString());
      });
      return _subjectList;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future updateUserInfoFromDashboard({required AppUser updatedUserInfo}) async {
    String? _userID = await getStringValuesSF("userID");

    String? _stream = updatedUserInfo.stream;
    String? _class = updatedUserInfo.classID!;

    await userRepository.saveUserDetailToLocal(
        "classNumber", _class.toString());

    if (updatedUserInfo.stream != null) {
      if (updatedUserInfo.stream == "Science") {
        updatedUserInfo.stream = "nonmedical_medical";
      } else if (_stream == "Commerce") {
        updatedUserInfo.stream = "commerce";
      } else if (_stream == "Arts") {
        updatedUserInfo.stream = "arts";
      }
    }
    await userRepository.saveUserDetailToLocal(
        "stream", updatedUserInfo.stream.toString());

    String formattedClass;
    if (updatedUserInfo.stream != null && updatedUserInfo.stream!.isNotEmpty) {
      formattedClass = "${_class}_${updatedUserInfo.stream!.toLowerCase()}";
    } else {
      formattedClass = _class.toString();
    }

    //Changes on 28th May 3:05 AM
    String? _userTypeNode = await (userRepository.getUserNodeName());
    bool? _response;
    if (!usingIprepLibrary) {
      await dbRef.child("users").child(_userTypeNode!).child(_userID!).update({
        "class_id": formattedClass,
        "student_class": formattedClass,
      }).then((_) async {
        _response = true;
        debugPrint("Saved Data successfully");
      }).catchError((onError) {
        debugPrint(onError);
        _response = false;
      });
    }
    return _response;
  }

  Future fetchStemProjectsList() async {
    String? _stream;
    try {
      String? _classNumber = await (getStringValuesSF("classNumber"));
      if ((int.parse(_classNumber!)) > 10) {
        _stream = await getStringValuesSF("stream"); //2
        _classNumber = "${_classNumber}_${_stream!}";
      } else {
        _classNumber = _classNumber;
      }

      String _educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String _language = (await getStringValuesSF("language"))!.toLowerCase();

      var response = await apiHandler.getAPICall(
          endPointURL:
              "topics/${_educationBoard.toLowerCase()}/$_language/$_classNumber/extra_content/activity_videos");

      List<StemModel> _stemModelList = [];

      if (_stemModelList != null) {
        List<String> _subjectNameList =
            (response as Map).keys.toList() as List<String>;
        var subjectListResponse = await apiHandler.getAPICall(
            endPointURL:
                "activity_videos_subjects/${_educationBoard.toLowerCase()}/$_language/$_classNumber");
        // debugPrint(subjectListResponse.toString());
        List<SubjectModel> _subjectList = [];
        await Future.forEach((subjectListResponse as List), (dynamic subjects) {
          SubjectModel _subject = SubjectModel(
            boardName: _educationBoard.toLowerCase().toString(),
            classID: _classNumber.toString(),
            subjectID: subjects["id"].toString(),
            subjectName: subjects["name"].toString(),
            subjectIconPath: subjects["icon"].toString(),
            subjectColor: subjects["color"].toString(),
          );
          _subjectList.add(_subject);
        });

        int _subjectIndex = 0;
        await Future.forEach(response.values, (dynamic stemProjects) async {
          SubjectModel _currentStemSubjectModel = _subjectList.firstWhere(
              (element) =>
                  (element.subjectID == _subjectNameList[_subjectIndex]));

          StemModel _stemModel = StemModel(
            subjectID: _subjectNameList[_subjectIndex],
            subjectName: _currentStemSubjectModel.subjectName,
            subjectIconPath:
                (_currentStemSubjectModel.subjectIconPath != null &&
                        _currentStemSubjectModel.subjectIconPath!.isNotEmpty)
                    ? _currentStemSubjectModel.subjectIconPath
                    : Constants.defaultSubjectImagePath,
            subjectColor: (_currentStemSubjectModel.subjectColor != null &&
                    _currentStemSubjectModel.subjectColor!.isNotEmpty)
                ? (int.parse(
                        _currentStemSubjectModel.subjectColor!.substring(1, 7),
                        radix: 16) +
                    0xFF000000)
                : Constants.defaultSubjectHexColor,
          );
          List<Chapters> _chaptersList = [];
          await Future.forEach(stemProjects as List,
              (dynamic chapterWiseVideos) async {
            List<VideoLessonModel> _videoLessonModel = [];
            await Future.forEach(chapterWiseVideos['topics'] as List,
                (dynamic videos) async {
              _videoLessonModel.add(VideoLessonModel(
                detail: videos['detail'],
                id: videos['id'],
                name: videos['name'],
                offlineLink: videos['offlineLink'],
                offlineThumbnail: videos['offlineThumbnail'],
                onlineLink: videos['onlineLink'],
                thumbnail: videos['thumbnail'],
                topicName: videos['topicName'],
              ));
            });
            _chaptersList.add(
              Chapters(
                chapterName: _videoLessonModel[0].topicName,
                videoLesson: _videoLessonModel,
              ),
            );
            _stemModel.chapterList = _chaptersList;
          });
          _stemModelList.add(_stemModel);
          _subjectIndex++;
        }).then((value) {
          return _stemModelList;
        }).catchError((error) {
          debugPrint(error.toString());
        });
      }
      // await Future.forEach(response as List, (subject) async {
      //   SubjectModel _subjectModel = SubjectModel(
      //     boardName: _educationBoard ?? "cbse",
      //     classID: _classNumber,
      //     subjectID: subject['id'],
      //     subjectName: subject['name'],
      //   );
      //   String _dataString =
      //       "INSERT Into $tableSubjects (boardName, classID, subjectID, subjectName)"
      //       " VALUES (?, ?, ?, ?)";
      //
      //   var rowID = await helper.rawInsertSubjects(
      //       tableData: _dataString, subjectModel: _subjectModel);
      //   _subjectList.add(_subjectModel);
      //   debugPrint(rowID.toString());
      // }).then((value) {
      //   return _subjectList;
      // }).catchError((error) {
      //   debugPrint(error.toString());
      // });
      return _stemModelList;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future fetchVideoPracticalsList() async {
    String? stream;
    try {
      String? classNumber = await (getStringValuesSF("classNumber"));
      if ((int.parse(classNumber!)) > 10) {
        stream = await getStringValuesSF("stream"); //2
        classNumber = "${classNumber}_${stream!}";
      } else {
        classNumber = classNumber;
      }

      String educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String language = (await getStringValuesSF("language"))!.toLowerCase();

      var response = await apiHandler.getAPICall(
          endPointURL:
              "topics/${educationBoard.toLowerCase()}/$language/$classNumber/extra_content/video_practicals");

      List<StemModel> stemModelList = [];

      if (stemModelList != null) {
        List<String> subjectNameList =
            (response as Map).keys.toList() as List<String>;
        var subjectListResponse = await apiHandler.getAPICall(
            endPointURL:
                "video_practicals_subjects/${educationBoard.toLowerCase()}/$language/$classNumber");
        // debugPrint(subjectListResponse.toString());
        List<SubjectModel> subjectList = [];
        await Future.forEach((subjectListResponse as List), (dynamic subjects) {
          SubjectModel subject = SubjectModel(
            language: language,
            boardName: educationBoard.toLowerCase().toString(),
            classID: classNumber.toString(),
            subjectID: subjects["id"].toString(),
            subjectName: subjects["name"].toString(),
            subjectIconPath: subjects["icon"].toString(),
            subjectColor: subjects["color"].toString(),
          );
          subjectList.add(subject);
        });

        int subjectIndex = 0;
        await Future.forEach(response.values, (dynamic stemProjects) async {
          SubjectModel currentStemSubjectModel = subjectList.firstWhere(
              (element) =>
                  (element.subjectID == subjectNameList[subjectIndex]));

          StemModel stemModel = StemModel(
            subjectID: subjectNameList[subjectIndex],
            subjectName: currentStemSubjectModel.subjectName,
            subjectIconPath: (currentStemSubjectModel.subjectIconPath != null &&
                    currentStemSubjectModel.subjectIconPath!.isNotEmpty)
                ? currentStemSubjectModel.subjectIconPath
                : Constants.defaultSubjectImagePath,
            subjectColor: (currentStemSubjectModel.subjectColor != null &&
                    currentStemSubjectModel.subjectColor!.isNotEmpty)
                ? (int.parse(
                        currentStemSubjectModel.subjectColor!.substring(1, 7),
                        radix: 16) +
                    0xFF000000)
                : Constants.defaultSubjectHexColor,
          );
          List<Chapters> chaptersList = [];
          await Future.forEach(stemProjects as List,
              (dynamic chapterWiseVideos) async {
            List<VideoLessonModel> videoLessonModel = [];
            await Future.forEach(chapterWiseVideos['topics'] as List,
                (dynamic videos) async {
              videoLessonModel.add(VideoLessonModel(
                detail: videos['detail'],
                id: videos['id'],
                name: videos['name'],
                offlineLink: videos['offlineLink'],
                offlineThumbnail: videos['offlineThumbnail'],
                onlineLink: videos['onlineLink'],
                thumbnail: videos['thumbnail'],
                topicName: videos['topicName'],
              ));
            });
            chaptersList.add(
              Chapters(
                chapterName: videoLessonModel[0].topicName,
                videoLesson: videoLessonModel,
              ),
            );
            stemModel.chapterList = chaptersList;
          });
          stemModelList.add(stemModel);
          subjectIndex++;
        }).then((value) {
          return stemModelList;
        }).catchError((error) {
          debugPrint(error.toString());
        });
      }
      return stemModelList;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future fetchExtraBookContent() async {
    String? _stream;
    try {
      String? _classNumber = await (getStringValuesSF("classNumber"));
      if ((int.parse(_classNumber!)) > 10) {
        _stream = await getStringValuesSF("stream"); //2
        _classNumber = "${_classNumber}_${_stream!}";
      } else {
        _classNumber = _classNumber;
      }

      String _educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String _language = (await getStringValuesSF("language"))!.toLowerCase();

      var response = await apiHandler.getAPICall(
          endPointURL: /*"Test1/topics/" +*/ "topics/${_educationBoard.toLowerCase()}/$_language/$_classNumber/extra_content/books");

      if (response == null) {
        // content not available status update on firebase console
        basicContentsTexting.contentsStatus(
          subject: "dashboard",
          classNo: _classNumber,
          language: _language,
          board: _educationBoard.toLowerCase(),
          dataNotFoundIn: 'dashboard ExtraBook Not found',
        );
        return response;
      }

      List<ExtraBookModel> _extraBookList = [];

      if (_extraBookList != null) {
        List<String> _subjectNameList =
            (response as Map).keys.toList() as List<String>;
        int _subjectIndex = 0;
        await Future.forEach(response.values, (dynamic extraBooks) async {
          ExtraBookModel _bookModel = ExtraBookModel(
            subjectID: _subjectNameList[_subjectIndex],
          );
          List<ExtraBooks> _bookList = [];
          await Future.forEach(extraBooks as List, (dynamic book) async {
            _bookModel.subjectName = book['name'];
            List<Topics> _topicList = [];
            await Future.forEach(book['topics'] as List,
                (dynamic topics) async {
              _topicList.add(Topics(
                detail: topics['detail'],
                id: topics['id'],
                name: topics['name'],
                offlineLink: topics['offlineLink'],
                offlineThumbnail: topics['offlineThumbnail'],
                onlineLink: topics['onlineLink'],
                thumbnail: topics['thumbnail'],
                topicName: topics['topicName'],
              ));
            });
            ExtraBooks _book =
                ExtraBooks(bookName: book['name'], topics: _topicList);
            _bookList.add(_book);
          });
          _bookModel.bookList = _bookList;
          _extraBookList.add(_bookModel);
          _subjectIndex++;
        }).then((value) {
          debugPrint('extraBookList Rendered');
          return _extraBookList;
        }).catchError((error) {
          debugPrint(error.toString());
        });
      }
      return _extraBookList;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future saveBookLibraryReport({
    int? durationInSeconds,
    Topics? bookLibraryModel,
    String? boardID, //Change for saving assignment's progress
    String? classID, //Change for saving assignment's progress
    String? language, //Change for saving assignment's progress
  }) async {
    try {
      String? _userID = await getStringValuesSF("userID");
      String? _educationBoard =
          boardID ?? (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String _language =
          language ?? (await getStringValuesSF("language"))!.toLowerCase();
      String? _classNumber = classID;
      if (_classNumber == null) {
        _classNumber = await getStringValuesSF("classNumber");
        if ((int.parse(_classNumber!)) > 10) {
          String? _stream = await getStringValuesSF("stream");
          if (_stream != null) _classNumber = "${_classNumber}_$_stream";
        }
        _classNumber = _classNumber;
      }
      dbRef
          .child("reports")
          .child("app_reports")
          .child(_userID!)
          .child("data")
          .child(_classNumber)
          .child(_educationBoard)
          .child(_language)
          .child("books")
          .child(bookLibraryModel!.topicName!)
          .child(bookLibraryModel.name!)
          .push()
          .set({
        "updated_time": DateTime.now().toUtc().toString(),
        "book_id": bookLibraryModel.id,
        "book_name": bookLibraryModel.name,
        "book_category": bookLibraryModel.topicName,
        "duration": durationInSeconds.toString(),
        "total_pages": totalBookOrNotesPageCount.toString(),
        "page_read": totalReadBookOrNotesPageCount.toString(),
        "subject_name": bookLibraryModel.topicName,
        'user_name': appUser!.fullName,
        'class_name': _classNumber,
      }).then((_) async {
        debugPrint("Saved UsersBooks Data successfully");
        await myReportsRepository.saveOverallAppUses(
            subjectID: bookLibraryModel.topicName,
            categoryName: "stem_videos",
            className: _classNumber,
            userId: _userID,
            boardName: _educationBoard,
            language: _language,
            appUsesDuration: durationInSeconds.toString());
      }).catchError((onError) {
        debugPrint(onError);
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future prepQueryParameterStringForTestPrep() async {
    Map map = {
      "name": appUser!.fullName ?? "",
      "email": appUser!.email ?? "",
      "mobile": appUser!.mobile ?? "",
    };

    String jsonString = json.encode(map);

    return encryption(jsonString);
  }

  String encryption(String plainText) {
    // final key = encrypt.Key.fromLength(32);
    // final iv = encrypt.IV.fromLength(16);
    // final encrypter = encrypt.Encrypter(encrypt.AES(key));
    //
    // final encrypted = encrypter.encrypt(plainText, iv: iv);
    // // final decrypted = encrypter.decrypt(encrypted, iv: iv);
    //
    // // debugPrint(decrypted);
    // // debugPrint(encrypted.bytes);
    // // debugPrint(encrypted.base16);
    // // debugPrint(encrypted.base64);
    // return encrypted.base64;
    return  Uri.encodeComponent(plainText);
  }

  // String decryption(String plainText) {
  //
  //   // final key = Key.fromBase64(ENCRYPTION_KEY);
  //   // final iv = IV.fromBase64(ENCRYPTION_IV);
  //   //
  //   // final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
  //   // final decrypted = encrypter.decrypt(Encrypted.from64(plainText), iv: iv);
  //   //
  //   // return decrypted;
  // }

  // Future<SubjectDataModel?>? fetchSubjectData() async {
  //   SubjectDataModel? subjectDataModel;
  //   try {
  //     final response = await apiHandler.getAPICall(
  //         endPointURL: "/topics/cbse/english/9/subjects/math");
  //     subjectDataModel = SubjectDataModel.fromJson(response);
  //
  //     return await Future(() => subjectDataModel);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return await Future(() => null);
  //   }
  // }

  Future<SubjectReportModelList?>? fetchSubjectData() async {
    SubjectReportModelList? subjectReportModel;
    try {
      final response = await apiHandler.getAPICall(
          endPointURL:
              "/reports/app_reports/1XP8KUhDjCdHmsnopOBlcnuooml2/data/1/cbse/english/");
      subjectReportModel = SubjectReportModelList.fromJson(response);

      return await Future(() => subjectReportModel);
    } catch (e) {
      debugPrint(e.toString());
      return await Future(() => null);
    }
  }
}
