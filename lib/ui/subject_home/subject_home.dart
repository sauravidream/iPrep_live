import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/ui/network_error_page.dart';
import 'package:provider/provider.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/custom_widgets/subject_home_page_widget.dart';
import 'package:idream/ui/subject_home/books_page.dart';
import 'package:idream/ui/subject_home/notes_page.dart';
import 'package:idream/ui/subject_home/practice_page.dart';
import 'package:idream/ui/subject_home/test_page.dart';
import 'package:idream/ui/subject_home/video_lessons_page.dart';

import '../../model/category_model.dart';

String? selectedChapter;

class SubjectHome extends StatefulWidget {
  final SubjectWidget? subjectWidget;
  final String? chapterName;
  final int? totalChapters;
  final List? chapterList;
  final List? categoryWiseData;
  final List<Category>? category;

  const SubjectHome({
    Key? key,
    this.subjectWidget,
    this.chapterName,
    this.totalChapters,
    this.chapterList,
    this.categoryWiseData,
    this.category,
  }) : super(key: key);

  @override
  _SubjectHomeState createState() => _SubjectHomeState();
}

class _SubjectHomeState extends State<SubjectHome> {
  bool _canLoadPage = false;
  String _language = "";
  late TabBar _tabBar;
  final List<String> listItems = [];
  final List<String> _tabs =
      [] /*<String>[
    "Videos",
    "Practice",
    "Test",
    "Notes",
    "Books",
  ]*/
      ;

  Future _prepareTabs() async {
    await Future.forEach(widget.category!, (element) {
      if (element.id == "multimedia") {
        _tabs.add("${element.id!}_${element.name!}");
      }
    });
    await Future.forEach(widget.category!, (element) {
      if (element.id == "practice") {
        _tabs.add("${element.id!}_${element.name!}");
      }
    });
    await Future.forEach(widget.category!, (element) {
      if (element.id == "test") {
        _tabs.add("${element.id!}_${element.name!}");
      }
    });
    await Future.forEach(widget.category!, (element) {
      if (element.id == "notes") {
        _tabs.add("${element.id!}_${element.name!}");
      }
    });
    await Future.forEach(widget.category!, (element) {
      if (element.id == "books") {
        _tabs.add("${element.id!}_${element.name!}");
      }
    });
  }
  /* Future _prepareTabs() async {
    _language = (await getStringValuesSF("language"))!.toLowerCase();
    if (_language == "english") {
      if (widget.categoryWiseData!.contains("Multimedia")) _tabs.add("Videos");
      if (widget.categoryWiseData!.contains("Practice")) _tabs.add("Practice");
      if (widget.categoryWiseData!.contains("Practice")) _tabs.add("Test");
      if (widget.categoryWiseData!.contains("Notes")) _tabs.add("Notes");
      if (widget.categoryWiseData!.contains("Syllabus Books"))
        _tabs.add("Books");
    } else {
      if (widget.categoryWiseData!.contains("मल्टीमीडिया")) _tabs.add("वीडियो");
      if (widget.categoryWiseData!.contains("अभ्यास")) _tabs.add("अभ्यास");
      if (widget.categoryWiseData!.contains("अभ्यास")) _tabs.add("परीक्षा");
      if (widget.categoryWiseData!.contains("Notes")) _tabs.add("Notes");
      if (widget.categoryWiseData!.contains("पुस्तकें")) _tabs.add("पुस्तकें");
    }
    print(widget.categoryWiseData);
  }*/

