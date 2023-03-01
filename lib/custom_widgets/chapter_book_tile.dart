import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/model/books_model.dart';
import 'package:idream/ui/subject_home/book_rendering_page.dart';
import 'package:idream/ui/subject_home/subject_home.dart';

class ChapterBookTile extends StatelessWidget {
  const ChapterBookTile(
      {Key? key,
      this.booksModel,
      this.bookIndex,
      this.subjectHome,
      this.assignment,
      this.batchInfo})
      : super(key: key);

  final BooksModel? booksModel;
  final int? bookIndex;
  final SubjectHome? subjectHome;
  final Map? assignment;
  final Batch? batchInfo;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          Stopwatch _booksStopwatch = Stopwatch();
          _booksStopwatch.start();
          await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (BuildContext context) => BookRenderingPage(
                chapterBookTileWidget: this,
              ),
            ),
          );
          _booksStopwatch.stop();
          if (!usingIprepLibrary) {
            booksRepository.saveUsersBooksReport(
              subjectHome!.subjectWidget!.subjectName,
              subjectID: subjectHome!.subjectWidget!.subjectID!,
              durationInSeconds: _booksStopwatch.elapsed.inSeconds,
              currentBooksModel: booksModel!,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 10, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                    child: Container(
                      color: Colors.grey.shade300,
                      constraints: const BoxConstraints(
                        maxHeight: 94,
                        maxWidth: 72,
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
                ],
              ),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 64,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0.0, 0.0, 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    booksModel!.bookName!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      // color: Color(subjectHome!
                                      //     .subjectWidget!.subjectColor!),
                                      color: const Color(0xFF212121),
                                      fontWeight: FontWeight.values[5],
                                      fontSize:
                                          selectedAppLanguage!.toLowerCase() ==
                                                  "english"
                                              ? 15
                                              : 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //TODO: Uncommenting it and pick it tomorrow
                            // Padding(
                            //   padding: EdgeInsets.only(
                            //     top: ScreenUtil()
                            //         .setSp(14, ),
                            //   ),
                            //   child: Text(
                            //     "65 pages",
                            //     style: TextStyle(
                            //       fontSize: ScreenUtil()
                            //           .setSp(10, ),
                            //       color: Color(0xFF666666),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),

                        //TODO: Uncommenting it and pick it tomorrow
                        // LinearPercentIndicator(
                        //   padding: EdgeInsets.only(
                        //     right:
                        //         ScreenUtil().setSp(8, ),
                        //     top:
                        //         ScreenUtil().setSp(6, ),
                        //   ),
                        //   backgroundColor: Color(0xFFDEDEDE),
                        //   percent: 0.8,
                        //   progressColor:
                        //       Color(subjectHome.subjectWidget.subjectColor),
                        //   trailing: Text(
                        //     "80%",
                        //     style: TextStyle(
                        //       color: Color(0xFF666666),
                        //       fontSize: ScreenUtil()
                        //           .setSp(8, ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
