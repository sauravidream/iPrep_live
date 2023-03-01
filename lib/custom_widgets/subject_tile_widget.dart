import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_packages/vimeoplayer.dart';
import 'package:idream/custom_widgets/linear_percent_indicator.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/provider/stem_video_provider.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:idream/ui/subject_home/subject_home.dart';
import 'package:idream/ui/subject_home/video_lessons_page.dart';
import 'package:idream/video_player/youtube_player_demo.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter/cupertino.dart';

import '../common/constants.dart';

bool videoPlayed = false;

class CustomSubjectListItem extends StatelessWidget {
  const CustomSubjectListItem({
    Key? key,
    this.stemSubjectName,
    this.videoLesson,
    this.subjectID,
    this.subjectHome,
    this.videoData,
    this.dashboardScreenState,
    this.isContinueLearningVideo = false,
    this.continueLearningSetter,
    this.stemVideosKey,
    this.videosChild,
  }) : super(key: key);

  final String? stemSubjectName;
  final VideoLessonModel? videoLesson;
  final String? subjectID;
  final SubjectHome? subjectHome;
  final Map? videoData;
  final DashboardScreenState? dashboardScreenState;
  final bool isContinueLearningVideo;
  final StateSetter? continueLearningSetter;
  final GlobalKey? stemVideosKey;
  final ListView? videosChild;
  final imageUrl =
      "https://i.picsum.photos/id/42/200/300.jpg?hmac=RFAv_ervDAXQ4uM8dhocFa6_hkOkoBLeRR35gF8OHgs";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 22,
      ),
      child: Material(
        color: (videoLesson!.id == videoIdBeingPlayed)
            ? const Color(0xFFFFF9F2)
            : Colors.transparent,
        child: Consumer<StemVideoProvider>(
            builder: (context, stemVideoProviderModel, child) => InkWell(
                  highlightColor: Colors.white,
                  onTap: () async {
                    if (videoLesson!.onlineLink!.contains("youtube")) {
                      //TODO: Youtube Player
                      if (videoPlayed) {
                        if ((stemVideoProviderModel
                                    .videoPlayerController!.value.duration !=
                                null) &&
                            usingIprepLibrary == false) {
                          // saveUsersStemVideoWatchingData in error

                          await stemVideoRepository
                              .saveUsersStemVideoWatchingData(
                            // subjectHome.subjectWidget.subjectName,
                            subjectID,
                            duration: stemVideoProviderModel
                                .videoPlayerController!
                                .value
                                .position
                                .inSeconds,
                            subjectID: subjectID!,
                            videoLesson: stemVideoProviderModel.videoLesson!,
                            videoStartTime:
                                stemVideoProviderModel.stemVideosStartTime,
                            videoTotalDuration: stemVideoProviderModel
                                .videoPlayerController!
                                .value
                                .duration!
                                .inSeconds,
                          );
                        }

                        stemVideoProviderModel.initialiseVideoPlayerController(
                          youtubeUrl: videoLesson!.onlineLink!,
                          videoName: videoLesson!.name,
                          currentVideoLesson: videoLesson,
                        );
                        stemVideoProviderModel.notifyListeners();
                      } else {
                        videoPlayed = true;
                        await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) => YoutubeVideo(
                              subjectName: stemSubjectName,
                              stemVideosKey: stemVideosKey,
                              videosChild: videosChild,
                              youtubeLink: videoLesson!
                                  .onlineLink /*Uri.tryParse(videoLesson.onlineLink)
                          .queryParameters['v']*/
                              ,
                              videoLesson: videoLesson,
                              subjectId: subjectID,
                              videoName: videoLesson!.name,
                            ),
                          ),
                        );
                      }
                    } else {
                      videoIdBeingPlayed = videoLesson!.id;
                      if (videoPlayed) {
                        await Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                CustomPlayerVideo(
                              subjectID: subjectID,
                              videoLesson: videoLesson,
                              videoName: videoLesson!.name,
                              videoUrl: videoLesson!
                                  .onlineLink /*.replaceAllMapped(
                        "https://vimeo.com/",
                        (match) => "https://player.vimeo.com/video/")*/
                              ,
                              subjectHome: subjectHome,
                              videoData: videoData,
                            ),
                          ),
                        );
                        if (dashboardScreenState != null &&
                            isContinueLearningVideo) {
                          // ignore: invalid_use_of_protected_member
                          dashboardScreenState!.setState(() {});
                        }
                      } else {
                        videoPlayed = true;
                        await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                CustomPlayerVideo(
                              subjectID: subjectID,
                              videoLesson: videoLesson,
                              videoName: videoLesson!.name,
                              videoUrl: videoLesson!
                                  .onlineLink /*.replaceAllMapped(
                        "https://vimeo.com/",
                        (match) => "https://player.vimeo.com/video/")*/
                              ,
                              subjectHome: subjectHome,
                              videoData: videoData,
                            ),
                          ),
                        );
                        if (dashboardScreenState != null &&
                            isContinueLearningVideo) {
                          // ignore: invalid_use_of_protected_member
                          dashboardScreenState!.setState(() {});
                        }
                      }
                      // await Navigator.push(
                      //   context,
                      //   CupertinoPageRoute(
                      //     builder: (context) => WebViewPage(
                      //       link: videoLesson.onlineLink.replaceAllMapped(
                      //           "https://vimeo.com/",
                      //           (match) => "https://player.vimeo.com/video/"),
                      //     ),
                      //   ),
                      // );
                    }

                    if (isContinueLearningVideo) {
                      Future.delayed(
                        const Duration(seconds: 2),
                        await Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const DashboardScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        ),
                      );
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        child: Container(
                          color: Colors.grey.shade300,
                          width: 112,
                          height: 64,
                          child: Stack(
                            children: [
                              if (videoLesson!.onlineLink!.contains("youtube"))
                                CachedNetworkImage(
                                  width: 112,
                                  imageUrl:
                                      'https://img.youtube.com/vi/${Uri.tryParse(videoLesson!.onlineLink!)?.queryParameters['v']}/0.jpg',
                                  fit: BoxFit.fill,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                        strokeWidth: 0.5,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                              else
                                FutureBuilder(
                                    future: videoLessonRepository
                                        .getVimeoVideoDetails(
                                            videoLesson!.onlineLink),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.data != null) {
                                        return CachedNetworkImage(
                                          imageUrl:
                                              snapshot.data["thumbnail_url"] ??
                                                  Constants.thumbnail,
                                          fit: BoxFit.fill,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress,
                                                strokeWidth: 0.5,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        );
                                      } else {
                                        return const Center(
                                          child: SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.5,
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              Container(
                                color: Colors.grey.withOpacity(0.2),
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/play_icon.png",
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          constraints: const BoxConstraints(
                            minHeight: 64,
                          ),
                          // height: ScreenUtil().setSp(64, ),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10, 0.0, 0.0, 0.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      videoLesson!.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: const Color(0xFF212121),
                                        fontWeight: FontWeight.values[5],
                                        fontSize: selectedAppLanguage!
                                                    .toLowerCase() ==
                                                "english"
                                            ? 14
                                            : 15,
                                      ),
                                    ),
                                    if (videoLesson!.id == videoIdBeingPlayed)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
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
                                    else if (videoLesson!.videoTotalDuration !=
                                            null &&
                                        videoLesson!.videoTotalDuration != 0)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                        ),
                                        child: Text(
                                          "${Duration(seconds: videoLesson!.videoTotalDuration!).inHours.toString().padLeft(2, '0')}:${Duration(seconds: videoLesson!.videoTotalDuration!).inMinutes.remainder(60).toString().padLeft(2, '0')}:${Duration(seconds: videoLesson!.videoTotalDuration!).inSeconds.remainder(60).toString().padLeft(2, '0')}",
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF8A8A8E),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (videoLesson!.videoTotalDuration != null &&
                                    videoLesson!.videoTotalDuration != 0)
                                  LinearPercentIndicator(
                                    padding: const EdgeInsets.only(
                                      right: 8,
                                    ),
                                    backgroundColor: const Color(0xFFDEDEDE),
                                    percent: (int.parse(videoLesson!
                                                    .videoCurrentProgress!) /
                                                videoLesson!
                                                    .videoTotalDuration!) >
                                            1
                                        ? ((int.parse(videoLesson!
                                                    .videoCurrentProgress!) %
                                                videoLesson!
                                                    .videoTotalDuration!) /
                                            videoLesson!.videoTotalDuration!)
                                        : int.parse(videoLesson!
                                                .videoCurrentProgress!) /
                                            videoLesson!.videoTotalDuration!,
                                    progressColor: const Color(0xFF3399FF),
                                    trailing: Text(
                                      "${(((int.parse(videoLesson!.videoCurrentProgress!) / videoLesson!.videoTotalDuration!) > 1 ? int.parse(videoLesson!.videoCurrentProgress!) % videoLesson!.videoTotalDuration! : int.parse(videoLesson!.videoCurrentProgress!)) * 100 ~/ videoLesson!.videoTotalDuration!).toInt()}%",
                                      style: const TextStyle(
                                        color: Color(0xFF8A8A8E),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
      ),
    );
  }
}

class CustomPlayerVideo extends StatefulWidget {
  final SubjectHome? subjectHome;
  final String? videoUrl;
  final String? videoName, subjectID;
  final VideoLessonModel? videoLesson;
  final Map? videoData;
  // final String batchId;
  // final String assignmentId;
  // final String assignmentIndex;
  final Map? assignment;
  final Batch? batchInfo;

  const CustomPlayerVideo({
    Key? key,
    this.videoUrl,
    this.videoName,
    this.videoLesson,
    this.subjectID,
    this.subjectHome,
    this.videoData,
    this.assignment,
    this.batchInfo,
    // this.batchId,
    // this.assignmentId,
    // this.assignmentIndex,
  }) : super(key: key);

  @override
  _CustomPlayerVideoState createState() => _CustomPlayerVideoState();
}

class _CustomPlayerVideoState extends State<CustomPlayerVideo>
    with AutomaticKeepAliveClientMixin {
/*
  VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;

  Future<bool> getVideoLink() async {
    String videoID =
        widget.videoUrl.replaceAllMapped("https://vimeo.com/", (match) => "");
    var vimeoJson =
        await http.get('https://player.vimeo.com/video/$videoID/config');
    Map response = json.decode(vimeoJson.body);
    _videoPlayerController = VideoPlayerController.network(
        response["request"]["files"]["progressive"][4]["url"]);
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    _videoPlayerController.addListener(() {
      if (startedPlaying && _videoPlayerController.value.isPlaying) {
        Navigator.pop(context);
      }
    });
    startedPlaying = true;
    return true;
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_videoPlayerController = null) _videoPlayerController.dispose();
    super.dispose();
  }
*/

  @override
  bool get wantKeepAlive => true;

  AutoScrollController? _videoPlayerScrollController;

  @override
  void initState() {
    super.initState();
    _videoPlayerScrollController = AutoScrollController();
    if (widget.subjectHome != null && widget.subjectHome!.chapterList != null) {
      _videoPlayerScrollController!.scrollToIndex(
          widget.subjectHome!.chapterList!.indexWhere(
              (element) => element == widget.videoLesson!.topicName),
          preferPosition: AutoScrollPosition.begin);
    }
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: WillPopScope(
        onWillPop: () async {
          videoPlayed = false;
          if (videoTotalDuration != null && usingIprepLibrary == false) {
            await videoLessonRepository.saveUsersVideoWatchingData(
              widget.subjectHome!.subjectWidget!.subjectName,
              thumbnail: widget.videoLesson?.thumbnail,
              duration: videoPlayerController!.value.position.inSeconds,
              subjectID: widget.subjectID!,
              videoID: widget.videoLesson!.id,
              videoUrl: widget.videoLesson!.onlineLink,
              videoName: widget.videoLesson!.name,
              topicName: widget.videoLesson!.topicName!,
              videoStartTime: videoStartTime,
              videoTotalDuration: videoTotalDuration,
              batchId: widget.batchInfo!.batchId,
              assignmentId: widget.assignment != null
                  ? widget.assignment!['assignment_id']
                  : null,
              teacherId: widget.assignment != null
                  ? widget.assignment!['teacher_id']
                  : null,
              assignmentIndex: widget.assignment != null
                  ? widget.assignment!['item_index']
                  : null,
              boardID: widget.batchInfo!.boardId,
              language: widget.batchInfo!.language,
              classID: widget.assignment != null
                  ? widget.assignment!['class_number']
                  : null,
            );
          }
          return true;
        },
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: VimeoPlayer(
                  subjectName: widget.subjectID,
                  // subjectName: widget.subjectHome?.subjectWidget?.subjectName ?? widget.assignment['subject_name'],
                  subjectID: widget.subjectID,
                  videoLesson: widget.videoLesson,
                  looping: true,
                  id: widget.videoUrl!
                      .replaceAllMapped("https://vimeo.com/", (match) => ""),
                  autoPlay: true,
                  alreadyPlayed:
                      widget.videoLesson!.videoCurrentProgress != null
                          ? true
                          : false,
                  position: int.parse(
                      widget.videoLesson!.videoCurrentProgress ?? '0'),
                  batchInfo: widget.batchInfo,
                  assignment: widget.assignment,
                  // batchId: widget.batchId,
                  // assignmentId: widget.assignmentId,
                  // assignmentIndex: widget.assignmentIndex,
                ),
              ),
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
                        "${widget.videoName}",
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
                    //TODO: Commenting it for now
                    // InkWell(
                    //   onTap: () async {
                    //     await showLanguageSelectionBottomSheet(context);
                    //   },
                    //   child: Container(
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Image.asset(
                    //           "assets/images/video_language_icon.png",
                    //           height: ScreenUtil()
                    //               .setSp(16, ),
                    //         ),
                    //         SizedBox(
                    //           height: ScreenUtil()
                    //               .setSp(4, ),
                    //         ),
                    //         Text(
                    //           "Language",
                    //           style: TextStyle(
                    //             fontSize: ScreenUtil()
                    //                 .setSp(10, ),
                    //             color: Color(0xFF9E9E9E),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                color: const Color(0xFFDEDEDE),
                child: const SizedBox(
                  height: 1,
                ),
              ),
              if (widget.subjectHome != null &&
                  widget.subjectHome!.chapterList != null)
                Expanded(
                  child: ListView.builder(
                    controller: _videoPlayerScrollController,
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
                        List<Widget> widgetList = [];

                        widgetList.add(
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16,
                              top: 7,
                            ),
                            child: Text(
                              "${index < 9 ? "0${index + 1}" : index + 1}.  ${widget.subjectHome!.chapterList![index]}",
                              style: TextStyle(
                                  color: Color(widget.subjectHome!
                                      .subjectWidget!.subjectColor!),
                                  fontSize: 14,
                                  fontWeight: FontWeight.values[5]),
                            ),
                          ),
                        );

                        completeListOfVideos!.addAll(widget.videoData![
                            widget.subjectHome!.chapterList![index]]);

                        (widget.videoData![
                                widget.subjectHome!.chapterList![index]])
                            .forEach((video) {
                          widgetList.add(
                            CustomSubjectListItem(
                              // videoLesson: snapshot.data[index],
                              videoData: widget.videoData,
                              videoLesson: video,
                              subjectID:
                                  widget.subjectHome!.subjectWidget!.subjectID,
                              subjectHome: widget.subjectHome,
                            ),
                          );
                        });
                        return AutoScrollTag(
                          key: ValueKey(index),
                          controller: _videoPlayerScrollController!,
                          index: index,
                          child: Column(
                            children: widgetList,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              // Expanded(child: videoPageContent ?? Container())
            ],
          ),
        ),
      ),
    );
  }
}

