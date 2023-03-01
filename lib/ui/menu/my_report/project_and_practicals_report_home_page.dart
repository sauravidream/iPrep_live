import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/my_reports_model.dart';

class ProjectAndPracticalsReportHomePage extends StatefulWidget {
  final List<MyReportsModel>? projectAndPracticalsReportData;

  const ProjectAndPracticalsReportHomePage(
      {Key? key, this.projectAndPracticalsReportData})
      : super(key: key);

  @override
  _ProjectAndPracticalsReportHomePageState createState() =>
      _ProjectAndPracticalsReportHomePageState();
}

class _ProjectAndPracticalsReportHomePageState
    extends State<ProjectAndPracticalsReportHomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  bool _contentReady = false;
  final List<MyReportVideoLessonsModel> _listOfAllStemVideos = [];
  final List<MyReportVideoLessonsModel> _listOfUniqueAllStemVideos = [];
  final List<List<MyReportVideoLessonsModel>>
      _listOfUniqueAllStemVideosTabWise = [];
  TabController? tabController;
  late TabBar _tabBar;
  final List<String?> _tabs = ["Overall"];

  Future prepareListForTabs() async {
    await Future.forEach(widget.projectAndPracticalsReportData!,
        (dynamic myReportsModel) async {
      if ((myReportsModel.myReportVideoLessonsModelList != null) &&
          (myReportsModel.myReportVideoLessonsModelList.isNotEmpty)) {
        _listOfAllStemVideos
            .addAll(myReportsModel.myReportVideoLessonsModelList);
        //Subject list is being iterating...

        String? _subjectName =
            await (subjectRepository.fetchSubjectNameBasisOnSubjectID(
                subjectID: myReportsModel.subjectID));
        _tabs.add(_subjectName ?? myReportsModel.subjectID);
        List<MyReportVideoLessonsModel> _listOfUniqueSubjectWiseVideos = [];
        await Future.forEach(
            myReportsModel.myReportVideoLessonsModelList.reversed,
            (dynamic myVideosReport) async {
          //Content inside that Subject are being iterating...
          if (!_listOfUniqueAllStemVideos.any(
              (element) => (element.videoUrl == myVideosReport.videoUrl))) {
            _listOfUniqueAllStemVideos.add(myVideosReport);
          }

          if (!_listOfUniqueSubjectWiseVideos.any(
              (element) => (element.videoUrl == myVideosReport.videoUrl))) {
            _listOfUniqueSubjectWiseVideos.add(myVideosReport);
          }
        });
        _listOfUniqueAllStemVideos
            .sort((a, b) => b.updatedTime!.compareTo(a.updatedTime!));

        //AddVideosTabWise
        _listOfUniqueAllStemVideosTabWise.add(_listOfUniqueSubjectWiseVideos);
      }
    });

    _listOfUniqueAllStemVideosTabWise.insert(0, _listOfUniqueAllStemVideos);
  }

  @override
  void initState() {
    super.initState();
    prepareListForTabs().then((value) {
      setState(() {
        _contentReady = true;
        tabController = TabController(vsync: this, length: _tabs.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: _contentReady
              ? DefaultTabController(
                  length: _tabs.length, // This is the number of tabs.
                  child: NestedScrollView(
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                    "Project And Practicals",
                                    style: TextStyle(
                                        color: const Color(0xFF212121),
                                        fontSize: 18,
                                        fontWeight: FontWeight.values[5]),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  right: 19,
                                ),
                              ),
                            ],
                          ),
                          // floating: true,
                          // pinned: true,
                          // snap: true,
                          primary: true,
                          forceElevated: innerBoxIsScrolled,
                          elevation: 0,
                          bottom: PreferredSize(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                  ),
                                  child: _tabBar = TabBar(
                                    // These are the widgets to put in each tab in the tab bar.
                                    isScrollable: true,
                                    controller: tabController,
                                    tabs: _tabs
                                        .map((String? name) => Tab(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  name!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    labelColor: const Color(0xFF212121),
                                    indicatorWeight: 4,
                                    indicator: UnderlineTabIndicator(
                                      borderSide: const BorderSide(
                                          color: Color(0xff0070FF), width: 4.0),

                                      insets: EdgeInsets.fromLTRB(
                                          MediaQuery.of(context).size.width *
                                              0.15,
                                          50.0,
                                          MediaQuery.of(context).size.width *
                                              0.15,
                                          5.0),
                                      // insets: EdgeInsets.fromLTRB(
                                      //     MediaQuery.of(context).size.width * 0.6, 50.0, 50.0, 5.0),
                                    ),

                                    unselectedLabelStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.values[5]),
                                    labelPadding: const EdgeInsets.all(0.0),
                                    unselectedLabelColor:
                                        const Color(0xFFC9C9C9),
                                    indicatorPadding: const EdgeInsets.all(0),
                                    indicatorColor: const Color(0xff0070FF),
                                    labelStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.values[5],
                                    ),
                                  ),
                                ),
                                PreferredSize(
                                  preferredSize: const Size.fromHeight(1),
                                  child: Container(
                                    height: 0.5,
                                    color: const Color(0xFF6A6A6A),
                                  ),
                                ),
                              ],
                            ),
                            preferredSize: _tabBar.preferredSize,
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      // These are the contents of the tab views, below the tabs.
                      controller: tabController,
                      children: List.generate(
                        _listOfUniqueAllStemVideosTabWise.length,
                        (index) => getTabWidgets(
                          _listOfUniqueAllStemVideosTabWise[index],
                        ),
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Color(0xFF3399FF),
                  ),
                ),
        ),
      ),
    );
  }

  getTabWidgets(
    List<MyReportVideoLessonsModel> currentTabBooks,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListView.builder(
        itemCount: currentTabBooks.length,
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return CustomStemVideoWatchedTile(
            myReportVideoLessonsModel: currentTabBooks[index],
            completeListOfVideos: _listOfAllStemVideos,
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomStemVideoWatchedTile extends StatefulWidget {
  final MyReportVideoLessonsModel? myReportVideoLessonsModel;
  final List<MyReportVideoLessonsModel> completeListOfVideos;

  const CustomStemVideoWatchedTile({
    Key? key,
    // this.videoLesson,
    // this.subjectID,
    this.myReportVideoLessonsModel,
    required this.completeListOfVideos,
  }) : super(key: key);

  @override
  _CustomStemVideoWatchedTileState createState() =>
      _CustomStemVideoWatchedTileState();
}

class _CustomStemVideoWatchedTileState extends State<CustomStemVideoWatchedTile>
    with AutomaticKeepAliveClientMixin {
  bool _showMore = false;
  int _totalTimeSpent = 0;
  final List<MyReportVideoLessonsModel> _listAllTheAttemptsOfCurrentVideos = [];

  @override
  void initState() {
    super.initState();
    _listAllTheAttemptsOfCurrentVideos.addAll(widget.completeListOfVideos.where(
        (element) =>
            (element.videoUrl == widget.myReportVideoLessonsModel!.videoUrl)));

    _listAllTheAttemptsOfCurrentVideos
        .forEach((element) => _totalTimeSpent += int.parse(element.duration!));
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: GestureDetector(
        onTap: () async {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _showMore = !_showMore;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      "${DateFormat.MMM().format(
                        DateTime.parse(
                            widget.myReportVideoLessonsModel!.updatedTime!),
                      )}\n${DateFormat.d().format(
                        DateTime.parse(
                            widget.myReportVideoLessonsModel!.updatedTime!),
                      )}",
                      // "Mar 10",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6),
                    ),
                    child: SizedBox(
                      width: 48,
                      height: 36,
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://img.youtube.com/vi/${Uri.tryParse(widget.myReportVideoLessonsModel!.videoUrl!)!.queryParameters['v']}/0.jpg',
                        fit: BoxFit.fill,
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
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          12,
                          0.0,
                          0.0,
                          0.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.myReportVideoLessonsModel!.videoName!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: const Color(0xFF212121),
                                    fontWeight: FontWeight.values[5],
                                    fontSize: 14,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 4,
                                  ),
                                ),
                                FutureBuilder(
                                  future: subjectRepository
                                      .fetchSubjectNameBasisOnSubjectID(
                                          subjectID: widget
                                              .myReportVideoLessonsModel!
                                              .subjectID),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.data == null) {
                                        return Text(
                                          "${(_totalTimeSpent / 60).toStringAsFixed(2)} min - ${widget.myReportVideoLessonsModel!.subjectID} - ${widget.myReportVideoLessonsModel!.topicName}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF9E9E9E),
                                          ),
                                        );
                                      }
                                      return Text(
                                        "${(_totalTimeSpent / 60).toStringAsFixed(2)} min - ${snapshot.data ?? widget.myReportVideoLessonsModel!.subjectID} - ${widget.myReportVideoLessonsModel!.topicName}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF9E9E9E),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Text(
                          //   "${_listAllTheAttemptsOfCurrentVideos.length}\nRevisits",
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //     color: Color(0xFF9E9E9E),
                          //     fontSize: 10,
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: 8,
                          // ),
                          Image.asset(
                            "assets/images/${_showMore ? "up_arrow" : "down_arrow"}.png",
                            height: 24,
                            width: 24,
                          )
                        ],
                      )),
                ],
              ),
            ),
            if (_showMore)
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      _listAllTheAttemptsOfCurrentVideos.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 21,
                          width: 1,
                          margin: const EdgeInsets.only(left: 23.5),
                          color: const Color(0XFFC9C9C9),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 48,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0XFFC9C9C9)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "${DateFormat.MMM().format(
                                  DateTime.parse(
                                      _listAllTheAttemptsOfCurrentVideos[index]
                                          .updatedTime!),
                                )} ${DateFormat.d().format(
                                  DateTime.parse(
                                      _listAllTheAttemptsOfCurrentVideos[index]
                                          .updatedTime!),
                                )}",
                                // "Mar 10",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Color(0xFF9E9E9E),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 21,
                              height: 1,
                              child: Container(
                                color: const Color(0XFFC9C9C9),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              "${(int.parse(_listAllTheAttemptsOfCurrentVideos[index].duration!) / 60).toStringAsFixed(2)} minutes",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
