import 'package:flutter/material.dart';
import 'package:idream/custom_widgets/loader.dart';

import 'package:intl/intl.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/my_reports_model.dart';

class TestAttemptedReportHomePage extends StatefulWidget {
  final List<MyReportsModel>? completeSubjectWiseReportList;

  const TestAttemptedReportHomePage(
      {Key? key, this.completeSubjectWiseReportList})
      : super(key: key);

  @override
  _TestAttemptedReportHomePageState createState() =>
      _TestAttemptedReportHomePageState();
}

class _TestAttemptedReportHomePageState
    extends State<TestAttemptedReportHomePage> {
  bool _contentReady = false;
  final List<MyReportTestModel> _listOfUniqueAllTests = [];
  final List<MyReportTestModel>? myReportTestList = [];
  final List<List<MyReportTestModel>> _listOfUniqueAllTestsTabWise = [];

  late TabBar _tabBar;
  final List<String> listItems = [];
  final List<String?> _tabs = ["Overall"];

  Future prepareListForTabs() async {
    await Future.forEach(widget.completeSubjectWiseReportList!,
        (dynamic myReportsModel) async {
      final List<MyReportTestModel> listOfUniqueSubjectWiseTests = [];
      if (myReportsModel.myReportTestModelList != null &&
          myReportsModel.myReportTestModelList.isNotEmpty) {
        myReportTestList!.addAll(myReportsModel.myReportTestModelList);

        String? _subjectName =
            await (subjectRepository.fetchSubjectNameBasisOnSubjectID(
                subjectID: myReportsModel.subjectID));
        _tabs.add(_subjectName ?? myReportsModel.subjectID);
        await Future.forEach(myReportsModel.myReportTestModelList.reversed,
            (dynamic myTestReport) async {
          if (!_listOfUniqueAllTests
              .any((element) => (element.topicID == myTestReport.topicID))) {
            _listOfUniqueAllTests.add(myTestReport);
          }
          if (!listOfUniqueSubjectWiseTests
              .any((element) => (element.topicID == myTestReport.topicID))) {
            listOfUniqueSubjectWiseTests.add(myTestReport);
          }
        });
        _listOfUniqueAllTests
            .sort((a, b) => b.updatedTime!.compareTo(a.updatedTime!));
        _listOfUniqueAllTestsTabWise.add(listOfUniqueSubjectWiseTests);
      }
    });

    _listOfUniqueAllTestsTabWise.insert(0, _listOfUniqueAllTests);
  }

  @override
  void initState() {
    super.initState();
    prepareListForTabs().then((value) {
      setState(() {
        _contentReady = true;
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
                  length: _tabs.length,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
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
                                    "Test Attempted",
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
                                    isScrollable: true,
                                    // These are the widgets to put in each tab in the tab bar.
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
                                    indicatorWeight: 2,
                                    indicator: const UnderlineTabIndicator(
                                      // borderSide: BorderSide(
                                      //     color: Color(widget.subjectWidget.subjectColor),
                                      //     width: 4.0),
                                      insets: EdgeInsets.fromLTRB(
                                          50.0, 50.0, 50.0, 5.0),
                                    ),

                                    unselectedLabelStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.values[5]),
                                    labelPadding: const EdgeInsets.all(0.0),
                                    unselectedLabelColor:
                                        const Color(0xFFC9C9C9),
                                    // indicatorColor:
                                    // Color(widget.subjectWidget.subjectColor),
                                    labelStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.values[5],
                                    ),
                                    onTap: (index) {},
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
                      children: List.generate(
                        _listOfUniqueAllTestsTabWise.length,
                        (index) =>
                            getTabWidgets(_listOfUniqueAllTestsTabWise[index]),
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Loader(),
                ),
        ),
      ),
    );
  }

  getTabWidgets(List<MyReportTestModel> currentTabTests) {
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
          return CustomTestAttemptedItem(
            myReportTestModel: currentTabTests[index],
            myReportTestList: myReportTestList,
          );
        },
      ),
    );
  }
}

class CustomTestAttemptedItem extends StatefulWidget {
  final MyReportTestModel? myReportTestModel;
  final List<MyReportTestModel>? myReportTestList;

  const CustomTestAttemptedItem({
    Key? key,
    this.myReportTestModel,
    this.myReportTestList,
  }) : super(key: key);

  @override
  _CustomTestAttemptedItemState createState() =>
      _CustomTestAttemptedItemState();
}

class _CustomTestAttemptedItemState extends State<CustomTestAttemptedItem> {
  bool _showMore = false;
  final List<MyReportTestModel> _listAllTheAttemptsOfCurrentTest = [];

  @override
  void initState() {
    _listAllTheAttemptsOfCurrentTest.addAll(widget.myReportTestList!.where(
        (element) => element.topicID == widget.myReportTestModel!.topicID));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_listAllTheAttemptsOfCurrentTest.toList().toString());
    return Column(
      children: [
        Material(
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              setState(() {
                _showMore = !_showMore;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(
                10,
              ),
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
                              widget.myReportTestModel!.updatedTime!),
                        )}\n${DateFormat.d().format(
                          DateTime.parse(
                              widget.myReportTestModel!.updatedTime!),
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
                    "assets/images/tests_category.png",
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
                              widget.myReportTestModel!.topicName!,
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
                                            .myReportTestModel!.subjectID),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.data == null) {
                                      return Center(
                                        child: Text(
                                          widget.myReportTestModel!.subjectID!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF9E9E9E),
                                          ),
                                        ),
                                      );
                                    }
                                    return Text(
                                      snapshot.data ??
                                          widget.myReportTestModel!.subjectID!,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
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
                            "${_listAllTheAttemptsOfCurrentTest.length.toString()}\nAttempts",
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
            padding: const EdgeInsets.only(left: 25.0, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_listAllTheAttemptsOfCurrentTest.length,
                  (index) {
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
                                  _listAllTheAttemptsOfCurrentTest[index]
                                      .updatedTime!),
                            )} ${DateFormat.d().format(
                              DateTime.parse(
                                  _listAllTheAttemptsOfCurrentTest[index]
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
                          "Marks: ${(_listAllTheAttemptsOfCurrentTest[index].marks)}",
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
