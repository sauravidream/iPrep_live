import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/ui/teacher/books_page_teacher.dart';
import 'package:idream/ui/teacher/notes_page_teacher.dart';
import 'package:idream/ui/teacher/practice_page_teacher.dart';
import 'package:idream/ui/teacher/video_lesson_teacher_page.dart';

String? selectedChapter;

class SubjectHomeTeacher extends StatefulWidget {
  final String? subjectImagePath;
  final String? subjectName;
  final int? subjectColor;
  final String? subjectID;
  final String? chapterName;
  final int? totalChapters;
  final List<String?> chapterList;
  final String? classId;
  final Batch? batch;
  final List? categoryWiseData;

  const SubjectHomeTeacher({
    Key? key,
    this.subjectImagePath,
    this.subjectName,
    this.subjectColor,
    this.subjectID,
    this.chapterName,
    this.totalChapters,
    required this.chapterList,
    this.classId,
    this.batch,
    this.categoryWiseData,
  }) : super(key: key);

  @override
  _SubjectHomeTeacherState createState() => _SubjectHomeTeacherState();
}

class _SubjectHomeTeacherState extends State<SubjectHomeTeacher> {
  bool _canLoadPage = false;
  late TabBar _tabBar;
  String _language = "";
  final List<String> listItems = [];
  final List<String> _tabs = [];

  Future _prepareTabs() async {
    _language = (await getStringValuesSF("language"))!.toLowerCase();
    if (widget.batch!.language == "english") {
      if (widget.categoryWiseData!.contains("Multimedia")) _tabs.add("Videos");
      if (widget.categoryWiseData!.contains("Practice")) _tabs.add("Practice");
      if (widget.categoryWiseData!.contains("Notes")) _tabs.add("Notes");
      if (widget.categoryWiseData!.contains("Syllabus Books"))
        _tabs.add("Books");
    } else {
      if (widget.categoryWiseData!.contains("मल्टीमीडिया")) _tabs.add("वीडियो");
      if (widget.categoryWiseData!.contains("अभ्यास")) _tabs.add("अभ्यास");
      if (widget.categoryWiseData!.contains("Notes")) _tabs.add("Notes");
      if (widget.categoryWiseData!.contains("पुस्तकें")) _tabs.add("पुस्तकें");
    }
    debugPrint(_tabs.toString());
    print(widget.categoryWiseData);
  }

  @override
  void initState() {
    super.initState();
    selectedChapter = widget.chapterName;
    _prepareTabs().then((value) {
      setState(() {
        _canLoadPage = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _canLoadPage
        ? Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Scaffold(
                body: DefaultTabController(
                  length: _tabs.length,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          backgroundColor: Colors.white,
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
                                  Text(
                                    widget.subjectName!,
                                    style: const TextStyle(
                                      color: Color(0xFF212121),
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 19,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget.subjectImagePath!,
                                  height: 43,
                                  width: 43,
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

                                // Image.asset(
                                //   widget.subjectImagePath,
                                //   height: ScreenUtil()
                                //       .setSp(43, ),
                                //   width: ScreenUtil()
                                //       .setSp(43, ),
                                // ),
                                // ),
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
                                indicator: UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                      color: Color(widget.subjectColor!),
                                      width: 4.0),
                                  insets: const EdgeInsets.fromLTRB(
                                      50.0, 50.0, 50.0, 5.0),
                                ),

                                unselectedLabelStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.values[5]),
                                labelPadding: const EdgeInsets.all(0.0),
                                unselectedLabelColor: const Color(0xFFC9C9C9),
                                indicatorColor: Color(widget.subjectColor!),
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
                    body: widget.batch!.language != _language
                        ? TabBarView(
                            children: [
                              if ((_tabs.contains("Videos") &&
                                      (widget.batch!.language == "english")) ||
                                  (_tabs.contains("वीडियो") &&
                                      (widget.batch!.language == "hindi")))
                                VideoLessonTeacherPage(
                                  subjectHome: widget,
                                ),
                              if ((_tabs.contains("Practice") &&
                                      (widget.batch!.language == "english")) ||
                                  (_tabs.contains("अभ्यास") &&
                                      (widget.batch!.language == "hindi")))
                                PracticePageTeacher(
                                  subjectHome: widget,
                                ),
                              // TestPageTeacher(
                              //   subjectHome: widget,
                              // ),
                              if ((_tabs.contains("Notes") &&
                                      (widget.batch!.language == "english")) ||
                                  (_tabs.contains("Notes") &&
                                      (widget.batch!.language == "hindi")))
                                NotesPageTeacher(
                                  subjectHome: widget,
                                ),
                              if ((_tabs.contains("Books") &&
                                      (widget.batch!.language == "english")) ||
                                  (_tabs.contains("पुस्तकें") &&
                                      (widget.batch!.language == "hindi")))
                                BooksPageTeacher(
                                  subjectHome: widget,
                                ),
                            ],
                          )
                        : TabBarView(
                            children: [
                              if ((_tabs.contains("Videos") &&
                                      (_language == "english")) ||
                                  (_tabs.contains("वीडियो") &&
                                      (_language == "hindi")))
                                VideoLessonTeacherPage(
                                  subjectHome: widget,
                                ),
                              if ((_tabs.contains("Practice") &&
                                      (_language == "english")) ||
                                  (_tabs.contains("अभ्यास") &&
                                      (_language == "hindi")))
                                PracticePageTeacher(
                                  subjectHome: widget,
                                ),
                              // TestPageTeacher(
                              //   subjectHome: widget,
                              // ),
                              if ((_tabs.contains("Notes") &&
                                      (_language == "english")) ||
                                  (_tabs.contains("Notes") &&
                                      (_language == "hindi")))
                                NotesPageTeacher(
                                  subjectHome: widget,
                                ),
                              if ((_tabs.contains("Books") &&
                                      (_language == "english")) ||
                                  (_tabs.contains("पुस्तकें") &&
                                      (_language == "hindi")))
                                BooksPageTeacher(
                                  subjectHome: widget,
                                ),
                            ],
                          ),
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
          );
  }
}
