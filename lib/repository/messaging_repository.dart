import 'package:flutter/foundation.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/batch_model.dart';

class MessagingRepository {
  Future saveBatchChat({
    String? messageText,
    required Batch batchInfo,
    String messageType = "Showable",
    String userType = "Teacher",
  }) async {
    try {
      String? _userID = await (getStringValuesSF("userID"));

      await dbRef
          .child("chat")
          .child('group_chat')
          .child(batchInfo.batchId!)
          .child(_userID!)
          .push()
          .set({
        "from": _userID,
        "message": messageText,
        "message_type": messageType,
        "time": DateTime.now().toUtc().toString(),
        "user_type": userType,
      }).then((_) async {
        print("Saved Batch Chat Data successfully");
        Future.forEach(batchInfo.joinedStudentsList!,
            (dynamic joinedStudent) async {
          await dbRef.child("notifications/messages/").push().set({
            'batch_name': batchInfo.batchName,
            'class_id': batchInfo.batchClass,
            "from": batchInfo.teacherId,
            "sender_profile_image": batchInfo.teacherProfilePhoto,
            "sender_name": batchInfo.teacherName,
            "batch_id": batchInfo.batchId,
            "message": messageText,
            "message_type": messageType,
            "time": DateTime.now().toUtc().toString(),
            "to": joinedStudent.userID,
            'to_name': joinedStudent.fullName,
            "user_type": userType,
          });
        }).then((value) async {
          print("Saved Group chat for sending notification to Receiver.");
          return true;
        });

        return true;
      }).catchError((onError) {
        print(onError);
        return true;
      });
      return true;
    } catch (error) {
      print(error);
      return true;
    }
  }

  Future saveOneToOneChat({
    required String receiverUserID,
    String? receiverName,
    String? messageText,
    String messageType = "Showable",
    String userType = "Teacher",
    String? senderProfileImage = Constants.defaultProfileImagePath,
    String? receiverProfileImage = Constants.defaultProfileImagePath,
  }) async {
    String? senderProfileImage = await getStringValuesSF("profilePhoto");

    try {
      if (senderProfileImage != null) {
        senderProfileImage = Constants.defaultProfileImagePath;
      }
      if (receiverProfileImage != null) {
        receiverProfileImage = Constants.defaultProfileImagePath;
      }
      String? userType = await getStringValuesSF("UserType");
      String? _loggedInUserTypeNode = await (userRepository.getUserNodeName());
      String _otherPersonUserTypeNode = 'teachers';

      if (userType != "Student") {
        userType = "Teacher";
        _otherPersonUserTypeNode = 'students';
      }

      String? _senderUserID = await (getStringValuesSF("userID"));
      String? _fullName = await getStringValuesSF("fullName");

      await dbRef
          .child("chat")
          .child('one_to_one_chat')
          .child(_loggedInUserTypeNode!)
          .child(_senderUserID!)
          .child(receiverUserID)
          .child(DateTime.now().microsecondsSinceEpoch.toString())
          .set({
        "from": _senderUserID,
        "message": messageText,
        "to": receiverUserID,
        "message_type": messageType,
        "type": "Sent",
        "time": DateTime.now().toUtc().toString(),
        "user_type": userType,
        "sender_profile_image": senderProfileImage,
        "sender_name": _fullName,
      }).then((_) async {
        await dbRef
            .child("chat")
            .child('one_to_one_chat')
            .child(_otherPersonUserTypeNode)
            .child(receiverUserID)
            .child(_senderUserID)
            .child(DateTime.now().microsecondsSinceEpoch.toString())
            .set({
          "from": _senderUserID,
          "message": messageText,
          "to": receiverUserID,
          "message_type": messageType,
          "type": "Receive",
          "time": DateTime.now().toUtc().toString(),
          "user_type": userType,
          "sender_profile_image": senderProfileImage,
          "sender_name": _fullName,
        }).then((value) async {
          await dbRef
              .child("recent_chats")
              .child(_loggedInUserTypeNode)
              .child(_senderUserID)
              .child(receiverUserID)
              .set({
            "user_id": receiverUserID,
            "name": receiverName,
            "time": DateTime.now().toUtc().toString(),
            "image": receiverProfileImage,
          }).then((value1) async {
            String? _senderName = await getStringValuesSF("fullName");
            await dbRef
                .child("recent_chats")
                .child(_otherPersonUserTypeNode)
                .child(receiverUserID)
                .child(_senderUserID)
                .set({
              "user_id": _senderUserID,
              "name": _senderName,
              "time": DateTime.now().toUtc().toString(),
              "image": senderProfileImage,
            }).then((value) async {
              //Save Data for notification as well
              await dbRef.child("notifications/messages/").push().set({
                "from": _senderUserID,
                "message": messageText,
                "message_type": messageType,
                "time": DateTime.now().toUtc().toString(),
                "to": receiverUserID,
                "sender_name": _senderName,
                // "type": "Receive",
                "user_type": userType,
                "sender_profile_image": senderProfileImage,
                'batch_name': "",
                "batch_id": "",
                // "sender_profile_image": senderProfileImage,
                // "sender_name": _fullName,
              }).then((value) {
                print(
                    "Saved one to one chat for sending notification to Receiver.");
                return true;
              });
            });
          });
        });
      }).catchError((onError) {
        print(onError);
        return true;
      });
      return true;
    } catch (error) {
      print(error);
      return true;
    }
  }

  Future sendBroadcastMessageToAllBatches(
      {required List<Batch>? batchList, String? messageText}) async {
    bool _response = false;
    try {
      await Future.forEach(batchList!, (dynamic batchDetails) async {
        await messagingRepository.saveBatchChat(
          messageText: messageText,
          batchInfo: batchDetails,
        );
      }).then((_) {
        _response = true;
      });
    } catch (e) {
      debugPrint("sendBroadcastMessageToAllBatches() $e");
      _response = false;
    }
    return _response;
  }

  Future sendNewMessageToSelectedBatchesOrStudents({
    List<Batch>? batchList,
    List<JoinedStudents>? studentsList,
    List<int>? selectedBatchesOrStudentsIndexes,
    String? messageText,
  }) async {
    bool _response = false;
    try {
      if (studentsList != null && studentsList.isNotEmpty) {
        List<JoinedStudents> _newStudentsList = [];
        await Future.forEach(selectedBatchesOrStudentsIndexes!,
            (dynamic index) {
          _newStudentsList.add(studentsList[index]);
        });

        String? _loggedInUserProfileImage =
            await getStringValuesSF('profilePhoto');
        await Future.forEach(_newStudentsList, (dynamic studentDetails) async {
          await saveOneToOneChat(
            messageText: messageText,
            senderProfileImage: _loggedInUserProfileImage,
            receiverName: (studentDetails as JoinedStudents).fullName,
            receiverUserID: studentDetails.userID!,
            receiverProfileImage: studentDetails.profileImage,
          );
        }).then((_) {
          _response = true;
        });
      } else {
        List<Batch> _newBatchesList = [];
        await Future.forEach(selectedBatchesOrStudentsIndexes!,
            (dynamic index) {
          _newBatchesList.add(batchList![index]);
        });
        _response = await (sendBroadcastMessageToAllBatches(
            batchList: _newBatchesList, messageText: messageText));
      }
    } catch (e) {
      print("sendNewMessageToSelectedBatchesOrStudents() $e");
      _response = false;
    }
    return _response;
  }
}
