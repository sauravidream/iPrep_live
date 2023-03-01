import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/custom_pop_up.dart';
import 'package:idream/custom_widgets/linear_percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/custom_widgets/video_player.dart';
import 'package:idream/custom_widgets/video_player/youtube_player.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/provider/video_provider.dart';
import 'package:idream/repository/in_app.dart';
import 'package:idream/ui/subject_home/subject_home.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../subscription/andriod/android_subscription.dart';

Widget? videoPageContent;

List<VideoLessonModel>? completeListOfVideos;
AutoScrollController? videoLessonScrollController;
late _VideoLessonPageState __videoLessonPageState;

class VideoLessonPage extends StatefulWidget {
  final SubjectHome? subjectHome;
  const VideoLessonPage({Key? key, this.subjectHome}) : super(key: key);

  @override
  _VideoLessonPageState createState() => _VideoLessonPageState();
}

class _VideoLessonPageState extends State<VideoLessonPage>
    with AutomaticKeepAliveClientMixin {
  bool _pageLoaded = false;
  var _videoData;
  var videoData;

  Future fetchVideoLessons() async {
    return await videoLessonRepository.fetchVideoLessonsFromLocal(
      subjectName: widget.subjectHome!.subjectWidget!.subjectID,
      chapterName: widget.subjectHome!.chapterName,
      chapterList: widget.subjectHome!.chapterList!,
    );
  }

  @override
  bool get wantKeepAlive => true;
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
        _videoData = value;
        videoData = value;
        _pageLoaded = true;
      });
    });
  }

  bool isPlaying = false;
  List? futureValue;
  var chapVideoList;

  @override
  Widget build(BuildContext context) {
    var videoProvider = Provider.of<VideoProvider>(context, listen: true);
    __videoLessonPageState = this;
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: SizedBox(
          height: 40,
          width: 95,
          child: FloatingActionButton(
            onPressed: () {
              showChapterListBottomSheet(
                  context,
                  widget.subjectHome!.chapterList as List<String?>,
                  widget.subjectHome!.subjectWidget!.subjectColor!);
            },
            elevation: 0,
            backgroundColor:
                Color(widget.subjectHome!.subjectWidget!.subjectColor!),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: Text(
              selectedAppLanguage!.toLowerCase() == 'hindi'
                  ? "अध्याय"
                  : "Chapters",
              style: const TextStyle(),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 16.5,
            ),
            Container(
              height: 0.5,
              color: const Color(0xFFC9C9C9),
            ),
            _pageLoaded
                ? Expanded(
                    child: videoPageContent = ListView.builder(
                      controller: videoLessonScrollController,
                      padding: const EdgeInsets.all(
                        16,
                      ),
                      shrinkWrap: true,
                      itemCount: widget.subjectHome!.chapterList!.length,
                      itemBuilder: (context, index) {
                        if (index > -1) {
                          if (_videoData == null) {
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

                          return AutoScrollTag(
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
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                Wrap(
                                  children: List.generate(
                                      _videoData[widget
                                              .subjectHome!.chapterList![index]]
                                          .length, (videoIndex) {
                                    var video = videoIndex;
                                    VideoLessonModel videoLesson = _videoData[
                                        widget.subjectHome!
                                            .chapterList![index]][videoIndex];

                                    return InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      // highlightColor: Colors.white,
                                      onTap: () async {
                                        if (videoLesson.onlineLink!
                                            .contains("youtube")) {
                                          await Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  YoutubeVideo(
                                                subjectName: widget.subjectHome!
                                                    .subjectWidget!.subjectName,
                                                // stemVideosKey: stemVideosKey,
                                                // videosChild: videosChild,
                                                youtubeLink:
                                                    videoLesson.onlineLink,
                                                videoLesson: videoLesson,
                                                subjectId: widget.subjectHome!
                                                    .subjectWidget!.subjectID,
                                                videoName: videoLesson.name,
                                              ),
                                            ),
                                          );

                                          debugPrint(
                                              '=============youtube=============');
                                        } else {
                                          if (restrictUser &&
                                              (videoIndex > 1)) {
                                            var response =
                                                await planExpiryPopUpForStudent(
                                                    context);
                                            if ((response != null) &&
                                                (response == "Yes")) {
                                              await Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      Platform.isAndroid
                                                          ? const AndroidSubscriptionPlan()
                                                          : const UpgradePlan(),
                                                ),
                                              );
                                            }
                                          } else {
                                            if (!isPlaying == true) {
                                              isPlaying =
                                                  true; // use for stop the multiRouting
                                              await videoProvider.getVideoData(
                                                  widget
                                                      .subjectHome!
                                                      .subjectWidget!
                                                      .subjectName,
                                                  subjectId: widget.subjectHome!
                                                      .subjectWidget!.subjectID,
                                                  videoLessonModel:
                                                      _completeListOfVideos,
                                                  videoIndex: videoLesson.id,
                                                  context: context);
                                              if (!mounted) return;
                                              await Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) => CustomVideoPlayer(
                                                          completeListOfVideos:
                                                              _completeListOfVideos,
                                                          videoLessonModel:
                                                              videoLesson,
                                                          videoLesson: video,
                                                          videoData: videoData,
                                                          subjectHome: widget
                                                              .subjectHome,
                                                          videoPageContent:
                                                              videoPageContent,
                                                          subjectHomeChapterListIndex:
                                                              widget.subjectHome!
                                                                      .chapterList![
                                                                  index])));
                                              isPlaying = false;
                                            }
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, left: 10, top: 10),
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
                                                            fit: BoxFit.fill,
                                                            progressIndicatorBuilder:
                                                                (context, url,
                                                                        downloadProgress) =>
                                                                    const SizedBox(
                                                              width: 112,
                                                              height: 64,
                                                              child: Center(
                                                                child: SizedBox(
                                                                  height: 25,
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
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            child: Center(
                                                              child:
                                                                  Image.asset(
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
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
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
                                                            videoLesson.name!,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                // textTheme.bodyText1!.copyWith(color:kPrimaryTextColorBlack100,)

                                                                TextStyle(
                                                              color: const Color(
                                                                  0xFF212121),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .values[5],
                                                              fontSize: selectedAppLanguage!
                                                                          .toLowerCase() ==
                                                                      "english"
                                                                  ? 15
                                                                  : 16,
                                                            ),
                                                          ),
                                                          if (videoLesson.id ==
                                                              videoIdBeingPlayed)
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 5.0),
                                                              // child: Text(
                                                              //   "Currently playing...",
                                                              //   maxLines: 2,
                                                              //   overflow:
                                                              //       TextOverflow
                                                              //           .ellipsis,
                                                              //   style:
                                                              //       TextStyle(
                                                              //     color: Color(
                                                              //         0xFF666666),
                                                              //     fontWeight:
                                                              //         FontWeight
                                                              //             .values[4],
                                                              //     fontSize: 10,
                                                              //   ),
                                                              // ),
                                                            )
                                                          else if (videoLesson
                                                                      .videoTotalDuration !=
                                                                  null &&
                                                              videoLesson
                                                                      .videoTotalDuration !=
                                                                  0)
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 4,
                                                              ),
                                                              child: Text(
                                                                Duration(seconds: videoLesson.videoTotalDuration!)
                                                                        .inHours
                                                                        .toString()
                                                                        .padLeft(
                                                                            2,
                                                                            '0') +
                                                                    ":" +
                                                                    Duration(
                                                                            seconds: videoLesson
                                                                                .videoTotalDuration!)
                                                                        .inMinutes
                                                                        .remainder(
                                                                            60)
                                                                        .toString()
                                                                        .padLeft(
                                                                            2,
                                                                            '0') +
                                                                    ":" +
                                                                    Duration(
                                                                            seconds: videoLesson
                                                                                .videoTotalDuration!)
                                                                        .inSeconds
                                                                        .remainder(
                                                                            60)
                                                                        .toString()
                                                                        .padLeft(
                                                                            2,
                                                                            '0'),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 10,
                                                                  color: Color(
                                                                      0xFF8A8A8E),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      if (videoLesson
                                                                  .videoTotalDuration !=
                                                              null &&
                                                          videoLesson
                                                                  .videoTotalDuration !=
                                                              0)
                                                        LinearPercentIndicator(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 8,
                                                          ),
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFFDEDEDE),
                                                          percent: (int.parse(videoLesson
                                                                          .videoCurrentProgress!) /
                                                                      videoLesson
                                                                          .videoTotalDuration!) >
                                                                  1
                                                              ? ((int.parse(videoLesson
                                                                          .videoCurrentProgress!) %
                                                                      videoLesson
                                                                          .videoTotalDuration!) /
                                                                  videoLesson
                                                                      .videoTotalDuration!)
                                                              : int.parse(videoLesson
                                                                      .videoCurrentProgress!) /
                                                                  videoLesson
                                                                      .videoTotalDuration!,
                                                          progressColor:
                                                              const Color(
                                                                  0xFF3399FF),
                                                          trailing: Text(
                                                            (((int.parse(videoLesson.videoCurrentProgress!) / videoLesson.videoTotalDuration!) >
                                                                                1
                                                                            ? int.parse(videoLesson.videoCurrentProgress!) %
                                                                                videoLesson.videoTotalDuration!
                                                                            : int.parse(videoLesson.videoCurrentProgress!)) *
                                                                        100 ~/
                                                                        videoLesson.videoTotalDuration!)
                                                                    .toInt()
                                                                    .toString() +
                                                                "%",
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFF8A8A8E),
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
                                      ),
                                    );
                                  }).toList(),
                                ),

                                // CachedNetworkImage(
                                //   imageUrl: widget
                                //               .subjectHome.chapterList[index] +
                                //           "thumbnail_url" ??
                                //       "https://i.picsum.photos/id/42/200/300.jpg?hmac=RFAv_ervDAXQ4uM8dhocFa6_hkOkoBLeRR35gF8OHgs",
                                //   fit: BoxFit.fill,
                                //   progressIndicatorBuilder:
                                //       (context, url, downloadProgress) =>
                                //           Center(
                                //     child: SizedBox(
                                //       height: 25,
                                //       width: 25,
                                //       child: CircularProgressIndicator(
                                //         value: downloadProgress.progress,
                                //         strokeWidth: 0.5,
                                //       ),
                                //     ),
                                //   ),
                                //   errorWidget: (context, url, error) =>
                                //       Icon(Icons.error),
                                // ),

                                // CustomSubjectListItem(
                                //   // videoLesson: snapshot.data[index],
                                //    videoData: _videoData,
                                //   videoLesson: widget.subjectHome.chapterList,
                                //   subjectID:
                                //   widget.subjectHome.subjectWidget.subjectID,
                                //   subjectHome: widget.subjectHome,
                                // ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  )
                : const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        backgroundColor: Color(0xFF3399FF),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

//Chapter List BottomSheet

class ChapterListBottomSheetWidget extends StatefulWidget {
  final BuildContext? context;
  final List<dynamic>? chapterList;
  final int? subjectColor;

  const ChapterListBottomSheetWidget({
    Key? key,
    this.context,
    this.chapterList,
    this.subjectColor,
  }) : super(key: key);

  @override
  _ChapterListBottomSheetWidgetState createState() =>
      _ChapterListBottomSheetWidgetState();
}

class _ChapterListBottomSheetWidgetState
    extends State<ChapterListBottomSheetWidget> {
  AutoScrollController? _chapterBottomSheetAutoScrollController;
  @override
  void initState() {
    super.initState();
    _chapterBottomSheetAutoScrollController = AutoScrollController();
    _chapterBottomSheetAutoScrollController!.scrollToIndex(
        widget.chapterList!.indexWhere((element) => element == selectedChapter),
        preferPosition: AutoScrollPosition.begin);
  }

  @override
  Widget build(BuildContext context) {
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
            "Select Chapter",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Flexible(
            child: ListView.builder(
              itemCount: widget.chapterList!.length,
              controller: _chapterBottomSheetAutoScrollController,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: _chapterBottomSheetAutoScrollController!,
                  index: index,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedChapter = widget.chapterList![index];
                      });
                      videoLessonScrollController!.scrollToIndex(
                        __videoLessonPageState.widget.subjectHome!.chapterList!
                            .indexWhere((element) =>
                                element == widget.chapterList![index]),
                        preferPosition: AutoScrollPosition.begin,
                      );
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: (selectedChapter == widget.chapterList![index])
                          ? Color(widget.subjectColor!).withOpacity(0.08)
                          : null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      height: 52,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: Row(
                              children: [
                                Text(
                                  "${index < 9 ? 0 : ""}${index + 1}.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(widget.subjectColor!),
                                  ),
                                ),
                                const SizedBox(
                                  width: 11,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.chapterList![index],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0xFF212121),
                                      fontWeight: FontWeight.values[5],
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selectedChapter == widget.chapterList![index])
                            Container(
                              height: 22,
                              width: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(widget.subjectColor!)
                                    .withOpacity(0.1),
                              ),
                              child: Image.asset(
                                "assets/images/tick.png",
                                height: 20,
                                width: 20,
                                color: Color(widget.subjectColor!),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// New Player Testing

// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:idream/common/constants.dart';
// import 'package:idream/common/global_variables.dart';
// import 'package:idream/common/references.dart';
// import 'package:idream/custom_widgets/custom_pop_up.dart';
// import 'package:idream/custom_widgets/linear_percent_indicator.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:idream/custom_widgets/video_player.dart';
// import 'package:idream/custom_widgets/video_player/youtube_player.dart';
// import 'package:idream/model/video_lesson.dart';
// import 'package:idream/provider/video_provider.dart';
// import 'package:idream/repository/in_app.dart';
// import 'package:idream/ui/menu/upgrade_plan_page.dart';
// import 'package:idream/ui/subject_home/subject_home.dart';
// import 'package:provider/provider.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../subscription/andriod/android_subscription.dart';
// import '../iprep_store/widget/video_tile_widget.dart';
//
// Widget? videoPageContent;
//
// List<VideoLessonModel>? completeListOfVideos;
// AutoScrollController? videoLessonScrollController;
// late _VideoLessonPageState __videoLessonPageState;
//
// class VideoLessonPage extends StatefulWidget {
//   final SubjectHome? subjectHome;
//   const VideoLessonPage({Key? key, this.subjectHome}) : super(key: key);
//
//   @override
//   _VideoLessonPageState createState() => _VideoLessonPageState();
// }
//
// class _VideoLessonPageState extends State<VideoLessonPage>
//     with AutomaticKeepAliveClientMixin {
//   bool _pageLoaded = false;
//   var _videoData;
//   var videoData;
//
//   Future fetchVideoLessons() async {
//     return await videoLessonRepository.fetchVideoLessonsFromLocal(
//       subjectName: widget.subjectHome!.subjectWidget!.subjectID,
//       chapterName: widget.subjectHome!.chapterName,
//       chapterList: widget.subjectHome!.chapterList!,
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
//   final List<VideoLessonModel>? _completeListOfVideos = [];
//   @override
//   void initState() {
//     super.initState();
//
//     fetchVideoLessons().then((value) {
//       if (value != null) {
//         Future.forEach(value.values, (dynamic element) {
//           _completeListOfVideos!.addAll(element);
//           completeListOfVideos = _completeListOfVideos;
//         });
//       }
//
//       videoLessonScrollController = AutoScrollController();
//       setState(() {
//         videoLessonScrollController!.scrollToIndex(
//             widget.subjectHome!.chapterList!.indexWhere(
//                 (element) => element == widget.subjectHome!.chapterName),
//             preferPosition: AutoScrollPosition.begin);
//         _videoData = value;
//         videoData = value;
//         _pageLoaded = true;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Provider(
//       dispose: (BuildContext context, VideoPlayerPro videoPlayerPro) {
//         videoPlayerPro.controller?.dispose();
//       },
//       create: (_) => VideoPlayerPro(),
//       child: Container(
//         color: Colors.white,
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           floatingActionButton: SizedBox(
//             height: 40,
//             width: 95,
//             child: FloatingActionButton(
//               onPressed: () {
//                 showChapterListBottomSheet(
//                     context,
//                     widget.subjectHome!.chapterList as List<String?>,
//                     widget.subjectHome!.subjectWidget!.subjectColor!);
//               },
//               elevation: 0,
//               backgroundColor:
//                   Color(widget.subjectHome!.subjectWidget!.subjectColor!),
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(12.0),
//                 ),
//               ),
//               child: Text(
//                 selectedAppLanguage!.toLowerCase() == 'hindi'
//                     ? "अध्याय"
//                     : "Chapters",
//                 style: const TextStyle(),
//               ),
//             ),
//           ),
//           body: Column(
//             children: [
//               const SizedBox(
//                 height: 16.5,
//               ),
//               Container(
//                 height: 0.5,
//                 color: const Color(0xFFC9C9C9),
//               ),
//               _pageLoaded
//                   ? Expanded(
//                       child: videoPageContent = ListView.builder(
//                         controller: videoLessonScrollController,
//                         padding: const EdgeInsets.all(
//                           16,
//                         ),
//                         shrinkWrap: true,
//                         itemCount: widget.subjectHome!.chapterList!.length,
//                         itemBuilder: (context, index) {
//                           if (index > -1) {
//                             if (_videoData == null) {
//                               return Center(
//                                 child: Text(
//                                   "No content available",
//                                   style: TextStyle(
//                                     color: const Color(0xFF212121),
//                                     fontWeight: FontWeight.values[5],
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               );
//                             }
//
//                             return AutoScrollTag(
//                               key: ValueKey(index),
//                               controller: videoLessonScrollController!,
//                               index: index,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                       bottom: 16,
//                                       top: 7,
//                                     ),
//                                     child: Text(
//                                       "${index < 9 ? "0${index + 1}" : index + 1}.  ${widget.subjectHome!.chapterList![index]}",
//                                       style: TextStyle(
//                                           color: Color(widget.subjectHome!
//                                               .subjectWidget!.subjectColor!),
//                                           fontSize: selectedAppLanguage!
//                                                       .toLowerCase() ==
//                                                   "english"
//                                               ? 15
//                                               : 16,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   Wrap(
//                                     children: List.generate(
//                                         _videoData[widget.subjectHome!
//                                                 .chapterList![index]]
//                                             .length, (videoIndex) {
//                                       VideoLessonModel videoLesson = _videoData[
//                                           widget.subjectHome!
//                                               .chapterList![index]][videoIndex];
//
//                                       return VideoTile(
//                                         video: videoLesson,
//                                         isPlaying: false,
//                                         index: 0,
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//                           return Container();
//                         },
//                       ),
//                     )
//                   : const Expanded(
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           valueColor:
//                               AlwaysStoppedAnimation<Color>(Colors.white),
//                           backgroundColor: Color(0xFF3399FF),
//                         ),
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// //Chapter List BottomSheet
//
// class VideoTile extends StatelessWidget {
//   const VideoTile({
//     Key? key,
//     required this.isPlaying,
//     this.index,
//     this.video,
//   }) : super(key: key);
//   final VideoLessonModel? video;
//   final bool isPlaying;
//   final int? index;
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: const EdgeInsets.all(0),
//       selectedTileColor:
//           Color(isPlaying ? 0xFF0077FF : 0xFF9A9A9A).withOpacity(.05),
//       minVerticalPadding: 0,
//       selected: isPlaying,
//       leading: leading(),
//       title: title(),
//       subtitle: subtitle(),
//       onTap: () async {
//         final provider = Provider.of<VideoPlayerPro>(context, listen: false);
//         if (isVideoPlaying != null) {
//         await  provider.initializePlayer();
//         }
//         if (isVideoPlaying == null) {
//           isVideoPlaying = video!.id ?? "";
//           provider.initializePlayer();
//           Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (builder) => const VideoPlayerView()))
//               .then((value) => isVideoPlaying = null);
//         }
//       },
//     );
//   }
//
//   Widget? leading() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         constraints: const BoxConstraints(
//           minWidth: 100,
//           minHeight: 260,
//           maxWidth: 104,
//           maxHeight: 264,
//         ),
//         decoration: BoxDecoration(color: Colors.grey.shade300),
//         child: Stack(
//           children: [
//             CachedNetworkImage(
//               width: 118,
//               height: 90,
//               imageUrl: video?.thumbnail ??
//                   "https://i.vimeocdn.com/video/892052862-6a351faf9eb4c100812d318b7faef025b0368693622dffff26c406fbef8d6864-d_640",
//               fit: BoxFit.fill,
//               progressIndicatorBuilder: (context, url, downloadProgress) =>
//                   Center(
//                 child: SizedBox(
//                   height: 25,
//                   width: 25,
//                   child: CircularProgressIndicator(
//                     value: downloadProgress.progress,
//                     strokeWidth: 0.5,
//                   ),
//                 ),
//               ),
//               errorWidget: (context, url, error) =>
//                   const Center(child: Icon(Icons.error)),
//             ),
//             Container(
//               color: Colors.grey.withOpacity(0.2),
//               child: Center(
//                 child: Image.asset(
//                   "assets/images/play_icon.png",
//                   height: 12,
//                   width: 12,
//                 ),
//               ),
//             ),
//             if (isPlaying) ...[
//               Positioned(
//                 // width: 118,
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: LinearPercentIndicator(
//                   padding: EdgeInsets.zero,
//                   progressColor: const Color(0xFF0077FF),
//                   percent: 50 / 100,
//                 ),
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget? title() {
//     return RichText(
//       maxLines: 2,
//       text: TextSpan(
//         text: video?.name ?? "",
//         style: TextStyle(
//           color: const Color(0xFF212121),
//           fontWeight: FontWeight.values[5],
//           fontSize: 15,
//         ),
//         children: const <TextSpan>[
//           // TextSpan(
//           //   text: "",
//           //   style: TextStyle(
//           //     fontFamily: "Inter",
//           //     color: Color(0xFF212121),
//           //     fontWeight: FontWeight.normal,
//           //     fontSize: 15,
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
//
//   Widget? subtitle() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 5),
//       child: Wrap(
//         spacing: 10,
//         children: [
//           if (isPlaying) ...[
//             SvgPicture.asset(
//               "assets/image/pause.svg",
//               width: 14,
//               height: 14,
//               color: const Color(0xFF0077FF),
//             ),
//           ],
//           Text(
//             "{video?.totalDuration ?? 0}",
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontFamily: "Inter",
//               color: Color(isPlaying ? 0xFF0077FF : 0xFF9A9A9A),
//               fontWeight: FontWeight.w400,
//               fontSize: 11,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class VideoPlayerView extends StatelessWidget {
//   const VideoPlayerView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListenableProvider(
//       create: (_) => VideoPlayerPro(),
//       child: Scaffold(
//         body: Column(
//           children: [
//             Expanded(
//               flex: 2,
//               child: Consumer<VideoPlayerPro>(
//                 child: Container(),
//                 builder: (context, value, child) {
//                   if (value.controller != null &&
//                       value.controller!.value.isInitialized) {
//                     return AspectRatio(
//                       aspectRatio: value.controller?.value.aspectRatio ?? 2 / 3,
//                       child: VideoPlayer(value.controller!),
//                     );
//                   } else {
//                     return const Expanded(
//                       flex: 2,
//                       child: Center(child: CircularProgressIndicator()),
//                     );
//                   }
//                 },
//               ),
//             ),
//             if (videoPageContent != null) ...[
//               Expanded(
//                 flex: 3,
//                 child: ListView(
//                   padding: const EdgeInsets.all(0),
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   children: [videoPageContent!],
//                 ),
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ChapterListBottomSheetWidget extends StatefulWidget {
//   final BuildContext? context;
//   final List<dynamic>? chapterList;
//   final int? subjectColor;
//
//   const ChapterListBottomSheetWidget({
//     Key? key,
//     this.context,
//     this.chapterList,
//     this.subjectColor,
//   }) : super(key: key);
//
//   @override
//   _ChapterListBottomSheetWidgetState createState() =>
//       _ChapterListBottomSheetWidgetState();
// }
//
// class _ChapterListBottomSheetWidgetState
//     extends State<ChapterListBottomSheetWidget> {
//   AutoScrollController? _chapterBottomSheetAutoScrollController;
//   @override
//   void initState() {
//     super.initState();
//     _chapterBottomSheetAutoScrollController = AutoScrollController();
//     _chapterBottomSheetAutoScrollController!.scrollToIndex(
//         widget.chapterList!.indexWhere((element) => element == selectedChapter),
//         preferPosition: AutoScrollPosition.begin);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 313,
//       color: Colors.transparent,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               vertical: 12,
//             ),
//             child: Image.asset(
//               "assets/images/line.png",
//               width: 40,
//             ),
//           ),
//           const Text(
//             "Select Chapter",
//             style: TextStyle(
//               fontSize: 16,
//               color: Color(0xFF666666),
//             ),
//           ),
//           const SizedBox(
//             height: 12,
//           ),
//           Flexible(
//             child: ListView.builder(
//               itemCount: widget.chapterList!.length,
//               controller: _chapterBottomSheetAutoScrollController,
//               padding: const EdgeInsets.symmetric(
//                 vertical: 12,
//               ),
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 return AutoScrollTag(
//                   key: ValueKey(index),
//                   controller: _chapterBottomSheetAutoScrollController!,
//                   index: index,
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedChapter = widget.chapterList![index];
//                       });
//                       videoLessonScrollController!.scrollToIndex(
//                         __videoLessonPageState.widget.subjectHome!.chapterList!
//                             .indexWhere((element) =>
//                                 element == widget.chapterList![index]),
//                         preferPosition: AutoScrollPosition.begin,
//                       );
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       color: (selectedChapter == widget.chapterList![index])
//                           ? Color(widget.subjectColor!).withOpacity(0.08)
//                           : null,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                       ),
//                       height: 52,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.80,
//                             child: Row(
//                               children: [
//                                 Text(
//                                   "${index < 9 ? 0 : ""}${index + 1}.",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Color(widget.subjectColor!),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 11,
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     widget.chapterList![index],
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       color: const Color(0xFF212121),
//                                       fontWeight: FontWeight.values[5],
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (selectedChapter == widget.chapterList![index])
//                             Container(
//                               height: 22,
//                               width: 22,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(widget.subjectColor!)
//                                     .withOpacity(0.1),
//                               ),
//                               child: Image.asset(
//                                 "assets/images/tick.png",
//                                 height: 20,
//                                 width: 20,
//                                 color: Color(widget.subjectColor!),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
