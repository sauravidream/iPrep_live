import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/linear_percent_indicator.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/ui/teacher/subject_home_teacher.dart';

bool videoPlayed = false;

class TeacherCustomSubjectListItem extends StatelessWidget {
  const TeacherCustomSubjectListItem(
      {this.videoLesson,
      this.subjectID,
      this.subjectHome,
      this.videoData,
      this.selectedTopic});

  final VideoLessonModel? videoLesson;
  final String? subjectID;
  final SubjectHomeTeacher? subjectHome;
  final Map? videoData;
  final List<VideoLessonModel?>? selectedTopic;

  @override
  Widget build(BuildContext context) {
    bool check = false;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter _setState) {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: check ? const Color(0xFFE8F2FF) : Colors.transparent,),


        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              _setState(() {
                if (check) {
                  check = false;
                  selectedTopic!.remove(videoLesson);
                } else {
                  check = true;
                  selectedTopic!.add(videoLesson);
                }
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10),
                  ),
                  child: Container(
                    color: Colors.grey.shade300,
                    width: 112,
                    height: 64,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: AlignmentDirectional.center,
                      children: [
                        if (videoLesson!.onlineLink!.contains("youtube"))
                          CachedNetworkImage(
                            imageUrl:
                                'https://img.youtube.com/vi/${Uri.tryParse(videoLesson!.onlineLink!)!.queryParameters['v']}/0.jpg',
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
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
                        // Image.network(
                        //   'https://img.youtube.com/vi/${Uri.tryParse(videoLesson.onlineLink).queryParameters['v']}/0.jpg' ??
                        //       "https://i.picsum.photos/id/42/200/300.jpg?hmac=RFAv_ervDAXQ4uM8dhocFa6_hkOkoBLeRR35gF8OHgs",
                        //   fit: BoxFit.cover,
                        //   frameBuilder: (BuildContext context, Widget child,
                        //       int frame, bool wasSynchronouslyLoaded) {
                        //     if (wasSynchronouslyLoaded) {
                        //       return child;
                        //     }
                        //     return AnimatedOpacity(
                        //       child: child,
                        //       opacity: frame == null ? 0 : 1,
                        //       duration: const Duration(seconds: 1),
                        //       curve: Curves.easeOut,
                        //     );
                        //   },
                        // )
                        else
                          FutureBuilder(
                              future: videoLessonRepository
                                  .getVimeoVideoDetails(videoLesson!.onlineLink),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null) {
                                  return CachedNetworkImage(
                                    imageUrl: snapshot.data["thumbnail_url"] ??
                                        "https://i.picsum.photos/id/42/200/300.jpg?hmac=RFAv_ervDAXQ4uM8dhocFa6_hkOkoBLeRR35gF8OHgs",
                                    fit: BoxFit.cover,
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
                                  );

                                  //   Image.network(
                                  //   snapshot.data["thumbnail_url"] ??
                                  //       "https://i.picsum.photos/id/42/200/300.jpg?hmac=RFAv_ervDAXQ4uM8dhocFa6_hkOkoBLeRR35gF8OHgs",
                                  //   fit: BoxFit.cover,
                                  //   frameBuilder: (BuildContext context,
                                  //       Widget child,
                                  //       int frame,
                                  //       bool wasSynchronouslyLoaded) {
                                  //     if (wasSynchronouslyLoaded) {
                                  //       return child;
                                  //     }
                                  //     return AnimatedOpacity(
                                  //       child: child,
                                  //       opacity: frame == null ? 0 : 1,
                                  //       duration: const Duration(seconds: 1),
                                  //       curve: Curves.easeOut,
                                  //     );
                                  //   },
                                  // );
                                } else {
                                  return const Center(
                                    child: const CircularProgressIndicator(),
                                  );
                                }
                              }),
                        Positioned(
                          child: Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: Center(
                              child: Image.asset(
                                "assets/images/play_icon.png",
                                height: 12,
                                width: 12,
                              ),
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
                    height: 64,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0.0, 0.0, 0.0),
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
                                  fontSize: 13,
                                ),
                              ),
                              if (videoLesson!.videoTotalDuration != null &&
                                  videoLesson!.videoTotalDuration != 0)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                  ),
                                  child: Text(
                                    Duration(
                                                seconds: videoLesson!
                                                    .videoTotalDuration!)
                                            .inHours
                                            .toString()
                                            .padLeft(2, '0') +
                                        ":" +
                                        Duration(
                                                seconds: videoLesson!
                                                    .videoTotalDuration!)
                                            .inMinutes
                                            .remainder(60)
                                            .toString()
                                            .padLeft(2, '0') +
                                        ":" +
                                        Duration(
                                                seconds: videoLesson!
                                                    .videoTotalDuration!)
                                            .inSeconds
                                            .remainder(60)
                                            .toString()
                                            .padLeft(2, '0'),
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
                              percent:
                                  (int.parse(videoLesson!.videoCurrentProgress!) /
                                              videoLesson!.videoTotalDuration!) >
                                          1
                                      ? ((int.parse(videoLesson!
                                                  .videoCurrentProgress!) %
                                              videoLesson!.videoTotalDuration!) /
                                          videoLesson!.videoTotalDuration!)
                                      : int.parse(videoLesson!
                                              .videoCurrentProgress!) /
                                          videoLesson!.videoTotalDuration!,
                              progressColor: const Color(0xFF3399FF),
                              trailing: Text(
                                (((int.parse(videoLesson!.videoCurrentProgress!) /
                                                        videoLesson!
                                                            .videoTotalDuration!) >
                                                    1
                                                ? int.parse(videoLesson!
                                                        .videoCurrentProgress!) %
                                                    videoLesson!
                                                        .videoTotalDuration!
                                                : int.parse(videoLesson!
                                                    .videoCurrentProgress!)) *
                                            100 ~/
                                            videoLesson!.videoTotalDuration!)
                                        .toInt()
                                        .toString() +
                                    "%",
                                style: const TextStyle(
                                  color: const Color(0xFF8A8A8E),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                check
                    ? Center(
                        child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: check
                              ? Image.asset(
                                  'assets/images/checked_image_blue.png',
                                  height: 22,
                                  width: 22,
                                )
                              : Container(height: 22, width: 22),
                        ),
                      ))
                    : Container(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
