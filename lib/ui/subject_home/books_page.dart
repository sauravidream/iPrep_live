import 'package:flutter/material.dart';

import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/chapter_book_tile.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/ui/subject_home/subject_home.dart';

class BooksPage extends StatefulWidget {
  final SubjectHome? subjectHome;
  BooksPage({this.subjectHome});

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage>
    with AutomaticKeepAliveClientMixin {
  Future fetchBooks() async {
    return await booksRepository.fetchBooksList(
        subjectID: widget.subjectHome!.subjectWidget!.subjectID);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 16.5,
          ),
          Container(
            height: 0.5,
            color: const Color(0xFFC9C9C9),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchBooks(),
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
                        return ChapterBookTile(
                            booksModel: snapshot.data[index],
                            bookIndex: index + 1,
                            subjectHome: widget.subjectHome);
                      });
                } else {
                  return const Center(
                    child:
                        /* Loader()*/
                        CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Color(0xFF3399FF),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
