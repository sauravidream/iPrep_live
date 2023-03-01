import 'package:flutter/material.dart';

import 'package:idream/common/references.dart';
import 'package:idream/model/books_model.dart';
import 'package:idream/ui/teacher/subject_home_teacher.dart';
import 'package:idream/ui/teacher/utilities/chapter_book_tile_teacher.dart';
import 'package:idream/ui/teacher/utilities/selectstudentbottom_sheet.dart';

class BooksPageTeacher extends StatefulWidget {
  final SubjectHomeTeacher? subjectHome;
  BooksPageTeacher({this.subjectHome});

  @override
  _BooksPageTeacherState createState() => _BooksPageTeacherState();
}

class _BooksPageTeacherState extends State<BooksPageTeacher>
    with AutomaticKeepAliveClientMixin {
  Future fetchBooks() async {
    return await assignmentRepository.fetchBooksList(
        widget.subjectHome!.subjectID,
        widget.subjectHome!.batch!,
        widget.subjectHome!.classId);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    List<BooksModel> selectedTopic = [];
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 16.5,
              ),
              Container(
                height: 0.5,
                color: Color(0xFF6A6A6A),
              ),
              Expanded(
                child: FutureBuilder(
                  future: fetchBooks(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                          itemCount:
                              snapshot.data == null ? 1 : snapshot.data.length,
                          padding: EdgeInsets.all(
                            16,
                          ),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (snapshot.data == null) {
                              return Center(
                                  child: Text(
                                "No content available",
                                style: TextStyle(
                                  color: Color(0xFF212121),
                                  fontWeight: FontWeight.values[5],
                                  fontSize: 15,
                                ),
                              ));
                            }
                            return ChapterBookTileTeacher(
                                booksModel: snapshot.data[index],
                                bookIndex: index + 1,
                                subjectHome: widget.subjectHome,
                                selectedTopic: selectedTopic);
                          });
                    } else
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: Color(0xFF3399FF),
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 25.0,
          right: 16.0,
          child: ElevatedButton(
            onPressed: () {
              showAssignBottomSheet(
                context,
                "SubjectBooks",
                widget.subjectHome!.subjectID,
                selectedTopic,
                batchInfo: widget.subjectHome!.batch!,
                subjectName: widget.subjectHome!.subjectName,
                classNumber: widget.subjectHome!.classId,
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
        ),
      ],
    );
  }
}
