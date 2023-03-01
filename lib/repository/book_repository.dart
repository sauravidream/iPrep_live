import 'package:flutter/foundation.dart';
import 'package:idream/common/local_db_helper.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/books_model.dart';

class BooksRepository {
  Future fetchBooksList({String? subjectID}) async {
    try {
      String? _educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      // if (_educationBoard == "CBSE") _educationBoard = "C_E_B";
      String? _language = (await getStringValuesSF("language"))!.toLowerCase();
      String? _classNumber = await (getStringValuesSF("classNumber"));
      if (int.parse(_classNumber!) > 10) {
        String? _stream = await getStringValuesSF("stream");
        _classNumber = _classNumber + "_$_stream";
      }

      var locallySavedBooks =
          await helper.fetchBooksBasisOnSubjectNameClassNameBoardNameLanguage(
              subjectName: subjectID,
              className: _classNumber,
              language: _language,
              boardName: _educationBoard);

      if (locallySavedBooks != null) {
        List<BooksModel>? _bookModelList = [];
        _bookModelList = locallySavedBooks
            .map<BooksModel>((i) => BooksModel.fromMap(i))
            .toList();

        if (_bookModelList!.length > 0) return _bookModelList;
      }

      var response = await apiHandler.getAPICall(
          endPointURL: /*"Test1/topics/" +*/ "topics/" +
              "$_educationBoard/" +
              "$_language/" +
              "$_classNumber/" +
              "subjects/" +
              "$subjectID/" +
              "books_ncert/");

      if (response == null) {
        // content not available status update on firebase console
        basicContentsTexting.contentsStatus(
          topicName: '',
          subject: subjectID!,
          classNo: _classNumber,
          language: _language,
          board: _educationBoard.toLowerCase(),
          dataNotFoundIn: 'Books Ncert',
        );
        return response;
      }

      /*await Future.forEach((response as Map).values, (chapterList) async {*/
      List<BooksModel> _bookList = [];
      await Future.forEach(response as List, (dynamic bookList) async {
        await Future.forEach(bookList['topics'] as List, (dynamic book) async {
          BooksModel _booksModel = BooksModel(
            boardID: _educationBoard,
            classID: _classNumber,
            language: _language,
            subjectName: subjectID,
            chapterName: book["topicName"],
            bookDetails: book["detail"],
            bookID: book["id"],
            bookName: book["name"],
            bookOfflineLink: book["offlineLink"],
            bookOfflineThumbnail: book["offlineThumbnail"],
            bookOnlineLink: book["onlineLink"],
            bookThumbnail: book["thumbnail"],
            bookTopicName: book["topicName"],
          );
          String _dataString =
              "INSERT Into $tableBooks (boardID, classID, language, subjectName, chapterName, bookDetails, bookID, bookName, bookOfflineLink, bookOfflineThumbnail, bookOnlineLink, bookThumbnail, bookTopicName)"
              " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

          var rowID = await helper.rawInsertBooks(
              tableData: _dataString, booksModel: _booksModel);
          _bookList.add(_booksModel);
          debugPrint(rowID.toString());
        });
      }) /*;
      })*/
          .then((value) {
        return _bookList;
      }).catchError((error) {
        debugPrint(error.toString());
      });
      return _bookList;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future saveUsersBooksReport(
    String? subjectName, {
    int? durationInSeconds,
    required BooksModel currentBooksModel,
    required String subjectID,
    String? boardID, //Change for saving assignment's progress
    String? classID, //Change for saving assignment's progress
    String? language, //Change for saving assignment's progress
    /*int lastPageNumber,*/
  }) async {
    try {
      String? _stream;
      String? _userID = await (getStringValuesSF("userID"));
      String? _educationBoard =
          boardID ?? (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String? _language =
          language ?? (await getStringValuesSF("language"))!.toLowerCase();
      String? _classNumber = classID;
      if (_classNumber == null) {
        _classNumber = await getStringValuesSF("classNumber");
        if ((int.parse(_classNumber!)) > 10) {
          _stream = await getStringValuesSF("stream"); //2
          _classNumber = _classNumber + "_" + _stream!;
        } else {
          _classNumber = _classNumber;
        }
      }
      dbRef
          .child("reports")
          .child("app_reports")
          .child(_userID!)
          .child("data")
          .child(_classNumber)
          .child(_educationBoard)
          .child(_language)
          .child(subjectID)
          .child("books_ncert")
          .child(currentBooksModel.bookName!)
          .push()
          .set({
        "updated_time": DateTime.now().toUtc().toString(),
        "book_id": currentBooksModel.bookID,
        "book_name": currentBooksModel.bookName,
        "topic_name": currentBooksModel.bookTopicName,
        "duration": durationInSeconds.toString(),
        "total_pages": totalBookOrNotesPageCount.toString(),
        "page_read": totalReadBookOrNotesPageCount.toString(),
        "subject_name": subjectName,
        'user_name': appUser!.fullName,
        'class_name': _classNumber,
      }).then((_) async {
        debugPrint("Saved UsersBooks Data successfully");

        await myReportsRepository.saveOverallAppUses(
            subjectID: subjectID,
            categoryName: "syllabus_books",
            className: _classNumber,
            userId: _userID,
            boardName: _educationBoard,
            language: _language,
            appUsesDuration: durationInSeconds.toString());
      }).catchError((onError) {
        debugPrint(onError.toString());
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
