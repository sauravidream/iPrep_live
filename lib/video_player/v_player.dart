import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:video_player/video_player.dart';

import '../common/constants.dart';
import '../common/global_variables.dart';
import '../common/references.dart';
import '../custom_packages/src/quality_links.dart';
import '../custom_widgets/loading_widget.dart';
import '../model/video_lesson.dart';
import '../ui/subject_home/subject_home.dart';

List<VideoLessonModel>? completeListOfVideos;
AutoScrollController? videoLessonScrollController;

class ChewieDemo extends StatefulWidget {
  final SubjectHome? subjectHome;
  final VideoLessonModel? videoLessonModel;
  var subjectHomeChapterListIndex;
  Widget? videoPageContent;
  var videoData;
  var videoLesson;

  final completeListOfVideos;
  ChewieDemo({
    Key? key,
    this.title = 'Chewie Demo',
    this.subjectHome,
    this.videoLessonModel,
    this.subjectHomeChapterListIndex,
    this.videoPageContent,
    this.videoData,
    this.videoLesson,
    this.completeListOfVideos,
  }) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

/* videoPlayerController!.addListener(() {
  if (videoPlayerController!.value.isInitialized) {
  Duration duration = videoPlayerController!.value.duration;
  Duration position = videoPlayerController!.value.position;

  if (duration.inSeconds - 1 == position.inSeconds) {
  debugPrint("Next Video Playing");
  } else {
  debugPrint(" Video Playing");
  }
  }
  });
  */

class _ChewieDemoState extends State<ChewieDemo> {
  late VideoPlayerController _videoPlayerController1;

  ChewieController? _chewieController;
  late VoidCallback listener;
  int? bufferDelay;
  bool isNextPlaying = true;

  var videoUrl;
  var chapVideoList;
  bool showLoader = true;

  var id;
  var videoLessonMode;
  var subjectID;
  var topName;
  late QualityLinks quality;

  String? qualityValue;

  VideoLessonModel? videoLessonModel;
  AutoScrollController? videoLessonScrollController;
  Future fetchVideoLessons() async {
    return await videoLessonRepository.fetchVideoLessonsFromLocal(
      subjectName: widget.subjectHome!.subjectWidget!.subjectID,
      chapterName: widget.subjectHome!.chapterName,
      chapterList: widget.subjectHome!.chapterList!,
    );
  }

