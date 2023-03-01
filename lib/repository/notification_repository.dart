import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/local_db_helper.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/main.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/model/chat_model.dart';
import 'package:idream/provider/bell_animation_provider.dart';
import 'package:idream/ui/dashboard/batches/student_batch_details_page.dart';
import 'package:idream/ui/dashboard/batches/student_profile_one_to_one_messaging.dart';
import 'package:idream/ui/teacher/one_to_one_messaging.dart';
import 'package:provider/provider.dart';
import '../ui/dashboard/notification_page.dart';

class NotificationRepository {
  Future<void> handleNotificationOnTapEvent(context) async {
    // var initializationSettingsAndroid =
    //     const AndroidInitializationSettings('@mipmap/ic_launcher');
    // var initializationSettingsIOS =;
    // var initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);
    //
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // try {
    //   await getNotification();
    // } catch (e) {
    //   debugPrint(e.toString());
    // }

    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
        try {
          await getNotification();
        } catch (e) {
          debugPrint(e.toString());
        }

        try {
          debugPrint("onMessage");
          Provider.of<BellAnimationProvider>(context, listen: false)
              .initialisePushNotificationAnimation();
          debugPrint(event.from);
          await displaySnackbarForAssignmentAndChatNotification(
              context: context, notificationInfo: (event));
        } catch (e) {
          debugPrint(e.toString());
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        notificationOnTapEventAction(message.data, context);
        debugPrint('Message clicked!');
      });

