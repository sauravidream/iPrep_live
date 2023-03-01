import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:idream/model/my_reports_model.dart';

class BooksLibraryReportHomePage extends StatefulWidget {
  final List<MyReportsModel>? booksLibraryReportData;

  const BooksLibraryReportHomePage({Key? key, this.booksLibraryReportData}) : super(key: key);

  @override
  _BooksLibraryReportHomePageState createState() =>
      _BooksLibraryReportHomePageState();
}

class _BooksLibraryReportHomePageState extends State<BooksLibraryReportHomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  bool _contentReady = false;
  List<MyReportExtraBooksModel> _listOfAllBooks = [];
  List<MyReportExtraBooksModel> _listOfUniqueAllBooks = [];
  List<List<MyReportExtraBooksModel>> _listOfUniqueAllBooksTabWise = [];
  TabController? tabController;
  late TabBar _tabBar;
  final List<String> listItems = [];
  final List<String?> _tabs = ["Overall"];

  Future prepareListForTabs() async {
    await Future.forEach(widget.booksLibraryReportData!, (dynamic myReportsModel) async {
      List<MyReportExtraBooksModel> _listOfUniqueSubjectWiseNotes = [];

      //Subject list is being iterating...\
      if ((myReportsModel.myReportExtraBooksModelList != null) &&
          (myReportsModel.myReportExtraBooksModelList.isNotEmpty)) {
        _listOfAllBooks.addAll(myReportsModel.myReportExtraBooksModelList);
        _tabs.add(myReportsModel.subjectName);

        await Future.forEach(
            myReportsModel.myReportExtraBooksModelList.reversed,
            (dynamic myBooksReport) async {
          //Content inside that Subject are being iterating...
          if (!_listOfUniqueAllBooks
              .any((element) => (element.bookID == myBooksReport.bookID))) {
            _listOfUniqueAllBooks.add(myBooksReport);
          }

          if (!_listOfUniqueSubjectWiseNotes
              .any((element) => (element.bookID == myBooksReport.bookID))) {
            _listOfUniqueSubjectWiseNotes.add(myBooksReport);
          }
        });
        _listOfUniqueAllBooks
            .sort((a, b) => b.updatedTime!.compareTo(a.updatedTime!));

        //AddVideosTabWise
        _listOfUniqueAllBooksTabWise.add(_listOfUniqueSubjectWiseNotes);
      }
    });

    _listOfUniqueAllBooksTabWise.insert(0, _listOfUniqueAllBooks);
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
                                    "Books Read",
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
                        _listOfUniqueAllBooksTabWise.length,
                        (index) =>
                            getTabWidgets(_listOfUniqueAllBooksTabWise[index]),
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

  getTabWidgets(List<MyReportExtraBooksModel> currentTabBooks) {
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
          return CustomLibraryBooksCompletedItem(
            myReportBooksModel: currentTabBooks[index],
            currentTabBooks: _listOfAllBooks,
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomLibraryBooksCompletedItem extends StatefulWidget {
  final MyReportExtraBooksModel? myReportBooksModel;
  final List<MyReportExtraBooksModel>? currentTabBooks;

   const CustomLibraryBooksCompletedItem({Key? key,
    this.myReportBooksModel,
    this.currentTabBooks,
  }) : super(key: key);

  @override
  _CustomLibraryBooksCompletedItemState createState() =>
      _CustomLibraryBooksCompletedItemState();
}

class _CustomLibraryBooksCompletedItemState
    extends State<CustomLibraryBooksCompletedItem> {
  bool _showMore = false;
  List<MyReportExtraBooksModel> _listAllTheAttemptsOfCurrentLibraryBook = [];
  @override
  void initState() {
    super.initState();
    _listAllTheAttemptsOfCurrentLibraryBook.addAll(widget.currentTabBooks!.where(
        (element) => (element.bookID == widget.myReportBooksModel!.bookID)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(color: Colors.white,
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
                          DateTime.parse(widget.myReportBooksModel!.updatedTime!),
                        )}\n${DateFormat.d().format(
                          DateTime.parse(widget.myReportBooksModel!.updatedTime!),
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
                              widget.myReportBooksModel!.bookCategory!,
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
                              child: Text(
                                widget.myReportBooksModel!.bookName!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9E9E9E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Image.asset(
                        "assets/images/${_showMore ? "up_arrow" : "down_arrow"}.png",
                        alignment: Alignment.centerRight,
                        height: 24,
                        width: 24,
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
                  _listAllTheAttemptsOfCurrentLibraryBook.length, (index) {
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
                                  _listAllTheAttemptsOfCurrentLibraryBook[
                                          index]
                                      .updatedTime!),
                            )} ${DateFormat.d().format(
                              DateTime.parse(
                                  _listAllTheAttemptsOfCurrentLibraryBook[
                                          index]
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
                          "${_listAllTheAttemptsOfCurrentLibraryBook[index].pageRead} of ${_listAllTheAttemptsOfCurrentLibraryBook[index].totalPages} Pages",
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
