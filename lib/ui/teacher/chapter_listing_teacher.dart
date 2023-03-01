import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/ui/teacher/subject_home_teacher.dart';

class ChapterListingTeacherPage extends StatefulWidget {
  final String? subjectImagePath;
  final String? subjectName;
  final int? subjectColor;
  final String? subjectID;
  final String? classId;
  final Batch? batch;
  final List? categoryWiseData;

  const ChapterListingTeacherPage({
    Key? key,
    this.subjectImagePath,
    this.subjectName,
    this.subjectColor,
    this.subjectID,
    this.classId,
    this.batch,
    this.categoryWiseData,
  }) : super(key: key);

  @override
  _ChapterListingTeacherPageState createState() =>
      _ChapterListingTeacherPageState();
}

class _ChapterListingTeacherPageState extends State<ChapterListingTeacherPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: FutureBuilder(
              future: assignmentRepository.fetchVideoLessons(
                  widget.subjectID, widget.batch!, widget.classId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  int? _chaptersCount = snapshot.data.length;
                  return NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.subjectName!,
                                            style: TextStyle(
                                                color:
                                                    Color(widget.subjectColor!),
                                                fontSize: 32,
                                                fontWeight:
                                                    FontWeight.values[5]),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            "$_chaptersCount Chapters",
                                            style: const TextStyle(
                                              color: Color(0xFF8A8A8E),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 16,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.subjectImagePath!,
                                          height: 49,
                                          width: 49,
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

                                        // Image.asset(
                                        //   widget.subjectImagePath,
                                        //   height: ScreenUtil().setSp(49,
                                        //       ),
                                        //   width: ScreenUtil().setSp(49,
                                        //       ),
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
                        itemCount: snapshot.data.length,
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 13,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return chapterTile(index, snapshot,
                              chaptersCount: _chaptersCount);
                        },
                      ),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data == null) {
                  return noDataFoundWidget();
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Color(0xFF3399FF),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget chapterTile(int index, AsyncSnapshot snapshot, {chaptersCount}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => SubjectHomeTeacher(
                subjectImagePath: widget.subjectImagePath,
                subjectName: widget.subjectName,
                subjectColor: widget.subjectColor,
                subjectID: widget.subjectID,
                chapterName: snapshot.data[index],
                totalChapters: chaptersCount,
                chapterList: snapshot.data,
                classId: widget.classId,
                batch: widget.batch,
                categoryWiseData: widget.categoryWiseData,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(
            10,
          ),
          child: Row(
            children: [
              Text(
                "${index < 9 ? "0" : ""}${index + 1}.",
                style: TextStyle(
                  fontSize:
                      selectedAppLanguage!.toLowerCase() == "english" ? 15 : 16,
                  fontWeight: FontWeight.values[5],
                  color: Color(widget.subjectColor!),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  snapshot.data[index],
                  style: TextStyle(
                    color: const Color(0xFF212121),
                    fontSize: selectedAppLanguage!.toLowerCase() == "english"
                        ? 15
                        : 16,
                    fontWeight: FontWeight.values[5],
                  ),
                ),
              ),
            ],
          ),
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
                                widget.subjectName!,
                                style: TextStyle(
                                  color: Color(widget.subjectColor!),
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
          child: const Text("No data found"),
        ),
      ),
    );
  }
}
