import 'package:flutter/material.dart';
import 'package:idream/custom_packages/exo_player/lib/ext_video_player.dart';
import 'package:idream/model/video_lesson.dart';

class StemVideoProvider extends ChangeNotifier {
  VideoPlayerController? videoPlayerController;
  bool hideControls = false;
  String? stemVideoName;
  VideoLessonModel? videoLesson;
  DateTime? stemVideosStartTime;

  Future initialiseVideoPlayerController({
    required String youtubeUrl,
    String? videoName,
    VideoLessonModel? currentVideoLesson,
  }) async {
    videoLesson = currentVideoLesson;
    stemVideoName = videoName;
    if (videoPlayerController != null) videoPlayerController!.pause();
    videoPlayerController = VideoPlayerController.network(youtubeUrl);
    videoPlayerController!.setLooping(true);
    videoPlayerController!.initialize().then((value) {
      stemVideosStartTime = DateTime.now();
      notifyListeners();
    });
    videoPlayerController!.play();

    Future.delayed(const Duration(seconds: 3), () {
      hideControls = true;
    });
  }
}
