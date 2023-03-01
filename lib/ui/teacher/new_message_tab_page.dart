import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';

import 'package:idream/common/references.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/ui/teacher/new_message_bottom_sheet.dart';

List<int> _selectedBatchIndex = [];
List<int> _selectedStudentIndex = [];

class NewMessageTabPage extends StatefulWidget {
  final List<Batch>? batchList;
  NewMessageTabPage({required this.batchList});

  @override
  _NewMessageTabPageState createState() => _NewMessageTabPageState();
}

class _NewMessageTabPageState extends State<NewMessageTabPage> {
  late TabBar _tabBar;
  final List<String> _tabs = ["Batches", "Students"];

  @override
  void initState() {
    super.initState();
    _selectedBatchIndex = [];
    _selectedStudentIndex = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 20),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            body: DefaultTabController(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          const Text(
                            "Message",
                            style: TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      //TODO: Commenting it for now.. Will discuss and add it for future release.
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //     right: ScreenUtil()
                      //         .setSp(19, ),
                      //   ),
                      //   child: Image.asset(
                      //     "assets/images/search.png",
                      //     height: ScreenUtil()
                      //         .setSp(24, ),
                      //     width: ScreenUtil()
                      //         .setSp(24, ),
                      //   ),
                      //   // ),
                      // ),
                    ],
                  ),
                  // floating: true,
                  // pinned: true,
                  // snap: true,
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
                            .map(
                              (String name) => Tab(
                                text: name,
                              ),
                            )
                            .toList(),
                        labelColor: const Color(0xFF212121),
                        indicatorWeight: 2,
                        indicator: const UnderlineTabIndicator(
                          borderSide:
                              BorderSide(color: Color(0xFF0070FF), width: 4.0),
                          insets: EdgeInsets.fromLTRB(70.0, 100.0, 115.0, 5.0),
                        ),
                        unselectedLabelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.values[5]),
                        labelPadding: const EdgeInsets.all(0.0),
                        unselectedLabelColor: const Color(0xFFC9C9C9),
                        indicatorColor: const Color(0xFF0070FF),
                        labelStyle: TextStyle(
                          fontSize: 16,
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
            body: TabBarView(
              // These are the contents of the tab views, below the tabs.
              children: [
                BatchSelectionPage(batchesList: widget.batchList),
                StudentSelectionPage(batchesList: widget.batchList),
              ],
            ),
          ),
        )),
      ),
    );
  }
}

class BatchSelectionPage extends StatefulWidget {
  final List<Batch>? batchesList;
  BatchSelectionPage({this.batchesList});
  @override
  _BatchSelectionPageState createState() => _BatchSelectionPageState();
}

