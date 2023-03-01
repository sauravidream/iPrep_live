import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/model/stem.dart';
import 'package:idream/ui/teacher/stem_teacher_video_page.dart';

class StemChapterListingTeacherPage extends StatefulWidget {
  final String? subjectImagePath;
  final int? subjectColor;
  final StemModel? steamModel;
  final Batch? batchInfo;
  final String? classId;
  StemChapterListingTeacherPage(
      {this.subjectImagePath,
      this.subjectColor,
      this.steamModel,
      this.batchInfo,
      this.classId});

  @override
  _StemChapterListingTeacherPageState createState() =>
      _StemChapterListingTeacherPageState();
}

class _StemChapterListingTeacherPageState
    extends State<StemChapterListingTeacherPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    bottom: false,
                    sliver: SliverAppBar(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      flexibleSpace: SizedBox(
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
                          SizedBox(
                            height: 23,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  "STEM for " + widget.steamModel!.subjectName!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Color(widget.subjectColor!),
                                      fontSize: 32,
                                      fontWeight: FontWeight.values[5]),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 16,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget.subjectImagePath!,
                                  height: 49,
                                  width: 49,
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
                                      Container(
                                    child: Icon(
                                      Icons.school,
                                      size: 50,
                                    ),
                                  ),
                                ),

                                // Image.network(
                                //   widget.subjectImagePath,
                                //   height: ScreenUtil()
                                //       .setSp(49, ),
                                //   width: ScreenUtil()
                                //       .setSp(49, ),
                                // ),
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
                        preferredSize: Size.fromHeight(1),
                        child: Container(
                          height: 0.5,
                          color: Color(0xFF6A6A6A),
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
                  itemCount: widget.steamModel!.chapterList!.length,
                  padding: EdgeInsets.symmetric(
                    vertical: 29,
                    horizontal: 13,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _chapterTile(
                      index,
                      widget.steamModel!.chapterList![index].chapterName!,
                      chaptersCount: widget.steamModel!.chapterList!.length,
                      stemSubjectData: widget.steamModel!.chapterList,
                      selectedClass: widget.classId,
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chapterTile(int index, String chapterName,
      {chaptersCount, stemSubjectData, String? selectedClass}) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => StemVideosTeacherListPage(
              subjectImagePath: widget.subjectImagePath,
              subjectColor: widget.subjectColor,
              steamModel: widget.steamModel,
              chapterName: chapterName,
              totalChapters: chaptersCount,
              batchInfo: widget.batchInfo,
              classId: selectedClass,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 31,
        ),
        child: Row(
          children: [
            Text(
              "${index < 9 ? "0" : ""}${index + 1}.",
              style: TextStyle(
                fontSize: 12,
                color: Color(widget.subjectColor!),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Flexible(
              child: Text(
                chapterName,
                style: TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 13,
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
                flexibleSpace: SizedBox(
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
                    SizedBox(
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
                                widget.steamModel!.subjectName!,
                                style: TextStyle(
                                  color: Color(widget.subjectColor!),
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 16,
                          ),
                          child: Image.asset(
                            widget.subjectImagePath!,
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
                  preferredSize: Size.fromHeight(1),
                  child: Container(
                    height: 0.5,
                    color: Color(0xFF6A6A6A),
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text("No data found"),
        ),
      ),
    );
  }
}
