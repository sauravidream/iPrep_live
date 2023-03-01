import 'package:flutter/material.dart';

import 'package:idream/model/batch_model.dart';
import 'package:idream/model/extra_book_model.dart';
import 'package:idream/ui/teacher/utilities/selectstudentbottom_sheet.dart';

class ExtraBooksListingTeacherPage extends StatefulWidget {
  final String? subjectImagePath;
  final int? subjectColor;
  final ExtraBookModel? extrabookModel;
  final Batch? batchInfo;
  final String? classId;

  ExtraBooksListingTeacherPage({
    this.subjectImagePath,
    this.subjectColor,
    this.extrabookModel,
    this.batchInfo,
    this.classId,
  });

  @override
  _ExtraBooksListingTeacherPageState createState() =>
      _ExtraBooksListingTeacherPageState();
}

class _ExtraBooksListingTeacherPageState
    extends State<ExtraBooksListingTeacherPage> {
  List<Topics> _selectedTopic = [];
  List<bool> checks = [];

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < widget.extrabookModel!.bookList![0].topics!.length; i++) {
      checks.add(false);
    }
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.extrabookModel!.subjectName!,
                                    style: TextStyle(
                                        color: Color(widget.subjectColor!),
                                        fontSize: 24,
                                        fontWeight: FontWeight.values[5]),
                                  ),
                                ],
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
            body: Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                      itemCount:
                          widget.extrabookModel!.bookList![0].topics!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _chapterTile(
                          index,
                          widget.extrabookModel!.bookList![0].topics![index].name!,
                          checks[index],
                          bookCount:
                              widget.extrabookModel!.bookList![0].topics!.length,
                        );
                      }),
                ),
                Positioned(
                  bottom: 15.0,
                  right: 15.0,
                  child: ElevatedButton(
                    onPressed: () {
                      showAssignBottomSheet(
                        context,
                        "Extra Books",
                        widget.extrabookModel!.subjectID,
                        _selectedTopic,
                        batchInfo: widget.batchInfo!,
                        subjectName: widget.extrabookModel!.subjectName,
                        classNumber: widget.classId,
                      );
                    },
                    child: Text(
                      "Select Students",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF0077FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: Size(176, 50),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chapterTile(int index, String bookName, bool check, {int? bookCount}) {
    return InkWell(
      onTap: () {
        setState(() {
          if (check) {
            checks[index] = false;
            _selectedTopic.remove(_selectedTopic.firstWhere((element) =>
                element.id ==
                widget.extrabookModel!.bookList![0].topics![index].id));
          } else {
            checks[index] = true;
            _selectedTopic.add(Topics(
              id: widget.extrabookModel!.bookList![0].topics![index].id,
              name: widget.extrabookModel!.bookList![0].topics![index].name,
              topicName:
                  widget.extrabookModel!.bookList![0].topics![index].topicName,
              onlineLink:
                  widget.extrabookModel!.bookList![0].topics![index].onlineLink,
            ));
          }
        });
      },
      child: Container(
        color: check ? Color(0xFFE8F2FF) : Colors.transparent,
        padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      child: Container(
                        color: Colors.grey.shade300,
                        margin: EdgeInsets.only(right: 20),
                        child: Image.asset(
                          widget.subjectImagePath!,
                          height: 49,
                          width: 49,
                        ),
                      ),
                    ),
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
                        bookName,
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
            ),
            Center(
                child: Container(
              margin: EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      check ? Color(widget.subjectColor!) : Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: check
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16.0,
                      )
                    : Container(height: 22, width: 22),
              ),
            )),
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
                                widget.extrabookModel!.subjectName!,
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
