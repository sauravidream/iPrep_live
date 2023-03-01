import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/books_model.dart';
import 'package:idream/ui/teacher/subject_home_teacher.dart';

class ChapterBookTileTeacher extends StatelessWidget {
  const ChapterBookTileTeacher(
      {this.booksModel, this.bookIndex, this.subjectHome, this.selectedTopic});

  final BooksModel? booksModel;
  final int? bookIndex;
  final SubjectHomeTeacher? subjectHome;
  final List<BooksModel?>? selectedTopic;

  @override
  Widget build(BuildContext context) {
    bool check = false;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter _setState) {
      return Container(
decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: check ? const Color(0xffE8F2FF) : Colors.white,),

        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () async {
              _setState(() {
                if (check) {
                  check = false;
                  selectedTopic!.remove(booksModel);
                } else {
                  check = true;
                  selectedTopic!.add(booksModel);
                }
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                  child: Container(
                    color: Colors.grey.shade300,
                    width: 65,
                    height: 94,
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
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
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
                                  Text(
                                    "${bookIndex! < 10 ? 0 : ""}$bookIndex.",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.values[5],
                                      color: Color(subjectHome!.subjectColor!),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      booksModel!.bookName!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(subjectHome!.subjectColor!),
                                        fontWeight: FontWeight.values[5],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                check
                    ? Center(
                        child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: check
                              ? Image.asset(
                                  'assets/images/checked_image_blue.png',
                                  height: 22,
                                  width: 22,
                                )
                              : Container(height: 22, width: 22),
                        ),
                      ))
                    : Container()
              ],
            ),
          ),
        ),
      );
    });
  }
}
