import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/model/subject_model.dart';

class BatchRepository {
  Stream<dynamic> getBatchList() async* {
    String? _currentUserId = await getStringValuesSF('userID');
    yield* dbRef.child("/batch/$_currentUserId").onValue;
  }

  Future fetchBatchList({String? subjectID}) async {
    try {
      String? _currentUserId = await getStringValuesSF('userID');
      var response =
          await apiHandler.getAPICall(endPointURL: "/batch/$_currentUserId");

      if (response == null) return response;
      List<Batch> _batchList = [];

// Stream.fromIterable((response).values).forEach((element) {
//   List<Batch> _batchList = [];
//   _batchList.add(element as Batch);
//   debugPrint(element.toString());
//   debugPrint(_batchList.toString());
//
//   Batch batchModel=Batch(
//
//   );
//
//
//
// });
      await Future.forEach((response as Map).values, (dynamic batch) async {
        Batch batchModel = Batch(
            batchId: batch["batchId"],
            batchClass: batch["batchClass"],
            batchCode: batch["batchCode"],
            batchName: batch["batchName"],
            teacherId: batch["teacherId"],
            teacherName: batch["teacherName"],
            deeplink: batch["deeplink"],
            language: batch["language"],
            board: batch["board"],
            boardId: batch["boardId"],
            batchSubject: batch["subjects"]
                .map<SubjectModel>((i) => SubjectModel.fromJson(i))
                .toList(),
            joinedStudentsList: (batch["students"] != null
                ? batch["students"]
                    .values
                    .map<JoinedStudents>((i) => JoinedStudents.fromJson(i))
                    .toList()
                : []),
            teacherProfilePhoto: batch['profile_photo']);
        List<SubjectModel> _locallySavedSubject = [];
        await Future.forEach(batch["subjects"] as List, (dynamic bentity) {
          _locallySavedSubject.add(SubjectModel(
              subjectName: bentity['subjectName'],
              subjectID: bentity['subjectID']));
        });
        batchModel.batchSubject = _locallySavedSubject;
        _batchList.add(batchModel);
      }).then((value) {
        return _batchList;
      }).catchError((error) {
        debugPrint(error.toString());
      });
      return _batchList;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  // ignore: missing_return
  Future updateBatch(Batch batch) async {
    List<Map<String, dynamic>> result2 = [];

    batch.batchSubject!.forEach((item) {
      result2.add(item.toJson());
    });

    bool? _response;

    String? _currentUserId = await (getStringValuesSF('userID'));
    await dbRef
        .child("batch")
        .child(_currentUserId!)
        .child(batch.batchId!)
        .update({
      // "batchCode": batch.batchCode,
      "batchName": batch.batchName,
      "board": batch.board,
      "language": batch.language,
      "batchClass": batch.batchClass,
      "subjects": result2,
      // "batchId": batch.batchId,
      // "teacherId": batch.teacherId,
      // "teacherName": batch.teacherName,
      // "deeplink": batch.deeplink,
// "language":batch.language
    }).then((_) async {
      debugPrint("Batch Data updated successfully");
      _response = true;
    }).catchError((onError) async {
      debugPrint(onError.toString());
      _response = false;
    });
    return _response;
  }

  Future deleteBatch(Batch batchInfo) async {
    bool? _response;
    String? _currentUserId = await (getStringValuesSF('userID'));
    await dbRef
        .child("batch")
        .child(_currentUserId!)
        .child(batchInfo.batchId!)
        .remove()
        .then((_) async {
      //TODO: Delete chat
      await dbRef
          .child("chat")
          .child(batchInfo.batchId!)
          .remove()
          .then((_) async {
        //Delete this batch from all the students's profile who had joined the same.
        await Future.forEach(batchInfo.joinedStudentsList!,
            (dynamic joinedStudent) async {
          await dbRef
              .child("users")
              .child("students")
              .child(joinedStudent.userID)
              .child(batchInfo.batchId!)
              .remove();
        }).then((_) {
          debugPrint(" Data deleted successfully");
          _response = true;
        });
      });
    }).catchError((onError) {
      debugPrint(onError.toString());
      _response = false;
    });
    return _response;
  }

  Future saveBatchData({
    String? batchName,
    required List<SubjectModel> subjectList,
    String? batchCode,
    required String batchId,
    String? teacherId,
    String? teacherName,
    String? boardId,
    String? deeplink,
    String? classId,
    String? language,
    String? board,
  }) async {
    List<Map<String, dynamic>> result2 = [];
    subjectList.forEach((item) {
      result2.add(item.toJson());
    });
    bool? _response;
    try {
      String? _currentUserId = await (getStringValuesSF('userID'));
      String? _profilePhoto = await getStringValuesSF('profilePhoto');

      await dbRef.child("batch").child(_currentUserId!).child(batchId).set({
        "subjects": result2,
        "batchCode": batchCode,
        "batchName": batchName,
        "batchId": batchId,
        "teacherId": teacherId,
        "teacherName": teacherName,
        "boardId": boardId,
        "deeplink": deeplink,
        "language": language,
        "batchClass": classId,
        "board": board,
        "board_id": boardId,
        "student": {},
        "profile_photo": _profilePhoto ?? Constants.defaultProfileImagePath,
      }).then((_) async {
        //Adding data for supporting batch joining using batch code.
        await dbRef.child("facilitator/ClassesByTeacherCode/$batchCode").set({
          "teacherID": teacherId,
          "shareCode": batchCode,
          "batchId": batchId,
          "subjects": result2,
          "batchCode": batchCode,
          "batchName": batchName,
          "teacherId": teacherId,
          "teacherName": teacherName,
          "boardId": boardId,
          "deeplink": deeplink,
          "language": language,
          "batchClass": classId,
          "board": board,
          "board_id": boardId,
          "student": {},
          "profile_photo": _profilePhoto ?? Constants.defaultProfileImagePath,
        }).then((value) {
          debugPrint("Created Batch successfully");
          _response = true;
        });
        return true;
      }).catchError((onError) {
        debugPrint(onError);
        _response = false;
        return false;
      });
      return _response;
    } catch (error) {
      debugPrint(error.toString());
      _response = false;
      return false;
    }
  }

  Future addStudentToSelectedBatch(
      {required String batchId, required String teacherId}) async {
    // List<Map<String, dynamic>> result2 = [];
    // subjectList.forEach((item) {
    //   result2.add(item.toJson());
    // });
    bool? _response;
    String? _studentUserId = await (getStringValuesSF("userID"));
    String? _fullName = await getStringValuesSF("fullName");
    String? _profilePhoto = await getStringValuesSF("profilePhoto");

    try {
      await dbRef
          .child("batch")
          .child(teacherId)
          .child(batchId)
          .child("students")
          .child(_studentUserId!)
          .update({
        'user_id': _studentUserId,
        'profile_photo': _profilePhoto ?? Constants.defaultProfileImagePath,
        'student_name': _fullName,
      }).then((_) async {
        debugPrint("Student added to the Batch successfully");
        //Now Add this batch to user's profile
        await dbRef
            .child("users")
            .child("students")
            .child(_studentUserId)
            .child("joined_batches")
            .child(batchId)
            .update({
          'batch_id': batchId,
          'teacher_id': teacherId,
        }).then((_) {
          _response = true;
          return true;
        });
      }).catchError((onError) {
        debugPrint(onError);
        _response = false;
        return false;
      });
      return _response;
    } catch (error) {
      debugPrint(error.toString());
      _response = false;
      return false;
    }
  }

  Future removeStudentFromBatch(
      {required String batchId, required String studentUserId}) async {
    bool? _response;
    try {
      String? _currentUserId = await (getStringValuesSF('userID'));
      await dbRef
          .child("batch")
          .child(_currentUserId!)
          .child(batchId)
          .child("students")
          .child(studentUserId)
          .remove()
          .then((_) async {
        debugPrint("Data deleted successfully");
        await dbRef
            .child("users")
            .child("students")
            .child(studentUserId)
            .child("joined_batches")
            .child(batchId)
            .remove()
            .then((_) {
          _response = true;
          return true;
        });
      }).catchError((onError) {
        debugPrint(onError.toString());
        _response = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      _response = false;
    }
    return _response;
  }

  Future fetchBatchListJoinedByLoggedInStudents({String? subjectID}) async {
    try {
      String? _currentUserId = await getStringValuesSF('userID');
      var response = await apiHandler.getAPICall(
          endPointURL: "users/students/$_currentUserId/joined_batches");

      if (response == null) return response;
      List<Batch> _batchList = [];
      await Future.forEach((response as Map).values, (dynamic batch) async {
        var _batchInfo = await apiHandler.getAPICall(
            endPointURL: "batch/${batch['teacher_id']}/${batch['batch_id']}");
        if ((_batchInfo != null) && (_batchInfo["batchId"] != null)) {
          Batch batchModel = Batch(
              batchId: _batchInfo["batchId"],
              batchClass: _batchInfo["batchClass"],
              batchCode: _batchInfo["batchCode"],
              batchName: _batchInfo["batchName"],
              teacherId: _batchInfo["teacherId"],
              teacherName: _batchInfo["teacherName"],
              deeplink: _batchInfo["deeplink"],
              language: _batchInfo["language"],
              board: _batchInfo["board"],
              boardId: _batchInfo["board_id"],
              batchSubject: _batchInfo["subjects"]
                  .map<SubjectModel>((i) => SubjectModel.fromJson(i))
                  .toList(),
              joinedStudentsList: (_batchInfo["students"] != null
                  ? _batchInfo["students"]
                      .values
                      .map<JoinedStudents>((i) => JoinedStudents.fromJson(i))
                      .toList()
                  : []),
              teacherProfilePhoto: _batchInfo['profile_photo']);
          List<SubjectModel> _locallySavedSubject = [];
          await Future.forEach(_batchInfo["subjects"] as List,
              (dynamic bentity) {
            _locallySavedSubject.add(SubjectModel(
                subjectName: bentity['subjectName'],
                subjectID: bentity['subjectID']));
          });
          batchModel.batchSubject = _locallySavedSubject;
          _batchList.add(batchModel);
        }
      }).then((value) {
        return _batchList;
      }).catchError((error) {
        debugPrint(error.toString());
      });
      return _batchList;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future fetchBatchDetails({String? batchId, String? teacherId}) async {
    var _response =
        await apiHandler.getAPICall(endPointURL: "/batch/$teacherId/$batchId");
    if (_response != null) {
      Batch _batchDetails = Batch.fromJson(_response);
      return _batchDetails;
    } else {
      return _response;
    }
  }
}
