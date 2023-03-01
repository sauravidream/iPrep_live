import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import '../../video_player/v_player.dart';

class VideoModule extends StatefulWidget {
  final Widget videoListingWidget;

  const VideoModule({
    Key? key,
    required this.videoListingWidget,
  }) : super(key: key);

  @override
  State<VideoModule> createState() => _VideoModuleState();
}

class _VideoModuleState extends State<VideoModule> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;
  int? bufferDelay;
  List<String> srcs = [
    "https://ntpproductionall.blob.core.windows.net/ntp-content-production/content/assets/do_31310784918609100812997/do-bailon-kii-kthaa.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];
  Future initializePlayer() async {
    _videoPlayerController1 =
        VideoPlayerController.network(srcs[currPlayIndex]);
    _videoPlayerController2 =
        VideoPlayerController.network(srcs[currPlayIndex]);
    await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
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

      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: toggleVideo,
            iconData: Icons.live_tv_sharp,
            title: 'Toggle Video Src',
          ),
        ];
      },
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),

      hideControlsTimer: const Duration(seconds: 1),

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  int currPlayIndex = 0;

  // Next Video Play

  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    currPlayIndex += 1;
    if (currPlayIndex >= srcs.length) {
      currPlayIndex = 0;
    }
    await initializePlayer();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        FutureBuilder(
            future: initializePlayer(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Widget? videoPlayer;
              if (snapshot.hasData) {
                videoPlayer = Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: _chewieController != null &&
                                _chewieController!
                                    .videoPlayerController.value.isInitialized
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
                    ),
                  ],
                );
              } else {
                videoPlayer = const CircularProgressIndicator();
              }

              return Container(
                child: videoPlayer,
              );
            }),
        Container(
          child: widget.videoListingWidget,
        )
      ],
    ));
  }
}
