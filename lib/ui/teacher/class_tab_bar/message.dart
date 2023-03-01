import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:idream/provider/chat_input.dart';
import 'package:intl/intl.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/batch_model.dart';
import 'package:provider/provider.dart';

class ChatTab extends StatefulWidget {
  final Batch? selectedBatchModel;
  ChatTab({this.selectedBatchModel});

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final TextEditingController _chatTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var chatInputProvider = Provider.of<ChatInput>(context, listen: true);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: chatInputProvider.container1Fex,
          child: StreamBuilder(
            stream: dbRef
                .child("chat/")
                .child('group_chat')
                .child("${widget.selectedBatchModel!.batchId}/")
                .child("${widget.selectedBatchModel!.teacherId}/")
                .orderByValue()
                .onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                DataSnapshot dataValues = snapshot.data.snapshot;
                Map<dynamic, dynamic>? _values = dataValues.value as Map<dynamic, dynamic>?;
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
                return Center(
                  child: Text(
                    "Loading...",
                    style: Constants.noDataTextStyle,
                  ),
                );
              }
            },
          ),
        ),
        Flexible(
          flex: chatInputProvider.container2Fex,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Color(0xffF8F8F8),
              child: TextFormField(
                controller: _chatTextController,
                keyboardType: TextInputType.multiline,
                maxLines: chatInputProvider.mexLines,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  color: Color(0xff212121),
                ),
                decoration: InputDecoration(
                    // prefixIcon: ImageIcon(
                    //   AssetImage(
                    //     'assets/images/Icon ionic-ios-add-circle-outline.png',
                    //   ),
                    //   color: Color(0xff666666),
                    // ),
                    prefix: Padding(
                      padding: EdgeInsets.only(left: 16),
                    ),
                    suffixIcon: InkWell(
                      onTap: () async {
                        chatInputProvider.getInputFromMyBatches('');
                        //Save sent message in the group
                        if (_chatTextController.text.isNotEmpty) {
                          String _message = _chatTextController.text;
                          _chatTextController.text = "";
                          await messagingRepository.saveBatchChat(
                            messageText: _message,
                            batchInfo: widget.selectedBatchModel!,
                          );
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Color(0xff0070FF),
                      ),
                    ),
                    border: InputBorder.none,
                    hintText: "Type a message here",
                    hintStyle: TextStyle(
                      color: Color(0xffDEDEDE),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    )),
                validator: (value) =>
                    value!.isEmpty ? "Field can't be null" : null,
                onSaved: (value) {},
                onChanged: (value) {
                  chatInputProvider.getInputFromMyBatches(value);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildMessage({String messageText = "This Message is here", required updatedTime}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 8, bottom: 8),
      child: InkWell(
        onTap: () {},
        child: Row(
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.all(Radius.circular(6))
              ),
              child: CachedNetworkImage(
                imageUrl: (appUser!.profilePhoto != null)
                    ? appUser!.profilePhoto!
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
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),

              // child: CircleAvatar(
              //   backgroundImage: NetworkImage(
              //     (appUser.profilePhoto != null)
              //         ? appUser.profilePhoto
              //         : Constants.defaultProfileImagePath,
              //   ),
              //   radius: ScreenUtil().setSp(36, ),
              // ),
            ),
            SizedBox(width: 6),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.selectedBatchModel!.teacherName!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Inter",
                          color: Color(0xff212121),
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        DateFormat.yMMMMd().format(
                          DateTime.parse(updatedTime),
                        ),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: "Inter",
                            color: Color(0xff666666)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    messageText,
                    maxLines: 10,
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: Color(0xff212121),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