  @override
  void initState() {
    super.initState();
    videoIdBeingPlayed = "";
    selectedChapter = widget.chapterName;
    _prepareTabs().then((value) {
      setState(() {
        _canLoadPage = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<NetworkProvider>(
        builder: (context, networkProvider, __) => networkProvider.isAvailable
            ? _canLoadPage
                ? Container(
                    color: Colors.white,
                    child: SafeArea(
                      bottom: false,
                      child: Scaffold(
                        body: DefaultTabController(
                          length: _tabs.length, // This is the number of tabs.
                          child: NestedScrollView(
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Image.asset(
                                                "assets/images/back_icon.png",
                                                height: 25,
                                                width: 25,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12),
                                                child: Text(
                                                  widget.subjectWidget!
                                                      .subjectName!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Color(0xFF212121),
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                            right: 19,
                                          ),
                                          // child: Hero(
                                          // tag:
                                          //     "SubjectTag${widget.subjectWidget.subjectName}",
                                          child: CachedNetworkImage(
                                            imageUrl: widget.subjectWidget!
                                                .subjectImagePath!,
                                            height: 43,
                                            width: 43,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Center(
                                              child: SizedBox(
                                                height: 25,
                                                width: 25,
                                                child:
                                                    CircularProgressIndicator(
                                                  value:
                                                      downloadProgress.progress,
                                                  strokeWidth: 0.5,
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )),
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
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: _tabBar = TabBar(
                                          indicatorSize:
                                              TabBarIndicatorSize.tab,
                                          // These are the widgets to put in each tab in the tab bar.
                                          tabs: _tabs
                                              .map(
                                                (String name) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Tab(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (name
                                                                .split('_')
                                                                .first ==
                                                            "multimedia") ...[
                                                          Image.asset(
                                                            'assets/images/video_icon.png',
                                                            height: 24,
                                                            width: 24,
                                                          ),
                                                        ],
                                                        if (name
                                                                .split('_')
                                                                .first ==
                                                            "practice") ...[
                                                          Image.asset(
                                                            'assets/images/practice_icon.png',
                                                            height: 24,
                                                          ),
                                                        ],
                                                        if (name
                                                                .split('_')
                                                                .first ==
                                                            "test") ...[
                                                          Image.asset(
                                                            'assets/images/test_icon.png',
                                                            height: 24,
                                                          ),
                                                        ],
                                                        if (name
                                                                .split('_')
                                                                .first ==
                                                            "notes") ...[
                                                          Image.asset(
                                                            'assets/images/notes_icon.png',
                                                            height: 24,
                                                          ),
                                                        ],
                                                        if (name
                                                                .split('_')
                                                                .first ==
                                                            "books") ...[
                                                          Image.asset(
                                                            'assets/images/books_icon.png',
                                                            height: 24,
                                                          ),
                                                        ],
                                                        Text(
                                                          name.split('_').last,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          labelColor: const Color(0xFF212121),
                                          indicatorWeight: 2,

                                          isScrollable: true,

                                          indicator: UnderlineTabIndicator(
                                            borderSide: BorderSide(
                                              color: Color(widget.subjectWidget!
                                                  .subjectColor!),
                                              width: 7.0,
                                            ),
                                            insets: const EdgeInsets.only(
                                                right: 40, left: 40),
                                          ),

                                          unselectedLabelStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.values[5],
                                          ),
                                          labelPadding:
                                              const EdgeInsets.all(0.0),
                                          unselectedLabelColor:
                                              const Color(0xFFC9C9C9),
                                          indicatorColor: Color(widget
                                              .subjectWidget!.subjectColor!),
                                          labelStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.values[5],
                                          ),
                                          onTap: (index) {},
                                        ),
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
                                if (widget.category!
                                    .map((e) => e.id)
                                    .contains("multimedia"))
                                  VideoLessonPage(
                                    subjectHome: widget,
                                  ),
                                if (widget.category!
                                    .map((e) => e.id)
                                    .contains("practice"))
                                  PracticePage(
                                    subjectHome: widget,
                                  ),
                                if (widget.category!
                                    .map((e) => e.id)
                                    .contains("test"))
                                  TestPage(
                                    subjectHome: widget,
                                  ),
                                if (widget.category!
                                    .map((e) => e.id)
                                    .contains("notes"))
                                  NotesPage(
                                    subjectHome: widget,
                                  ),
                                if (widget.category!
                                    .map((e) => e.id)
                                    .contains("books"))
                                  BooksPage(
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
                  )
            : const NetworkError());
  }
}

Future showChapterListBottomSheet(
  BuildContext context,
  List<dynamic>? chapterList,
  int subjectColor,
) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    builder: (builder) {
      return ChapterListBottomSheetWidget(
        context: context,
        chapterList: chapterList,
        subjectColor: subjectColor,
      );
    },
  );
}
