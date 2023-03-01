import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/extra_book_model.dart';
import 'package:idream/ui/dashboard/extra_books/extra_book_listing_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import '../../network_error_page.dart';

class ExtraBooksContainer extends StatefulWidget {
  @override
  _ExtraBooksContainerState createState() => _ExtraBooksContainerState();
}

class _ExtraBooksContainerState extends State<ExtraBooksContainer> {
  bool _showFullList = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        FutureBuilder(
            future: dashboardRepository.fetchExtraBookContent(),
            builder: (context, subjects) {
              Widget? subjectWidget;

              if (subjects.connectionState == ConnectionState.none ||
                  subjects.connectionState == ConnectionState.waiting) {
                subjectWidget = Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  enabled: true,
                  period: const Duration(seconds: 1),
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Books',
                                style: TextStyle(
                                  fontWeight: FontWeight.values[5],
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  color: const Color(0xFF212121),
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          children: List.generate(6, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, top: 8, right: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[100]!,
                                ),
                                height: 40,
                                width: 150,
                              ),
                            );

                            /*  ExtraBooksWidget(
                              extraBookModel: ExtraBookModel(
                                  subjectName: "Subject Name",
                                  bookList: [
                                    ExtraBooks(topics: [Topics()])
                                  ]),
                              subjectImagePath: "assets/images/physics.png",
                              subjectColor: 0xFFFCAC52,
                            );*/
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (!subjects.hasData) {
                subjectWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Books',
                          style: TextStyle(
                            fontWeight: FontWeight.values[5],
                            fontFamily: GoogleFonts.inter().fontFamily,
                            color: const Color(0xFF212121),
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: const Text("No data available. Please try later."),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              } else if (subjects.hasData) {
                List<ExtraBookModel>? _extraBookslist =
                    subjects.data as List<ExtraBookModel>?;
                subjectWidget = Container(
                  margin: const EdgeInsets.only(
                    bottom: 18,
                  ),
                  child: Wrap(
                    children: List.generate(
                        _showFullList
                            ? (_extraBookslist!.length + 1)
                            : (_extraBookslist!.length > 3
                                ? 5
                                : (_extraBookslist.length + 1)), (index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 18,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedAppLanguage!.toLowerCase() == 'hindi'
                                    ? "पुस्तकालय"
                                    : 'Book Library',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  color: const Color(0xFF212121),
                                  fontSize: 18,
                                ),
                              ),
                              if (_extraBookslist.length > 3) const SizedBox()
                            ],
                          ),
                        );
                      }
                      return ExtraBooksWidget(
                        extraBookModel: _extraBookslist[index - 1],
                        subjectImagePath: (Constants.subjectColorAndImageMap[
                                    _extraBookslist[index - 1].subjectID] !=
                                null)
                            ? Constants.subjectColorAndImageMap[
                                    _extraBookslist[index - 1].subjectID]
                                ['assetPath']
                            : "assets/images/physics.png",
                        subjectColor: (Constants.subjectColorAndImageMap[
                                    _extraBookslist[index - 1].subjectID] !=
                                null)
                            ? Constants.subjectColorAndImageMap[
                                    _extraBookslist[index - 1].subjectID]
                                ['subjectColor']
                            : 0xFFFCAC52,
                      );
                    }),
                  ),
                );
              }
              return Container(
                child: subjectWidget,
              );
              /*if (subjects.connectionState == ConnectionState.none &&
                !subjects.hasData) {
              return Container();
            } else if (subjects.connectionState == ConnectionState.done &&
                subjects.data == null) {
              return Container();
            } else if (subjects.hasData) {
              List<ExtraBookModel>? _extraBookslist =
                  subjects.data as List<ExtraBookModel>?;
              return Container(
                margin: const EdgeInsets.only(
                  bottom: 18,
                ),
                child: Wrap(
                  children: List.generate(
                      _showFullList
                          ? (_extraBookslist!.length + 1)
                          : (_extraBookslist!.length > 3
                              ? 5
                              : (_extraBookslist.length + 1)), (index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 18,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedAppLanguage!.toLowerCase() == 'hindi'
                                  ? "पुस्तकें"
                                  : 'Books',
                              style: TextStyle(
                                fontWeight: FontWeight.values[5],
                                fontFamily: GoogleFonts.inter().fontFamily,
                                color: const Color(0xFF212121),
                                fontSize: 17,
                              ),
                            ),
                            if (_extraBookslist.length > 3) const SizedBox()
                          ],
                        ),
                      );
                    }
                    return ExtraBooksWidget(
                      extraBookModel: _extraBookslist[index - 1],
                      subjectImagePath: (Constants.subjectColorAndImageMap[
                                  _extraBookslist[index - 1].subjectID] !=
                              null)
                          ? Constants.subjectColorAndImageMap[
                              _extraBookslist[index - 1].subjectID]['assetPath']
                          : "assets/images/physics.png",
                      subjectColor: (Constants.subjectColorAndImageMap[
                                  _extraBookslist[index - 1].subjectID] !=
                              null)
                          ? Constants.subjectColorAndImageMap[
                                  _extraBookslist[index - 1].subjectID]
                              ['subjectColor']
                          : 0xFFFCAC52,
                    );
                  }),
                ),
              );
            } else {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                period: const Duration(seconds: 1),
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 18,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Books',
                              style: TextStyle(
                                fontWeight: FontWeight.values[5],
                                fontFamily: GoogleFonts.inter().fontFamily,
                                color: const Color(0xFF212121),
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        children: List.generate(4, (index) {
                          return ExtraBooksWidget(
                            extraBookModel: ExtraBookModel(
                                subjectName: "Subject Name",
                                bookList: [
                                  ExtraBooks(topics: [Topics()])
                                ]),
                            subjectImagePath: "assets/images/physics.png",
                            subjectColor: 0xFFFCAC52,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );*/
            })
      ],
    );
  }
}

class ExtraBooksWidget extends StatelessWidget {
  final String? subjectImagePath;
  final int? subjectColor;
  final ExtraBookModel? extraBookModel;

  const ExtraBooksWidget({
    Key? key,
    this.subjectImagePath,
    this.subjectColor = 0xFF212121,
    this.extraBookModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: const Color(0xFFFFd1d1d1),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(7.0),
        onTap: () {
          {
            networkInfoImpl.isConnected.then((value) async {
              if (value == true) {
                await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ExtraBooksListingPage(
                      extraBookWidget: this,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const NetworkError(),
                  ),
                );
              }
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                subjectImagePath!,
                height: 34,
                width: 34,
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    extraBookModel!.subjectName!,
                    style: TextStyle(
                        color: const Color(0xFF212121),
                        fontSize:
                            selectedAppLanguage!.toLowerCase() == "english"
                                ? 15
                                : 16,
                        fontWeight: FontWeight.values[5]),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${extraBookModel!.bookList![0].topics!.length} Books",
                    style: TextStyle(
                        color: const Color(0xFF707070),
                        fontSize: 11,
                        fontWeight: FontWeight.values[2]),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
