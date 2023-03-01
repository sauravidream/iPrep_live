import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/my_reports_model.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';

import '../../common/global_variables.dart';
import '../subject_tile_widget.dart';

class ContinueLearningVideosWidget extends StatefulWidget {
  final List<MyReportVideoLessonsModel>? videoData;
  final DashboardScreenState? dashboardScreenState;
  final StateSetter? stateSetter;

  const ContinueLearningVideosWidget({
    Key? key,
    this.videoData,
    this.dashboardScreenState,
    this.stateSetter,
  }) : super(key: key);

  @override
  _ContinueLearningVideosWidgetState createState() =>
      _ContinueLearningVideosWidgetState();
}

class _ContinueLearningVideosWidgetState
    extends State<ContinueLearningVideosWidget> {
  bool _seeMore = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: widget.videoData!.isEmpty ? 0 : 15,
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        // itemCount: videoData.length + 1,
        itemCount: _seeMore
            ? (widget.videoData!.length + 1)
            : ((widget.videoData!.length + 1) > 4
                ? 5
                : (widget.videoData!.length + 1)),
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == 0 && ((widget.videoData!.length) != 0)) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedAppLanguage!.toLowerCase() == 'hindi'
                        ? "सीखना जारी रखें"
                        : 'Continue Learning',
                    style: TextStyle(
                      color: const Color(0xFF212121),
                      fontSize: 18,
                      fontWeight: FontWeight.values[5],
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (index == 0 && ((widget.videoData!.length) == 0)) {
              return Container();
            }
          }
          return CustomSubjectListItem(
            videoLesson: VideoLessonModel(
              detail: '',
              id: widget.videoData![index - 1].videoID ?? "",
              name: widget.videoData![index - 1].videoName ?? "",
              offlineLink: "",
              offlineThumbnail: "",
              onlineLink: widget.videoData![index - 1].videoUrl ?? "",
              thumbnail: "",
              topicName: widget.videoData![index - 1].topicName ?? "",
              videoCurrentProgress: widget.videoData![index - 1].duration ?? "",
              videoTotalDuration: int.tryParse(
                      widget.videoData![index - 1].videoTotalDuration!) ??
                  0,
            ),
            dashboardScreenState: dashboardScreenState,
            continueLearningSetter: widget.stateSetter,
            subjectID: widget.videoData![index - 1].subjectID,
            isContinueLearningVideo: true,
          );
        },
      ),
    );
  }
}
