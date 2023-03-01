import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/my_reports_model.dart';

class PracticeAttemptedReportHomePage extends StatefulWidget {
  final List<MyReportsModel>? completeSubjectWiseReportList;

  const PracticeAttemptedReportHomePage(
      {Key? key, this.completeSubjectWiseReportList})
      : super(key: key);

  @override
  _PracticeAttemptedReportHomePageState createState() =>
      _PracticeAttemptedReportHomePageState();
}

class _PracticeAttemptedReportHomePageState
    extends State<PracticeAttemptedReportHomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  bool _contentReady = false;
  final List<MyReportPracticeModel> _listOfAllPractice = [];
  final List<MyReportPracticeModel> _listOfUniqueAllPractices = [];
  final List<List<MyReportPracticeModel>> _listOfUniqueAllPracticesTabWise = [];
  TabController? tabController;
  late TabBar _tabBar;
  final List<String> listItems = [];
  final List<String?> _tabs = ["Overall"];

  Future prepareListForTabs() async {
    await Future.forEach(widget.completeSubjectWiseReportList!,
        (dynamic myReportsModel) async {
      List<MyReportPracticeModel> _listOfUniqueSubjectWisePractices = [];

      //Subject list is being iterating...
      if ((myReportsModel.myReportPracticeModelList != null) &&
          (myReportsModel.myReportPracticeModelList.isNotEmpty)) {
        _listOfAllPractice.addAll(myReportsModel.myReportPracticeModelList);

        String? _subjectName =
            await (subjectRepository.fetchSubjectNameBasisOnSubjectID(
                subjectID: myReportsModel.subjectID));
        _tabs.add(_subjectName ?? myReportsModel.subjectID);

        await Future.forEach(myReportsModel.myReportPracticeModelList.reversed,
            (dynamic myPracticeReport) async {
          //Content inside that Subject are being iterating...
          if (!_listOfUniqueAllPractices.any(
              (element) => (element.topicID == myPracticeReport.topicID))) {
            _listOfUniqueAllPractices.add(myPracticeReport);
          }

          if (!_listOfUniqueSubjectWisePractices.any(
              (element) => (element.topicID == myPracticeReport.topicID))) {
            _listOfUniqueSubjectWisePractices.add(myPracticeReport);
          }
        });
        _listOfUniqueAllPractices
            .sort((a, b) => b.updatedTime!.compareTo(a.updatedTime!));
        _listOfUniqueAllPracticesTabWise.add(_listOfUniqueSubjectWisePractices);
      }
    });

    _listOfUniqueAllPracticesTabWise.insert(0, _listOfUniqueAllPractices);
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
  // ignore: must_call_super
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
                                    "Practice Attempted",
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
                        _listOfUniqueAllPracticesTabWise.length,
                        (index) => getTabWidgets(
                            _listOfUniqueAllPracticesTabWise[index]),
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

  @override
  bool get wantKeepAlive => true;

  getTabWidgets(List<MyReportPracticeModel> currentTabPractices) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListView.builder(
        itemCount: currentTabPractices.length,
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return CustomPracticeAttemptedTile(
            myReportPracticeModel: currentTabPractices[index],
            completeListOfPractice: _listOfAllPractice,
          );
        },
      ),
    );
  }
}

class CustomPracticeAttemptedTile extends StatefulWidget {
  final MyReportPracticeModel? myReportPracticeModel;
  final List<MyReportPracticeModel> completeListOfPractice;

  const CustomPracticeAttemptedTile({
    Key? key,
    this.myReportPracticeModel,
    required this.completeListOfPractice,
  }) : super(key: key);

  @override
  _CustomPracticeAttemptedTileState createState() =>
      _CustomPracticeAttemptedTileState();
}

class _CustomPracticeAttemptedTileState
    extends State<CustomPracticeAttemptedTile>
    with AutomaticKeepAliveClientMixin {
  bool _showMore = false;
  final List<MyReportPracticeModel> _listAllTheAttemptsOfCurrentPractice = [];

  @override
  void initState() {
    super.initState();
    _listAllTheAttemptsOfCurrentPractice.addAll(widget.completeListOfPractice
        .where((element) =>
            (element.topicID == widget.myReportPracticeModel!.topicID)));
    debugPrint(widget.myReportPracticeModel!.topicID);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
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
                          DateTime.parse(
                              widget.myReportPracticeModel!.updatedTime!),
                        )}\n${DateFormat.d().format(
                          DateTime.parse(
                              widget.myReportPracticeModel!.updatedTime!),
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
                              widget.myReportPracticeModel!.topicName!,
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
                                top: 2.5,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: FutureBuilder(
                                future: subjectRepository
                                    .fetchSubjectNameBasisOnSubjectID(
                                        subjectID: widget
                                            .myReportPracticeModel!.subjectID),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.data == null) {
                                      return Center(
                                        child: Text(
                                          "Mastery: ${(widget.myReportPracticeModel!.mastery! * 100).round()}% ${widget.myReportPracticeModel!.subjectID}",
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF9E9E9E),
                                          ),
                                        ),
                                      );
                                    }
                                    return Text(
                                      "Mastery: ${(widget.myReportPracticeModel!.mastery! * 100).round()}% ${snapshot.data}",
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${_listAllTheAttemptsOfCurrentPractice.length}\nAttempts",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 10,
                            ),
                          ),
                          Image.asset(
                            "assets/images/${_showMore ? "up_arrow" : "down_arrow"}.png",
                            height: 24,
                            width: 24,
                          )
                        ],
                      )
                      /*: Container(),*/
                      ),
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
                  _listAllTheAttemptsOfCurrentPractice.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 21,
                      width: 1,
                      margin: const EdgeInsets.only(left: 22.5),
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
                                  _listAllTheAttemptsOfCurrentPractice[index]
                                      .updatedTime!),
                            )} ${DateFormat.d().format(
                              DateTime.parse(
                                  _listAllTheAttemptsOfCurrentPractice[index]
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
                          "Mastery: ${(_listAllTheAttemptsOfCurrentPractice[index].mastery! * 100).round()}%",
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

  @override
  bool get wantKeepAlive => true;
}
