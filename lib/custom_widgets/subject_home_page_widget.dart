import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:idream/ui/network_error_page.dart';
import 'package:idream/ui/subject_home/chapter_listing_page.dart';
import 'package:idream/ui/subject_home/subject_home.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';

class SubjectWidget extends StatefulWidget {
  final DashboardScreenState? dashboardScreenState;
  final String? subjectImagePath;
  final String? subjectName;
  final int? subjectColor;
  final String? subjectID;
  final String? subjectShortName;

  const SubjectWidget({
    Key? key,
    this.dashboardScreenState,
    this.subjectImagePath,
    this.subjectName,
    this.subjectColor = 0xFF212121,
    this.subjectID,
    this.subjectShortName,
  }) : super(key: key);

  @override
  _SubjectWidgetState createState() => _SubjectWidgetState();
}

bool isNav = true;

class _SubjectWidgetState extends State<SubjectWidget> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: 110, width: 80,
        // color: Colors.grey,
        child: InkResponse(
          highlightColor: const Color(0x9DEEEEEE).withOpacity(.5),
          radius: 60,
          borderRadius: BorderRadius.circular(5),
          onTap: () async {
            if (isNav == false) return;
            isNav = false;
            networkInfoImpl.isConnected.then((value) async {
              if (value == true) {
                setState(() {
                  _enabled = false;
                });

                List categoryWiseData = [];
                List categoryWiseId = [];
                final categoryList = await subjectRepository
                    .fetchCategoryWiseDataBasisOnSubjectID(
                        subjectID: widget.subjectID!);

                await Future.forEach(categoryList!, (element) {
                  categoryWiseData.add(element.name);
                  categoryWiseId.add(element.id);
                });

                if (categoryWiseData.isNotEmpty) {
                  if ((categoryWiseId).contains("multimedia")) {
                    if (!mounted) return;
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ChapterListingPage(
                          subjectWidget: widget,
                          categoryWiseData: categoryWiseData,
                          category: categoryList,
                        ),
                      ),
                    ).then((value) {
                      setState(() {
                        _enabled = true;
                      });
                    });
                  } else {
                    if (!mounted) return;
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SubjectHome(
                          subjectWidget: widget,
                          chapterName: "",
                          totalChapters: 0,
                          // ignore: prefer_const_literals_to_create_immutables
                          chapterList: [],
                          categoryWiseData: categoryWiseData,
                          category: categoryList,
                        ),
                      ),
                    );
                  }
                } else {
                  if (!mounted) return;
                  SnackbarMessages.showErrorSnackbar(context,
                      error: Constants.noCategoryDataAvailableForSubjects);
                }
                setState(() {
                  _enabled = true;
                });
              } else {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const NetworkError()));
              }
              isNav = true;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 5,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 4, right: 4, top: 4, bottom: 4),
                    child: CachedNetworkImage(
                      imageUrl: widget.subjectImagePath!,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                        period: const Duration(seconds: 1),
                        child: const SizedBox(

                            // width: 102,
                            ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.school),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Text(
                  (widget.subjectShortName!.length > 8)
                      ? ("${widget.subjectShortName!.substring(0, 7)}..")
                      : widget.subjectShortName!,
                  maxLines: 1,
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
