import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/subject_tile_widget.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import '../ui/dashboard/stem_videos/stem_videos_list_page.dart';
import 'src/quality_links.dart';
import 'src/fullscreen_player.dart';

DateTime? videoStartTime;
int? videoTotalDuration;
VideoPlayerController? videoPlayerController;
List<VideoLessonModel>? completeListOfVideo = completeListOfVideos;

class VimeoPlayer extends StatefulWidget {
  final List<VideoLessonModel>? completeListOfVideos;
  Function? callback;
  final String? id, subjectID;
  final bool? autoPlay;
  final bool? looping;
  final int? position;
  final bool alreadyPlayed;
  final VideoLessonModel? videoLesson;
  final Map? assignment;
  final Batch? batchInfo;
  final String? subjectName;
  // final String batchId;
  // final String assignmentId;
  // final String assignmentIndex;
  // final String classNumber;

  VimeoPlayer({
    this.callback,
    required this.id,
    this.subjectID,
    this.autoPlay,
    this.looping,
    this.position,
    this.videoLesson,
    this.alreadyPlayed = false,
    this.assignment,
    this.batchInfo,
    required this.subjectName,
    // this.batchId,
    // this.assignmentId,
    // this.assignmentIndex,
    // this.classNumber,
    Key? key,
    this.completeListOfVideos,
  }) : super(key: key);

  @override
  _VimeoPlayerState createState() =>
      _VimeoPlayerState(id, autoPlay, looping, position, alreadyPlayed);
}

class _VimeoPlayerState extends State<VimeoPlayer> {
  final String? _id;
  bool? autoPlay = false;
  bool? looping = false;
  bool _overlay = true;
  bool fullScreen = false;
  int? position;
  bool _alreadyPlayed;

  _VimeoPlayerState(this._id, this.autoPlay, this.looping, this.position,
      this._alreadyPlayed);

  Future<void>? initFuture;

  //Quality Class
  late QualityLinks _quality;
  late Map _qualityValues;
  var _qualityValue;

  bool _seek = false;

  late double videoHeight;
  late double videoWidth;
  late double videoMargin;

  double doubleTapRMargin = 36;
  double doubleTapRWidth = 400;
  double doubleTapRHeight = 160;
  double doubleTapLMargin = 10;
  double doubleTapLWidth = 400;
  double doubleTapLHeight = 160;
  bool clicked = false;
  // int? _videoTotalDuration;

  late VoidCallback listener;
  late List<VideoLessonModel>? completeListOfVideo;

  @override
  void initState() {
    super.initState();
    completeListOfVideo = widget.completeListOfVideos;

    initializePlayer(_id!);
  }

