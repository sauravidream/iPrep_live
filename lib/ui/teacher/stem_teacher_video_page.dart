import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:idream/model/batch_model.dart';
import 'package:idream/model/stem.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/ui/teacher/utilities/custom_subjectlist_teacher.dart';
import 'package:idream/ui/teacher/utilities/selectstudentbottom_sheet.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

String? selectedChapter;
late List<VideoLessonModel> completeListOfVideos;
AutoScrollController? stemVideoLessonScrollController;

class StemVideosTeacherListPage extends StatefulWidget {
  final String? subjectImagePath;
  final int? subjectColor;
  final StemModel? steamModel;
  final String? chapterName;
  final int? totalChapters;
  final List<String>? chapterList;
  final Batch? batchInfo;
  final String? classId;

  StemVideosTeacherListPage({
    this.subjectImagePath,
    this.subjectColor,
    this.steamModel,
    this.chapterName,
    this.totalChapters,
    this.chapterList,
    this.batchInfo,
    this.classId,
  });

  @override
  _StemVideosTeacherListPageState createState() =>
      _StemVideosTeacherListPageState();
}

class _StemVideosTeacherListPageState extends State<StemVideosTeacherListPage> {
  final List<String> listItems = [];

  @override
  void initState() {
    super.initState();
    stemVideoLessonScrollController = AutoScrollController();
    completeListOfVideos = [];
    selectedChapter = widget.chapterName;
  }

  @override
  Widget build(BuildContext context) {
    List<VideoLessonModel> selectedTopic = [];
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      titleSpacing: 0,
                      leadingWidth: 11,
                      leading: Container(),
                      flexibleSpace: SizedBox(
                        height: 20,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  "assets/images/back_icon.png",
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                widget.steamModel!.subjectName!,
                                style: TextStyle(
                                  color: Color(0xFF212121),
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: 19,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.subjectImagePath!,
                              height: 43,
                              width: 43,
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
                              errorWidget: (context, url, error) => Container(
                                child: Icon(
                                  Icons.school,
                                  size: 50,
                                ),
                              ),
                            ),
                            // Image.asset(
                            //   widget.subjectImagePath,
                            //   height: ScreenUtil()
                            //       .setSp(43, ),
                            //   width: ScreenUtil()
                            //       .setSp(43, ),
                            // ),
                            // ),
                          ),
                        ],
                      ),
                      floating: true,
                      pinned: true,
                      snap: true,
                      primary: true,
                      forceElevated: innerBoxIsScrolled,
                      elevation: 0,
                    ),
                  ];
                },
                body: ListView.builder(
                  itemCount: widget.steamModel!.chapterList!.length,
                  controller: stemVideoLessonScrollController,
                  padding: EdgeInsets.all(
                    16,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index > -1) {
                      List<Widget> widgetList = [];
                      widgetList.add(
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 16,
                            top: 7,
                          ),
                          child: Text(
                            "${index < 9 ? "0${index + 1}" : index + 1}.  ${widget.steamModel!.chapterList![index].chapterName}",
                            style: TextStyle(
                                color: Color(widget.subjectColor!),
                                fontSize: 14,
                                fontWeight: FontWeight.values[5]),
                          ),
                        ),
                      );

                      completeListOfVideos.addAll(
                          widget.steamModel!.chapterList![index].videoLesson!);

                      widget.steamModel!.chapterList![index].videoLesson!
                          .forEach((video) {
                        widgetList.add(
                          TeacherCustomSubjectListItem(
                              videoLesson: video,
                              subjectID: widget.steamModel!.subjectID,
                              selectedTopic: selectedTopic),
                        );
                      });
                      return AutoScrollTag(
                        key: ValueKey(index),
                        controller: stemVideoLessonScrollController!,
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
            ),
          ),
        ),
        Positioned(
          bottom: 30.0,
          right: 15.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF0077FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              minimumSize: Size(176, 50),
            ),
            onPressed: () {
              showAssignBottomSheet(
                context,
                "Stem Videos",
                widget.steamModel!.subjectID,
                selectedTopic,
                batchInfo: widget.batchInfo!,
                subjectName: widget.steamModel!.subjectName,
                classNumber: widget.classId,
              );
            },
            child: Text(
              "Select Students",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        )
      ],
    );
  }
}