Future showLanguageSelectionBottomSheet(
  BuildContext context,
) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        12,
      ),
    ),
    builder: (builder) {
      return Container(
        height: 313,
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
            const Text(
              "Select Language",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: 1,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      height: 52,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.80,
                              child: Row(
                                children: const [
                                  Text(
                                    "English",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Image.asset(
                            "assets/images/checked_image_blue.png",
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

// class DemoYoutubePage extends StatelessWidget {
//   final String youtubeLink;
//   final String videoName;
//   DemoYoutubePage({
//     this.youtubeLink,
//     this.videoName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         // toolbarHeight:
//         //     ScreenUtil().setSp(128, ),
//         titleSpacing: 0,
//         leadingWidth: 11,
//         leading: Container(),
//         elevation: 0,
//         flexibleSpace: SizedBox(
//           height: 20,
//         ),
//         title: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Image.asset(
//                 "assets/images/back_icon.png",
//                 height: 25,
//                 width: 25,
//               ),
//             ),
//             SizedBox(
//               width: 6,
//             ),
//             Flexible(
//               child: Text(
//                 videoName,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: Color(0xFF212121),
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: WebviewScaffold(
//           url: 'https://fluttervimeo.web.app/youtube,$youtubeLink',
//           javascriptChannels: jsChannels,
//           mediaPlaybackRequiresUserGesture: false,
//
//           // withZoom: true,s
//           // withLocalStorage: true,
//           // hidden: true,
//           useWideViewPort: true,
//
//           initialChild: Container(
//             color: Colors.white,
//             child: const Center(child: CircularProgressIndicator()),
//           ),
//         ),
//       ),
//     );
//   }
// }