  initializePlayer(String id) {
    _quality = QualityLinks(id);
    _quality.getQualitiesSync().then((value) {
      _qualityValues = value;
      _qualityValue = value['360p 30'] ?? value[value.lastKey()];
      videoPlayerController = VideoPlayerController.network(
        _qualityValue,
      );
      videoPlayerController!.setLooping(/*looping*/ false);
      initFuture = videoPlayerController!.initialize();
      videoStartTime = DateTime.now();
      if (autoPlay!) videoPlayerController!.play();

      setState(() {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
      });

      listener() {
        if (videoPlayerController!.value.position.inSeconds ==
                videoPlayerController!.value.duration.inSeconds &&
            videoPlayerController!.value.isInitialized) {
          videoPlayerController!.removeListener(listener);
          int videoIndex = 0;
          for (var element in completeListOfVideo!) {
            if (element.onlineLink
                    ?.replaceAllMapped("https://vimeo.com/", (match) => "") ==
                id) {
              print("nextVideo play");
              initializePlayer(completeListOfVideo![videoIndex + 1]
                  .onlineLink!
                  .replaceAllMapped("https://vimeo.com/", (match) => ""));
            }
            videoIndex++;
          }
        }
      }

      videoPlayerController?.addListener(listener);
    });

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _overlay = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return SafeArea(
          bottom: false,
          child: orientation == Orientation.landscape
              ? Scaffold(
                  body: Center(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        GestureDetector(
                            child: Container(
                              width: doubleTapLWidth / 2 - 30,
                              height: doubleTapLHeight - 46,
                              margin: EdgeInsets.fromLTRB(
                                  0,
                                  10,
                                  doubleTapLWidth / 2 + 30,
                                  doubleTapLMargin + 20),
                              decoration: const BoxDecoration(
                                  //color: Colors.red,
                                  ),
                            ),
                            onTap: () {
                              setState(() {
                                _overlay = _overlay;
                                if (_overlay) {
                                  doubleTapRHeight = videoHeight - 36;
                                  doubleTapLHeight = videoHeight - 10;
                                  doubleTapRMargin = 36;
                                  doubleTapLMargin = 10;
                                } else if (_overlay) {
                                  doubleTapRHeight = videoHeight + 36;
                                  doubleTapLHeight = videoHeight + 16;
                                  doubleTapRMargin = 0;
                                  doubleTapLMargin = 0;
                                }
                              });
                              if (_overlay && mounted) {
                                Future.delayed(const Duration(seconds: 3), () {
                                  setState(() {
                                    _overlay = false;
                                  });
                                });
                              }
                            },
                            onDoubleTap: () {
                              // setState(() {
                              videoPlayerController!.seekTo(Duration(
                                  seconds: videoPlayerController!
                                          .value.position.inSeconds -
                                      10));
                              // });
                            }),
                        GestureDetector(
                            child: Container(
                              width: doubleTapRWidth / 2 - 45,
                              height: doubleTapRHeight - 60,
                              margin: EdgeInsets.fromLTRB(
                                  doubleTapRWidth / 2 + 45,
                                  doubleTapRMargin,
                                  0,
                                  doubleTapRMargin + 20),
                              decoration: const BoxDecoration(
                                  //color: Colors.red,
                                  ),
                            ),
                            onTap: () {
                              setState(() {
                                _overlay = _overlay;
                                if (_overlay) {
                                  doubleTapRHeight = videoHeight - 36;
                                  doubleTapLHeight = videoHeight - 10;
                                  doubleTapRMargin = 36;
                                  doubleTapLMargin = 10;
                                } else if (_overlay) {
                                  doubleTapRHeight = videoHeight + 36;
                                  doubleTapLHeight = videoHeight + 16;
                                  doubleTapRMargin = 0;
                                  doubleTapLMargin = 0;
                                }
                              });
                              if (_overlay && mounted) {
                                Future.delayed(const Duration(seconds: 3), () {
                                  setState(() {
                                    _overlay = false;
                                  });
                                });
                              }
                            },
                            onDoubleTap: () {
                              // setState(() {
                              videoPlayerController!.seekTo(Duration(
                                  seconds: videoPlayerController!
                                          .value.position.inSeconds +
                                      10));
                              // });
                            }),
                        GestureDetector(
                          child: FutureBuilder(
                              future: initFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  double delta =
                                      MediaQuery.of(context).size.width -
                                          MediaQuery.of(context).size.height *
                                              videoPlayerController!
                                                  .value.aspectRatio;

                                  if (MediaQuery.of(context).orientation ==
                                          Orientation.portrait ||
                                      delta < 0) {
                                    videoHeight =
                                        MediaQuery.of(context).size.width /
                                            videoPlayerController!
                                                .value.aspectRatio;
                                    videoWidth =
                                        MediaQuery.of(context).size.width;
                                    videoMargin = 0;
                                  } else {
                                    videoHeight =
                                        MediaQuery.of(context).size.height;
                                    videoWidth = videoHeight *
                                        videoPlayerController!
                                            .value.aspectRatio;
                                    videoMargin =
                                        (MediaQuery.of(context).size.width -
                                                videoWidth) /
                                            2;
                                  }

                                  if (_seek &&
                                      videoPlayerController!
                                              .value.duration.inSeconds >
                                          2) {
                                    videoPlayerController!
                                        .seekTo(Duration(seconds: position!));
                                    _seek = false;
                                  }
                                  if (_alreadyPlayed &&
                                      // ignore: unnecessary_null_comparison
                                      widget.videoLesson!
                                              .videoCurrentProgress !=
                                          null) {
                                    videoPlayerController!
                                        .seekTo(Duration(seconds: position!));
                                    _alreadyPlayed = false;
                                  }

                                  return Stack(
                                    children: <Widget>[
                                      Container(
                                        // height: videoHeight,
                                        // width: videoWidth,
                                        margin:
                                            EdgeInsets.only(left: videoMargin),
                                        child:
                                            VideoPlayer(videoPlayerController!),
                                      ),
                                      _videoOverlay(context),
                                    ],
                                  );
                                } else {
                                  return const Center(
                                    heightFactor: 6,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 4,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF22A3D2)),
                                    ),
                                  );
                                }
                              }),
                          onTap: () {
                            setState(() {
                              _overlay = _overlay;
                              if (_overlay) {
                                doubleTapRHeight = videoHeight - 36;
                                doubleTapLHeight = videoHeight - 10;
                                doubleTapRMargin = 36;
                                doubleTapLMargin = 10;
                              } else if (_overlay) {
                                doubleTapRHeight = videoHeight + 36;
                                doubleTapLHeight = videoHeight + 16;
                                doubleTapRMargin = 0;
                                doubleTapLMargin = 0;
                              }
                            });

                            if (_overlay && mounted) {
                              Future.delayed(const Duration(seconds: 3), () {
                                setState(() {
                                  _overlay = false;
                                });
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : FullscreenPlayer(
                  id: _id,
                  autoPlay: true,
                  controller: videoPlayerController,
                  position: videoPlayerController!.value.position.inSeconds,
                  initFuture: initFuture,
                  qualityValue: _qualityValue,
                  videoPlayerContext: context,
                  videoName: widget.videoLesson!.name ?? "",
                  vimeoPlayerWidget: widget,
                ),
        );
      },
    );
  }

