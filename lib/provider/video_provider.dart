import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_packages/src/quality_links.dart';
import 'package:idream/custom_widgets/custom_pop_up.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/repository/in_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../subscription/andriod/android_subscription.dart';

class VideoProvider extends ChangeNotifier {
  bool _playNextVideo = false;
  bool _videoDataSave = false;
  bool qualitAvl = false;
  int?
      currentVideoIndex; //Index of the video placed inside complete list of videos of all chapters
  List<VideoLessonModel>? completeListOfVideos;
  int? chapterIndex;
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  var videoUrl;
  VideoLessonModel? videoLesson;
  late var listOfAllVideoModels;
  int counter = 0;
  bool controlsHide = false;
  late QualityLinks quality;
  var subjectId;
  String? subjectName;

  var qualityValue;
  var videoQualityAvl;
  var videoStartTime;
  late VoidCallback listener;

  Future getVideoData(String? subjectName,
      {String? videoIndex,
      required var videoLessonModel,
      var subjectId,
      BuildContext? context}) async {
    listOfAllVideoModels = videoLessonModel;
    this.subjectId = subjectId;
    this.subjectName = subjectName;

    for (int i = 0; i <= videoLessonModel.length; i++) {
      if (videoLessonModel[i].id == videoIndex) {
        currentVideoIndex =
            i; //Index of the video placed inside complete list of videos of all chapters
        await videoPlay(
          videoLessonModel: videoLessonModel,
          currentVideoIndex: currentVideoIndex,
          context: context,
        );
        break;
      }
    }
    notifyListeners();
  }

  Future videoPlay(
      {required var videoLessonModel,
      required int? currentVideoIndex,
      BuildContext? context}) async {
    // debugPrint("----------current--@----${videoLessonModel[currentVideoIndex].id}");

    videoLesson = videoLessonModel[currentVideoIndex];

    if (videoLesson!.onlineLink!.contains('https://vimeo.com/')) {
      qualitAvl = true;
      debugPrint(true.toString());
      String videoId = videoLesson!.onlineLink!
          .replaceAllMapped("https://vimeo.com/", (match) => "");

      quality = QualityLinks(videoId);

      await quality.getQualitiesSync().then(
        (value) async {
          videoQualityAvl = await value;
          if (value != null) {
            qualityValue = await value['360p 30'] ?? value[value.lastKey()];
            // debugPrint(qualityValue);
            videoUrl = qualityValue;
            if (videoUrl == null) {
              debugPrint('https://player.vimeo.com/video/config');
            }
            videoStartTime = DateTime.now();
            // debugPrint('-------------------@--$videoUrl.-----------------------------');
            await resetVideosController(
                qualityValue: qualityValue,
                videoId: videoId,
                videoLesson: videoLesson,
                context: context);
          } else {
            await canLaunch('https://player.vimeo.com/video/config')
                ? await launch('https://player.vimeo.com/video/config')
                : throw 'Could not launch ';

            await quality.getQualitiesSync().then((value) async {
              videoQualityAvl = await value;
              qualityValue = await value['360p 30'] ?? value[value.lastKey()];
              // debugPrint(qualityValue);
              videoUrl = qualityValue;
              if (videoUrl == null) {
                debugPrint('https://player.vimeo.com/video/config');
              }
              videoStartTime = DateTime.now();
              // debugPrint('-------------------@--$videoUrl.-----------------------------');
              await resetVideosController(
                  qualityValue: qualityValue,
                  videoId: videoId,
                  videoLesson: videoLesson,
                  context: context);
            });
          }
        },
      );
    } else {
      qualitAvl = false;
      debugPrint(false.toString());
      resetVideosController(
          qualityValue: videoLesson!.onlineLink!,
          videoId: videoLesson!.id.toString(),
          videoLesson: videoLesson,
          context: context);
    }

    notifyListeners();
  }