class _BatchSelectionPageState extends State<BatchSelectionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  width: double.maxFinite,
                  height: 2,
                  color: const Color(0xFFDEDEDE),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      widget.batchesList!.length,
                      (index) {
                        return InkWell(
                          onTap: () async {
                            if (_selectedBatchIndex.contains(index))
                              _selectedBatchIndex
                                  .removeWhere((element) => element == index);
                            else
                              _selectedBatchIndex.add(index);
                            setState(() {});
                          },
                          child: BatchTile(
                            batchInfo: widget.batchesList![index],
                            batchSelected: _selectedBatchIndex.contains(index),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OnBoardingBottomButton(
                buttonText: "Next",
                onPressed: () async {
                  if (_selectedBatchIndex.isNotEmpty) {
                    await showNewMessageBottomSheet(
                      context: context,
                      batchListInfo: widget.batchesList,
                      selectedBatchesOrStudentsIndexes: _selectedBatchIndex,
                    );
                  } else {
                    SnackbarMessages.showErrorSnackbar(context,
                        error:
                            Constants.dashboardNewMessageNoBatchSelectionAlert);
                  }
                },
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

class BatchTile extends StatefulWidget {
  const BatchTile({
    required this.batchInfo,
    this.batchSelected = false,
  });

  final Batch batchInfo;
  final bool batchSelected;

  @override
  _BatchTileState createState() => _BatchTileState();
}

class _BatchTileState extends State<BatchTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15,
        ),
        color: Color(widget.batchSelected ? 0xFFE8F2FF : 0xFFFFFFFF),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 44,
              width: 44,
              decoration: const BoxDecoration(
                  color: Color(0xffD1E6FF),
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Text(
                widget.batchInfo.batchClass!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff0070FF)),
              ),
            ),
            const SizedBox(width: 6),
            Flexible(flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Class ${widget.batchInfo.batchClass!} - ${widget.batchInfo.batchName!}",
                    textAlign: TextAlign.left,overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.values[5],
                      color: const Color(0xff212121),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    "${widget.batchInfo.joinedStudentsList!.length} Students",
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      color: Color(0xff666666),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StudentSelectionPage extends StatefulWidget {
  final List<Batch>? batchesList;
  StudentSelectionPage({this.batchesList});
  @override
  _StudentSelectionPageState createState() => _StudentSelectionPageState();
}

class _StudentSelectionPageState extends State<StudentSelectionPage> {
  bool _listPrepared = false;
  List<JoinedStudents> _totalJoinedStudentList = [];
  Future _prepareJoinedStudentsList() async {
    await Future.forEach(widget.batchesList!, (dynamic batchInfo) async {
      _totalJoinedStudentList.addAll((batchInfo as Batch).joinedStudentsList!);
      final _userIds = _totalJoinedStudentList.map((e) => e.userID).toSet();
      _totalJoinedStudentList.retainWhere((x) => _userIds.remove(x.userID));
    });
  }

  @override
  void initState() {
    super.initState();
    _prepareJoinedStudentsList().then((_) {
      setState(() {
        _listPrepared = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: _listPrepared
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: 2,
                          color: const Color(0xFFDEDEDE),
                        ),
                        Flexible(
                          flex: 1,
                          child: ListView.builder(
                            itemCount: _totalJoinedStudentList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return StudentTile(
                                joinedStudent: _totalJoinedStudentList[index],
                                studentIndex: index,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: OnBoardingBottomButton(
                      buttonText: "Next",
                      onPressed: () async {
                        if (_selectedStudentIndex.isNotEmpty) {
                          await showNewMessageBottomSheet(
                            context: context,
                            studentsListInfo: _totalJoinedStudentList,
                            selectedBatchesOrStudentsIndexes:
                                _selectedStudentIndex,
                          );
                        } else {
                          SnackbarMessages.showErrorSnackbar(context,
                              error: Constants
                                  .dashboardNewMessageNoStudentSelectionAlert);
                        }
                      },
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Color(0xFF3399FF),
                ),
              ),
      ),
    );
  }
}

class StudentTile extends StatefulWidget {
  final JoinedStudents joinedStudent;
  final int studentIndex;
  const StudentTile({
    required this.joinedStudent,
    required this.studentIndex,
  });

  @override
  _StudentTileState createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (_selectedStudentIndex.contains(widget.studentIndex))
          _selectedStudentIndex
              .removeWhere((element) => element == widget.studentIndex);
        else
          _selectedStudentIndex.add(widget.studentIndex);
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Container(
          color: Color(_selectedStudentIndex.contains(widget.studentIndex)
              ? 0xFFE8F2FF
              : 0xFFFFFFFF),
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10,
          ),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: widget.joinedStudent.profileImage!,
                imageBuilder: (context, imageProvider) => Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),

              // CircleAvatar(
              //   backgroundImage: NetworkImage(
              //     widget.joinedStudent.profileImage,
              //   ),
              //   radius: ScreenUtil().setSp(22, ),
              // ),
              const SizedBox(width: 12),
              Text(
                widget.joinedStudent.fullName!,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.values[4],
                  color: const Color(0xff212121),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
