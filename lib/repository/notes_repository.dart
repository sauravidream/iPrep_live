import 'package:idream/common/local_db_helper.dart';

import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/notes_model.dart';

class NotesRepository {
  Future fetchNotesList({String? subjectID}) async {
    try {
      String _educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      // if (_educationBoard == "CBSE") _educationBoard = "C_E_B";
      String? _language = (await getStringValuesSF("language"))!.toLowerCase();
      String? _classNumber = await (getStringValuesSF("classNumber"));
      if (int.parse(_classNumber!) > 10) {
        String? _stream = await getStringValuesSF("stream");
        _classNumber = _classNumber + "_$_stream";
      }

      var _locallySavedNotes =
          await helper.fetchNotesBasisOnSubjectNameClassNameBoardNameLanguage(
              subjectName: subjectID,
              className: _classNumber,
              language: _language,
              boardName: _educationBoard);

      if (_locallySavedNotes != null) {
        List<NotesModel>? _noteModelList = [];
        _noteModelList = _locallySavedNotes
            .map<NotesModel>((i) => NotesModel.fromMap(i))
            .toList();

        if (_noteModelList!.length > 0) return _noteModelList;
      }

      var response = await apiHandler.getAPICall(
          endPointURL: /*"Test1/topics/" +*/ "topics/" +
              "$_educationBoard/" +
              "$_language/" +
              "$_classNumber/" +
              "subjects/" +
              "$subjectID/" +
              "books_notes/");

      if (response == null) {
        // content not available status update on firebase console
        basicContentsTexting.contentsStatus(
          topicName: '',
          subject: subjectID!,
          classNo: _classNumber,
          language: _language,
          board: _educationBoard.toLowerCase(),
          dataNotFoundIn: 'Notes Book',
        );
        // return response;
      }

      /*await Future.forEach((response as Map).values, (chapterList) async {*/
      List<NotesModel> _notesList = [];
      await Future.forEach(response as List, (dynamic notesList) async {
        await Future.forEach(notesList['topics'] as List, (dynamic note) async {
          NotesModel _notesModel = NotesModel(
            boardID: _educationBoard,
            classID: _classNumber,
            language: _language,
            subjectName: subjectID,
            chapterName: note["topicName"],
            noteDetails: note["detail"],
            noteID: note["id"],
            noteName: note["name"],
            noteOfflineLink: note["offlineLink"],
            noteOfflineThumbnail: note["offlineThumbnail"],
            noteOnlineLink: note["onlineLink"],
            noteThumbnail: note["thumbnail"],
            noteTopicName: note["topicName"],
          );
          String _dataString =
              "INSERT Into $tableNotes (boardID, classID, language, subjectName, chapterName, noteDetails, noteID, noteName, noteOfflineLink, noteOfflineThumbnail, noteOnlineLink, noteThumbnail, noteTopicName)"
              " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

          var rowID = await helper.rawInsertNotes(
              tableData: _dataString, notesModel: _notesModel);
          _notesList.add(_notesModel);
          print(rowID.toString());
        });
      }) /*;
      })*/
          .then((value) {
        return _notesList;
      }).catchError((error) {
        print(error.toString());
      });
      return _notesList;
    } catch (error) {
      print(error);
    }
  }

  Future saveUsersNotesReport(
    String? subjectName, {
    int? durationInSeconds,
    required NotesModel currentNotesModel,
    required String subjectID,
    String? boardID, //Change for saving assignment's progress
    String? classID, //Change for saving assignment's progress
    String? language, //Change for saving assignment's progress
    /*int lastPageNumber,*/
  }) async {
    try {
      String? _userID = await (getStringValuesSF("userID"));
      String? _educationBoard =
          boardID ?? (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String? _language =
          language ?? (await getStringValuesSF("language"))!.toLowerCase();
      String? _classNumber = classID;
      if (_classNumber == null) {
        _classNumber = await getStringValuesSF("classNumber");
        String? _stream = await getStringValuesSF("stream");
        if (_stream != "null" && _stream != "" && _stream != null) {
          _classNumber = _classNumber! + "_" + _stream;
        }
      }
      dbRef
          .child("reports")
          .child("app_reports")
          .child(_userID!)
          .child("data")
          .child(_classNumber!)
          .child(_educationBoard)
          .child(_language)
          .child(subjectID)
          .child("books_notes")
          .child(currentNotesModel.noteTopicName!)
          .push()
          .set({
        "updated_time": DateTime.now().toUtc().toString(),
        "note_id": currentNotesModel.noteID,
        "notes_name": currentNotesModel.noteName,
        "topic_name": currentNotesModel.noteTopicName,
        "duration": durationInSeconds.toString(),
        "total_pages": totalBookOrNotesPageCount.toString(),
        "page_read": totalReadBookOrNotesPageCount.toString(),
        "subject_name": subjectName,
        'user_name': appUser!.fullName,
        'class_name': _classNumber,
      }).then((_) async {
        print("Saved UsersNotes Data successfully");

        await myReportsRepository.saveOverallAppUses(
            subjectID: subjectID,
            categoryName: "notes",
            className: _classNumber,
            userId: _userID,
            boardName: _educationBoard,
            language: _language,
            appUsesDuration: durationInSeconds.toString());
      }).catchError((onError) {
        print(onError);
      });
    } catch (error) {
      print(error);
    }
  }
}