  resetVideosController(
      {required String qualityValue,
      required String videoId,
      videoLesson,
      required BuildContext? context}) async {
    // debugPrint('-------------------@@-------------------------------');
    videoPlayerController = VideoPlayerController.network(qualityValue);
    //  chewieController..enterFullScreen();
    // chewieController.exitFullScreen();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: /*MediaQuery.of(context).size.height  / MediaQuery.of(context).size.width */ /*Platform.isIOS ? 16 / 9 : 16 / 9*/ 16 /
          9,
      autoInitialize: false,
      // overlay: ,
      autoPlay: true,
      // isLive: true,
      looping: false,
      allowFullScreen: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      allowedScreenSleep: false,
      fullScreenByDefault:
          false /*(MediaQuery.of(context).orientation == Orientation.portrait )? false : true*/,
      customControls: Container(),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );

    // chewieController.videoPlayerController.addListener(() {
    //   Future.delayed(Duration(seconds: 3), () {
    //     controlsHide = false;
    //   });
    // });

    chewieController!.videoPlayerController.play().then(
        (value) => Future.delayed(const Duration(milliseconds: 300), () {}));
    notifyListeners();

    listener() async {
      Duration _currentVideoTime =
          chewieController!.videoPlayerController.value.position;
      Duration _totalVideoTime =
          chewieController!.videoPlayerController.value.duration;

      if (chewieController!.videoPlayerController.value.isInitialized &&
          (_currentVideoTime == _totalVideoTime) &&
          !_playNextVideo) {
        _playNextVideo = true;

        if (currentVideoIndex! <= listOfAllVideoModels.length) {
          if (restrictUser && (currentVideoIndex! > 0)) {
            _playNextVideo = false;
            saveUsersVideoWatchingHistory().then((value) async {
              Navigator.pop(context!);
              var _response = await planExpiryPopUpForStudent(context);
              if ((_response != null) && (_response == "Yes")) {
                await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (BuildContext context) => Platform.isAndroid
                        ? const AndroidSubscriptionPlan()
                        : const UpgradePlan(),
                  ),
                );
              }
            });
          } else {
            currentVideoIndex = currentVideoIndex! + 1;
            saveUsersVideoWatchingHistory().then((value) async {
              await videoPlay(
                  videoLessonModel: listOfAllVideoModels,
                  currentVideoIndex: currentVideoIndex,
                  context: context);
              _playNextVideo = false;
              _videoDataSave = false;
            });
          }

          // saveUsersVideoWatchingHistory();
        } else {
          debugPrint('error');
        }

        notifyListeners();
      }
    }

    ;
    chewieController!.videoPlayerController.addListener(listener);
  }

  Future saveUsersVideoWatchingHistory() async {
    debugPrint("saveUsersVideoWatchingHistory");
    if (!usingIprepLibrary) {
      await videoLessonRepository.saveUsersVideoWatchingData(
        subjectName,
        thumbnail: videoLesson?.thumbnail,
        duration:
            chewieController!.videoPlayerController.value.position.inSeconds,
        subjectID: subjectId,
        videoID: videoLesson!.id,
        videoUrl: videoLesson!.onlineLink,
        videoName: videoLesson!.name,
        topicName: videoLesson!.topicName!,
        videoStartTime: videoStartTime,
        videoTotalDuration:
            chewieController!.videoPlayerController.value.duration.inSeconds,
      );
      debugPrint("Successful");
    }
    notifyListeners();
  }

  hideController() {
    if (controlsHide != false) {
      controlsHide = false;
    } else {
      controlsHide = true;
    }
    resetControlsHide();

    notifyListeners();
  }

  resetControlsHide() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    controlsHide = false;
    notifyListeners();
  }
}

class VideoPlayerPro extends ChangeNotifier {
  VideoPlayerController? controller;
  VideoLessonModel? video;

  Future<void> initializePlayer() async {
    if (controller != null) controller!.pause();

    controller = VideoPlayerController.network(
        "https://player.vimeo.com/play/a2cf9821-f709-43aa-9a81-22b398ec2996/hls?s=417726914_1673370808_5e4f2a9130fbcf502b2c2a60a0fcf9c1&context=Vimeo%5CController%5CApi%5CResources%5CVideoController.&log_user=0&oauth2_token_id=1672456103");
    controller!.setLooping(false);
    controller!.initialize().then((value) {
      notifyListeners();
    });
    controller?.play();

    notifyListeners();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