      // FirebaseMessaging.onBackgroundMessage((message) async {
      //   try {
      //     await getNotification();
      //   } catch (e) {
      //     debugPrint(e.toString());
      //   }
      //   debugPrint('Message clicked!');
      //   return SnackbarMessages.showInfoSnackbar(
      //     context: context,
      //     title: message.data["batch_name"],
      //     info:
      //         "${message.data["sender"]} has ${message.data['message']}. Tap here to check.",
      //   );
      // });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future notificationOnTapEventAction(notificationInfo, context) async {
    if (notificationInfo != null) {
      String? notificationType = notificationInfo["notification_type"];

      if (notificationType == "chat") {
        //is Message sent from Teacher or Student
        String? loggedInUserId = await getStringValuesSF("userID");

        if (notificationInfo['user_type'] == "Student") {
          // It will a one to one message sent by a Student to Teacher. And will be displayed on Coach version.
          await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (BuildContext context) => OneToOneMessagingPage(
                loggedInUserId: loggedInUserId,
                selectedBatchModel: Batch(
                  teacherName: appUser!.fullName,
                ),
                joinedStudentModel: JoinedStudents(
                  userID: notificationInfo['senderId'],
                  fullName: notificationInfo['sender_name'],
                  profileImage: notificationInfo['sender_profile_image'] ??
                      Constants.defaultProfileImagePath,
                ),
              ),
            ),
          );
        } else {
          if (notificationInfo['batch_id'] != null &&
              notificationInfo['batch_id'].isNotEmpty) {
            // It would be a message sent by the teacher on group And Logged in user would a student

            //Fetch Batch Details from backend..
            var batchDetails = await batchRepository.fetchBatchDetails(
                batchId: notificationInfo['batch_id'],
                teacherId: notificationInfo['senderId']);

            await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (BuildContext context) => StudentBatchDetailsPage(
                  batch: batchDetails,
                ),
              ),
            );
          } else {
            //It would be one to one chat sent from teacher to student And Logged in user would a student
            await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (BuildContext context) =>
                    StudentProfileOneToOneMessagingPage(
                  loggedInStudentId: loggedInUserId,
                  teacherId: notificationInfo["senderId"],
                  teacherName: notificationInfo["sender"],
                  teacherProfilePhoto: notificationInfo["sender_profile_image"],
                ),
              ),
            );
          }
        }
      } else if (notificationType == "assignment") {
        //Fetch Batch Details from backend..
        var batchDetails = await batchRepository.fetchBatchDetails(
            batchId: notificationInfo['batch_id'],
            teacherId: notificationInfo['senderId']);
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (BuildContext context) => StudentBatchDetailsPage(
              batch: batchDetails,
              showTabIndex: 1,
            ),
          ),
        );
      } else if (notificationType == "backend_notification") {
        //Fetch Batch Details from backend..
        String? _userID = await getStringValuesSF("userID");
        String? _userTypeNode = await (userRepository.getUserNodeName());
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => NotificationPage(
              userId: _userID,
              userType: _userTypeNode,
            ),
          ),
        );
      }
    }
  }

  Future<Response?> getNotification() async {
    Response? response;
    try {
      String? userID = await getStringValuesSF("userID");
      String? userTypeNode = await (userRepository.getUserNodeName());
      response = await Dio().get(
        "https://iprep-web.herokuapp.com/api/notifications/webNotifications?userId=$userID&userType=$userTypeNode",
      );
      if (response.statusCode == 200) {
        debugPrint("Notifications saved successfully");
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      return response;
    }
    return response;
  }

  Future markAllNotificationsAsRead(
      {required loggedInUserId,
      required List notificationListData,
      required context}) async {
    //Deleting all locally saved messages
    await helper.deleteAllDataOnTableName(unreadChatHistory);

    Provider.of<BellAnimationProvider>(context, listen: false)
        .fetchLocallySavedUnreadMessages();

    notificationListData.removeWhere(
        (notificationData) => notificationData.value['message_opened']);
    String? userTypeNode = await (userRepository.getUserNodeName());
    await Future.forEach(notificationListData,
        (dynamic notificationData) async {
      dbRef
          .child("notification/$userTypeNode/$loggedInUserId")
          .child(notificationData.key)
          .update({
        "message_opened": true,
      });
    }).then((value) {
      debugPrint("All the notifications have been marked as read.");
    });
  }

  Future markSelectedNotificationsAsRead(
      {required loggedInUserId, required String? notificationId}) async {
    String? userTypeNode = await (userRepository.getUserNodeName());
    dbRef
        .child("notification/$userTypeNode/$loggedInUserId/$notificationId")
        .update({
      "message_opened": true,
    }).then((value) {
      debugPrint("All the notifications have been marked as read.");
    });
  }

  Future displaySnackbarForAssignmentAndChatNotification(
      {notificationInfo, context}) async {
    if (notificationInfo != null) {
      String? notificationType = notificationInfo.data["notification_type"];
      if (notificationType == "chat") {
        //is Message sent from Teacher or Student
        String? loggedInUserId = await getStringValuesSF("userID");

        ChatModel chatModel = ChatModel(
          senderId: notificationInfo.data["senderId"],
          receiverId: loggedInUserId,
          message: notificationInfo.data['message'],
          batchId: notificationInfo.data['batch_id'],
          batchName: notificationInfo.data['batch_name'],
          messageTime: notificationInfo.data['messageTime'],
          senderUserType: notificationInfo.data['user_type'],
          senderProfilePhoto: notificationInfo.data["sender_profile_image"],
          senderName: notificationInfo.data['sender_name'] ??
              notificationInfo.data['sender'],
        );
        //Save this chat message to the local database as well
        var result = await helper.insert(
          tableName: unreadChatHistory,
          tableData: chatModel,
        );
        chatModel.id = result;

        if (notificationInfo.data['user_type'] == "Student") {
          // It will a one to one message sent by a Student to Teacher. And will be displayed on Coach version.
          SnackbarMessages.showInfoSnackbar(
            context: context,
            title: notificationInfo.data['sender_name'],
            info:
                "sent you a message ${notificationInfo.data['message']}. Tap here to check.",
            navigationPage: OneToOneMessagingPage(
              loggedInUserId: loggedInUserId,
              selectedBatchModel: Batch(
                teacherName: appUser!.fullName,
              ),
              joinedStudentModel: JoinedStudents(
                userID: notificationInfo.data['senderId'],
                fullName: notificationInfo.data['sender_name'],
                profileImage: notificationInfo.data['sender_profile_image'] ??
                    Constants.defaultProfileImagePath,
              ),
            ),
            chatModel: chatModel,
          );
        } else {
          if (notificationInfo.data['batch_id'] != null &&
              notificationInfo.data['batch_id'].isNotEmpty) {
            // It would be a message sent by the teacher on group And Logged in user would a student

            //Fetch Batch Details from backend..
            var batchDetails = await batchRepository.fetchBatchDetails(
                batchId: notificationInfo.data['batch_id'],
                teacherId: notificationInfo.data['senderId']);

            SnackbarMessages.showInfoSnackbar(
              context: context,
              title: notificationInfo.data["sender"],
              info:
                  "sent you a message ${notificationInfo.data['message']}. Tap here to check.",
              navigationPage: StudentBatchDetailsPage(
                batch: batchDetails,
              ),
              chatModel: chatModel,
            );
          } else {
            //It would be one to one chat sent from teacher to student And Logged in user would a student

            SnackbarMessages.showInfoSnackbar(
              context: context,
              title: notificationInfo.data["sender"],
              info:
                  "sent you a message ${notificationInfo.data['message']}. Tap here to check.",
              navigationPage: StudentProfileOneToOneMessagingPage(
                loggedInStudentId: loggedInUserId,
                teacherId: notificationInfo.data["senderId"],
                teacherName: notificationInfo.data["sender"],
                teacherProfilePhoto:
                    notificationInfo.data["sender_profile_image"],
              ),
              chatModel: chatModel,
            );
          }
        }

        Provider.of<BellAnimationProvider>(context, listen: false)
            .fetchLocallySavedUnreadMessages();
      } else if (notificationType == "assignment") {
        //Fetch Batch Details from backend..
        var batchDetails = await batchRepository.fetchBatchDetails(
            batchId: notificationInfo.data['batch_id'],
            teacherId: notificationInfo.data['senderId']);

        SnackbarMessages.showInfoSnackbar(
          context: context,
          title: notificationInfo.data["batch_name"],
          info:
              "${notificationInfo.data["sender"]} has ${notificationInfo.data['message']}. Tap here to check.",
          navigationPage: StudentBatchDetailsPage(
            batch: batchDetails,
            showTabIndex: 1,
          ),
        );
      }
    }
  }
}
