import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/state_manager.dart';
import 'package:idream/model/video_lesson.dart';
import 'package:idream/ui/iprep_store/widget/category_header_widget.dart';
import 'package:idream/ui/iprep_store/widget/text_divider.dart';
import '../../common/references.dart';
import '../../custom_widgets/loading_widget.dart';
import '../../custom_widgets/subject_tile_widget.dart';
import '../../model/iprep_store_model/categories_dtl_model.dart';
import '../../model/iprep_store_model/video_model.dart';

class SubCategoriesDTLPage extends HookWidget {
  final Subcategory? subcategory;
  const SubCategoriesDTLPage({Key? key, this.subcategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toggleState = useState(false);
    ListView? videosListWidget;
    final GlobalKey stemVideosKey = GlobalKey();
    List<Video>? videoData;

    return Scaffold(
      body: SafeArea(
        // top: false,
        bottom: false,
        /*child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                children: [
                  CategoryDTLHeaderWidget(
                    coverImage: subcategory?.coverImage,
                    name: subcategory?.name,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 15),
                    child: Text(
                      subcategory?.description ?? "",
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF020202)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: TextDivider(
                      text: subcategory?.description ?? "",
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 15),
                    child: const Text(
                      "Lessons",
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF020202)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                      onPressed: () {
                        toggleState.value = !toggleState.value;
                        print(toggleState.value);
                      },
                      child: Text("TAP ME")),

                  // TODO: New Version Video Player

                  */ /* FutureBuilder(
                      future: storeRepository
                          .getCategoryVideos(subcategory?.subcategoryId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        Widget videoTile;

                        if (snapshot.data != null) {
                          List<Video> videoData = snapshot.data;
                          videoTile = videosListWidget = ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: videoData.length,
                              itemBuilder: (context, index) {
                                List<Widget> widgetList = [];

                                widgetList.add(VideoTile(
                                  video: videoData[index],
                                  index: index,
                                  isPlaying: false,
                                  videosListWidget: videosListWidget!,
                                ));

                                return Column(
                                  children: widgetList,
                                );
                              });
                        } else {
                          videoTile = const LoadingWidget(
                            height: 100,
                          );
                        }

                        return videoTile;
                      }),*/ /*

                  if (subcategory?.subcategoryId != null)
                    FutureBuilder(
                        future: storeRepository
                            .getCategoryVideos(subcategory?.subcategoryId),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          List<Widget> widgetList = [];

                          if (snapshot.data != null) {
                            widgetList.clear();
                            videoData = snapshot.data;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 15),
                                  child: TextDivider(
                                    text: "${videoData?.length} videos",
                                  ),
                                ),
                                const SizedBox(height: 15),
                                videosListWidget = ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount: videoData?.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    if (index > -1) {
                                      List<Widget> widgetList = [];

                                      widgetList.add(
                                        CustomSubjectListItem(
                                          stemSubjectName:
                                              videoData?[index].name,
                                          videoLesson: VideoLessonModel(
                                            name:
                                                videoData?[index].name ?? "",
                                            onlineLink: videoData?[index]
                                                    .onlineLink ??
                                                "",
                                            id: videoData?[index].videoid ??
                                                "",
                                          ),
                                          stemVideosKey: stemVideosKey,
                                          videosChild: videosListWidget,
                                        ),
                                      );

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: widgetList,
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ],
                            );
                          } else {
                            widgetList.add(const LoadingWidget(
                              height: 100,
                            ));
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widgetList,
                          );
                        }),
                ],
              ),
            ),
            // TODO: New Version Video Player
            */ /* CustomElevatedButton(
              svgIMPath: "assets/image/play.svg",
              name: "Start Lessons",
              key: const Key("Start Lessons"),
              onPressed: () {
                if (isVideoPlaying == null) {
                  isVideoPlaying = "0";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoPlayListPage(
                                videosListWidget: _videosListWidget!,
                              ))).then((value) => isVideoPlaying = null);
                } else {
                  print("Playing");
                }
              },
            ),*/ /*
            */ /* CustomElevatedButton(
              svgIMPath: "assets/image/play.svg",
              name: "Start Lessons",
              key: const Key("Start Lessons"),
              onPressed: () async {
                try {
                  String videoId = getIdFromUrl(
                      "https://www.youtube.com/watch?v=hwNWx1GTSKo");
                  var yt = YoutubeExplode(); // This is explosion

                  var manifest =
                      await yt.videos.streamsClient.getManifest(videoId);
                  // Returns a Video instance.

                  print(manifest.streams.last.url);
                } catch (e) {
                  print(e);
                }
              },
            ),*/ /*

            */ /*toggleState.value
                ? CustomSubjectListItem(
                    stemSubjectName: videoData?.first.name,
                    videoLesson: VideoLessonModel(
                      name: videoData?.first.name ?? "",
                      onlineLink: videoData?.first.onlineLink ?? "",
                      id: videoData?.first.videoid ?? "",
                    ),
                    stemVideosKey: stemVideosKey,
                    videosChild: videosListWidget,
                  )
                : CustomElevatedButton(
                    svgIMPath: "assets/image/play.svg",
                    name: "Start Lessons",
                    key: const Key("Start Lessons"),
                    onPressed: () async {
                      CustomSubjectListItem(
                        stemSubjectName: videoData?.first.name,
                        videoLesson: VideoLessonModel(
                          name: videoData?.first.name ?? "",
                          onlineLink: videoData?.first.onlineLink ?? "",
                          id: videoData?.first.videoid ?? "",
                        ),
                        stemVideosKey: stemVideosKey,
                        videosChild: videosListWidget,
                      );
                    },
                  ),*/ /*

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: */ /*toggleState.value
                  ? CustomSubjectListItem(
                      stemSubjectName: videoData?.first.name,
                      videoLesson: VideoLessonModel(
                        name: videoData?.first.name ?? "",
                        onlineLink: videoData?.first.onlineLink ?? "",
                        id: videoData?.first.videoid ?? "",
                      ),
                      stemVideosKey: stemVideosKey,
                      videosChild: videosListWidget,
                    )  : */ /*
                  CustomElevatedButton(
                svgIMPath: "assets/image/play.svg",
                name: "Start Lessons",
                key: const Key("Start Lessons"),
                onPressed: () async {
                  CustomSubjectListItem(
                    stemSubjectName: videoData?.first.name,
                    videoLesson: VideoLessonModel(
                      name: videoData?.first.name ?? "",
                      onlineLink: videoData?.first.onlineLink ?? "",
                      id: videoData?.first.videoid ?? "",
                    ),
                    stemVideosKey: stemVideosKey,
                    videosChild: videosListWidget,
                  );
                },
              ),
            ),

            */ /* Consumer<StemVideoProvider>(
              builder: (context, stemVideoProviderModel, child) =>
                  CustomElevatedButton(
                svgIMPath: "assets/image/play.svg",
                name: "Start Lessons",
                key: const Key("Start Lessons"),
                onPressed: () async {
                  if (videoData!.first.onlineLink!.contains("youtube")) {
                    //TODO: Youtube Player
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (BuildContext context) => YoutubeVideo(
                          subjectName: videoData?.first.name ?? "",
                          stemVideosKey: stemVideosKey,
                          videosChild: videosListWidget,
                          youtubeLink: videoData?.first.onlineLink ?? "",
                          videoLesson: VideoLessonModel(
                            name: videoData?.first.name ?? "",
                            onlineLink: videoData?.first.onlineLink ?? "",
                            id: videoData?.first.videoid ?? "",
                          ),
                          // subjectId: subjectID,
                          videoName: videoData?.first.name,
                        ),
                      ),
                    );
                  }
                },
              ),
            )*/ /*
          ],
        ),*/
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          children: [
            CategoryDTLHeaderWidget(
              coverImage: subcategory?.coverImage,
              name: subcategory?.name,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Text(
                subcategory?.description ?? "",
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF020202)),
              ),
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 5, right: 15),
              child: TextDivider(
                text: subcategory?.description ?? "",
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: const Text(
                "Lessons",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF020202)),
              ),
            ),
            const SizedBox(height: 8),

            // TODO: New Version Video Player

            /* FutureBuilder(
                      future: storeRepository
                          .getCategoryVideos(subcategory?.subcategoryId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        Widget videoTile;

                        if (snapshot.data != null) {
                          List<Video> videoData = snapshot.data;
                          videoTile = videosListWidget = ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: videoData.length,
                              itemBuilder: (context, index) {
                                List<Widget> widgetList = [];

                                widgetList.add(VideoTile(
                                  video: videoData[index],
                                  index: index,
                                  isPlaying: false,
                                  videosListWidget: videosListWidget!,
                                ));

                                return Column(
                                  children: widgetList,
                                );
                              });
                        } else {
                          videoTile = const LoadingWidget(
                            height: 100,
                          );
                        }

                        return videoTile;
                      }),*/

            if (subcategory?.subcategoryId != null)
              FutureBuilder(
                  future: storeRepository
                      .getCategoryVideos(subcategory?.subcategoryId),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    List<Widget> widgetList = [];

                    if (snapshot.data != null) {
                      widgetList.clear();
                      videoData = snapshot.data;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 15),
                            child: TextDivider(
                              text: "${videoData?.length} videos",
                            ),
                          ),
                          const SizedBox(height: 15),
                          videosListWidget = ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: videoData?.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (index > -1) {
                                List<Widget> widgetList = [];

                                widgetList.add(
                                  CustomSubjectListItem(
                                    stemSubjectName: videoData?[index].name,
                                    videoLesson: VideoLessonModel(
                                      name: videoData?[index].name ?? "",
                                      onlineLink:
                                          videoData?[index].onlineLink ?? "",
                                      id: videoData?[index].videoid ?? "",
                                    ),
                                    stemVideosKey: stemVideosKey,
                                    videosChild: videosListWidget,
                                  ),
                                );

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: widgetList,
                                );
                              }
                              return Container();
                            },
                          ),
                        ],
                      );
                    } else {
                      widgetList.add(const LoadingWidget(
                        height: 100,
                      ));
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widgetList,
                    );
                  }),
          ],
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {Key? key, this.svgIMPath, this.name, this.onPressed})
      : super(key: key);
  final String? svgIMPath;
  final String? name;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0077FF),
          // 0077FF
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          minimumSize: const Size(double.maxFinite, 60),
        ),
        onPressed: onPressed,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children: [
            if (svgIMPath != null) ...[
              SvgPicture.asset(
                svgIMPath ?? "assets/image/play.svg",
                width: 16,
                height: 16,
                color: const Color(0xFFFFFFFF),
              ),
            ],
            Text(
              name ?? "!",
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