  //================================ Quality ================================//
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        builder: (BuildContext bc) {
          final children = <Widget>[];
          _qualityValues.forEach(
            (elem, value) => (children.add(
              ListTile(
                selectedTileColor: const Color(0xFFE8F2FF),
                selected: (videoPlayerController!.dataSource == value),
                trailing: (videoPlayerController!.dataSource == value)
                    ? Image.asset(
                        "assets/images/checked_image_blue.png",
                        height: 22,
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                title: Text(
                  " ${elem.toString().replaceAll("30", "")}",
                  textAlign: TextAlign.left,
                ),
                onTap: () => {
                  setState(() {
                    videoPlayerController!.pause();
                    _qualityValue = value;
                    videoPlayerController =
                        VideoPlayerController.network(_qualityValue);
                    videoPlayerController!.setLooping(true);
                    _seek = true;
                    initFuture = videoPlayerController!.initialize();
                    videoPlayerController!.play();
                    _overlay = false;
                  }),
                  Navigator.pop(context)
                },
              ),
            )),
          );

          Widget _firstWidget = children[0];
          children.removeAt(0);
          children.add(_firstWidget);
          return Wrap(
            children: [
              SafeArea(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Image.asset("assets/images/line.png", width: 40),
                      ),
                      Text(
                        "Video Quality",
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF666666),
                          fontWeight: FontWeight.values[4],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        child: Wrap(
                          children: children,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  //================================ OVERLAY ================================//
  Widget _videoOverlay(videoPlayerContext) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          child: Center(
            child: Container(
              // width: videoWidth,
              // height: videoHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Color(0x662F2C47), Color(0x662F2C47)],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                    child: Image.asset(
                      "assets/images/backward_video_icon.png",
                      width: 32,
                      height: 34,
                    ) /*Icon(
                            Icons.skip_previous,
                            size: 60.0,
                            color: Color(0xFFFFFFFF),
                          )*/
                    ,
                    onTap: () {
                      // setState(() {
                      videoPlayerController!.seekTo(Duration(
                          seconds:
                              videoPlayerController!.value.position.inSeconds -
                                  10));
                      // });
                    }),
              ),
              const SizedBox(
                width: 60,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    child: videoPlayerController!.value.isPlaying
                        ? const Icon(
                            Icons.pause,
                            size: 60.0,
                            color: Color(0xFFFFFFFF),
                          )
                        : const Icon(
                            Icons.play_arrow,
                            size: 60.0,
                            color: Color(0xFFFFFFFF),
                          ),
                    onTap: () {
                      setState(() {
                        videoPlayerController!.value.isPlaying
                            ? videoPlayerController!.pause()
                            : videoPlayerController!.play();
                      });
                    }),
              ),
              const SizedBox(
                width: 60,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    child: Image.asset(
                      "assets/images/forward_video_icon.png",
                      width: 32,
                      height: 34,
                    ) /*Icon(
                            Icons.skip_next,
                            size: 60.0,
                            color: Color(0xFFFFFFFF),
                          )*/
                    ,
                    onTap: () async {
                      // setState(() {
                      videoPlayerController!.seekTo(Duration(
                          seconds:
                              videoPlayerController!.value.position.inSeconds +
                                  10));
                      // });
                    }),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () async {
                if (clicked == false) {
                  clicked = true;
                  videoPlayerController!.pause();
                  videoIdBeingPlayed = "";
                  videoPlayed = false;
                  if (videoTotalDuration != null &&
                      !usingIprepLibrary &&
                      widget.subjectID != null) {
                    await videoLessonRepository.saveUsersVideoWatchingData(
                      widget.subjectName,
                      thumbnail: widget.videoLesson?.thumbnail ?? "",
                      duration: videoPlayerController!.value.position.inSeconds,
                      subjectID: widget.subjectID!,
                      videoID: widget.videoLesson!.id,
                      videoUrl: widget.videoLesson!.onlineLink,
                      videoName: widget.videoLesson!.name,
                      topicName: widget.videoLesson!.topicName!,
                      videoStartTime: videoStartTime,
                      videoTotalDuration: videoTotalDuration,
                      assignmentId: ((widget.assignment != null)
                          ? widget.assignment!['assignment_id']
                          : null),
                      teacherId: ((widget.assignment != null)
                          ? widget.assignment!['teacher_id']
                          : null),
                      assignmentIndex: ((widget.assignment != null)
                          ? widget.assignment!['item_index']
                          : null),
                      boardID: ((widget.batchInfo != null)
                          ? widget.batchInfo!.boardId
                          : null),
                      language: ((widget.batchInfo != null)
                          ? widget.batchInfo!.language
                          : null),
                      classID: ((widget.assignment != null)
                          ? widget.assignment!['class_number']
                          : null),
                      batchId: ((widget.batchInfo != null)
                          ? widget.batchInfo!.batchId
                          : null),
                    );
                  }
                  Navigator.pop(videoPlayerContext);
                  // return true;
                } else {
                  debugPrint("Clicked Multiple times. Please wait...");
                }
              },
              child: Container(
                // margin: EdgeInsets.only(left: videoWidth + videoMargin - 48),
                padding: const EdgeInsets.only(
                  right: 30,
                  bottom: 30,
                ),
                margin: const EdgeInsets.only(
                  left: 12,
                  top: 12,
                ),
                child: Image.asset(
                  "assets/images/back_icon.png",
                  height: 30,
                  width: 30,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //TODO: Part of future release
                // GestureDetector(
                //     child: Image.asset(
                //       "assets/images/save.png",
                //       height: ScreenUtil()
                //           .setSp(26, ),
                //       width: ScreenUtil()
                //           .setSp(26, ),
                //       color: Color(0xFFFFFFFF),
                //     ),
                //     onTap: () {},
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 11,
                  ),
                  child: GestureDetector(
                      child: Image.asset(
                        "assets/images/3_dot.png",
                        height: 26,
                        width: 26,
                        color: const Color(0xFFFFFFFF),
                      ),
                      onTap: () {
                        position =
                            videoPlayerController!.value.position.inSeconds;
                        _seek = true;
                        _settingModalBottomSheet(context);
                        setState(() {});
                      }),
                ),
              ],
            ),
          ],
        ),
        Container(
          //===== Ползунок =====//
          margin: EdgeInsets.only(
            top: videoHeight - videoHeight * 0.3,
            left: videoMargin,
          ), //CHECK IT
          child: _videoOverlaySlider(videoPlayerContext),
        )
      ],
    );
  }

  Widget _videoOverlaySlider(videoPlayerContext) {
    return ValueListenableBuilder(
      valueListenable: videoPlayerController!,
      builder: (context, VideoPlayerValue value, child) {
        if (!value.hasError && value.isInitialized) {
          videoTotalDuration = value.duration.inSeconds;

          return Row(
            children: <Widget>[
              const SizedBox(
                width: 2,
              ),
              Container(
                width: videoWidth * 0.13,
                alignment: const Alignment(0, 0),
                child: Text(
                  '${value.position.inMinutes.toString().padLeft(2, '0')}:${(value.position.inSeconds - value.position.inMinutes * 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Flexible(
                child: SizedBox(
                  height: 20,
                  width: videoWidth * 0.65,
                  child: VideoProgressIndicator(
                    videoPlayerController!,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Color(0xFF0070FF),
                      backgroundColor: Color(0xFFFFFFFF),
                      bufferedColor: Color(0x5583D8F7),
                    ),
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Container(
                width: videoWidth * 0.13,
                alignment: const Alignment(0, 0),
                child: Text(
                  '${value.duration.inMinutes.toString().padLeft(2, '0')}:${(value.duration.inSeconds - value.duration.inMinutes * 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              SizedBox(
                // margin: EdgeInsets.only(
                //     top: videoHeight - 70, left: videoWidth + videoMargin - 50),

                width: videoWidth * 0.1,
                child: IconButton(
                    alignment: AlignmentDirectional.center,
                    icon: const Icon(Icons.fullscreen, size: 30.0),
                    color: const Color(0xFFFFFFFF),
                    onPressed: () async {
                      setState(() {
                        videoPlayerController!.pause();
                      });
                      position = await Navigator.push(
                          context,
                          PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) =>
                                  FullscreenPlayer(
                                    id: _id,
                                    autoPlay: true,
                                    controller: videoPlayerController,
                                    position: videoPlayerController!
                                        .value.position.inSeconds,
                                    initFuture: initFuture,
                                    qualityValue: _qualityValue,
                                    videoPlayerContext: videoPlayerContext,
                                    videoName: widget.videoLesson!.name ?? "",
                                    vimeoPlayerWidget: widget,
                                  ),
                              transitionsBuilder: (___,
                                  Animation<double> animation,
                                  ____,
                                  Widget child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                      scale: animation, child: child),
                                );
                              }));
                      setState(() {
                        videoPlayerController!.play();
                        _seek = true;
                      });
                    }),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }
}
