import 'package:flutter/material.dart';

import 'package:idream/common/references.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/ui/teacher/subject_home_teacher.dart';
import 'package:idream/ui/teacher/utilities/custom_subjectlist_teacher.dart';
import 'package:idream/ui/teacher/utilities/selectstudentbottom_sheet.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

Widget? videoPageContent;

late List<VideoLessonModel> completeListOfVideos;
AutoScrollController? videoLessonScrollController;

class VideoLessonTeacherPage extends StatefulWidget {
  final SubjectHomeTeacher? subjectHome;
  const VideoLessonTeacherPage({Key? key, this.subjectHome}) : super(key: key);

  @override
  _VideoLessonTeacherPageState createState() => _VideoLessonTeacherPageState();
}

class _VideoLessonTeacherPageState extends State<VideoLessonTeacherPage>
    with AutomaticKeepAliveClientMixin {
  bool _pageLoaded = false;
  var _videoData;

  Future fetchVideoLessons() async {
    return await assignmentRepository.fetchVideoLessonsFromLocal(
        subjectName: widget.subjectHome!.subjectID,
        chapterName: widget.subjectHome!.chapterName,
        chapterList: widget.subjectHome!.chapterList as List<String?>,
        batch: widget.subjectHome!.batch!,
        classID: widget.subjectHome!.classId);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    completeListOfVideos = [];
    fetchVideoLessons().then((value) {
      videoLessonScrollController = AutoScrollController();
      setState(() {
        videoLessonScrollController!.scrollToIndex(
            widget.subjectHome!.chapterList.indexWhere(
                (element) => element == widget.subjectHome!.chapterName),
            preferPosition: AutoScrollPosition.begin);
        _videoData = value;
        _videoData = value;
        _pageLoaded = true;
      });
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    List<VideoLessonModel> selectedTopic = [];
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                const SizedBox(
                  height: 16.5,
                ),
                Container(
                  height: 0.5,
                  color: const Color(0xFF6A6A6A),
                ),
                _pageLoaded
                    ? Expanded(
                        child: videoPageContent = ListView.builder(
                          controller: videoLessonScrollController,
                          padding: const EdgeInsets.all(
                            16,
                          ),
                          itemCount: _videoData.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            List<Widget> widgetList = [];

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
                              } else if (_videoData.isNotEmpty) {
                                widgetList.add(
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16,
                                      top: 7,
                                    ),
                                    child: Text(
                                      "${index < 9 ? "0${index + 1}" : index + 1}.  ${widget.subjectHome!.chapterList[index]}",
                                      style: TextStyle(
                                          color: Color(widget
                                              .subjectHome!.subjectColor!),
                                          fontSize: 14,
                                          fontWeight: FontWeight.values[5]),
                                    ),
                                  ),
                                );

                                completeListOfVideos.addAll(_videoData[
                                        widget.subjectHome!.chapterList[index]]
                                    as List<VideoLessonModel>);

                                for (var video in _videoData[
                                    widget.subjectHome!.chapterList[index]]) {
                                  debugPrint(video.toString());
                                  widgetList.add(
                                    TeacherCustomSubjectListItem(
                                      videoData: _videoData,
                                      videoLesson: video,
                                      subjectID: widget.subjectHome!.subjectID,
                                      subjectHome: widget.subjectHome,
                                      selectedTopic: selectedTopic,
                                    ),
                                  );
                                }
                              }

                              return AutoScrollTag(
                                key: ValueKey(index),
                                controller: videoLessonScrollController!,
                                index: index,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: widgetList,
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: Color(0xFF3399FF),
                        ),
                      )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 25.0,
          right: 16.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF0077FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              minimumSize: const Size(176, 50),
            ),
            onPressed: () {
              showAssignBottomSheet(
                context,
                "SubjectVideos",
                widget.subjectHome!.subjectID,
                selectedTopic,
                batchInfo: widget.subjectHome!.batch!,
                subjectName: widget.subjectHome!.subjectName,
                classNumber: widget.subjectHome!.classId,
              );
            },
            child: const Text(
              "Select Students",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
