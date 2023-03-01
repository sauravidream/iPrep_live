import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/ui/network_error_page.dart';
import 'package:provider/provider.dart';
import 'package:idream/ui/dashboard/stem_videos/stem_projects_widget.dart';
import 'package:idream/ui/dashboard/stem_videos/stem_videos_list_page.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter/cupertino.dart';
import '../../../common/global_variables.dart';

AutoScrollController? stemChapterListingPageScrollController;

class StemChapterListingPage extends StatefulWidget {
  final StemSubjectWidget? stemSubjectWidget;
  const StemChapterListingPage({
    Key? key,
    this.stemSubjectWidget,
  }) : super(key: key);

  @override
  _StemChapterListingPageState createState() => _StemChapterListingPageState();
}

class _StemChapterListingPageState extends State<StemChapterListingPage> {
  @override
  void initState() {
    super.initState();
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
                  body: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      // These are the slivers that show up in the "outer" scroll view.
                      return <Widget>[
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                          sliver: SliverSafeArea(
                            top: false,
                            bottom: false,
                            sliver: SliverAppBar(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              flexibleSpace: const SizedBox(
                                height: 20,
                              ),
                              toolbarHeight: 160,
                              titleSpacing: 0,
                              leadingWidth: 16,
                              leading: Container(),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                      "assets/images/back_icon.png",
                                      height: 24,
                                      width: 24,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 23,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${widget.stemSubjectWidget!.steamModel!.subjectName!} Project",
                                              style: TextStyle(
                                                  color: Color(widget
                                                      .stemSubjectWidget!
                                                      .subjectColor),
                                                  fontSize: 32,
                                                  fontWeight:
                                                      FontWeight.values[5]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 16,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.stemSubjectWidget!
                                              .subjectImagePath!,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: 49,
                                            width: 49,
                                            decoration: BoxDecoration(
                                              // shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              floating: false,
                              pinned: true,
                              // snap: true,
                              primary: false,
                              forceElevated: innerBoxIsScrolled,
                              bottom: PreferredSize(
                                preferredSize: const Size.fromHeight(1),
                                child: Container(
                                  height: 0.5,
                                  color: const Color(0xFF6A6A6A),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Container(
                      color: Colors.white,
                      child: ListView.builder(
                          itemCount: widget.stemSubjectWidget!.steamModel!
                              .chapterList!.length,
                          padding: const EdgeInsets.symmetric(
                            vertical: 29,
                            horizontal: 13,
                          ),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return chapterTile(
                              index,
                              widget.stemSubjectWidget!.steamModel!
                                  .chapterList![index].chapterName!,
                              chaptersCount: widget.stemSubjectWidget!
                                  .steamModel!.chapterList!.length,
                              stemSubjectData: widget
                                  .stemSubjectWidget!.steamModel!.chapterList,
                            );
                          }),
                    ),
                  ),
                ),
              ),
            )
          : const NetworkError(),
    );
  }

  Widget chapterTile(int index, String chapterName,
      {chaptersCount, stemSubjectData}) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => StemVideosListPage(
                stemSubjectWidget: widget.stemSubjectWidget, //TODO:Update this.
                chapterName: chapterName,
                totalChapters: chaptersCount,
                chapterListIndex: index
                // chapterList: stemSubjectData,
                ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 31,
        ),
        child: Row(
          children: [
            Text(
              "${index < 9 ? "0" : ""}${index + 1}.",
              style: TextStyle(
                fontSize:
                    selectedAppLanguage!.toLowerCase() == "english" ? 15 : 16,
                fontWeight: FontWeight.values[5],
                color: Color(widget.stemSubjectWidget!.subjectColor),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Flexible(
              child: Text(
                chapterName,
                style: TextStyle(
                  color: const Color(0xFF212121),
                  fontSize:
                      selectedAppLanguage!.toLowerCase() == "english" ? 15 : 16,
                  fontWeight: FontWeight.values[5],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget noDataFoundWidget() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        // These are the slivers that show up in the "outer" scroll view.
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverSafeArea(
              top: false,
              bottom: false,
              sliver: SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: const SizedBox(
                  height: 20,
                ),
                toolbarHeight: 186,
                titleSpacing: 0,
                leadingWidth: 16,
                leading: Container(),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "assets/images/back_icon.png",
                        height: 24,
                        width: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 23,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.stemSubjectWidget!.steamModel!
                                    .subjectName!,
                                style: TextStyle(
                                  color: Color(
                                      widget.stemSubjectWidget!.subjectColor),
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 16,
                          ),
                          child: Image.asset(
                            widget.stemSubjectWidget!.subjectImagePath!,
                            height: 49,
                            width: 49,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                floating: true,
                pinned: true,
                snap: true,
                primary: false,
                forceElevated: innerBoxIsScrolled,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    height: 0.5,
                    color: const Color(0xFF6A6A6A),
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text("No data found"),
        ),
      ),
    );
  }
}