  final List<VideoLessonModel>? _completeListOfVideos = [];
  @override
  void initState() {
    super.initState();
    fetchVideoLessons().then((value) {
      if (value != null) {
        Future.forEach(value.values, (dynamic element) {
          _completeListOfVideos!.addAll(element);
          completeListOfVideos = _completeListOfVideos;
        });
      }

      videoLessonScrollController = AutoScrollController();
      setState(() {
        videoLessonScrollController!.scrollToIndex(
            widget.subjectHome!.chapterList!.indexWhere(
                (element) => element == widget.subjectHome!.chapterName),
            preferPosition: AutoScrollPosition.begin);

        showLoader = false;
      });
    });
    videoRepository.getQualitiesAsync("467356029").then((value) {
      if (value != null) {
        final qualityValue = value['360p 30'] ?? value[value.lastKey()];
        debugPrint(qualityValue.toString());
        initializePlayer().then((value) {
          listener = () {
            if (_videoPlayerController1.value.isInitialized) {
              Duration duration = _videoPlayerController1.value.duration;
              Duration position = _videoPlayerController1.value.position;
              if (duration.inSeconds - 1 == position.inSeconds) {
                _videoPlayerController1.removeListener(listener);
                toggleVideo();
                print("Next video play");

                Future.delayed(const Duration(seconds: 10)).then((value) {
                  _videoPlayerController1.addListener(listener);
                  print(" listener  Next video play");
                });
              } else {
                print("video play");
              }
            }
          };

          _videoPlayerController1.addListener(listener);
        });
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController1.pause();
    _videoPlayerController1.addListener(listener);
    _videoPlayerController1.dispose();

    _chewieController?.dispose();
    super.dispose();
  }

  List<String> srcs = [
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(qualityValue!);

    await Future.wait([
      _videoPlayerController1.initialize(),
    ]);
    _createChewieController();

    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      hideControlsTimer: const Duration(seconds: 10),
      allowedScreenSleep: false,
      startAt: const Duration(seconds: 2),
    );
    isNextPlaying = false;
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    currPlayIndex += 1;
    if (currPlayIndex >= srcs.length) {
      currPlayIndex = 0;
    }
    await _videoPlayerController1.play();
    await initializePlayer().then((value) {
      isNextPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: size.height * .30,
            child: _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: _chewieController!,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Loading'),
                    ],
                  ),
          ),
          showLoader
              ? const LoadingWidget()
              : widget.videoPageContent = ListView.builder(
                  controller: videoLessonScrollController,
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  shrinkWrap: true,
                  itemCount: widget.subjectHome!.chapterList!.length,
                  itemBuilder: (context, index) {
                    Widget? listOfWidget;

                    if (index > -1) {
                      if (widget.videoData == null) {
                        listOfWidget = Center(
                          child: Text(
                            "No content available",
                            style: TextStyle(
                              color: const Color(0xFF212121),
                              fontWeight: FontWeight.values[5],
                              fontSize: 15,
                            ),
                          ),
                        );
                      } else if (widget.videoData != null) {
                        listOfWidget = AutoScrollTag(
                            key: ValueKey(index),
                            controller: videoLessonScrollController!,
                            index: index,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        color: Color(widget.subjectHome!
                                            .subjectWidget!.subjectColor!),
                                        fontSize: selectedAppLanguage!
                                                    .toLowerCase() ==
                                                "english"
                                            ? 15
                                            : 16,
                                        fontWeight: FontWeight.values[5]),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Wrap(
                                      children: List.generate(
                                          widget
                                              .videoData[widget.subjectHome!
                                                  .chapterList![index]]
                                              .length, (videoIndex) {
                                        VideoLessonModel videoLesson =
                                            widget.videoData[widget.subjectHome!
                                                    .chapterList![index]]
                                                [videoIndex];
                                        chapVideoList = widget.videoData[widget
                                            .subjectHome!.chapterList![index]];

                                        return InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          /* onTap: () async {
                                  if (counter == 0) {
                                    _startTimer();

                                    if (restrictUser && (videoIndex > 1)) {
                                      videoProvider
                                          .videoPlayerController
                                          .pause();

                                      var _response =
                                          await planExpiryPopUpForStudent(
                                              context);
                                      if ((_response != null) &&
                                          (_response == "Yes")) {
                                        await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (BuildContext
                                                    context) =>
                                                Platform.isAndroid
                                                    ? const UpgradePlanPage()
                                                    : const UpgradePlan(),
                                          ),
                                        );
                                        videoProvider
                                            .videoPlayerController
                                            .play();
                                      } else {
                                        videoProvider
                                            .videoPlayerController
                                            .play();
                                      }
                                    } else {
                                      if (videoProvider
                                              .videoLesson!.onlineLink !=
                                          videoLesson.onlineLink) {
                                        videoProvider
                                            .videoPlayerController
                                            .pause();
                                        await videoProvider
                                            .saveUsersVideoWatchingHistory();
                                        await videoProvider.getVideoData(
                                            widget.subjectHome!
                                                .subjectWidget!.subjectName,
                                            videoLessonModel:
                                                widget.completeListOfVideos,
                                            videoIndex: videoLesson.id,
                                            subjectId: subjectID);

                                        videoLessonModel = videoLesson;
                                      }
                                    }
                                  }
                                },*/
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 10,
                                                bottom: 10),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  child: Container(
                                                    color: Colors.grey.shade300,
                                                    width: 112,
                                                    height: 64,
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Stack(
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl: videoLesson
                                                                            .thumbnail ==
                                                                        ""
                                                                    ? Constants
                                                                        .thumbnail
                                                                    : videoLesson
                                                                        .thumbnail!,
                                                                fit:
                                                                    BoxFit.fill,
                                                                progressIndicatorBuilder:
                                                                    (context,
                                                                            url,
                                                                            downloadProgress) =>
                                                                        const SizedBox(
                                                                  width: 112,
                                                                  height: 64,
                                                                  child: Center(
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          25,
                                                                      width: 25,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        // color: Colors.green,
                                                                        strokeWidth:
                                                                            1.5,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                              Container(
                                                                width: 112,
                                                                height: 64,
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.2),
                                                                child: Center(
                                                                  child: Image
                                                                      .asset(
                                                                    "assets/images/play_icon.png",
                                                                    height: 12,
                                                                    width: 12,
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
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0.0, 0.0, 0.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: <Widget>[
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                videoLesson
                                                                    .name!,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  color: const Color(
                                                                      0xFF212121),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .values[5],
                                                                  fontSize:
                                                                      selectedAppLanguage!.toLowerCase() ==
                                                                              "english"
                                                                          ? 15
                                                                          : 16,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: 4,
                                                                ),
                                                              ),
                                                            ],
                                                          )
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
                    }

                    return Container(
                      child: listOfWidget,
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class DelaySlider extends StatefulWidget {
  const DelaySlider({Key? key, required this.delay, required this.onSave})
      : super(key: key);

  final int? delay;
  final void Function(int?) onSave;
  @override
  State<DelaySlider> createState() => _DelaySliderState();
}

class _DelaySliderState extends State<DelaySlider> {
  int? delay;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    delay = widget.delay;
  }

  @override
  Widget build(BuildContext context) {
    const int max = 1000;
    return ListTile(
      title: Text(
        "Progress indicator delay ${delay != null ? "${delay.toString()} MS" : ""}",
      ),
      subtitle: Slider(
        value: delay != null ? (delay! / max) : 0,
        onChanged: (value) async {
          delay = (value * max).toInt();
          setState(() {
            saved = false;
          });
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.save),
        onPressed: saved
            ? null
            : () {
                widget.onSave(delay);
                setState(() {
                  saved = true;
                });
              },
      ),
    );
  }
}
