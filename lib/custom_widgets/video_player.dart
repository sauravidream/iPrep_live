import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/core/app.dart';
import 'package:idream/custom_widgets/custom_pop_up.dart';
import 'package:idream/custom_widgets/video_test.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/provider/video_provider.dart';
import 'package:idream/repository/in_app.dart';
import 'package:idream/ui/menu/upgrade_plan_page.dart';
import 'package:idream/ui/subject_home/subject_home.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:wakelock/wakelock.dart';

import '../subscription/andriod/android_subscription.dart';

List<VideoLessonModel>? completeListOfVideos;

// ignore: must_be_immutable
class CustomVideoPlayer extends StatefulWidget {
  final SubjectHome? subjectHome;
  VideoLessonModel? videoLessonModel;
  var subjectHomeChapterListIndex;
  Widget? videoPageContent;
  var videoData;
  var videoLesson;

  var completeListOfVideos;

  CustomVideoPlayer(
      {Key? key,
      required this.subjectHome,
      required this.videoPageContent,
      required this.videoData,
      required this.videoLesson,
      this.subjectHomeChapterListIndex,
      this.videoLessonModel,
      this.completeListOfVideos})
      : super(key: key);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> with RouteAware {
  var videoUrl;

  var id;
  var videoLessonMode;
  var subjectID;
  var topName;
  VideoLessonModel? videoLessonModel;
  AutoScrollController? videoLessonScrollController;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Wakelock.enable();
      super.initState();
      routeObserver.subscribe(this, ModalRoute.of(context)!);

      videoLessonModel = (widget.videoData[widget.subjectHomeChapterListIndex]
          [widget.videoLesson]);
      videoUrl = (widget.videoData[widget.subjectHomeChapterListIndex]
          [widget.videoLesson]);

      id = videoLessonModel!.onlineLink;
      topName = videoLessonModel!.name;
      subjectID = widget.subjectHome!.subjectWidget!.subjectID;

      SystemChrome.setEnabledSystemUIMode(
          //This is use for the system noach return
          SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      _startTimer();
    });
  }

  int? counter;

  late VideoProvider videoProvider;
  var chapVideoList;

  @override
  void dispose() {
    Wakelock.disable();
    routeObserver.unsubscribe(this);
    videoProvider.chewieController!.dispose();
    videoProvider.chewieController!.videoPlayerController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  late Timer? _timer;
  void _startTimer() {
    counter = 4;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter! > 0) {
        counter = (counter! - 1);

        debugPrint(counter.toString());
      } else {
        _timer!.cancel();
      }
    });
  }

  /// Called when the current route has been popped off.
  @override
  void didPop() {
    print('didPop');
    videoProvider = Provider.of<VideoProvider>(context, listen: false);
    videoProvider.videoPlayerController.pause();

    super.didPop();
  }

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  @override
  void didPopNext() {
    print('didPopNext');
    videoProvider = Provider.of<VideoProvider>(context, listen: false);
    videoProvider.videoPlayerController.pause();
    super.didPopNext();
  }

  /// Called when the current route has been pushed.
  @override
  void didPush() {
    print('didPush');
    videoProvider = Provider.of<VideoProvider>(context, listen: false);
    videoProvider.videoPlayerController.pause();

    super.didPush();
  }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  @override
  void didPushNext() {
    print('didPushNext');
    videoProvider = Provider.of<VideoProvider>(context, listen: false);
    videoProvider.videoPlayerController.pause();

    super.didPushNext();
  }

  @override
  Widget build(BuildContext context) {
    videoProvider = Provider.of<VideoProvider>(context, listen: false);
    videoLessonScrollController = AutoScrollController();
    videoLessonScrollController!.scrollToIndex(
        widget.subjectHome!.chapterList!.indexWhere(
            (element) => element == widget.subjectHomeChapterListIndex),
        preferPosition: AutoScrollPosition.begin);

    return WillPopScope(
      onWillPop: () async {
        if (MediaQuery.of(context).orientation == Orientation.landscape) {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
          return false;
        }
        if (usingIprepLibrary == false) {
          videoProvider.saveUsersVideoWatchingHistory();
        }
        return true;
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.portrait
                  ? Column(
                      children: [
                        Consumer<VideoProvider>(
                            builder: (_, videoProvider, __) {
                          return AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ChewieListItem(
                              subjectID:
                                  widget.subjectHome!.subjectWidget!.subjectID,
                            ),
                          );
                        }),
                        Container(
                          height: 51,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Consumer<VideoProvider>(
                                    builder: (_, videoProvider, __) {
                                      return Text(
                                        videoProvider.videoLesson!.name!,
                                        style: TextStyle(
                                            fontSize: selectedAppLanguage!
                                                        .toLowerCase() ==
                                                    "english"
                                                ? 15
                                                : 16,
                                            color: const Color(0xFF212121),
                                            fontWeight: FontWeight.values[5]),
                                      );
                                    },
                                  )),
                              Container(
                                width: 1,
                                margin: const EdgeInsets.only(
                                  right: 16,
                                ),
                                height: double.maxFinite,
                                color: const Color(0xFFDEDEDE),
                                child: const SizedBox(
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 0.5,
                          color: const Color(0xFFC9C9C9),
                        ),
                        Expanded(
                          child: widget.videoPageContent = ListView.builder(
                            controller: videoLessonScrollController,
                            padding: const EdgeInsets.all(
                              16,
                            ),
                            shrinkWrap: true,
                            itemCount: widget.subjectHome!.chapterList!.length,
                            itemBuilder: (context, index) {
                              if (index > -1) {
                                if (widget.videoData == null) {
                                  return Center(
                                    child: Text(
                                      "No content available",
                                      style: TextStyle(
                                        color: const Color(0xFF212121),
                                        fontWeight: FontWeight.values[5],
                                        fontSize: 15,
                                      ),
                                    ),
                                  );
                                }

                                return AutoScrollTag(
                                    key: ValueKey(index),
                                    controller: videoLessonScrollController!,
                                    index: index,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 16,
                                            top: 7,
                                          ),
                                          // get
                                          child: Text(
                                            "${index < 9 ? "0${index + 1}" : index + 1}.  ${widget.subjectHome!.chapterList![index]}",
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
                                                fontWeight:
                                                    FontWeight.values[5]),
                                          ),
                                        ),
                                        Stack(
                                          children: [
                                            Wrap(
                                              children: List.generate(
                                                  widget
                                                      .videoData[widget
                                                          .subjectHome!
                                                          .chapterList![index]]
                                                      .length, (videoIndex) {
                                                VideoLessonModel videoLesson =
                                                    widget.videoData[widget
                                                            .subjectHome!
                                                            .chapterList![
                                                        index]][videoIndex];
                                                chapVideoList =
                                                    widget.videoData[widget
                                                        .subjectHome!
                                                        .chapterList![index]];

                                                return InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  onTap: () async {
                                                    if (counter == 0) {
                                                      _startTimer();

                                                      if (restrictUser &&
                                                          (videoIndex > 1)) {
                                                        videoProvider
                                                            .chewieController!
                                                            .videoPlayerController
                                                            .pause();

                                                        var _response =
                                                            await planExpiryPopUpForStudent(
                                                                context);
                                                        if ((_response !=
                                                                null) &&
                                                            (_response ==
                                                                "Yes")) {
                                                          await Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  Platform.isAndroid
                                                                      ? const AndroidSubscriptionPlan()
                                                                      : const UpgradePlan(),
                                                            ),
                                                          );
                                                          videoProvider
                                                              .chewieController!
                                                              .videoPlayerController
                                                              .play();
                                                        } else {
                                                          videoProvider
                                                              .chewieController!
                                                              .videoPlayerController
                                                              .play();
                                                        }
                                                      } else {
                                                        if (videoProvider
                                                                .videoLesson!
                                                                .onlineLink !=
                                                            videoLesson
                                                                .onlineLink) {
                                                          videoProvider
                                                              .chewieController!
                                                              .videoPlayerController
                                                              .pause();
                                                          await videoProvider
                                                              .saveUsersVideoWatchingHistory();
                                                          await videoProvider.getVideoData(
                                                              widget
                                                                  .subjectHome!
                                                                  .subjectWidget!
                                                                  .subjectName,
                                                              videoLessonModel:
                                                                  widget
                                                                      .completeListOfVideos,
                                                              videoIndex:
                                                                  videoLesson
                                                                      .id,
                                                              subjectId:
                                                                  subjectID);

                                                          videoLessonModel =
                                                              videoLesson;
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 10,
                                                            bottom: 10),
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(10),
                                                          ),
                                                          child: Container(
                                                            color: Colors
                                                                .grey.shade300,
                                                            width: 112,
                                                            height: 64,
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                  child: Stack(
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                        imageUrl: videoLesson.thumbnail ==
                                                                                ""
                                                                            ? Constants.thumbnail
                                                                            : videoLesson.thumbnail!,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        progressIndicatorBuilder: (context,
                                                                                url,
                                                                                downloadProgress) =>
                                                                            const SizedBox(
                                                                          width:
                                                                              112,
                                                                          height:
                                                                              64,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                SizedBox(
                                                                              height: 25,
                                                                              width: 25,
                                                                              child: CircularProgressIndicator(
                                                                                // color: Colors.green,
                                                                                strokeWidth: 1.5,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            const Icon(Icons.error),
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            112,
                                                                        height:
                                                                            64,
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.2),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Image.asset(
                                                                            "assets/images/play_icon.png",
                                                                            height:
                                                                                12,
                                                                            width:
                                                                                12,
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
                                                        Expanded(
                                                          flex: 3,
                                                          child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                              minHeight: 64,
                                                            ),
                                                            // height: ScreenUtil().setSp(64, ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: <
                                                                    Widget>[
                                                                  Consumer<
                                                                          VideoProvider>(
                                                                      builder: (_,
                                                                          videoProvider,
                                                                          __) {
                                                                    return Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          videoLesson
                                                                              .name!,
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                const Color(0xFF212121),
                                                                            fontWeight:
                                                                                FontWeight.values[5],
                                                                            fontSize: selectedAppLanguage!.toLowerCase() == "english"
                                                                                ? 15
                                                                                : 16,
                                                                          ),
                                                                        ),
                                                                        if (videoLesson.id ==
                                                                            videoProvider.videoLesson!.id)
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 5.0),
                                                                            child:
                                                                                Text(
                                                                              "Currently playing...",
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                color: const Color(0xFF666666),
                                                                                fontWeight: FontWeight.values[4],
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        else if (videoLesson.videoTotalDuration !=
                                                                                null &&
                                                                            videoLesson.videoTotalDuration !=
                                                                                0)
                                                                          const Padding(
                                                                            padding:
                                                                                EdgeInsets.only(
                                                                              top: 4,
                                                                            ),
                                                                            // child: Text(
                                                                            //   Duration(seconds: videoLesson.videoTotalDuration)
                                                                            //           .inHours
                                                                            //           .toString()
                                                                            //           .padLeft(
                                                                            //               2,
                                                                            //               '0') +
                                                                            //       ":" +
                                                                            //       Duration(
                                                                            //               seconds: videoLesson
                                                                            //                   .videoTotalDuration)
                                                                            //           .inMinutes
                                                                            //           .remainder(
                                                                            //               60)
                                                                            //           .toString()
                                                                            //           .padLeft(
                                                                            //               2,
                                                                            //               '0') +
                                                                            //       ":" +
                                                                            //       Duration(
                                                                            //               seconds: videoLesson
                                                                            //                   .videoTotalDuration)
                                                                            //           .inSeconds
                                                                            //           .remainder(
                                                                            //               60)
                                                                            //           .toString()
                                                                            //           .padLeft(
                                                                            //               2,
                                                                            //               '0'),
                                                                            //   style: TextStyle(
                                                                            //     fontSize: 10,
                                                                            //     color: Color(
                                                                            //         0xFF8A8A8E),
                                                                            //   ),
                                                                            // ),
                                                                          ),
                                                                      ],
                                                                    );
                                                                  }),
                                                                  // if (videoLesson
                                                                  //         .videoTotalDuration !=
                                                                  //     0)
                                                                  // LinearPercentIndicator(
                                                                  //   padding:
                                                                  //       const EdgeInsets
                                                                  //           .only(
                                                                  //     right:
                                                                  //         8,
                                                                  //   ),
                                                                  //   backgroundColor:
                                                                  //       const Color(
                                                                  //           0xFFDEDEDE),
                                                                  //   percent: (int.parse(videoLesson.videoCurrentProgress!) / videoLesson.videoTotalDuration!) >
                                                                  //           1
                                                                  //       ? ((int.parse(videoLesson.videoCurrentProgress!) % videoLesson.videoTotalDuration!) /
                                                                  //           videoLesson
                                                                  //               .videoTotalDuration!)
                                                                  //       : int.parse(videoLesson.videoCurrentProgress!) /
                                                                  //           videoLesson.videoTotalDuration!,
                                                                  //   progressColor:
                                                                  //       const Color(
                                                                  //           0xFF3399FF),
                                                                  //   trailing:
                                                                  //       Text(
                                                                  //     (((int.parse(videoLesson.videoCurrentProgress!) / videoLesson.videoTotalDuration!) > 1 ? int.parse(videoLesson.videoCurrentProgress!) % videoLesson.videoTotalDuration! : int.parse(videoLesson.videoCurrentProgress!)) * 100 ~/ videoLesson.videoTotalDuration!).toInt().toString() +
                                                                  //         "%",
                                                                  //     style: const TextStyle(
                                                                  //         color:
                                                                  //             Color(0xFF8A8A8E),
                                                                  //         fontSize: 12)
                                                                  //   )
                                                                  // )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                                // );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ));
                              }
                              return Consumer<VideoProvider>(
                                  builder: (_, videoProvider, __) {
                                return AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: ChewieListItem(
                                      subjectID: widget.subjectHome!
                                          .subjectWidget!.subjectID,
                                    ));
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : Consumer<VideoProvider>(builder: (_, videoProvider, __) {
                      return FullScreenPlayer(
                        subjectID: widget.subjectHome!.subjectWidget!.subjectID,
                      );
                    });
            },
          ),
        ),
      ),
    );
  }
}
