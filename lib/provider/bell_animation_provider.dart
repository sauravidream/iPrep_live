import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/model/chat_model.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/ui/dashboard/batches/student_batch_details_page.dart';
import 'package:idream/ui/dashboard/batches/student_profile_one_to_one_messaging.dart';
import 'package:idream/ui/teacher/one_to_one_messaging.dart';

class BellAnimationProvider extends ChangeNotifier {
  late AnimationController heartAnimationController;
  Animation? heartAnimation;
  List<ChatModel> localChatList = [];

  initialiseHearAnimation(TickerProvider vsync) {
    heartAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 4),
      lowerBound: 0.7,
    );
    heartAnimation = Tween(
      begin: 0.5,
      end: 1,
    ).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: heartAnimationController));
  }

  initialisePushNotificationAnimation() {
    TickerFuture tickerFuture = heartAnimationController.repeat();
    notifyListeners();
    tickerFuture.timeout(const Duration(seconds: 10), onTimeout: () {
      heartAnimationController.forward(from: 0);
      heartAnimationController.stop(canceled: true);
    });
  }

  Future fetchLocallySavedUnreadMessages() async {
    localChatList.clear();
    String? userID = await getStringValuesSF("userID");
    String? userType = await getStringValuesSF("UserType");
    if (userType != null && userType == "Coach") {
      userType = "Student";
    } else {
      userType = "Teacher";
    }

    var locallySavedMessages = await helper.fetchChatFromLocalDB(
        receiverId: userID, userType: userType);
    List<ChatModel> chatData = locallySavedMessages
        .map<ChatModel>((i) => ChatModel.fromMap(i))
        .toList();
    localChatList = chatData.reversed.toList();
    notifyListeners();
  }

  Future deleteLocallySavedChatMessage(
      {int? messageId, required ChatModel chatModel}) async {
    if (chatModel.batchId != null) {
      await helper.deleteAllBatchMessages(batchId: chatModel.batchId);
    } else {
      await helper.deleteAllOneToOneMessages(
          senderId: chatModel.senderId, receiverId: chatModel.receiverId);
    }
    await fetchLocallySavedUnreadMessages();
  }

  Future handleLocallyChatNotificationInTap(
      {BuildContext? context, required ChatModel chatModel}) async {
    if (chatModel.senderUserType == "Student") {
      // It will a one to one message sent by a Student to Teacher. And will be displayed on Coach version.
      await Navigator.pushReplacement(
        context!,
        CupertinoPageRoute(
          builder: (BuildContext context) => OneToOneMessagingPage(
            loggedInUserId: chatModel.receiverId,
            selectedBatchModel: Batch(
              teacherName: appUser!.fullName,
            ),
            joinedStudentModel: JoinedStudents(
                userID: chatModel.senderId,
                fullName: chatModel.senderName,
                profileImage: chatModel.senderProfilePhoto),
          ),
        ),
      );
    } else {
      if (chatModel.batchId != null && chatModel.batchId!.isNotEmpty) {
        // It would be a message sent by the teacher on group And Logged in user would a student
        //Fetch Batch Details from backend..
        var _batchDetails = await batchRepository.fetchBatchDetails(
            batchId: chatModel.batchId, teacherId: chatModel.senderId);

        await Navigator.pushReplacement(
          context!,
          CupertinoPageRoute(
            builder: (BuildContext context) => StudentBatchDetailsPage(
              batch: _batchDetails,
            ),
          ),
        );
      } else {
        //It would be one to one chat sent from teacher to student And Logged in user would a student
        await Navigator.pushReplacement(
          context!,
          CupertinoPageRoute(
            builder: (BuildContext context) =>
                StudentProfileOneToOneMessagingPage(
              loggedInStudentId: chatModel.receiverId,
              teacherId: chatModel.senderId,
              teacherName: chatModel.senderName,
              teacherProfilePhoto: chatModel.senderProfilePhoto,
            ),
          ),
        );
      }
    }
    await deleteLocallySavedChatMessage(
        messageId: chatModel.id, chatModel: chatModel);
  }
}
