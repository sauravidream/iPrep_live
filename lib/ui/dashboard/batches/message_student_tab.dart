import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/provider/chat_input.dart';
import 'package:idream/ui/dashboard/batches/student_profile_one_to_one_messaging.dart';
import 'package:provider/provider.dart';

class ChatTabForStudent extends StatefulWidget {
  final Batch? selectedBatchModel;
  ChatTabForStudent({this.selectedBatchModel});

  @override
  _ChatTabForStudentState createState() => _ChatTabForStudentState();
}

class _ChatTabForStudentState extends State<ChatTabForStudent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 8,
          child: StreamBuilder(
            stream: dbRef
                .child("chat/")
                .child('group_chat/')
                .child("${widget.selectedBatchModel!.batchId}/")
                .child("${widget.selectedBatchModel!.teacherId}/")
                .orderByValue()
                .onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                DataSnapshot dataValues = snapshot.data.snapshot;
                Map<dynamic, dynamic>? _values =
                    dataValues.value as Map<dynamic, dynamic>?;
                if (_values != null) {
                  var list = _values.entries.toList(); //DateTime.parse(newDate)
                  list.sort(
                      (a, b) => b.value["time"].compareTo(a.value["time"]));
                  var list2 = list.map((a) => {a.key: a.value}).toList();
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: ListView.builder(
                      itemCount: list2.length,
                      shrinkWrap: true,
                      reverse: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        String _key = list2[index].keys.first;
                        return buildMessage(
                          messageText: list2[index][_key]["message"],
                          updatedTime: list2[index][_key]["time"],
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "No Message. Send your first message.",
                      style: Constants.noDataTextStyle,
                    ),
                  );
                }
              } else {
                return const Center(
                  child: Loader(),
                );
              }
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                Provider.of<ChatInput>(context, listen: false)
                    .getInputFromStudentmessage('');
                String? _loggedInUserId = await getStringValuesSF("userID");
                await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        StudentProfileOneToOneMessagingPage(
                      loggedInStudentId: _loggedInUserId,
                      teacherId: widget.selectedBatchModel!.teacherId,
                      teacherName: widget.selectedBatchModel!.teacherName,
                      teacherProfilePhoto:
                          widget.selectedBatchModel!.teacherProfilePhoto,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Send Message to ${widget.selectedBatchModel!.teacherName}",
                  style: const TextStyle(
                    color: Color(0xFF0070FF),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 32),
            child: Text(
              "You can't reply in Groups",
              style: TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildMessage(
      {String messageText = "This Message is here", required updatedTime}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CircleAvatar(
          //   backgroundImage: NetworkImage(
          //     joinedStudents.profileImage,
          //   ),
          //   radius: ScreenUtil().setSp(22, ),
          // ),
          Container(
            alignment: Alignment.center,
            height: 44,
            width: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              //borderRadius: BorderRadius.all(Radius.circular(6))
            ),
            child: CachedNetworkImage(
              imageUrl: (widget.selectedBatchModel!.teacherProfilePhoto != null)
                  ? widget.selectedBatchModel!.teacherProfilePhoto!
                  : Constants.defaultProfileImagePath,
              imageBuilder: (context, imageProvider) => Container(
                width: 72.0,
                height: 72.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    strokeWidth: 0.5,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            // child: CircleAvatar(
            //   backgroundImage:
            //   NetworkImage(
            //     (widget.selectedBatchModel.teacherProfilePhoto != null)
            //         ? widget.selectedBatchModel.teacherProfilePhoto
            //         : Constants.defaultProfileImagePath,
            //   ),
            //   radius: ScreenUtil().setSp(36, ),
            // ),
          ),
          const SizedBox(width: 6),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.selectedBatchModel!.teacherName ?? "",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: "Inter",
                        color: Color(0xff212121),
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      DateFormat.yMMMMd().format(
                        DateTime.parse(updatedTime),
                      ),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 10, color: Color(0xff666666)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  messageText,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff212121),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
