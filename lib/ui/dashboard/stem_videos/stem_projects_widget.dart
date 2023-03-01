import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/stem.dart';
import 'package:idream/ui/dashboard/stem_videos/stem_chapter_listing_page.dart';
import 'package:shimmer/shimmer.dart';

import '../../network_error_page.dart';

// ignore: must_be_immutable
class StemProjectsWidget extends StatelessWidget {
  /* final List<SubjectModel>? subjectList;*/

  StemProjectsWidget({Key? key /*, this.subjectList*/}) : super(key: key);

  Future? _stemProjectData;
  Future? videoPracticalsData;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _stemProjectData = dashboardRepository.fetchStemProjectsList();
    videoPracticalsData = dashboardRepository.fetchVideoPracticalsList();
    return Column(
      children: [
        FutureBuilder(
            future: _stemProjectData,
            builder: (BuildContext context, AsyncSnapshot stemModelLisData) {
              List<Widget>? stemProjectChildren = [];
              if (stemModelLisData.hasData) {
                List<StemModel>? stemModelList =
                    stemModelLisData.data as List<StemModel>?;
                stemProjectChildren = <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width,
                        child: Text(
                          selectedAppLanguage!.toLowerCase() == 'hindi'
                              ? "परियोजनाओं"
                              : 'Projects',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF212121),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 18,
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Wrap(
                          children: List.generate(
                            stemModelList!.length,
                            (index) {
                              return StemSubjectWidget(
                                steamModel: stemModelList[index],
                                subjectColor:
                                    stemModelList[index].subjectColor!,
                                subjectImagePath:
                                    stemModelList[index].subjectIconPath!,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ];
              }
              if (stemModelLisData.connectionState == ConnectionState.waiting ||
                  stemModelLisData.connectionState == ConnectionState.none) {
                stemProjectChildren = <Widget>[
                  Shimmer.fromColors(
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
                                  selectedAppLanguage!.toLowerCase() == 'hindi'
                                      ? "परियोजनाओं और व्यावहारिक"
                                      : 'Projects and Practicals',
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
                  )
                ];
              }
              if (stemModelLisData.error != null) {
                stemProjectChildren = <Widget>[];
              }

              return Column(
                children: stemProjectChildren,
              );
            }),
        FutureBuilder(
            future: videoPracticalsData,
            builder: (BuildContext context, AsyncSnapshot stemModelLisData) {
              List<Widget>? stemProjectChildren = [];
              if (stemModelLisData.hasData) {
                List<StemModel>? stemModelList =
                    stemModelLisData.data as List<StemModel>?;
                stemProjectChildren = <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width,
                        child: Text(
                          selectedAppLanguage!.toLowerCase() == 'hindi'
                              ? "व्यावहारिक"
                              : 'Practicals',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF212121),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 18,
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Wrap(
                          children: List.generate(
                            stemModelList!.length,
                            (index) {
                              return StemSubjectWidget(
                                steamModel: stemModelList[index],
                                subjectColor:
                                    stemModelList[index].subjectColor!,
                                subjectImagePath:
                                    stemModelList[index].subjectIconPath!,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ];
              }
              if (stemModelLisData.connectionState == ConnectionState.waiting ||
                  stemModelLisData.connectionState == ConnectionState.none) {
                stemProjectChildren = <Widget>[
                  Shimmer.fromColors(
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
                                  selectedAppLanguage!.toLowerCase() == 'hindi'
                                      ? "व्यावहारिक"
                                      : 'Practicals',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    color: const Color(0xFF212121),
                                    fontSize: 18,
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
                            }),
                          ),
                        ],
                      ),
                    ),
                  )
                ];
              }
              if (stemModelLisData.error != null) {
                stemProjectChildren = <Widget>[];
              }

              return Column(
                children: stemProjectChildren,
              );
            }),
      ],
    );
  }
}

class StemSubjectWidget extends StatelessWidget {
  final String? subjectImagePath;
  final int subjectColor;
  final StemModel? steamModel;

  const StemSubjectWidget({
    Key? key,
    this.subjectImagePath,
    this.subjectColor = 0xFF212121,
    this.steamModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      decoration: BoxDecoration(
          border: const Border(
            top: BorderSide(width: 1.0, color: Color(0xFFD1D1D1)),
            left: BorderSide(width: 1.0, color: Color(0xFFD1D1D1)),
            right: BorderSide(width: 1.0, color: Color(0xFFD1D1D1)),
            bottom: BorderSide(width: 1.0, color: Color(0xFFD1D1D1)),
          ),
          borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(7.0),
        onTap: () {
          networkInfoImpl.isConnected.then((value) async {
            if (value == true) {
              await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => StemChapterListingPage(
                    stemSubjectWidget: this,
                  ),
                ),
              );
            } else {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const NetworkError()));
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: subjectImagePath!,
                height: 34,
                width: 34,
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
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Text(
                  steamModel!.subjectName!,
                  style: TextStyle(
                      color: const Color(0xFF212121),
                      fontSize: selectedAppLanguage!.toLowerCase() == "english"
                          ? 15
                          : 16,
                      fontWeight: FontWeight.values[5]),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
