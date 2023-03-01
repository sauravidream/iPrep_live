import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:video_player/video_player.dart';

class SubjectVideoProvider extends ChangeNotifier {
  VideoPlayerController? videoPlayerController;
  bool hideControls = false;
  String? stemVideoName;
  VideoLessonModel? videoLesson;
  DateTime? subjectVideosStartTime;

  late VideoPlayerController videoPlayerController1;
  late VideoPlayerController videoPlayerController2;
  ChewieController? chewieController;
  int? bufferDelay;

  List<String> srcs = [
    "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];

  Future initialiseVideoPlayerController({
    required String subjectVideoUrl,
    String? videoName,
    VideoLessonModel? currentVideoLesson,
  }) async {
    videoLesson = currentVideoLesson;
    stemVideoName = videoName;
    if (videoPlayerController != null) videoPlayerController!.pause();
    videoPlayerController = VideoPlayerController.network(subjectVideoUrl);
    videoPlayerController!.setLooping(true);
    videoPlayerController!.initialize().then((value) {
      subjectVideosStartTime = DateTime.now();
      notifyListeners();
    });
    videoPlayerController!.play();

    Future.delayed(const Duration(seconds: 3), () {
      hideControls = true;
    });
  }

  Future<void> initializePlayer() async {
    videoPlayerController1 = VideoPlayerController.network(srcs[currPlayIndex]);
    videoPlayerController2 = VideoPlayerController.network(srcs[currPlayIndex]);
    await Future.wait([
      videoPlayerController1.initialize(),
      videoPlayerController2.initialize()
    ]);
    _createChewieController();
    notifyListeners();
  }

  void _createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController1,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      hideControlsTimer: const Duration(seconds: 5),
    );
    notifyListeners();
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await videoPlayerController1.pause();
    currPlayIndex += 1;
    if (currPlayIndex >= srcs.length) {
      currPlayIndex = 0;
    }
    await initializePlayer();
    notifyListeners();
  }
}
