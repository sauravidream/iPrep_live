import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/local_db_helper.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/books_model.dart';
import 'package:idream/model/extra_book_model.dart';
import 'package:idream/model/notes_model.dart';
import 'package:idream/model/practice_model.dart';
import 'package:idream/model/stem.dart';
import 'package:idream/model/streams_model.dart';
import 'package:idream/model/subject_model.dart';
import 'package:idream/model/test_model.dart';
import 'package:idream/model/video_lesson.dart';

class AssignmentRepository {
  Future fetchStream(String selectedClass, Batch batch) async {
    try {
      String classNumber = selectedClass.replaceAll(RegExp(r'[^0-9]'), '');
      String board = batch.board!.toLowerCase();
      String? language = batch.language;

      var response = await apiHandler.getAPICall(
          endPointURL: "/streams/$board/$language/$classNumber");

      if (response == null) return response;

      List<StreamsModel> _streamList = [];
      await Future.forEach((response as List), (dynamic stream) async {
        StreamsModel streamsModel = StreamsModel(
            boardName: board,
            classID: classNumber,
            streamID: stream["id"],
            streamName: stream["name"],
            icon: stream["icon"]);
        _streamList.add(streamsModel);
      }).then((value) {
        return _streamList;
      }).catchError((error) {
        print(error.toString());
      });
      return _streamList;
    } catch (e) {
      print(e);
    }
  }

  Future fetchSubjectList(String url, String board, String classNumber) async {
    var response = await apiHandler.getAPICall(endPointURL: url);
    if (response == null) return response;

    List<SubjectModel> _subjectList = [];
    await Future.forEach((response as List), (dynamic subjects) {
      SubjectModel _subject = SubjectModel(
          boardName: board,
          classID: classNumber,
          subjectID: subjects["id"],
          subjectName: subjects["name"]);
      _subjectList.add(_subject);
    }).then((value) {
      return _subjectList;
    }).catchError((error) {
      print(error);
    });
    return _subjectList;
  }

