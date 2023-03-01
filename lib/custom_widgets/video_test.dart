import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idream/provider/video_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

int? videoTotalDuration;

class ChewieListItem extends StatefulWidget {
  final String? subjectID;
  const ChewieListItem({
    Key? key,
    this.subjectID,
  }) : super(key: key);

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  @override
  Widget build(BuildContext context) {
    var videoProvider = Provider.of<VideoProvider>(context, listen: true);

    return GestureDetector(
      onTap: () {
        setState(() {
          videoProvider.hideController();
        });
      },
      child: Container(
        color: Colors.black87,
        alignment: Alignment.center,
        child: Stack(
          children: [
            videoProvider.chewieController != null
                ? Stack(
                    children: [
                      const Center(child: CircularProgressIndicator()),
                      Chewie(controller: videoProvider.chewieController!),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            videoProvider.controlsHide == true
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () async {
                                SystemChrome.setEnabledSystemUIMode(
                                    //This is use for the system noach return
                                    SystemUiMode.manual,
                                    overlays: [
                                      SystemUiOverlay.top,
                                      SystemUiOverlay.bottom
                                    ]);
                                await videoProvider
                                    .chewieController!.videoPlayerController
                                    .pause();
                                videoProvider.saveUsersVideoWatchingHistory();
                                Navigator.pop(context);
                              },
                              icon: Container(
                                // padding: EdgeInsets.only(
                                //   right: 20,
                                //   bottom: 20,
                                // ),
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
                              iconSize: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4,
                                right: 11,
                              ),
                              child: videoProvider.qualitAvl == true
                                  ? GestureDetector(
                                      child: Image.asset(
                                        "assets/images/3_dot.png",
                                        height: 26,
                                        width: 26,
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                      onTap: () {
                                        // videoProvider
                                        //     .chewieController
                                        //     .videoPlayerController
                                        //     .value
                                        //     .position
                                        //     .inSeconds;
                                        videoProvider.chewieController!
                                            .videoPlayerController
                                            .pause();
                                        // _seek = true;
                                        _settingModalBottomSheet(
                                            context, setState, videoProvider);
                                        setState(() {});
                                      })
                                  : const SizedBox(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60.0,
                        // color: Colors.blue,
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
                                    setState(() {
                                      videoProvider.chewieController!
                                          .videoPlayerController
                                          .seekTo(Duration(
                                              seconds: videoProvider
                                                      .chewieController!
                                                      .videoPlayerController
                                                      .value
                                                      .position
                                                      .inSeconds -
                                                  10));
                                    });
                                  }),
                            ),
                            const SizedBox(
                              width: 60,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  child: videoProvider.chewieController!
                                          .videoPlayerController.value.isPlaying
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
                                    videoProvider
                                            .chewieController!
                                            .videoPlayerController
                                            .value
                                            .isPlaying
                                        ? videoProvider.chewieController!
                                            .videoPlayerController
                                            .pause()
                                        : videoProvider.chewieController!
                                            .videoPlayerController
                                            .play();
                                    videoProvider.notifyListeners();
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
                                    setState(() {
                                      videoProvider.chewieController!
                                          .videoPlayerController
                                          .seekTo(Duration(
                                              seconds: videoProvider
                                                      .chewieController!
                                                      .videoPlayerController
                                                      .value
                                                      .position
                                                      .inSeconds +
                                                  10));
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        // color: Colors.green,
                        height: 60.0,
                        // width: 100,

                        child: _videoOverlaySlider(
                            context, videoProvider, setState),
                      )
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

Widget _videoOverlaySlider(context, videoProvider, setState) {
  double videoWidth = MediaQuery.of(context).size.width;
  return ValueListenableBuilder(
    valueListenable: videoProvider.chewieController.videoPlayerController,
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
                  videoProvider.chewieController.videoPlayerController,
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
            InkWell(
              child: Container(
                // color: Colors.red,
                child: const Icon(
                  Icons.fullscreen,
                  size: 21.0,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              onTap: () {
                setState(() {
                  // videoProvider.chewieController.enterFullScreen();
                  // videoProvider.chewieController.exitFullScreen();
                  if (MediaQuery.of(context).orientation ==
                      Orientation.portrait) {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeRight,
                      DeviceOrientation.landscapeLeft,
                    ]);
                  } else {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown
                    ]);
                  }
                });
              },
            ),
          ],
        );
      } else {
        return Container();
      }
    },
  );
}

_settingModalBottomSheet(context, setState, videoProvider) {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (BuildContext bc) {
        final children = <Widget>[];
        videoProvider.videoQualityAvl.forEach(
          (elem, value) => (children.add(
            ListTile(
              selectedTileColor: const Color(0xFFE8F2FF),
              selected: (videoProvider.qualityValue == value),
              trailing: (videoProvider.qualityValue == value)
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
              onTap: () {
                try {
                  setState(() {
                    videoProvider.chewieController.videoPlayerController
                        .pause();
                    videoProvider.qualityValue = value;
                    // videoProvider.chewieController.videoPlayerController =
                    //     VideoPlayerController.network(
                    //         videoProvider.qualityValue);
                    videoProvider.chewieController.videoPlayerController
                        .setLooping(true);

                    // videoProvider.notifyListeners();
                    // _seek = true;
                    // initFuture = videoProvider.chewieController.videoPlayerController.initialize();
                    // videoProvider.chewieController.videoPlayerController.play();
                    // _overlay = false;
                    videoProvider.chewieController.videoPlayerController.play();
                  });
                } catch (e) {
                  debugPrint(e.toString());
                } finally {
                  Navigator.pop(context);
                }
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

class FullScreenPlayer extends StatefulWidget {
  const FullScreenPlayer({Key? key, this.subjectID}) : super(key: key);
  final String? subjectID;
  @override
  _FullScreenPlayerState createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  bool isShowing = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var videoProvider = Provider.of<VideoProvider>(context, listen: true);

    return GestureDetector(
      onTap: () {
        setState(() {
          isShowing = !isShowing;
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          videoProvider.chewieController != null
              ? Container(
                  color: Colors.black87,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Chewie(
                    controller: videoProvider.chewieController!,
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          AnimatedOpacity(
            opacity: isShowing ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 60.0,
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (MediaQuery.of(context).orientation ==
                              Orientation.landscape) {
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitDown,
                              DeviceOrientation.portraitUp
                            ]);
                            SystemChrome.setEnabledSystemUIOverlays(
                                [SystemUiOverlay.top, SystemUiOverlay.bottom]);
                            return;
                          }
                          videoProvider.chewieController!.pause();
                          videoProvider.saveUsersVideoWatchingHistory();
                          Navigator.pop(context);
                        },
                        child: Container(
                          // padding: EdgeInsets.only(
                          //   right: 20,
                          //   bottom: 20,
                          // ),
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
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 4,
                          right: 11,
                        ),
                        child: videoProvider.qualitAvl == true
                            ? GestureDetector(
                                child: Image.asset(
                                  "assets/images/3_dot.png",
                                  height: 26,
                                  width: 26,
                                  color: const Color(0xFFFFFFFF),
                                ),
                                onTap: () {
                                  videoProvider
                                      .chewieController!.videoPlayerController
                                      .pause();
                                  // _seek = true;
                                  _settingModalBottomSheet(
                                      context, setState, videoProvider);
                                  setState(() {});
                                })
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60.0,
                  // color: Colors.blue,
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
                              setState(() {
                                videoProvider
                                    .chewieController!.videoPlayerController
                                    .seekTo(Duration(
                                        seconds: videoProvider
                                                .chewieController!
                                                .videoPlayerController
                                                .value
                                                .position
                                                .inSeconds -
                                            10));
                              });
                            }),
                      ),
                      const SizedBox(
                        width: 60,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                            child: videoProvider.chewieController!
                                    .videoPlayerController.value.isPlaying
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
                              videoProvider.chewieController!
                                      .videoPlayerController.value.isPlaying
                                  ? videoProvider
                                      .chewieController!.videoPlayerController
                                      .pause()
                                  : videoProvider
                                      .chewieController!.videoPlayerController
                                      .play();
                              videoProvider.notifyListeners();
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
                              setState(() {
                                videoProvider
                                    .chewieController!.videoPlayerController
                                    .seekTo(Duration(
                                        seconds: videoProvider
                                                .chewieController!
                                                .videoPlayerController
                                                .value
                                                .position
                                                .inSeconds +
                                            10));
                              });
                            }),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  // color: Colors.green,
                  height: 60.0,
                  // width: 100,

                  child: _videoOverlaySlider(context, videoProvider, setState),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _settingModalBottomSheet(context, setState, videoProvider) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        builder: (BuildContext bc) {
          final children = <Widget>[];
          videoProvider.videoQualityAvl.forEach(
            (elem, value) => (children.add(
              ListTile(
                selectedTileColor: const Color(0xFFE8F2FF),
                selected: (videoProvider.qualityValue == value),
                trailing: (videoProvider.qualityValue == value)
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
                onTap: () {
                  try {
                    setState(() {
                      videoProvider.chewieController.videoPlayerController
                          .pause();
                      videoProvider.qualityValue = value;

                      videoProvider.chewieController.videoPlayerController
                          .setLooping(true);

                      videoProvider.chewieController.videoPlayerController
                          .play();
                    });
                  } catch (e) {
                    print(e.toString());
                  } finally {
                    Navigator.pop(context);
                  }
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
                  constraints: BoxConstraints(maxHeight: size.height * 0.7),
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Image.asset("assets/images/line.png", width: 40),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Video Quality",
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF666666),
                            fontWeight: FontWeight.values[4],
                          ),
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
}
