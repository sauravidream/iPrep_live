import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/provider/stem_video_provider.dart';
import 'package:provider/provider.dart';
import 'package:idream/custom_packages/exo_player/lib/ext_video_player.dart';
import '../custom_widgets/subject_tile_widget.dart';

class YoutubeVideo extends StatefulWidget {
  final GlobalKey? stemVideosKey;
  final ListView? videosChild;
  final String? youtubeLink;
  final String? videoName;
  final VideoLessonModel? videoLesson;
  final Map? assignment;
  final Batch? batchInfo;
  final String? subjectId;
  final String? subjectName;

  const YoutubeVideo({
    Key? key,
    this.videosChild,
    this.stemVideosKey,
    this.videoName,
    this.youtubeLink,
    this.videoLesson,
    this.assignment,
    this.batchInfo,
    this.subjectId,
    this.subjectName,
  }) : super(key: key);

  @override
  _YoutubeVideoState createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
  final key = GlobalKey();
  Widget? videoListWidget;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    if (widget.videosChild != null) {
      videoListWidget = KeyedSubtree(key: key, child: widget.videosChild!);
    }
    Provider.of<StemVideoProvider>(context, listen: false)
        .initialiseVideoPlayerController(
      youtubeUrl: widget.youtubeLink!,
      videoName: widget.videoName,
      currentVideoLesson: widget.videoLesson,
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (Provider.of<StemVideoProvider>(context, listen: false)
            .videoPlayerController !=
        null) {
      Provider.of<StemVideoProvider>(context, listen: false)
          .videoPlayerController!
          .pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    var stemProvider = Provider.of<StemVideoProvider>(context, listen: false);
    return OrientationBuilder(builder: (context, orientation) {
      return WillPopScope(
        onWillPop: () async {
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
            return false;
          } else {
            videoPlayed = false;
            if ((Provider.of<StemVideoProvider>(context, listen: false)
                        .videoPlayerController!
                        .value
                        .duration !=
                    null) &&
                usingIprepLibrary == false) {
              await stemVideoRepository.saveUsersStemVideoWatchingData(
                widget.subjectName ?? widget.assignment!['subject_name'],
                duration: Provider.of<StemVideoProvider>(context, listen: false)
                    .videoPlayerController!
                    .value
                    .position
                    .inSeconds,
                subjectID: widget.subjectId!,
                videoLesson: stemProvider.videoLesson!,
                videoStartTime: stemProvider.stemVideosStartTime,
                videoTotalDuration:
                    Provider.of<StemVideoProvider>(context, listen: false)
                        .videoPlayerController!
                        .value
                        .duration!
                        .inSeconds,
                batchId: widget.batchInfo?.batchId,
                assignmentId: (widget.assignment != null)
                    ? widget.assignment!['assignment_id']
                    : null,
                assignmentIndex: (widget.assignment != null)
                    ? widget.assignment!['item_index']
                    : null,
                teacherId: (widget.assignment != null)
                    ? widget.assignment!['teacher_id']
                    : null,
                boardID: widget.batchInfo?.boardId,
                language: widget.batchInfo?.language,
                classID: (widget.assignment != null)
                    ? widget.assignment!['class_number']
                    : null,
              );
            }
            return true;
          }
        },
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                Consumer<StemVideoProvider>(
                  builder: (context, stemVideoProviderModel, child) =>
                      (OrientationBuilder(
                    builder: (context, orientation) {
                      return Column(
                        children: [
                          Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Container(
                                    color: Colors.black,
                                    height: (MediaQuery.of(context)
                                                .orientation ==
                                            Orientation.portrait)
                                        ? MediaQuery.of(context).size.height *
                                            0.35
                                        : MediaQuery.of(context).size.height,
                                    width: double.maxFinite,
                                    child: (stemVideoProviderModel
                                                .videoPlayerController !=
                                            null)
                                        ? (stemVideoProviderModel
                                                .videoPlayerController!
                                                .value
                                                .initialized
                                            ? Stack(
                                                children: <Widget>[
                                                  InkWell(
                                                    child: VideoPlayer(
                                                      stemVideoProviderModel
                                                          .videoPlayerController!,
                                                    ),
                                                    onTap: () {
                                                      stemVideoProviderModel
                                                              .hideControls =
                                                          !stemVideoProviderModel
                                                              .hideControls;
                                                      stemVideoProviderModel
                                                          .notifyListeners();
                                                      Future.delayed(
                                                          const Duration(
                                                              seconds: 2), () {
                                                        stemVideoProviderModel
                                                                .hideControls =
                                                            true;
                                                        stemVideoProviderModel
                                                            .notifyListeners();
                                                      });
                                                    },
                                                  ),
                                                  Visibility(
                                                    visible:
                                                        !stemVideoProviderModel
                                                            .hideControls,
                                                    child: _PlayPauseOverlay(
                                                      controller:
                                                          stemVideoProviderModel
                                                              .videoPlayerController,
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible:
                                                        !stemVideoProviderModel
                                                            .hideControls,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Container(
                                                        height: 50,
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              '${stemVideoProviderModel.videoPlayerController!.value.position.inMinutes.toString().padLeft(2, '0')}:${(stemVideoProviderModel.videoPlayerController!.value.position.inSeconds - stemVideoProviderModel.videoPlayerController!.value.position.inMinutes * 60).toString().padLeft(2, '0')}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Color(
                                                                    0xFFFFFFFF),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Flexible(
                                                              child:
                                                                  VideoProgressIndicator(
                                                                stemVideoProviderModel
                                                                    .videoPlayerController!,
                                                                allowScrubbing:
                                                                    true,
                                                                colors:
                                                                    VideoProgressColors(
                                                                  playedColor:
                                                                      const Color(
                                                                          0xFF0070FF),
                                                                  backgroundColor:
                                                                      const Color(
                                                                          0xFFFFFFFF),
                                                                  bufferedColor:
                                                                      const Color(
                                                                          0x5583D8F7),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0,
                                                                        bottom:
                                                                            8.0),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              '${stemVideoProviderModel.videoPlayerController!.value.duration!.inMinutes.toString().padLeft(2, '0')}:${(stemVideoProviderModel.videoPlayerController!.value.duration!.inSeconds - stemVideoProviderModel.videoPlayerController!.value.duration!.inMinutes * 60).toString().padLeft(2, '0')}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Color(
                                                                    0xFFFFFFFF),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                if (MediaQuery.of(
                                                                            context)
                                                                        .orientation ==
                                                                    Orientation
                                                                        .portrait) {
                                                                  SystemChrome
                                                                      .setPreferredOrientations([
                                                                    DeviceOrientation
                                                                        .landscapeRight,
                                                                    DeviceOrientation
                                                                        .landscapeLeft,
                                                                  ]);
                                                                } else {
                                                                  SystemChrome
                                                                      .setPreferredOrientations([
                                                                    DeviceOrientation
                                                                        .portraitUp,
                                                                    DeviceOrientation
                                                                        .portraitDown
                                                                  ]);
                                                                }
                                                              },
                                                              child: const Icon(
                                                                Icons
                                                                    .fullscreen,
                                                                size: 30.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible:
                                                        !stemVideoProviderModel
                                                            .hideControls,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        if (MediaQuery.of(
                                                                    context)
                                                                .orientation ==
                                                            Orientation
                                                                .landscape) {
                                                          SystemChrome
                                                              .setPreferredOrientations([
                                                            DeviceOrientation
                                                                .landscapeRight,
                                                            DeviceOrientation
                                                                .landscapeLeft,
                                                            DeviceOrientation
                                                                .portraitUp,
                                                            DeviceOrientation
                                                                .portraitDown,
                                                          ]);
                                                          return false
                                                              as Future<void>;
                                                        } else {
                                                          videoIdBeingPlayed =
                                                              "";
                                                          videoPlayed = false;
                                                          if ((Provider.of<StemVideoProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .videoPlayerController!
                                                                      .value
                                                                      .duration !=
                                                                  null) &&
                                                              !usingIprepLibrary &&
                                                              widget.subjectId !=
                                                                  null) {
                                                            await stemVideoRepository
                                                                .saveUsersStemVideoWatchingData(
                                                              widget.subjectName ??
                                                                  widget.assignment?[
                                                                      'subject_name'],
                                                              duration: Provider.of<
                                                                          StemVideoProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .videoPlayerController!
                                                                  .value
                                                                  .position
                                                                  .inSeconds,
                                                              subjectID: widget
                                                                  .subjectId!,
                                                              videoLesson:
                                                                  stemProvider
                                                                      .videoLesson!,
                                                              videoStartTime:
                                                                  stemProvider
                                                                      .stemVideosStartTime,
                                                              videoTotalDuration: Provider.of<
                                                                          StemVideoProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .videoPlayerController!
                                                                  .value
                                                                  .duration!
                                                                  .inSeconds,
                                                              batchId: widget
                                                                  .batchInfo
                                                                  ?.batchId,
                                                              assignmentId: (widget
                                                                          .assignment !=
                                                                      null)
                                                                  ? widget.assignment![
                                                                      'assignment_id']
                                                                  : null,
                                                              teacherId: (widget
                                                                          .assignment !=
                                                                      null)
                                                                  ? widget.assignment![
                                                                      'teacher_id']
                                                                  : null,
                                                              assignmentIndex: (widget
                                                                          .assignment !=
                                                                      null)
                                                                  ? widget.assignment![
                                                                      'item_index']
                                                                  : null,
                                                              boardID: widget
                                                                  .batchInfo
                                                                  ?.boardId,
                                                              language: widget
                                                                  .batchInfo
                                                                  ?.language,
                                                              classID: (widget
                                                                          .assignment !=
                                                                      null)
                                                                  ? widget.assignment![
                                                                      'class_number']
                                                                  : null,
                                                            );
                                                          }

                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 30, left: 8),
                                                        // margin: EdgeInsets.only(
                                                        //   left: 12,
                                                        //   top: 12,
                                                        // ),
                                                        child: Image.asset(
                                                          "assets/images/back_icon.png",
                                                          height: 30,
                                                          width: 30,
                                                          color: const Color(
                                                              0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible:
                                                        !stemVideoProviderModel
                                                            .hideControls,
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          InkWell(
                                                            child: Image.asset(
                                                              "assets/images/backward_video_icon.png",
                                                              width: 40,
                                                              height: 40,
                                                            ),
                                                            onTap: () {
                                                              stemVideoProviderModel
                                                                  .videoPlayerController!
                                                                  .seekTo(
                                                                Duration(
                                                                    seconds: stemVideoProviderModel
                                                                            .videoPlayerController!
                                                                            .value
                                                                            .position
                                                                            .inSeconds -
                                                                        10),
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.45,
                                                          ),
                                                          InkWell(
                                                            child: Image.asset(
                                                              "assets/images/forward_video_icon.png",
                                                              width: 40,
                                                              height: 40,
                                                            ),
                                                            onTap: () async {
                                                              stemVideoProviderModel
                                                                  .videoPlayerController!
                                                                  .seekTo(
                                                                Duration(
                                                                    seconds: stemVideoProviderModel
                                                                            .videoPlayerController!
                                                                            .value
                                                                            .position
                                                                            .inSeconds +
                                                                        10),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator()))
                                        : Container(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
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
                                    child: Text(
                                      stemVideoProviderModel.stemVideoName!,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: const Color(0xFF212121),
                                          fontWeight: FontWeight.values[5]),
                                    ),
                                  ),
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
                          if (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                            Container(
                              width: double.maxFinite,
                              color: const Color(0xFFDEDEDE),
                              child: const SizedBox(
                                height: 1,
                              ),
                            ),
                        ],
                      );
                    },
                  )),
                ),
                if (videoListWidget != null)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [videoListWidget!]),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key? key, this.controller}) : super(key: key);

  final VideoPlayerController? controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<StemVideoProvider>(
      builder: (context, stemVideoProviderModel, child) => (Stack(
        children: <Widget>[
          InkWell(
            onTap: () {
              stemVideoProviderModel.hideControls =
                  !stemVideoProviderModel.hideControls;
              stemVideoProviderModel.notifyListeners();
              Future.delayed(const Duration(seconds: 2), () {
                stemVideoProviderModel.hideControls = true;
                stemVideoProviderModel.notifyListeners();
              });
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 50),
              reverseDuration: const Duration(milliseconds: 200),
              child: Container(
                color: Colors.black38,
              ),
            ),
          ),
          Center(
            child: InkWell(
              onTap: () {
                controller!.value.isPlaying
                    ? controller!.pause()
                    : controller!.play();

                stemVideoProviderModel.notifyListeners();

                if (controller!.value.isPlaying) {
                  Future.delayed(const Duration(seconds: 2), () {
                    stemVideoProviderModel.hideControls = true;
                    stemVideoProviderModel.notifyListeners();
                  });
                }
              },
              child: Icon(
                controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 60.0,
                color: const Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
