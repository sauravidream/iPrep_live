import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/ui/network_error_page.dart';
import 'package:provider/provider.dart';
import 'package:idream/common/references.dart';
import 'package:idream/ui/dashboard/extra_books/extra_book_widget.dart';
import 'package:idream/ui/dashboard/extra_books/extra_book_rendering_page.dart';
import 'package:flutter/cupertino.dart';

class ExtraBooksListingPage extends StatefulWidget {
  final ExtraBooksWidget? extraBookWidget;
  const ExtraBooksListingPage({
    Key? key,
    this.extraBookWidget,
  }) : super(key: key);

  @override
  _ExtraBooksListingPageState createState() => _ExtraBooksListingPageState();
}

class _ExtraBooksListingPageState extends State<ExtraBooksListingPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(
        builder: (BuildContext context, NetworkProvider networkProvider, __) {
      if (networkProvider.isAvailable == true) {
        return Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Scaffold(
              body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverSafeArea(
                        top: false,
                        bottom: false,
                        sliver: SliverAppBar(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          flexibleSpace: const SizedBox(
                            height: 20,
                          ),
                          toolbarHeight: 120,
                          titleSpacing: 0,
                          leadingWidth: 16,
                          leading: Container(),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    highlightColor: Colors.white,
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
                                    width: 8,
                                  ),
                                  Text(
                                    "Books",
                                    style: TextStyle(
                                        color: const Color(0xFF212121),
                                        fontSize: 20,
                                        fontWeight: FontWeight.values[5]),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 23,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.extraBookWidget!
                                              .extraBookModel!.subjectName!,
                                          style: TextStyle(
                                              color: Color(widget
                                                  .extraBookWidget!
                                                  .subjectColor!),
                                              fontSize: 24,
                                              fontWeight: FontWeight.values[5]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 16,
                                    ),
                                    child: Image.asset(
                                      widget.extraBookWidget!.subjectImagePath!,
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
                  child: ListView.builder(
                      itemCount: widget
                          .extraBookWidget!.extraBookModel!.bookList!.length,
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 29, left: 13, right: 13),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _chapterTile(
                          index,
                          widget.extraBookWidget!.extraBookModel!
                              .bookList![index].bookName,
                          bookCount: widget.extraBookWidget!.extraBookModel!
                              .bookList!.length,
                          extrabookSubjectData: widget.extraBookWidget!,
                        );
                      }),
                ),
              ),
            ),
          ),
        );
      } else {
        return const NetworkError();
      }
    });
  }

  Widget _chapterTile(int index, String? bookName,
      {int? bookCount, required ExtraBooksWidget extrabookSubjectData}) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: extrabookSubjectData
            .extraBookModel!.bookList![index].topics!.length,
        shrinkWrap: true,
        itemBuilder: (context, ind) {
          return InkWell(
            onTap: () async {
              Stopwatch _booksStopwatch = Stopwatch();
              _booksStopwatch.start();
              await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => ExtraBookRenderingPage(
                    bookIndex: index,
                    index: ind,
                    bookName: extrabookSubjectData
                        .extraBookModel!.bookList![index].topics![ind].name,
                    chapterBookTileWidget: extrabookSubjectData,
                  ),
                ),
              );
              _booksStopwatch.stop();
              //bookName: extrabookSubjectData.extrabookModel.bookList[index].bookName
              //

              if (!usingIprepLibrary) {
                await dashboardRepository.saveBookLibraryReport(
                  bookLibraryModel: extrabookSubjectData
                      .extraBookModel!.bookList![index].topics![ind],
                  durationInSeconds: _booksStopwatch.elapsed.inSeconds,
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                    child: Container(
                      color: Colors.grey.shade300,
                      constraints: const BoxConstraints(
                        maxHeight: 86,
                        maxWidth: 62,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: Constants.bookImageList[random.nextInt(6)],
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
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
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        extrabookSubjectData.extraBookModel!.bookList![index]
                            .topics![ind].name!,
                        style: TextStyle(
                          color: const Color(0xFF212121),
                          fontSize: 13,
                          fontWeight: FontWeight.values[4],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
                                widget.extraBookWidget!.extraBookModel!
                                    .subjectName!,
                                style: TextStyle(
                                  color: Color(
                                      widget.extraBookWidget!.subjectColor!),
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
                          child: Image.asset(
                            widget.extraBookWidget!.subjectImagePath!,
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
