library vimeoplayer;

import 'package:flutter/material.dart';
// ignore: unused_import

import 'package:idream/custom_packages/vimeoplayer.dart';
// ignore: unused_import
import 'package:idream/custom_widgets/subject_tile_widget.dart';
// ignore: unused_import
import 'package:idream/ui/subject_home/video_lessons_page.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'quality_links.dart';


class FullscreenPlayer extends StatefulWidget {
  final String? id;
  final bool? autoPlay;
  final bool? looping;
  final VideoPlayerController? controller;
  final position;
  final Future<void>? initFuture;
  final String? qualityValue;
  final BuildContext? videoPlayerContext;
  final String? videoName;
  final VimeoPlayer? vimeoPlayerWidget;

  const FullscreenPlayer({
    required this.id,
    this.autoPlay,
    this.looping,
    this.controller,
    this.position,
    this.initFuture,
    this.qualityValue,
    this.videoPlayerContext,
    this.videoName,
    this.vimeoPlayerWidget,
    Key? key,
  }) : super(key: key);

  @override
  _FullscreenPlayerState createState() => _FullscreenPlayerState(
      id, autoPlay, looping, controller, position, initFuture, qualityValue);
}

class _FullscreenPlayerState extends State<FullscreenPlayer> {
  String? _id;
  bool? autoPlay = false;
  bool? looping = false;
  bool _overlay = true;
  bool fullScreen = true;

  VideoPlayerController? controller;
  VideoPlayerController? _controller;

  int? position;

  Future<void>? initFuture;
  var qualityValue;

  _FullscreenPlayerState(this._id, this.autoPlay, this.looping, this.controller,
      this.position, this.initFuture, this.qualityValue);

  // Quality Class
  late QualityLinks _quality;
   Map? _qualityValues;

  bool _seek = true;

  double? videoHeight;
  double? videoWidth;
  late double videoMargin;

  double doubleTapRMarginFS = 36;
  double? doubleTapRWidthFS = 700;
  double doubleTapRHeightFS = 300;
  double doubleTapLMarginFS = 10;
  double? doubleTapLWidthFS = 700;
  double? doubleTapLHeightFS = 400;

