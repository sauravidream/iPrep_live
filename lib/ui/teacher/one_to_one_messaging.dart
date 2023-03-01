import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:idream/provider/chat_input.dart';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/ui/network_error_page.dart';
import 'package:intl/intl.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/batch_model.dart';
import 'package:provider/provider.dart';

class OneToOneMessagingPage extends StatefulWidget {
  final String? loggedInUserId;
  final JoinedStudents? joinedStudentModel;
  final Batch? selectedBatchModel;

  const OneToOneMessagingPage(
      {Key? key, this.loggedInUserId, this.joinedStudentModel, this.selectedBatchModel}) : super(key: key);

  @override
  _OneToOneMessagingPageState createState() => _OneToOneMessagingPageState();
}

class _OneToOneMessagingPageState extends State<OneToOneMessagingPage> {
  final TextEditingController _chatTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var chatInputProvider = Provider.of<ChatInput>(context, listen: true);
    return Consumer<NetworkProvider>(builder: (BuildContext context,NetworkProvider networkProvider, Widget? child) {
      return networkProvider.isAvailable==true?Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          leadingWidth: 36,
          leading: GestureDetector(
            onTap: () {
              chatInputProvider.getInputFromRecentMessages('');
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 11,
              ),
              child: Image.asset(
                "assets/images/back_icon.png",
                height: 25,
                width: 25,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: widget.joinedStudentModel!.profileImage!,
                imageBuilder: (context, imageProvider) => Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image:
                    DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),

              const SizedBox(
                width: 6,
              ),
              Text(
                widget.joinedStudentModel!.fullName!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.values[5],
                  color: const Color(0xFF212121),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: chatInputProvider.container1Fex,
              child: StreamBuilder(
                stream: dbRef
                    .child("chat/")
                    .child('one_to_one_chat')
                    .child('teachers')
                    .child("${widget.loggedInUserId}/")
                    .child("${widget.joinedStudentModel!.userID}/")
                    .orderByValue()
                    .onValue,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    DataSnapshot dataValues = snapshot.data.snapshot;
                    Map<dynamic, dynamic>? _values = dataValues.value as Map<dynamic, dynamic>?;
                    if (_values != null) {
                      var list = _values.entries.toList();
                      list.sort(
                              (a, b) => b.value["time"].compareTo(a.value["time"]));
                      var list2 = list.map((a) => {a.key: a.value}).toList();
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: ListView.builder(
                          itemCount: list2.length,
                          shrinkWrap: true,
                          reverse: true,
                          itemBuilder: (context, index) {
                            String _key = list2[index].keys.first;
                            if (list2[index][_key]['user_type'] == "Student") {
                              list2[index][_key]['sender_profile_image'] =
                                  widget.joinedStudentModel!.profileImage;
                              list2[index][_key]['sender_name'] =
                                  widget.joinedStudentModel!.fullName;
                            } else {
                              list2[index][_key]['sender_profile_image'] =
                                  appUser!.profilePhoto ??
                                      list2[index][_key]['sender_profile_image'];
                              list2[index][_key]['sender_name'] =
                                  appUser!.fullName ??
                                      list2[index][_key]['sender_name'];
                            }
                            return buildMessage(
                              msgInfo: list2[index][_key],
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
                  color: const Color(0xffF8F8F8),
                  child: TextFormField(
                    controller: _chatTextController,
                    // scrollPhysics: NeverScrollableScrollPhysics(),
                    keyboardType: TextInputType.multiline,
                    maxLines: chatInputProvider.mexLines,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff212121),
                    ),
                    decoration: InputDecoration(
                      // prefixIcon: ImageIcon(
                      //   AssetImage(
                      //     'assets/images/Icon ionic-ios-add-circle-outline.png',
                      //   ),
                      //   color: Color(0xff666666),
                      // ),
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 16),
                        ),
                        suffixIcon: InkWell(
                          onTap: () async {
                            chatInputProvider.getInputFromRecentMessages('');
                            //Save sent message in the group
                            if (_chatTextController.text.isNotEmpty) {
                              String _message = _chatTextController.text;
                              _chatTextController.text = "";
                              String? _loggedInUserProfileImage =
                              await getStringValuesSF('profilePhoto');
                              await messagingRepository.saveOneToOneChat(
                                messageText: _message,
                                receiverUserID: widget.joinedStudentModel!.userID!,
                                receiverName: widget.joinedStudentModel!.fullName,
                                senderProfileImage: _loggedInUserProfileImage,
                                receiverProfileImage:
                                widget.joinedStudentModel!.profileImage,
                              );
                            }
                          },
                          child: const Icon(
                            Icons.send,
                            color: Color(0xff0070FF),
                          ),
                        ),
                        border: InputBorder.none,
                        hintText: "Type a message here",
                        hintStyle: const TextStyle(
                          color: Color(0xffDEDEDE),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                    validator: (value) =>
                    value!.isEmpty ? "Field can't be null" : null,
                    onSaved: (value) {},
                    onChanged: (value) {
                      chatInputProvider.getInputFromRecentMessages(value);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ):const NetworkError();
    },);
  }

  buildMessage({required Map msgInfo}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 8, bottom: 8),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            height: 44,
            width: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CachedNetworkImage(
              imageUrl: (msgInfo['sender_profile_image'] != null)
                  ? msgInfo['sender_profile_image']
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
                      msgInfo['sender_name'] ?? "",
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
                        DateTime.parse(msgInfo['time']),
                      ),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 10,
                          fontFamily: "Inter",
                          color: Color(0xff666666)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  msgInfo['message'],
                  textAlign: TextAlign.left,
                  style: const TextStyle(
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
    );
  }
}
