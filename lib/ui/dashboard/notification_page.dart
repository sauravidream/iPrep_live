import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/chat_model.dart';
import 'package:idream/provider/bell_animation_provider.dart';
import 'package:idream/ui/dashboard/batches/student_batch_details_page.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  final String? userId;
  final String? userType;

  const NotificationPage({
    Key? key,
    this.userId,
    this.userType,
  }) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List _notificationListData = [];
  @override
  void initState() {
    super.initState();
    Provider.of<BellAnimationProvider>(context, listen: false)
        .fetchLocallySavedUnreadMessages();
    _notificationListData.clear();
    notificationRepository.getNotification().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: false,
            leadingWidth: 50,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                "assets/images/back_icon.png",
                // height: 100,
                // width: 100,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.values[5],
                    color: const Color(0xFF212121),
                  ),
                ),
                Material(
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      await notificationRepository.markAllNotificationsAsRead(
                          loggedInUserId: widget.userId,
                          notificationListData: _notificationListData,
                          context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Mark all as read",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.values[5],
                          color: const Color(0xFF0077FF),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Consumer<BellAnimationProvider>(
                    builder: (context, bellAnimationProvide, child) =>
                        ListView.builder(
                      itemCount: bellAnimationProvide.localChatList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return notificationTile(
                          title: bellAnimationProvide
                              .localChatList[index].senderName!,
                          elapsedTime: _getTotalTimeString(bellAnimationProvide
                              .localChatList[index].messageTime!),
                          description:
                              "has sent you a message ${bellAnimationProvide.localChatList[index].message!}",
                          hasRead: false,
                          notificationId: bellAnimationProvide
                              .localChatList[index].id
                              .toString(),
                          notificationType: "Chat",
                          notificationInfo:
                              bellAnimationProvide.localChatList[index].toMap(),
                        );
                      },
                    ),
                  ),
                  StreamBuilder(
                    stream: dbRef
                        .child(
                            "notification/${widget.userType}/${widget.userId}/")
                        .orderByValue()
                        .onValue,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        DataSnapshot dataValues = snapshot.data.snapshot;
                        Map<dynamic, dynamic>? _values =
                            dataValues.value as Map<dynamic, dynamic>?;
                        if (_values != null) {
                          var list = _values.entries.toList();

                          list.sort((element1, element2) => element2
                              .value['time']
                              .compareTo(element1.value['time']));

                          _notificationListData.clear();
                          _notificationListData = list;
                          return ListView.builder(
                            itemCount: list.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return notificationTile(
                                title: list[index].value['title'] ?? "",
                                elapsedTime: _getTotalTimeString(
                                        list[index].value['time']) ??
                                    "",
                                description: list[index].value['message'] ?? "",
                                hasRead: list[index].value['message_opened'] ??
                                    "" as bool,
                                notificationId: list[index].key ?? "",
                                notificationType:
                                    list[index].value['notification_type'] ??
                                        "",
                                notificationInfo: list[index].value ??
                                    "" as Map<dynamic, dynamic>?,
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Text(
                              "No notification.",
                              style: Constants.noDataTextStyle,
                            ),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            backgroundColor: Color(0xFF3399FF),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget notificationTile({
    required String title,
    required String elapsedTime,
    required String description,
    bool hasRead = true,
    String? notificationId,
    String? notificationType,
    Map<dynamic, dynamic>? notificationInfo,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24,
      ),
      child: GestureDetector(
        onTap: () async {
          if (notificationType == "Chat") {
            Provider.of<BellAnimationProvider>(context, listen: false)
                .handleLocallyChatNotificationInTap(
                    context: context,
                    chatModel: ChatModel.fromMap(
                        notificationInfo as Map<String, dynamic>));
            return;
          }

          if (!notificationInfo!['message_opened']) {
            await notificationRepository.markSelectedNotificationsAsRead(
                loggedInUserId: widget.userId, notificationId: notificationId);
          }
          if ((notificationType != null) &&
              (notificationType == "assignment")) {
            //Fetch Batch Details from backend..
            var _batchDetails = await batchRepository.fetchBatchDetails(
                batchId: notificationInfo['batch_id'],
                teacherId: notificationInfo['sender_id']);
            await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (BuildContext context) => StudentBatchDetailsPage(
                  batch: _batchDetails,
                  showTabIndex: 1,
                ),
              ),
            );
          }
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 6,
                  ),
                  child: Image.asset(
                    "assets/images/dot.png",
                    alignment: Alignment.centerLeft,
                    color:
                        hasRead ? Colors.transparent : const Color(0xFF0077FF),
                    height: 6,
                    width: 6,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.values[5],
                      color: hasRead
                          ? const Color(0xFF212121)
                          : const Color(0xFF0077FF),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    elapsedTime,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.values[4],
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 6,
                  ),
                  child: Image.asset(
                    "assets/images/dot.png",
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    height: 6,
                    width: 6,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    description,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.values[4],
                      height: 1.5,
                      color: Color(hasRead ? 0xFF666666 : 0xFF9E9E9E),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding notificationHeader({required String headerLeadingText}) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerLeadingText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.values[4],
              color: const Color(0xFF9E9E9E),
            ),
          ),
          Text(
            "Clear",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.values[4],
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }

  _getTotalTimeString(String messageTime) {
    Duration _lapsedTimeDuration =
        DateTime.now().difference(DateTime.parse(messageTime));
    String _timeSpentString = "";
    if (_lapsedTimeDuration.inDays > 365) {
      _timeSpentString =
          "${(_lapsedTimeDuration.inDays / 365).round()} years ago";
    } else if (_lapsedTimeDuration.inDays > 30) {
      _timeSpentString =
          "${(_lapsedTimeDuration.inDays / 30).round()} months ago";
    } else if (_lapsedTimeDuration.inHours > 24) {
      _timeSpentString =
          "${(_lapsedTimeDuration.inHours / 24).round()} days ago";
    } else if (_lapsedTimeDuration.inMinutes > 60) {
      _timeSpentString = "${_lapsedTimeDuration.inHours} hours ago";
    } else if (_lapsedTimeDuration.inSeconds > 60) {
      _timeSpentString = "${_lapsedTimeDuration.inMinutes} minutes ago";
    } else {
      _timeSpentString = "${_lapsedTimeDuration.inSeconds} seconds ago";
    }
    if (_timeSpentString.contains("0")) {
      debugPrint(_timeSpentString);
    }
    return _timeSpentString;
  }
}