  @override
  void initState() {
    _controller = controller;
    if (autoPlay!) _controller!.play();

    _quality = QualityLinks(_id); //Create class
    _quality.getQualitiesSync().then((value) {
      _qualityValues = value;
    });

    setState(() {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _overlay = false;
      });
    });
    super.initState();
  }

  Future<bool> _onWillPop() {
    setState(() {
      _controller!.pause();
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
    Navigator.pop(context, _controller!.value.position.inSeconds);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            body: Center(
                child: Container(
          color: Colors.black87,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              GestureDetector(
                  child: Container(
                    width: doubleTapLWidthFS! / 2 - 30,
                    height: doubleTapLHeightFS! - 44,
                    margin: EdgeInsets.fromLTRB(
                        0, 40, doubleTapLWidthFS! / 2 + 30, 40),
                    decoration: const BoxDecoration(
                        //color: Colors.red,
                        ),
                  ),
                  onTap: () {
                    setState(() {
                      _overlay = !_overlay;
                      if (_overlay) {
                        doubleTapRHeightFS = videoHeight! - 36;
                        doubleTapLHeightFS = videoHeight! - 10;
                        doubleTapRMarginFS = 36;
                        doubleTapLMarginFS = 10;
                      } else if (!_overlay) {
                        doubleTapRHeightFS = videoHeight! + 36;
                        doubleTapLHeightFS = videoHeight;
                        doubleTapRMarginFS = 0;
                        doubleTapLMarginFS = 0;
                      }
                    });
                    if (_overlay && this.mounted) {
                      Future.delayed(const Duration(seconds: 3), () {
                        setState(() {
                          _overlay = false;
                        });
                      });
                    }
                  },
                  onDoubleTap: () {
                    // setState(() {
                    _controller!.seekTo(Duration(
                        seconds: _controller!.value.position.inSeconds - 10));
                    // });
                  }),
              GestureDetector(
                  child: Container(
                    width: doubleTapRWidthFS! / 2 - 45,
                    height: doubleTapRHeightFS - 80,
                    margin: EdgeInsets.fromLTRB(doubleTapRWidthFS! / 2 + 45, 0,
                        0, doubleTapLMarginFS + 20),
                    decoration: const BoxDecoration(
                        //color: Colors.red,
                        ),
                  ),
                  //Редактируем размер области дабл тапа при показе оверлея.
                  // Сделано для открытия кнопок "Во весь экран" и "Качество"
                  onTap: () {
                    setState(() {
                      _overlay = !_overlay;
                      if (_overlay) {
                        doubleTapRHeightFS = videoHeight! - 36;
                        doubleTapLHeightFS = videoHeight! - 10;
                        doubleTapRMarginFS = 36;
                        doubleTapLMarginFS = 10;
                      } else if (!_overlay) {
                        doubleTapRHeightFS = videoHeight! + 36;
                        doubleTapLHeightFS = videoHeight;
                        doubleTapRMarginFS = 0;
                        doubleTapLMarginFS = 0;
                      }
                    });
                    if (_overlay && this.mounted) {
                      Future.delayed(const Duration(seconds: 3), () {
                        setState(() {
                          _overlay = false;
                        });
                      });
                    }
                  },
                  onDoubleTap: () {
                    // setState(() {
                    _controller!.seekTo(Duration(
                        seconds: _controller!.value.position.inSeconds + 10));
                    // });
                  }),
              GestureDetector(
                child: FutureBuilder(
                    future: initFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        //Управление шириной и высотой видео
                        double delta = MediaQuery.of(context).size.width -
                            MediaQuery.of(context).size.height *
                                _controller!.value.aspectRatio;
                        if (MediaQuery.of(context).orientation ==
                                Orientation.portrait ||
                            delta < 0) {
                          videoHeight = MediaQuery.of(context).size.width /
                              _controller!.value.aspectRatio;
                          videoWidth = MediaQuery.of(context).size.width;
                          videoMargin = 0;
                        } else {
                          videoHeight = MediaQuery.of(context).size.height;
                          videoWidth =
                              videoHeight! * _controller!.value.aspectRatio;
                          videoMargin =
                              (MediaQuery.of(context).size.width - videoWidth!) /
                                  2;
                        }
                        //Переменные дабл тапа, зависимые от размеров видео
                        doubleTapRWidthFS = videoWidth;
                        doubleTapRHeightFS = videoHeight! - 36;
                        doubleTapLWidthFS = videoWidth;
                        doubleTapLHeightFS = videoHeight;

                        if (_seek && fullScreen) {
                          _controller!.seekTo(Duration(seconds: position!));
                          _seek = false;
                        }

                        if (_seek && _controller!.value.duration.inSeconds > 2) {
                          _controller!.seekTo(Duration(seconds: position!));
                          _seek = false;
                        }
                        SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

                        return Stack(
                          children: <Widget>[
                            Container(
                              // height: videoHeight,
                              // width: videoWidth,
                              margin: EdgeInsets.only(
                                left: videoMargin,
                              ),
                              child: VideoPlayer(_controller!),
                            ),
                            _videoOverlay(),
                          ],
                        );
                      } else {
                        return const Center(
                            heightFactor: 6,
                            child:  CircularProgressIndicator(
                              strokeWidth: 4,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF22A3D2)),
                            ));
                      }
                    }),
                onTap: () {
                  setState(() {
                    _overlay = !_overlay;
                    if (_overlay) {
                      doubleTapRHeightFS = videoHeight! - 36;
                      doubleTapLHeightFS = videoHeight! - 10;
                      doubleTapRMarginFS = 36;
                      doubleTapLMarginFS = 10;
                    } else if (!_overlay) {
                      doubleTapRHeightFS = videoHeight! + 36;
                      doubleTapLHeightFS = videoHeight;
                      doubleTapRMarginFS = 0;
                      doubleTapLMarginFS = 0;
                    }
                  });
                  if (_overlay && this.mounted) {
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
        ))));
  }

  //================================ Quality ================================//
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      builder: (BuildContext bc) {
        final children = <Widget>[];

        if (_qualityValues != null) {
          _qualityValues!.forEach((elem, value) => (children.add(ListTile(
              title: Text(
                " ${elem.toString().replaceAll("30", "")}",
              ),
              onTap: () => {
                    setState(() {
                      _controller!.pause();
                      _controller = VideoPlayerController.network(value);
                      _controller!.setLooping(true);
                      _seek = true;
                      initFuture = _controller!.initialize();
                      _controller!.play();
                    }),
                  }))));
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
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: Image.asset(
                          "assets/images/line.png",
                          width: 40,
                        ),
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
        }
        return Center(
          child: Container(
            // height: videoHeight,
            child: const Text(
              "Currently, data is not available. Please retry.",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF212121),
                fontFamily: "Inter",
              ),
            ),
          ),
        );
      },
    );
  }

  //================================ OVERLAY ================================//
  Widget _videoOverlay() {
    return _overlay
        ? Stack(
            children: <Widget>[
              GestureDetector(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: videoHeight,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Color(0x662F2C47),
                          Color(0x662F2C47)
                        ],
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
                            width: 50,
                            height: 50,
                          ),
                          onTap: () async {
                            // setState(() {
                            _controller!.seekTo(Duration(
                                seconds:
                                    _controller!.value.position.inSeconds - 10));
                            // });
                          }),
                    ),
                    const SizedBox(
                      width: 106,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                          child: _controller!.value.isPlaying
                              ? const Icon(Icons.pause,
                                  size: 60.0, color: const Color(0xFFFFFFFF))
                              : const Icon(Icons.play_arrow,
                                  size: 60.0, color: const Color(0xFFFFFFFF)),
                          // color: Color(0xFFFFFFFF),
                          onTap: () {
                            setState(() {
                              _controller!.value.isPlaying
                                  ? _controller!.pause()
                                  : _controller!.play();
                            });
                          }),
                    ),
                    // IconButton(
                    //     padding: EdgeInsets.only(
                    //       top: videoHeight / 2 - 50,
                    //       bottom: videoHeight / 2 - 30,
                    //     ),
                    //     icon: _controller.value.isPlaying
                    //         ? Icon(Icons.pause, size: 60.0)
                    //         : Icon(Icons.play_arrow, size: 60.0),
                    //     color: Color(0xFFFFFFFF),
                    //     onPressed: () {
                    //       setState(() {
                    //         _controller.value.isPlaying
                    //             ? _controller.pause()
                    //             : _controller.play();
                    //       });
                    //     }),
                    const SizedBox(
                      width: 106,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                          // padding: EdgeInsets.only(
                          //   // top: videoHeight / 2 - videoHeight * 0.1,
                          //   // bottom: videoHeight / 2 + videoHeight * 0.1
                          //   left: 50,
                          //   right: 16,
                          //   top: 0,
                          //   bottom: 0,
                          // ),
                          child: Image.asset(
                            "assets/images/forward_video_icon.png",
                            width: 50,
                            height: 50,
                          ),
                          onTap: () async {
                            // setState(() {
                            _controller!.seekTo(Duration(
                                seconds:
                                    _controller!.value.position.inSeconds + 10));
                            // });
                          }),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: videoHeight! - 40,
                  left: videoMargin,
                ), //CHECK IT
                child: _videoOverlaySlider(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Container(
                    //   // margin: EdgeInsets.only(left: videoWidth + videoMargin - 200),
                    //   child: IconButton(
                    //       icon: Image.asset(
                    //         "assets/images/back_icon.png",
                    //         height:
                    //         ScreenUtil().setSp(100, ),
                    //         width:
                    //         ScreenUtil().setSp(100, ),
                    //         color: Color(0xFFFFFFFF),
                    //       ),
                    //       onPressed: () {
                    //         setState(() {
                    //           _controller.pause();
                    //           SystemChrome.setPreferredOrientations([
                    //             DeviceOrientation.portraitDown,
                    //             DeviceOrientation.portraitUp
                    //           ]);
                    //           SystemChrome.setEnabledSystemUIOverlays(
                    //               [SystemUiOverlay.top, SystemUiOverlay.bottom]);
                    //         });
                    //         Navigator.pop(
                    //             context, _controller.value.position.inSeconds);
                    //       }),
                    // ),

                    InkWell(
                      onTap: () {
                        setState(() {
                          _controller!.pause();
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitDown,
                            DeviceOrientation.portraitUp
                          ]);
                          SystemChrome.setEnabledSystemUIOverlays(
                              [SystemUiOverlay.top, SystemUiOverlay.bottom]);
                        });
                        Navigator.pop(
                            context, _controller!.value.position.inSeconds);
                      },
                      child: Container(
                        // width: 150,
                        // margin: EdgeInsets.only(left: videoWidth + videoMargin - 48),
                        margin: const EdgeInsets.only(
                          left: 12,
                          top: 12,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/back_icon.png",
                              height: 30,
                              width: 30,
                              color: const Color(0xFFFFFFFF),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              widget.videoName!,
                              style: const TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ignore: todo
                        //TODO: Part of future release
                        // GestureDetector(
                        //     child: Image.asset(
                        //       "assets/images/save.png",
                        //       height: ScreenUtil()
                        //           .setSp(50, ),
                        //       width: ScreenUtil()
                        //           .setSp(50, ),
                        //       color: Color(0xFFFFFFFF),
                        //     ),
                        //     onTap: () {}),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, right: 10, top: 10),
                          child: GestureDetector(
                              child: Image.asset(
                                "assets/images/3_dot.png",
                                height: 32,
                                width: 32,
                              ),
                              onTap: () {
                                position = _controller!.value.position.inSeconds;
                                _seek = true;
                                _settingModalBottomSheet(context);
                                setState(() {});
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        : const Center();
  }

  Widget _videoOverlaySlider() {
    return ValueListenableBuilder(
      valueListenable: _controller!,
      builder: (context, VideoPlayerValue value, child) {
        if (!value.hasError && value.isInitialized) {
          return Row(
            children: <Widget>[
              Container(
                width: 70,
                alignment: const Alignment(0, 0),
                child: Text(
                  value.position.inMinutes.toString().padLeft(2, '0') +
                      ':' +
                      (value.position.inSeconds - value.position.inMinutes * 60)
                          .toString()
                          .padLeft(2, '0'),
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  height: 20,
                  width: videoWidth! - 92,
                  child: VideoProgressIndicator(
                    _controller!,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Color(0xFF22A3D2),
                      backgroundColor: Color(0x5515162B),
                      bufferedColor: Color(0x5583D8F7),
                    ),
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  ),
                ),
              ),
              Container(
                width: 70,
                alignment: const Alignment(0, 0),
                child: Text(
                  value.duration.inMinutes.toString().padLeft(2, '0') +
                      ':' +
                      (value.duration.inSeconds - value.duration.inMinutes * 60)
                          .toString()
                          .padLeft(2, '0'),
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              IconButton(
                  alignment: AlignmentDirectional.center,
                  icon: const Icon(Icons.fullscreen, size: 30.0),
                  color: const Color(0xFFFFFFFF),
                  onPressed: () {
                    setState(() {
                      _controller!.pause();
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitDown,
                        DeviceOrientation.portraitUp
                      ]);
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
                    });
                    Navigator.pop(
                        context, _controller!.value.position.inSeconds);
                  }),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
