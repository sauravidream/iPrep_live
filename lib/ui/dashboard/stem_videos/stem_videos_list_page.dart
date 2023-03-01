import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/ui/network_error_page.dart';
import 'package:provider/provider.dart';
import 'package:idream/custom_widgets/subject_tile_widget.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/ui/dashboard/stem_videos/stem_projects_widget.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

String? selectedChapter;
late List<VideoLessonModel> completeListOfVideos;
AutoScrollController? stemVideoLessonScrollController;

class StemVideosListPage extends StatefulWidget {
  final StemSubjectWidget? stemSubjectWidget;
  final String? chapterName;
  final int? totalChapters;
  final List<String>? chapterList;
  final int chapterListIndex;
  const StemVideosListPage({
    Key? key,
    this.stemSubjectWidget,
    this.chapterName,
    this.totalChapters,
    this.chapterList,
    required this.chapterListIndex,
  }) : super(key: key);

  @override
  _StemVideosListPageState createState() => _StemVideosListPageState();
}

class _StemVideosListPageState extends State<StemVideosListPage> {
  final List<String> listItems = [];
  ListView? _videosListWidget;
  final _stemVideosKey = GlobalKey();
  final AutoScrollController _stemVideoLessonScrollController =
      AutoScrollController();
  @override
  void initState() {
    super.initState();

    _stemVideoLessonScrollController.scrollToIndex(widget.chapterListIndex,
        preferPosition: AutoScrollPosition.begin);

    completeListOfVideos = [];
    selectedChapter = widget.chapterName;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(
      builder: (context, networkProvider, __) => networkProvider.isAvailable ==
              true
          ? Container(
              color: Colors.white,
              child: SafeArea(
                bottom: false,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      // These are the slivers that show up in the "outer" scroll view.
                      return <Widget>[
                        SliverAppBar(
                          backgroundColor: Colors.white,
                          // toolbarHeight:
                          //     ScreenUtil().setSp(128, ),
                          titleSpacing: 0,
                          leadingWidth: 11,
                          leading: Container(),
                          flexibleSpace: const SizedBox(
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
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    widget.stemSubjectWidget!.steamModel!
                                        .subjectName!,
                                    style: const TextStyle(
                                      color: Color(0xFF212121),
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 19,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget
                                      .stemSubjectWidget!.subjectImagePath!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 43,
                                    width: 43,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) {
                                    return Center(
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                          strokeWidth: 0.5,
                                        ),
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
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
                    body: _videosListWidget = ListView.builder(
                      itemCount: widget
                          .stemSubjectWidget!.steamModel!.chapterList!.length,
                      controller: _stemVideoLessonScrollController,
                      padding: const EdgeInsets.all(
                        16,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index > -1) {
                          List<Widget> widgetList = [];

                          widgetList.add(
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 16,
                                top: 7,
                              ),
                              child: Text(
                                "${index < 9 ? "0${index + 1}" : index + 1}.  ${widget.stemSubjectWidget!.steamModel!.chapterList![index].chapterName}",
                                style: TextStyle(
                                    color: Color(
                                        widget.stemSubjectWidget!.subjectColor),
                                    fontSize: 14,
                                    fontWeight: FontWeight.values[5]),
                              ),
                            ),
                          );

                          completeListOfVideos.addAll(widget.stemSubjectWidget!
                              .steamModel!.chapterList![index].videoLesson!);

                          for (var video in widget.stemSubjectWidget!
                              .steamModel!.chapterList![index].videoLesson!) {
                            widgetList.add(
                              CustomSubjectListItem(
                                // videoLesson: snapshot.data[index],
                                stemSubjectName: widget
                                    .stemSubjectWidget!.steamModel!.subjectName,
                                videoLesson: video,
                                subjectID: widget
                                    .stemSubjectWidget!.steamModel!.subjectID,
                                stemVideosKey: _stemVideosKey,
                                videosChild: _videosListWidget,
                              ),
                            );
                          }
                          return AutoScrollTag(
                            key: ValueKey(index),
                            controller: _stemVideoLessonScrollController,
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
                  ),
                ),
              ),
            )
          : const NetworkError(),
    );
  }
}
