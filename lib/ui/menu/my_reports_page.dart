import 'dart:convert';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/ui/network_error_page.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/model/my_reports_model.dart';
import 'package:idream/ui/menu/my_report/date_wise_report_page.dart';
import 'package:idream/ui/menu/my_report/monthly_report_tab_dart.dart';
import 'package:idream/ui/menu/my_report/weekly_report_tab.dart';
import 'package:idream/ui/menu/my_report/yearly_report_tab.dart';

class MyReportsPage extends StatefulWidget {
  final JoinedStudents? joinedStudent;
  final String? boardID;
  final String? language;
  final String? studentClass;
  const MyReportsPage({
    Key? key,
    this.joinedStudent,
    this.boardID,
    this.language,
    this.studentClass,
  }) : super(key: key);

  @override
  _MyReportsPageState createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  late TabBar _tabBar;
  final List<String> listItems = [];
  final List<String> _tabs = <String>[
    "Week",
    "Month",
    "Year",
  ];

  List<MyReportsModel>? _listMyReportsModel = [];
  bool _dataLoaded = false;
  Map? _bookLibraryCompleteData;
  Map? _stemVideosCompleteData;

  @override
  void initState() {
    super.initState();
    String? _studentUserID;
    if (widget.joinedStudent != null) {
      _studentUserID = widget.joinedStudent!.userID;
    }
    myReportsRepository
        .fetchCompleteReport(
      studentUserID: _studentUserID,
      boardName: widget.boardID,
      studentClass: widget.studentClass,
      studentLanguage: widget.language,
    )
        .then((value) {
      myReportsRepository
          .fetchExtraBookReport(
        studentUserID: _studentUserID,
        boardName: widget.boardID,
        studentClass: widget.studentClass,
        studentLanguage: widget.language,
      )
          .then((value1) {
        _bookLibraryCompleteData = value1;
        myReportsRepository
            .fetchStemVideosReport(
          studentUserID: _studentUserID,
          boardName: widget.boardID,
          studentClass: widget.studentClass,
          studentLanguage: widget.language,
        )
            .then((value2) {
          _stemVideosCompleteData = value2;
          if (value.runtimeType == _listMyReportsModel.runtimeType) {
            _listMyReportsModel = value;
            setState(() {
              _dataLoaded = true;
            });
          } else {
            setState(() {
              _dataLoaded = true;
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          bottom: false,
          child: Consumer<NetworkProvider>(
            builder: (context, networkProvider, __) => networkProvider
                        .isAvailable ==
                    true
                ? Scaffold(
                    backgroundColor: Colors.white,
                    body: DefaultTabController(
                      length: _tabs.length, // This is the number of tabs.
                      child: NestedScrollView(
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            // These are the slivers that show up in the "outer" scroll view.
                            return <Widget>[
                              if (widget.joinedStudent == null)
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     Navigator.pop(context);
                                      //   },
                                      //   child: Image.asset(
                                      //     "assets/images/back_icon.png",
                                      //     height: ScreenUtil()
                                      //         .setSp(25, ),
                                      //     width: ScreenUtil()
                                      //         .setSp(25, ),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        "My Reports",
                                        style: TextStyle(
                                          color: Color(0xFF212121),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// Calender wise filter

                                  /* actions: [
                                    InkWell(
                                      highlightColor: Colors.white,
                                      onTap: () async {
                                        final DateTime? picked =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                          helpText: "Select Date",
                                          errorFormatText: 'Enter valid date',
                                          errorInvalidText:
                                              'Enter date in valid range',
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData
                                                  .light(), // This will change to light theme.
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (picked != null) {
                                          debugPrint(picked.toString());
                                          if (!mounted) return;
                                          await Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  DateWiseReportPage(
                                                listMyReportsModel:
                                                    _listMyReportsModel,
                                                selectedDate: picked,
                                                bookLibraryCompleteData:
                                                    json.encode(
                                                        _bookLibraryCompleteData),
                                                stemVideosCompleteData:
                                                    json.encode(
                                                        _stemVideosCompleteData),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(
                                          11,
                                        ),
                                        child: Image.asset(
                                          "assets/images/calendar.png",
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                    ),
                                  ],*/
                                  floating: true,
                                  pinned: true,
                                  snap: true,
                                  primary: true,
                                  forceElevated: innerBoxIsScrolled,
                                  elevation: 0,
                                  bottom: PreferredSize(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                      ),
                                      child: _tabBar = TabBar(
                                        // These are the widgets to put in each tab in the tab bar.
                                        tabs: _tabs
                                            .map((String name) => Tab(
                                                  text: name,
                                                ))
                                            .toList(),
                                        labelColor: const Color(0xFF212121),
                                        indicatorWeight: 2,
                                        indicator: const UnderlineTabIndicator(
                                          borderSide: BorderSide(
                                              color: Color(0xFF0077FF),
                                              width: 4.0),
                                          insets: EdgeInsets.fromLTRB(
                                              50.0, 50.0, 50.0, 5.0),
                                        ),

                                        unselectedLabelStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.values[5]),
                                        labelPadding: const EdgeInsets.all(0.0),
                                        unselectedLabelColor:
                                            const Color(0xFF8A8A8E),
                                        indicatorColor: const Color(0xFF0077FF),
                                        labelStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.values[5],
                                        ),
                                        onTap: (index) {},
                                      ),
                                    ),
                                    preferredSize: _tabBar.preferredSize,
                                  ),
                                ),
                              if (widget.joinedStudent != null)
                                SliverAppBar(
                                  backgroundColor: Colors.white,
                                  // toolbarHeight:
                                  //     ScreenUtil().setSp(128, ),
                                  titleSpacing: 0,
                                  leadingWidth: 36,
                                  leading: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 11,
                                      ),
                                      child: Image.asset(
                                        "assets/images/back_icon.png",
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                  ),
                                  flexibleSpace: const SizedBox(
                                    height: 20,
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      CachedNetworkImage(
                                        imageUrl:
                                            widget.joinedStudent!.profileImage!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
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
                                            const Icon(Icons.error),
                                      ),

                                      // CircleAvatar(
                                      //   backgroundImage: NetworkImage(
                                      //     widget.joinedStudent.profileImage,
                                      //   ),
                                      //   radius: ScreenUtil()
                                      //       .setSp(22, ),
                                      // ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        widget.joinedStudent!.fullName!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.values[5],
                                          color: const Color(0xFF212121),
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
                                  bottom: PreferredSize(
                                    // ignore: sort_child_properties_last
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                      ),
                                      child: _tabBar = TabBar(
                                        // These are the widgets to put in each tab in the tab bar.
                                        tabs: _tabs
                                            .map((String name) => Tab(
                                                  text: name,
                                                ))
                                            .toList(),
                                        labelColor: const Color(0xFF212121),
                                        indicatorWeight: 2,
                                        indicator: const UnderlineTabIndicator(
                                          borderSide: BorderSide(
                                              color: Color(0xFF0077FF),
                                              width: 4.0),
                                          insets: EdgeInsets.fromLTRB(
                                              50.0, 50.0, 50.0, 5.0),
                                        ),

                                        unselectedLabelStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.values[5]),
                                        labelPadding: const EdgeInsets.all(0.0),
                                        unselectedLabelColor:
                                            const Color(0xFF8A8A8E),
                                        indicatorColor: const Color(0xFF0077FF),
                                        labelStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.values[5],
                                        ),
                                        onTap: (index) {},
                                      ),
                                    ),
                                    preferredSize: _tabBar.preferredSize,
                                  ),
                                ),
                            ];
                          },
                          body: Stack(
                            children: [
                              if (_dataLoaded)
                                TabBarView(
                                  children: [
                                    WeeklyReportTab(
                                      listMyReportsModel: _listMyReportsModel,
                                      bookLibraryCompleteData:
                                          _bookLibraryCompleteData,
                                      stemVideosCompleteData:
                                          _stemVideosCompleteData,
                                      myReportsPage: widget.boardID != null
                                          ? widget
                                          : null,
                                    ),
                                    MonthlyReportTab(
                                      listMyReportsModel: _listMyReportsModel,
                                      bookLibraryCompleteData:
                                          _bookLibraryCompleteData,
                                      stemVideosCompleteData:
                                          _stemVideosCompleteData,
                                      myReportsPage: widget.boardID != null
                                          ? widget
                                          : null,
                                    ),
                                    YearlyReportTab(
                                      listMyReportsModel: _listMyReportsModel,
                                      bookLibraryCompleteData:
                                          _bookLibraryCompleteData,
                                      stemVideosCompleteData:
                                          _stemVideosCompleteData,
                                      myReportsPage: widget.boardID != null
                                          ? widget
                                          : null,
                                    ),
                                  ],
                                )
                              /*: Center(
                              child: Text(
                                "No data exist for this profile",
                                style: Constants.noDataTextStyle,
                              ),
                            ))*/
                              else
                                const FullPageLoader()
                            ],
                          )),
                    ),
                  )
                : const NetworkError(),
          )),
    );
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isNotSameDate(DateTime other) {
    return year != other.year || month != other.month || day != other.day;
  }
}
