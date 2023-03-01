import 'package:flutter/material.dart';

import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/model/notes_model.dart';
import 'package:idream/ui/teacher/subject_home_teacher.dart';
import 'package:idream/ui/teacher/utilities/selectstudentbottom_sheet.dart';

class NotesPageTeacher extends StatefulWidget {
  final SubjectHomeTeacher? subjectHome;
  const NotesPageTeacher({Key? key, this.subjectHome}) : super(key: key);

  @override
  _NotesPageTeacherState createState() => _NotesPageTeacherState();
}

class _NotesPageTeacherState extends State<NotesPageTeacher>
    with AutomaticKeepAliveClientMixin {
  Future fetchNotes() async {
    return await assignmentRepository.fetchNotesList(
        widget.subjectHome!.subjectID,
        widget.subjectHome!.batch!,
        widget.subjectHome!.classId);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    List<NotesModel?> selectedTopic = [];
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(
                height: 16.5,
              ),
              Container(
                height: 0.5,
                color: const Color(0xFF6A6A6A),
              ),
              Expanded(
                child: FutureBuilder(
                  future: fetchNotes(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                          itemCount:
                              snapshot.data == null ? 1 : snapshot.data.length,
                          padding: const EdgeInsets.all(
                            16,
                          ),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (snapshot.data == null) {
                              return Center(
                                  child: Text(
                                "No content available",
                                style: TextStyle(
                                  color: const Color(0xFF212121),
                                  fontWeight: FontWeight.values[5],
                                  fontSize: 15,
                                ),
                              ));
                            }
                            bool check = false;
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter _setState) {
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    _setState(() {
                                      if (check) {
                                        check = false;
                                        selectedTopic.remove(
                                            snapshot.data[index] as NotesModel?);
                                      } else {
                                        check = true;
                                        selectedTopic.add(
                                            snapshot.data[index] as NotesModel?);
                                      }
                                    });
                                  },
                                  child: Container(

                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: check
                                        ? const Color(0xffE8F2FF)
                                        : Colors.white,),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${index < 9 ? "0" : ""}${index + 1}.",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(widget
                                                      .subjectHome!.subjectColor!),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  (snapshot.data[index]
                                                          as NotesModel)
                                                      .noteName!,
                                                  style: TextStyle(
                                                    color: Color(widget
                                                        .subjectHome!
                                                        .subjectColor!),
                                                    fontSize: 13,
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
                                                        padding:
                                                            const EdgeInsets.all(
                                                                6.0),
                                                        child: check
                                                            ? Image.asset(
                                                                'assets/images/checked_image_blue.png',
                                                                height: 22,
                                                                width: 22,
                                                              )
                                                            : const SizedBox(
                                                                height: 22,
                                                                width: 22),
                                                      ),
                                                    ))
                                                  : Container()
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                          });
                    } else {
                      return const Center(
                        child: Loader()

                        /*CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: const Color(0xFF3399FF),
                        ),*/
                      );
                    }
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
                "SubjectNotes",
                widget.subjectHome!.subjectID,
                selectedTopic,
                batchInfo: widget.subjectHome!.batch!,
                subjectName: widget.subjectHome!.subjectName,
                classNumber: widget.subjectHome!.classId,
              );
            },
            child: const Text(
              "Select Students",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF0077FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              minimumSize: const Size(176, 50),
            ),
          ),
        ),
      ],
    );
  }
}
