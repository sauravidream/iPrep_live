import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/provider/chat_input.dart';
import 'package:idream/ui/dashboard/batches/student_batch_details_page.dart';
import 'package:idream/ui/dashboard/batches/student_profile_one_to_one_messaging.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class JoinedBatchesPage extends StatelessWidget {
  const JoinedBatchesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Your Joined Batches",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            FutureBuilder(
                future:
                    batchRepository.fetchBatchListJoinedByLoggedInStudents(),
                // ignore: missing_return
                builder: (context, batches) {
                  if (batches.connectionState == ConnectionState.none &&
                      batches.hasData == null) {
                    return Container();
                  } else if (batches.connectionState ==
                      ConnectionState.waiting) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                        period: const Duration(seconds: 2),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          height: 65,
                          width: double.maxFinite,
                        ),
                      ),
                    );
                  } else if (batches.connectionState == ConnectionState.done &&
                      batches.data == null) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Text(
                        "No batch Joined yet.",
                        style: Constants.noDataTextStyle,
                      ),
                    );
                  } else if (batches.hasData) {
                    List<Batch>? finalBatchList = batches.data as List<Batch>?;
                    return Column(
                      children: List.generate(finalBatchList!.length, (index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    StudentBatchDetailsPage(
                                  batch: finalBatchList[index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: 44,
                                        width: 44,
                                        decoration: const BoxDecoration(
                                            color: Color(0xffD1E6FF),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6))),
                                        child: Text(
                                          (finalBatchList[index]
                                                      .batchClass!
                                                      .length >
                                                  2)
                                              ? finalBatchList[index]
                                                  .batchClass!
                                                  .substring(0, 2)
                                              : finalBatchList[index]
                                                  .batchClass!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              fontFamily: "Inter",
                                              color: Color(0xff0070FF)),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        flex: 1,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                finalBatchList[index]
                                                    .batchName!,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Inter",
                                                    color: Color(0xff212121)),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                finalBatchList[index]
                                                    .batchSubject!
                                                    .map((e) => e.subjectName)
                                                    .toList()
                                                    .toString(),
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff666666)),
                                              ),
                                            ]),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "${finalBatchList[index].joinedStudentsList!.length} Students",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Inter",
                                      color: Color(0xff212121)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  } else {
                    return Container();
                  }
                }),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Recent Messages",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            StreamBuilder(
              stream: dbRef
                  .child("recent_chats/students/${appUser!.userID}/")
                  .orderByChild('time')
                  .onValue,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.snapshot.value != null) {
                    DataSnapshot dataValues = snapshot.data.snapshot;
                    Map<dynamic, dynamic> _values =
                        dataValues.value as Map<dynamic, dynamic>;
                    List _chatList = _values.values.toList();
                    if (_chatList.length > 3) {
                      _chatList.removeRange(2, _chatList.length - 1);
                    }
                    if (_values != null) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: ListView.builder(
                          itemCount: _chatList.length,
                          shrinkWrap: true,
                          reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                                future: dbRef
                                    .child(
                                        'users/teachers/${_chatList[index]['user_id']}')
                                    .once(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.data != null) {
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () async {
                                        Provider.of<ChatInput>(context,
                                                listen: false)
                                            .getInputFromStudentmessage('');
                                        String? _loggedInUserId =
                                            await getStringValuesSF('userID');
                                        await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                StudentProfileOneToOneMessagingPage(
                                                    loggedInStudentId:
                                                        _loggedInUserId,
                                                    teacherId: _chatList[index]
                                                        ['user_id'],
                                                    teacherName: snapshot
                                                            .data
                                                            .snapshot
                                                            .value['full_name']
                                                        /*_chatList[index]
                                                                  ['name'] */
                                                        ??
                                                        "",
                                                    teacherProfilePhoto: snapshot
                                                                .data
                                                                .snapshot
                                                                .value[
                                                            'profile_photo']
                                                        /*_chatList[index]
                                                                  ['image'] */
                                                        ??
                                                        Constants
                                                            .defaultProfileImagePath),
                                          ),
                                        );
                                      },
                                      child: getRecentMessageWidget(
                                          fullName: snapshot
                                                      .data.snapshot.value[
                                                  'full_name'] /*_chatList[index]['name']*/ ??
                                              "",
                                          profilePhoto: snapshot
                                                      .data.snapshot.value[
                                                  'profile_photo'] /*_chatList[index]
                                                    ['image']*/
                                              ??
                                              Constants
                                                  .defaultProfileImagePath),
                                    );
                                  }

                                  return Container();
                                });
                          },
                        ),
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                        child: Text(
                          "No message history found.",
                          style: Constants.noDataTextStyle,
                        ),
                      );
                    }
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 20, top: 10),
                      child: Text(
                        Constants.noRecentMessageTextBatchCreatedStudentView,
                        style: Constants.noDataTextStyle,
                      ),
                    );
                  }
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                    period: const Duration(seconds: 2),
                    child: Container(
                      height: 80,
                      width: double.maxFinite,
                      color: Colors.grey,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Padding getRecentMessageWidget(
    {required String profilePhoto, required String fullName}) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
    child: Row(
      children: [
        CachedNetworkImage(
          imageUrl: profilePhoto,
          imageBuilder: (context, imageProvider) => Container(
            width: 44.0,
            height: 44.0,
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
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
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
        const SizedBox(
          width: 6,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fullName,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 14, color: Color(0xff212121)),
            ),
          ],
        ),
      ],
    ),
  );
}
