import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/custom_pop_up.dart';
import 'package:idream/model/notes_model.dart';
import 'package:idream/repository/in_app.dart';
import 'package:idream/ui/menu/upgrade_plan_page.dart';
import 'package:idream/ui/subject_home/notes_rendering_page.dart';
import 'package:idream/ui/subject_home/subject_home.dart';

import '../../common/constants.dart';
import '../../subscription/andriod/android_subscription.dart';

class NotesPage extends StatefulWidget {
  final SubjectHome? subjectHome;
  const NotesPage({Key? key, this.subjectHome}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage>
    with AutomaticKeepAliveClientMixin {
  Future fetchNotes() async {
    return await notesRepository.fetchNotesList(
        subjectID: widget.subjectHome!.subjectWidget!.subjectID);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 16.5,
          ),
          Container(
            height: 0.5,
            color: const Color(0xFFC9C9C9),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchNotes(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount:
                          snapshot.data == null ? 1 : snapshot.data.length,
                      padding: const EdgeInsets.all(
                        16,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (snapshot.data == null) {
                          return Center(
                              child: Text(
                            "No content available",
                            style: TextStyle(
                              color: const Color(0xFF212121),
                              fontWeight: FontWeight.values[5],
                              fontSize: 15,
                            ),
                          ));
                        }
                        return Material(
                          color: Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              if (restrictUser && (index > 1)) {
                                var _response =
                                    await planExpiryPopUpForStudent(context);
                                if ((_response != null) &&
                                    (_response == "Yes")) {
                                  await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          Platform.isAndroid
                                              ? const AndroidSubscriptionPlan()
                                              : const UpgradePlan(),
                                    ),
                                  );
                                }
                              } else {
                                Stopwatch _notesStopwatch = Stopwatch();
                                _notesStopwatch.start();
                                await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        NotesRenderingPage(
                                      notesModel: snapshot.data[index],
                                      notesPageWidget: widget,
                                    ),
                                  ),
                                );
                                _notesStopwatch.stop();

                                if (!usingIprepLibrary) {
                                  notesRepository.saveUsersNotesReport(
                                    widget.subjectHome!.subjectWidget!
                                        .subjectName,
                                    subjectID: widget
                                        .subjectHome!.subjectWidget!.subjectID!,
                                    durationInSeconds:
                                        _notesStopwatch.elapsed.inSeconds,
                                    currentNotesModel: snapshot.data[index],
                                  );
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, top: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: const BoxConstraints(
                                      maxHeight: 94,
                                      maxWidth: 72,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: CachedNetworkImage(
                                      imageUrl: Constants
                                          .bookImageList[random.nextInt(6)],
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
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
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        // Text(
                                        //   "${index < 9 ? "0" : ""}${index + 1}.",
                                        //   style: TextStyle(
                                        //     fontSize: selectedAppLanguage!
                                        //                 .toLowerCase() ==
                                        //             "english"
                                        //         ? 15
                                        //         : 16,
                                        //     fontWeight: FontWeight.values[5],
                                        //     color: Color(widget.subjectHome!
                                        //         .subjectWidget!.subjectColor!),
                                        //     // fontWeight: FontWeight.values[5],
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            (snapshot.data[index] as NotesModel)
                                                .noteName!,
                                            style: TextStyle(
                                              color: Color(widget
                                                  .subjectHome!
                                                  .subjectWidget!
                                                  .subjectColor!),
                                              fontSize: selectedAppLanguage!
                                                          .toLowerCase() ==
                                                      "english"
                                                  ? 15
                                                  : 16,
                                              fontWeight: FontWeight.values[5],
                                              // fontWeight: FontWeight.values[5],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: /*  Loader()*/ CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Color(0xFF3399FF),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
