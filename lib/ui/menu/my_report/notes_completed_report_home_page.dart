

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/my_reports_model.dart';

class NotesCompletedReportHomePage extends StatefulWidget {
  final List<MyReportsModel> completeSubjectWiseReportList;

  const NotesCompletedReportHomePage({Key? key, required this.completeSubjectWiseReportList}) : super(key: key);

  @override
  _NotesCompletedReportHomePageState createState() =>
      _NotesCompletedReportHomePageState();
}

class _NotesCompletedReportHomePageState
    extends State<NotesCompletedReportHomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  bool _contentReady = false;
  final List<MyReportNotesModel> _listOfAllNotes = [];
  final List<MyReportNotesModel> _listOfUniqueAllNotes = [];
  final List<List<MyReportNotesModel>> _listOfUniqueAllNotesTabWise = [];
  TabController? tabController;
  late TabBar _tabBar;
  final List<String> listItems = [];
  final List<String?> _tabs = ["Overall"];

  Future prepareListForTabs() async {
    /*widget.completeSubjectWiseReportList.forEach((myReportsModel) */
    await Future.forEach(widget.completeSubjectWiseReportList,
        (dynamic myReportsModel) async {
      List<MyReportNotesModel> _listOfUniqueSubjectWiseNotes = [];

      //Subject list is being iterating...\
      if ((myReportsModel.myReportNotesModelList != null) &&
          (myReportsModel.myReportNotesModelList.isNotEmpty)) {
        _listOfAllNotes.addAll(myReportsModel.myReportNotesModelList);

        String? _subjectName =
            await (subjectRepository.fetchSubjectNameBasisOnSubjectID(
                subjectID: myReportsModel.subjectID) );
        _tabs.add(_subjectName ?? myReportsModel.subjectID);

        /*myReportsModel.myReportNotesModelList.reversed.forEach((myNotesReport) */
        await Future.forEach(myReportsModel.myReportNotesModelList.reversed,
            (dynamic myNotesReport) async {
          //Content inside that Subject are being iterating...
          if (!_listOfUniqueAllNotes
              .any((element) => (element.noteID == myNotesReport.noteID))) {
            _listOfUniqueAllNotes.add(myNotesReport);
          }

          if (!_listOfUniqueSubjectWiseNotes
              .any((element) => (element.noteID == myNotesReport.noteID))) {
            _listOfUniqueSubjectWiseNotes.add(myNotesReport);
          }
        });
        _listOfUniqueAllNotes
            .sort((a, b) => b.updatedTime!.compareTo(a.updatedTime!));

        //AddVideosTabWise
        _listOfUniqueAllNotesTabWise.add(_listOfUniqueSubjectWiseNotes);
      }
    });

    _listOfUniqueAllNotesTabWise.insert(0, _listOfUniqueAllNotes);
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
                                    "Notes Attempted",
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
                                    unselectedLabelColor: const Color(0xFFC9C9C9),
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
                        _listOfUniqueAllNotesTabWise.length,
                        (index) =>
                            getTabWidgets(_listOfUniqueAllNotesTabWise[index]),
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

  getTabWidgets(List<MyReportNotesModel> currentTabTests) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListView.builder(
        itemCount: currentTabTests.length,
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return CustomNotesCompletedItem(
            myReportNotesModel: currentTabTests[index],
            completeListOfNotes: _listOfAllNotes,
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomNotesCompletedItem extends StatefulWidget {
  final MyReportNotesModel? myReportNotesModel;
  final List<MyReportNotesModel>? completeListOfNotes;

  const CustomNotesCompletedItem({Key? key,
    this.myReportNotesModel,
    this.completeListOfNotes,
  }) : super(key: key);

  @override
  _CustomNotesCompletedItemState createState() =>
      _CustomNotesCompletedItemState();
}

class _CustomNotesCompletedItemState extends State<CustomNotesCompletedItem> {
  bool _showMore = false;
  final List<MyReportNotesModel> _listAllTheAttemptsOfCurrentNotes = [];
  @override
  void initState() {
    super.initState();
    _listAllTheAttemptsOfCurrentNotes.addAll(widget.completeListOfNotes!.where(
        (element) => (element.noteID == widget.myReportNotesModel!.noteID)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(color: Colors.white,
          child: InkWell(borderRadius: BorderRadius.circular(10),
            onTap: () {
              setState(() {
                _showMore = !_showMore;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: 2,
                      ),
                      child: Text(
                        "${DateFormat.MMM().format(
                          DateTime.parse(widget.myReportNotesModel!.updatedTime!),
                        )}\n${DateFormat.d().format(
                          DateTime.parse(widget.myReportNotesModel!.updatedTime!),
                        )}",
                        // "Mar 10",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/images/practice_category.png",
                    fit: BoxFit.fill,
                    height: 36,
                    width: 36,
                  ),
                  Expanded(
                    flex: 8,
                    child: SizedBox(
                      height: 36.5,
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
                            Text(
                              widget.myReportNotesModel!.topicName!,
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
                            Flexible(
                              flex: 1,
                              child: FutureBuilder(
                                future: subjectRepository
                                    .fetchSubjectNameBasisOnSubjectID(
                                        subjectID: widget
                                            .myReportNotesModel!.subjectID),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.data == null) {
                                      return Center(
                                        child: Text(
                                          widget.myReportNotesModel!.subjectID!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF9E9E9E),
                                          ),
                                        ),
                                      );
                                    }
                                    return Text(
                                      snapshot.data ??
                                          widget.myReportNotesModel!.subjectID!,
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
                          //   "${_listAllTheAttemptsOfCurrentNotes.length}\nAttempts",
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
          ),
        ),
        if (_showMore)
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  _listAllTheAttemptsOfCurrentNotes.length, (index) {
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
                            border: Border.all(color: const Color(0XFFC9C9C9)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "${DateFormat.MMM().format(
                              DateTime.parse(
                                  _listAllTheAttemptsOfCurrentNotes[index]
                                      .updatedTime!),
                            )} ${DateFormat.d().format(
                              DateTime.parse(
                                  _listAllTheAttemptsOfCurrentNotes[index]
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
                          "${_listAllTheAttemptsOfCurrentNotes[index].pageRead} of ${_listAllTheAttemptsOfCurrentNotes[index].totalPages} Pages",
                          overflow: TextOverflow.ellipsis,
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
    );
  }
}