  Future fetchSubject(String selectedOption, Batch batch, String? classNumber,
      StreamsModel? stream) async {
    String board = batch.boardId!.toLowerCase();
    String language = batch.language!.toLowerCase();

    var url = "";
    if (selectedOption == "Subjects") {
      url =
          "/subjects/$board/$language/$classNumber" /*"/Test/subjects/$board/$language/$classNumber"*/;
    } else if (selectedOption == "STEM Videos") {
      url =
          "/topics/$board/$language/$classNumber/extra_content/activity_videos" /*"/Test/topics/$board/$language/$classNumber/extra_content/activity_videos"*/;
    } else {
      url =
          "/topics/$board/$language/$classNumber/extra_content/books" /*"/Test/topics/$board/$language/$classNumber/extra_content/books"*/;
    }

    var response = await apiHandler.getAPICall(endPointURL: url);
    try {
      if (selectedOption == "Subjects") {
        List<SubjectModel> _subjectList = [];
        await Future.forEach((response as List), (dynamic subjects) {
          SubjectModel _subject = SubjectModel(
            boardName: board,
            classID: classNumber,
            subjectID: subjects["id"],
            subjectName: subjects["name"],
            subjectColor: subjects["color"],
            subjectIconPath: subjects["icon"],
            shortName: subjects['short_name'],
          );
          _subjectList.add(_subject);
        }).then((value) {
          return _subjectList;
        }).catchError((error) {
          print(error);
        });
        return _subjectList;
      } else if (selectedOption == "STEM Videos") {
        // String subjecturl =
        //     "/subjects/$board/$language/$classNumber" /*"/Test/subjects/$board/$language/$classNumber"*/;
        List<StemModel> _stemvidList = [];
        List<String> _subjectNameList =
            (response as Map).keys.toList() as List<String>;
        var subjectListResponse = await apiHandler.getAPICall(
            endPointURL:
                "activity_videos_subjects/$board/$language/$classNumber");
        List<SubjectModel> _subjectList = [];
        await Future.forEach((subjectListResponse as List), (dynamic subjects) {
          SubjectModel _subject = SubjectModel(
            boardName: board,
            classID: classNumber,
            subjectID: subjects["id"],
            subjectName: subjects["name"],
            subjectIconPath: subjects["icon"],
            subjectColor: subjects["color"],
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
          _stemvidList.add(_stemModel);
          _subjectIndex++;
        }).then((value) {
          return _stemvidList;
        }).catchError((error) {
          print(error);
        });
        return _stemvidList;
      } else {
        List<ExtraBookModel> _extraBookList = [];
        List<String> _bookNameList =
            (response as Map).keys.toList() as List<String>;
        int _bookIndex = 0;
        await Future.forEach(response.values, (dynamic extraBooks) async {
          ExtraBookModel _bookModel = ExtraBookModel(
            subjectID: _bookNameList[_bookIndex],
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
          _bookIndex++;
        }).then((value) {
          return _extraBookList;
        }).catchError((error) {
          print(error.toString());
        });
        return _extraBookList;
      }
    } catch (e) {
      print(e);
    }
  }

  Future fetchVideoLessons(
      String? subjectID, Batch batch, String? classID) async {
    try {
      String _educationBoard = batch.boardId!.toLowerCase();
      String _language = batch.language!.toLowerCase();
      String? _classNumber = classID;

      //Check if we already saved the data
      var localData = await helper
          .fetchChapterListBasisOnSubjectNameClassNameBoardNameLanguage(
        boardName: _educationBoard,
        className: _classNumber,
        subjectName: subjectID,
        language: _language,
      );

      if (localData.length > 0) {
        List<String?> chapterList = [];
        (localData as List<Map>).forEach((data) {
          chapterList.add(data["chapterName"]);
        });
        return chapterList;
      }

      var response = await apiHandler.getAPICall(
          endPointURL:
              "topics/$_educationBoard/$_language/$_classNumber/subjects/$subjectID/video_lessons/");

      if (response == null) return response;

      List<String?> chapterList = [];
      /*await Future.forEach((response as Map).values, (chapterList) async {*/
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
          print(rowID.toString());
        });
      }).then((value) {
        return chapterList;
      }).catchError((error) {
        print(error.toString());
      });
      return chapterList;
    } catch (error) {
      print(error);
    }
  }

  Future fetchVideoLessonsFromLocal(
      {String? subjectName,
      String? chapterName,
      required List<String?> chapterList,
      required Batch batch,
      String? classID}) async {
    Map<String, List<VideoLessonModel>?> _map = {};
    String _educationBoard = batch.board!.toLowerCase();
    String? _classNumber = classID;
    String _language = batch.language!.toLowerCase();

    // FirebaseDatabase.instance.ref("/topics/${batch.board}/${batch.language}/${batch.batchClass}/subjects${subjectName}").get().then((value) {
    //
    // });

    await Future.forEach(chapterList, (dynamic chapterTitle) async {
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
    return _map;
  }

  Future fetchPracticeTopicList(
      String? subjectID, Batch batch, String? classID) async {
    try {
      String _educationBoard = batch.board!.toLowerCase();
      String? _language = batch.language;
      String? _classNumber = classID;

      var response = await apiHandler.getAPICall(
          endPointURL:
              "topics/$_educationBoard/$_language/$_classNumber/subjects/$subjectID/practice/");

      if (response == null) return response;

      List<PracticeModel>? _practiceList = [];
      if (_practiceList != null) {
        _practiceList = response
            .map<PracticeModel>((i) => PracticeModel.fromJson(i))
            .toList();
      }
      return _practiceList;
    } catch (error) {
      print(error);
    }
  }

  Future fetchTestQuestions(
      String? subjectID, Batch batch, String? classID) async {
    try {
      try {
        String _educationBoard = batch.board!.toLowerCase();
        String _language = batch.language!.toLowerCase();
        String? _classNumber = classID;

        var response = await apiHandler.getAPICall(
            endPointURL: /*"Test1/topics/" +*/ "topics/$_educationBoard/$_language/$_classNumber/subjects/$subjectID/practice/");

        if (response == null) return response;

        List<TestModel>? _testList = [];

        if (_testList != null) {
          _testList =
              response.map<TestModel>((i) => TestModel.fromJson(i)).toList();
        }
        return _testList;
      } catch (error) {
        print(error);
      }
    } catch (error) {
      print(error);
    }
  }

  Future fetchNotesList(String? subjectID, Batch batch, String? classID) async {
    try {
      String _educationBoard = batch.board!.toLowerCase();
      String _language = batch.language!.toLowerCase();
      String? _classNumber = classID;

      var _locallySavedNotes =
          await helper.fetchNotesBasisOnSubjectNameClassNameBoardNameLanguage(
              subjectName: subjectID,
              className: _classNumber,
              language: _language,
              boardName: _educationBoard);

      if (_locallySavedNotes != null) {
        List<NotesModel>? _noteModelList = [];
        _noteModelList = _locallySavedNotes
            .map<NotesModel>((i) => NotesModel.fromMap(i))
            .toList();

        if (_noteModelList!.length > 0) return _noteModelList;
      }

      var response = await apiHandler.getAPICall(
          endPointURL: /*"Test1/topics/" +*/ "topics/$_educationBoard/$_language/$_classNumber/subjects/$subjectID/books_notes/");

      if (response == null) return response;

      List<NotesModel> _notesList = [];
      await Future.forEach(response as List, (dynamic notesList) async {
        await Future.forEach(notesList['topics'] as List, (dynamic note) async {
          NotesModel _notesModel = NotesModel(
            boardID: _educationBoard,
            classID: _classNumber,
            language: _language,
            subjectName: subjectID,
            chapterName: note["topicName"],
            noteDetails: note["detail"],
            noteID: note["id"],
            noteName: note["name"],
            noteOfflineLink: note["offlineLink"],
            noteOfflineThumbnail: note["offlineThumbnail"],
            noteOnlineLink: note["onlineLink"],
            noteThumbnail: note["thumbnail"],
            noteTopicName: note["topicName"],
          );
          String _dataString =
              "INSERT Into $tableNotes (boardID, classID, language, subjectName, chapterName, noteDetails, noteID, noteName, noteOfflineLink, noteOfflineThumbnail, noteOnlineLink, noteThumbnail, noteTopicName)"
              " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

          var rowID = await helper.rawInsertNotes(
              tableData: _dataString, notesModel: _notesModel);
          _notesList.add(_notesModel);
          print(rowID.toString());
        });
      }).then((value) {
        return _notesList;
      }).catchError((error) {
        print(error.toString());
      });
      return _notesList;
    } catch (error) {
      print(error);
    }
  }

  Future fetchBooksList(String? subjectID, Batch batch, String? classID) async {
    try {
      String _educationBoard = batch.board!.toLowerCase();
      String _language = batch.language!.toLowerCase();
      String? _classNumber = classID;

      var locallySavedBooks =
          await helper.fetchBooksBasisOnSubjectNameClassNameBoardNameLanguage(
              subjectName: subjectID,
              className: _classNumber,
              language: _language,
              boardName: _educationBoard);

      if (locallySavedBooks != null) {
        List<BooksModel>? _bookModelList = [];
        _bookModelList = locallySavedBooks
            .map<BooksModel>((i) => BooksModel.fromMap(i))
            .toList();

        if (_bookModelList!.length > 0) return _bookModelList;
      }

      var response = await apiHandler.getAPICall(
          endPointURL: /*"Test1/topics/" +*/ "topics/$_educationBoard/$_language/$_classNumber/subjects/$subjectID/books_ncert/");

      if (response == null) return response;

      List<BooksModel> _bookList = [];
      await Future.forEach(response as List, (dynamic bookList) async {
        await Future.forEach(bookList['topics'] as List, (dynamic book) async {
          BooksModel _booksModel = BooksModel(
            boardID: _educationBoard,
            classID: _classNumber,
            language: _language,
            subjectName: subjectID,
            chapterName: book["topicName"],
            bookDetails: book["detail"],
            bookID: book["id"],
            bookName: book["name"],
            bookOfflineLink: book["offlineLink"],
            bookOfflineThumbnail: book["offlineThumbnail"],
            bookOnlineLink: book["onlineLink"],
            bookThumbnail: book["thumbnail"],
            bookTopicName: book["topicName"],
          );
          String _dataString =
              "INSERT Into $tableBooks (boardID, classID, language, subjectName, chapterName, bookDetails, bookID, bookName, bookOfflineLink, bookOfflineThumbnail, bookOnlineLink, bookThumbnail, bookTopicName)"
              " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

          var rowID = await helper.rawInsertBooks(
              tableData: _dataString, booksModel: _booksModel);
          _bookList.add(_booksModel);
          print(rowID.toString());
        });
      }).then((value) {
        return _bookList;
      }).catchError((error) {
        print(error.toString());
      });
      return _bookList;
    } catch (error) {
      print(error);
    }
  }

  // Future saveAssignment(
  //     String contentType,
  //     String dataID,
  //     List<dynamic> dataContent,
  //     List<Batch> batchList,
  //     List<JoinedStudents> studentList,
  //     {@required String subjectName,
  //     String classNumber}) async {
  //   print(dataID);
  //   String _userID = await getStringValuesSF("userID");
  //   if (contentType == "Extra Books") {
  //     List<Map<String, dynamic>> result = [];
  //     dataContent.forEach((element) {
  //       result.add(element.toJson());
  //     });
  //     bool _response;
  //     try {
  //       if (dataContent != []) {
  //         batchList.forEach((element) async {
  //           await dbRef
  //               .child("assignments")
  //               .child(element.batchId)
  //               .child("extrabooks")
  //               .child(DateTime.now().microsecondsSinceEpoch.toString())
  //               .set({
  //             'extrabooks': result,
  //             'time': DateTime.now().toUtc().toString(),
  //             "subject_name": subjectName,
  //             "subject_id": dataID,
  //           }).then((value) async {
  //             await dbRef
  //                 .child("recentassignment")
  //                 .child(_userID)
  //                 .child(DateTime.now().microsecondsSinceEpoch.toString())
  //                 .set({
  //               'extrabooks': result,
  //               'time': DateTime.now().toUtc().toString(),
  //               "subject_name": subjectName,
  //               "subject_id": dataID,
  //             });
  //           }).then((value) {
  //             print("Assigned Successfully");
  //             _response = true;
  //             return _response;
  //           }).catchError((onError) {
  //             print(onError);
  //             _response = false;
  //             return false;
  //           });
  //           return _response;
  //         });
  //         studentList.forEach((element) async {
  //           await dbRef
  //               .child("assignments")
  //               .child(element.userID)
  //               .child("extrabooks")
  //               .child(DateTime.now().microsecondsSinceEpoch.toString())
  //               .set({
  //             'extrabooks': result,
  //             'time': DateTime.now().toUtc().toString(),
  //             "subject_name": subjectName,
  //             "subject_id": dataID,
  //           }).then((value) async {
  //             await dbRef
  //                 .child("recentassignment")
  //                 .child(_userID)
  //                 .child(DateTime.now().microsecondsSinceEpoch.toString())
  //                 .set({
  //               'extrabooks': result,
  //               'time': DateTime.now().toUtc().toString(),
  //               "subject_name": subjectName,
  //               "subject_id": dataID,
  //             });
  //           }).then((value) {
  //             print("Assigned Successfully");
  //             _response = true;
  //             return _response;
  //           }).catchError((onError) {
  //             print(onError);
  //             _response = false;
  //             return false;
  //           });
  //           return _response;
  //         });
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else if (contentType == "Stem Videos") {
  //     List<Map<String, dynamic>> result = [];
  //     dataContent.forEach((element) {
  //       result.add(element.toJson());
  //     });
  //     bool _response;
  //     try {
  //       if (dataContent != []) {
  //         batchList.forEach((element) async {
  //           await dbRef
  //               .child("assignments")
  //               .child(element.batchId)
  //               .child("stemvideos")
  //               .child(DateTime.now().microsecondsSinceEpoch.toString())
  //               .set({
  //             'stemvideos': result,
  //             'time': DateTime.now().toUtc().toString(),
  //             "subject_name": subjectName,
  //             "subject_id": dataID,
  //           }).then((value) async {
  //             await dbRef
  //                 .child("recentassignment")
  //                 .child(_userID)
  //                 .child(DateTime.now().microsecondsSinceEpoch.toString())
  //                 .set({
  //               'stemvideos': result,
  //               'time': DateTime.now().toUtc().toString(),
  //               "subject_name": subjectName,
  //               "subject_id": dataID,
  //             });
  //           }).then((value) {
  //             print("Assigned Successfully");
  //             _response = true;
  //             return _response;
  //           }).catchError((onError) {
  //             print(onError);
  //             _response = false;
  //             return false;
  //           });
  //           return _response;
  //         });
  //         studentList.forEach((element) async {
  //           await dbRef
  //               .child("assignments")
  //               .child(element.userID)
  //               .child("stemvideos")
  //               .child(DateTime.now().microsecondsSinceEpoch.toString())
  //               .set({
  //             'stemvideos': result,
  //             'time': DateTime.now().toUtc().toString(),
  //             "subject_name": subjectName,
  //             "subject_id": dataID,
  //           }).then((value) async {
  //             await dbRef
  //                 .child("recentassignment")
  //                 .child(_userID)
  //                 .child(DateTime.now().microsecondsSinceEpoch.toString())
  //                 .set({
  //               'stemvideos': result,
  //               'time': DateTime.now().toUtc().toString(),
  //               "subject_name": subjectName,
  //               "subject_id": dataID,
  //             });
  //           }).then((value) {
  //             print("Assigned Successfully");
  //             _response = true;
  //             return _response;
  //           }).catchError((onError) {
  //             print(onError);
  //             _response = false;
  //             return false;
  //           });
  //           return _response;
  //         });
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else {
  //     List<Map<String, dynamic>> result = [];
  //     String _language = (await getStringValuesSF("language")).toLowerCase();
  //     dataContent.forEach((element) {
  //       result.add({
  //         "assignment_details": element.toJson(),
  //         "student_report":studentList.map((e) => e.toJson()).toList(),
  //       });
  //       print(result);
  //     });
  //     bool _response;
  //     try {
  //       if (dataContent != []) {
  //         String type =
  //             contentType.substring(7, contentType.length).toLowerCase();
  //         batchList.forEach((element) async {
  //           await dbRef
  //               .child("assignments")
  //               .child(element.batchId)
  //               .child("subjects")
  //               .child(DateTime.now().microsecondsSinceEpoch.toString())
  //               .set({
  //             '$type': result,
  //             'time': DateTime.now().toUtc().toString(),
  //             "subject_name": subjectName,
  //             "subject_id": dataID,
  //             "class_number": classNumber,
  //             'language': _language,
  //           }).then((value) async {
  //             await dbRef
  //                 .child("recentassignment")
  //                 .child(_userID)
  //                 .child(DateTime.now().microsecondsSinceEpoch.toString())
  //                 .set({
  //               '$type': result,
  //               'time': DateTime.now().toUtc().toString(),
  //               "subject_name": subjectName,
  //               "subject_id": dataID,
  //               "class_number": classNumber,
  //               'language': _language,
  //             });
  //           }).then((value) {
  //             print("Assigned Successfully");
  //             _response = true;
  //             return _response;
  //           }).catchError((onError) {
  //             print(onError);
  //             _response = false;
  //             return false;
  //           });
  //           return _response;
  //         });
  //         studentList.forEach((element) async {
  //           await dbRef
  //               .child("assignments")
  //               .child(element.userID)
  //               .child("subjects")
  //               .child(DateTime.now().microsecondsSinceEpoch.toString())
  //               .set({
  //             '$type': result,
  //             'time': DateTime.now().toUtc().toString(),
  //             "subject_name": subjectName,
  //             "subject_id": dataID,
  //             "class_number": classNumber,
  //             'language': _language,
  //           }).then((value) async {
  //             await dbRef
  //                 .child("recentassignment")
  //                 .child(_userID)
  //                 .child(DateTime.now().microsecondsSinceEpoch.toString())
  //                 .set({
  //               '$type': result,
  //               'time': DateTime.now().toUtc().toString(),
  //               "subject_name": subjectName,
  //               "subject_id": dataID,
  //               "class_number": classNumber,
  //               'language': _language,
  //             });
  //           }).then((value) {
  //             print("Assigned Successfully");
  //             _response = true;
  //             return _response;
  //           }).catchError((onError) {
  //             print(onError);
  //             _response = false;
  //             return false;
  //           });
  //           return _response;
  //         });
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  Future saveAssignmentDetails(
      String contentType,
      String? dataID,
      List<dynamic> dataContent,
      Batch batchInfo,
      List<JoinedStudents> studentList,
      {required String? subjectName,
      required String assignmentDueDate,
      String? classNumber}) async {
    try {
      if (dataContent != null && dataContent.length != 0) {
        String? _userID = await getStringValuesSF("userID");
        String? _language = batchInfo.language;
        List<Map<String, dynamic>> _jsonFormattedData = [];
        Map<String?, dynamic> _studentDetailsMap = {};
        studentList.forEach((student) {
          _studentDetailsMap.addAll({student.userID: student.toJson()});
        });
        dataContent.forEach((element) {
          _jsonFormattedData.add({
            "assignment_details": element.toJson(),
            "student_report": _studentDetailsMap,
          });
        });

        String _assignmentTypeNodeName;
        String _internalAttributeName;
        String _categoryNameForNotification;

        switch (contentType) {
          case "Extra Books":
            _assignmentTypeNodeName = "extra_books";
            _internalAttributeName = "extra_books";
            _categoryNameForNotification = "Books and Stories";
            break;
          case "Stem Videos":
            _assignmentTypeNodeName = "stem_videos";
            _internalAttributeName = "stem_videos";
            _categoryNameForNotification = "Stem Videos";
            break;
          default:
            _assignmentTypeNodeName = "subjects";
            _internalAttributeName =
                contentType.substring(7, contentType.length).toLowerCase();
            _categoryNameForNotification =
                contentType.substring(7, contentType.length);
            break;
        }
        bool? _response;
        String _assignmentNodeName =
            DateTime.now().microsecondsSinceEpoch.toString();
        await dbRef
            .child("assignments")
            .child(batchInfo.batchId!)
            .child(_assignmentTypeNodeName)
            .child(_assignmentNodeName)
            .set({
          _internalAttributeName: _jsonFormattedData,
          'time': DateTime.now().toUtc().toString(),
          "teacher_id": _userID,
          "subject_name": subjectName,
          "subject_id": dataID,
          "class_number": classNumber,
          'language': _language,
          'due_date': assignmentDueDate,
        }).then((value) async {
          await Future.forEach(studentList, (dynamic studentInfo) async {
            await dbRef
                .child("recent_assignment")
                .child(_userID!)
                .child(_assignmentNodeName)
                .set({
              _internalAttributeName: _jsonFormattedData,
              'time': DateTime.now().toUtc().toString(),
              "subject_name": subjectName,
              "subject_id": dataID,
              "class_number": classNumber,
              'language': _language,
              'due_date': assignmentDueDate,
              'batch_id': batchInfo.batchId,
            });
          }).then((value) async {
            print("Assigned Successfully");
          });
        }).then((value) async {
          //Save Data for sending notification as well
          await Future.forEach(studentList, (dynamic studentInfo) async {
            await dbRef.child("notifications/Topics/messages/").push().set({
              "from": _userID,
              "message": "Assigned $contentType to you.",
              "category_name": _categoryNameForNotification,
              "message_type": "Showable",
              "time": DateTime.now().toUtc().toString(),
              "to": studentInfo.userID,
              "sender_name": batchInfo.teacherName,
              "user_type": "Teacher",
              "sender_profile_image": batchInfo.teacherProfilePhoto,
              'batch_name': batchInfo.batchName,
              "batch_id": batchInfo.batchId,
              "subject_name": subjectName,
            }).then((value) async {
              print("Saved assignment for notification successfully.");
              //Save Data for displaying it on notification page
              await dbRef
                  .child("notification/students/")
                  .child(studentInfo.userID)
                  .child(_assignmentNodeName)
                  .set({
                "title": batchInfo.teacherName,
                "sender_name": batchInfo.teacherName,
                "sender_id": _userID,
                "message":
                    "Assigned $subjectName's ${contentType.contains("Subject") ? contentType.replaceFirst("Subject", "") : contentType} to you in batch ${batchInfo.batchName}.",
                "show_message": true,
                "message_opened": false,
                "time": DateTime.now().toUtc().toString(),
                "user_type": "Teacher",
                "sender_profile_image": batchInfo.teacherProfilePhoto,
                'batch_name': batchInfo.batchName,
                "batch_id": batchInfo.batchId,
                "subject_name": subjectName,
                "assignment_data": {_internalAttributeName: _jsonFormattedData},
                "notification_type": "assignment",
              }).then((value) async {
                print(
                    "Saved assignment successfully to display it on Notification Page.");
              });
            });
          }).then((value) async {
            print("Assigned Successfully");
            _response = true;
            return _response;
          });
        }).catchError((onError) {
          print(onError);
          _response = false;
          return false;
        });
        return _response;
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<dynamic> getAssignments(Batch selectedBatch) async* {
    yield* dbRef.child("/assignments/${selectedBatch.batchId}").onValue;
  }

  Future fetchAssignments(Batch selectedBatch) async {
    try {
      var response = await apiHandler.getAPICall(
          endPointURL: "/assignments/${selectedBatch.batchId}");

      if (response == null) return response;
      List<String> _categoryNames =
          (response as Map).keys.toList() as List<String>;
      List<dynamic> assignedList = [];
      int _categoryIndex = 0;
      await Future.forEach(response.values, (dynamic assigned) async {
        if (response[_categoryNames[_categoryIndex]] != null) {
          List<String> _assignmentIds =
              (assigned as Map).keys.toList() as List<String>;
          int _assignmentIndex = 0;
          await Future.forEach(assigned.values, (dynamic assignment) {
            (assignment)
                .addAll({"assignment_id": _assignmentIds[_assignmentIndex]});
            assignedList.add(assignment);
            _assignmentIndex++;
          });
        }
        _categoryIndex++;
      }).then((value) {
        return assignedList.reversed;
      }).catchError((error) {
        print(error);
      });
      return assignedList;
    } catch (e) {
      print(e);
    }
  }

  Future recentAssignments() async {
    try {
      String? _userID = await getStringValuesSF("userID");
      var response = await apiHandler.getAPICall(
          endPointURL: "/recent_assignment/$_userID");

      if (response == null) return response;

      List<dynamic> rassignmentlist = [];
      await Future.forEach((response as Map).values,
          (dynamic assignment) async {
        rassignmentlist.add(assignment);
      }).then((value) async {
        if (rassignmentlist.length > 3) {
          rassignmentlist.sublist(
              rassignmentlist.length - 3, rassignmentlist.length);
        }
        return rassignmentlist;
      }).catchError((e) {
        print(e);
      });
      return rassignmentlist;
    } catch (e) {
      print(e);
    }
  }

  Future deleteAssignment({
    required String? batchId,
    required dynamic assignmentDetails,
  }) async {
    bool? _response;
    String _assignmentPath =
        "assignments/$batchId/${assignmentDetails['assignment_category']}/${assignmentDetails['assignment_id']}/${assignmentDetails['assignment_sub_category']}/${assignmentDetails['item_index']}";

    await dbRef.child(_assignmentPath).remove().then((_) async {
      //Deleting same assignment from recent assignment node for each student of this batch.
      await Future.forEach(assignmentDetails['student_report'],
          (dynamic joinedStudent) async {
        await dbRef
            .child("recent_assignment")
            .child(joinedStudent.userID)
            .child(assignmentDetails['assignment_id'])
            .child(assignmentDetails['assignment_sub_category'])
            .child(assignmentDetails['item_index'])
            .remove();
      }).then((_) {
        print(" Data deleted successfully");
        _response = true;
      });
    }).catchError((onError) {
      print(onError);
      _response = false;
    });
    return _response;
  }

  Future updateAssignmentEndDate(
      {required String? batchId,
      required dynamic assignmentDetails,
      required updatedDueDate}) async {
    bool? _response;
    String _assignmentPath =
        "assignments/$batchId/${assignmentDetails['assignment_category']}/${assignmentDetails['assignment_id']}";

    await dbRef.child(_assignmentPath).update({
      "due_date": updatedDueDate,
    }).then((_) async {
      print("Assignment End Date updated successfully");
      await Future.forEach(assignmentDetails['student_report'],
          (dynamic joinedStudent) async {
        await dbRef
            .child("recent_assignment")
            .child(joinedStudent.userID)
            .child(assignmentDetails['assignment_id'])
            .child(assignmentDetails['assignment_sub_category'])
            .child(assignmentDetails['item_index'])
            .remove();
      }).then((_) {
        print("Assignment End date updated in Recent assignments successfully");
        _response = true;
      });
    }).catchError((onError) async {
      print(onError);
      _response = false;
    });
    return _response;
  }
}
