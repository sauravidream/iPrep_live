import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/custom_widgets/subject_home_page_widget.dart';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/ui/network_error_page.dart';
import 'package:provider/provider.dart';
import 'package:idream/ui/subject_home/subject_home.dart';

import '../../model/category_model.dart';

class ChapterListingPage extends StatefulWidget {
  final SubjectWidget? subjectWidget;
  final List? categoryWiseData;
  final List<Category>? category;

  const ChapterListingPage({
    Key? key,
    this.subjectWidget,
    this.categoryWiseData,
    this.category,
  }) : super(key: key);

  @override
  _ChapterListingPageState createState() => _ChapterListingPageState();
}

class _ChapterListingPageState extends State<ChapterListingPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.white,
      child: SafeArea(
          bottom: false,
          child: Consumer<NetworkProvider>(
            builder: (_, networkProvider, __) => networkProvider.isAvailable ==
                    true
                ? Scaffold(
                    body: FutureBuilder(
                      future: videoLessonRepository
                          .fetchVideoLessons(widget.subjectWidget!.subjectID),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          int? _chaptersCount = snapshot.data.length;
                          return NestedScrollView(
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              // These are the slivers that show up in the "outer" scroll view.
                              return <Widget>[
                                SliverOverlapAbsorber(
                                  handle: NestedScrollView
                                      .sliverOverlapAbsorberHandleFor(context),
                                  sliver: SliverSafeArea(
                                    top: false,
                                    bottom: false,
                                    sliver: SliverAppBar(
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      toolbarHeight: 160,
                                      titleSpacing: 0,
                                      leadingWidth: 0,
                                      // leading: Container(
                                      //   height: 10,color: Colors.red,
                                      // ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Image.asset(
                                              "assets/images/back_icon.png",
                                              height: 24,
                                              width: 24,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 23,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        widget.subjectWidget!
                                                            .subjectName!,
                                                        style: TextStyle(
                                                            color: Color(widget
                                                                .subjectWidget!
                                                                .subjectColor!),
                                                            fontSize: 32,
                                                            fontWeight:
                                                                FontWeight
                                                                    .values[5]),
                                                      ),
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                      Text(
                                                        selectedAppLanguage!
                                                                    .toLowerCase() ==
                                                                'hindi'
                                                            ? "$_chaptersCount अध्याय"
                                                            : "$_chaptersCount Chapters",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xFF8A8A8E),
                                                          fontSize:
                                                              selectedAppLanguage!
                                                                          .toLowerCase() ==
                                                                      "english"
                                                                  ? 15
                                                                  : 16,
                                                          fontWeight: FontWeight
                                                              .values[5],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 16,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: widget
                                                      .subjectWidget!
                                                      .subjectImagePath!,
                                                  height: 49,
                                                  width: 49,
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
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
                                        preferredSize: const Size.fromHeight(1),
                                        child: Container(
                                          height: 0.5,
                                          color: const Color(0xFFC9C9C9),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ];
                            },
                            body: Container(
                              color: Colors.white,
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 13,
                                  ),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return chapterTile(index, snapshot,
                                        chaptersCount: _chaptersCount);
                                  }),
                            ),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data == null) {
                          return noDataFoundWidget();
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              backgroundColor: Color(0xFF3399FF),
                            ),
                          );
                        }
                      },
                    ),
                  )
                : const NetworkError(),
          )),
    );
  }

  Widget chapterTile(int index, AsyncSnapshot snapshot, {chaptersCount}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => SubjectHome(
                subjectWidget: widget.subjectWidget,
                chapterName: snapshot.data[index],
                totalChapters: chaptersCount,
                chapterList: snapshot.data!,
                categoryWiseData: widget.categoryWiseData,
                category: widget.category,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 10, top: 10),
          child: Row(
            children: [
              Text(
                "${index < 9 ? "0" : ""}${index + 1}.",
                // style: textTheme.bodyText1!.copyWith(color:Color(widget.subjectWidget!.subjectColor!),)
                style: TextStyle(
                  fontSize:
                      selectedAppLanguage!.toLowerCase() == "english" ? 15 : 16,
                  fontWeight: FontWeight.values[5],
                  color: Color(widget.subjectWidget!.subjectColor!),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  snapshot.data[index],
                  style:
                      /*  textTheme.bodyText1!.copyWith(color:kPrimaryTextColorBlack100,)*/

                      TextStyle(
                    color: const Color(0xFF212121),
                    fontSize: selectedAppLanguage!.toLowerCase() == "english"
                        ? 15
                        : 16,
                    fontWeight: FontWeight.values[5],
                  ),
                ),
              ),
            ],
          ),
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
                flexibleSpace: const SizedBox(
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
                    const SizedBox(
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
                                widget.subjectWidget!.subjectName!,
                                style: TextStyle(
                                  color: Color(
                                      widget.subjectWidget!.subjectColor!),
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 16,
                          ),
                          child: Image.network(
                            widget.subjectWidget!.subjectImagePath!,
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
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    height: 0.5,
                    color: const Color(0xFF6A6A6A),
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text("No data found"),
        ),
      ),
    );
  }
}
