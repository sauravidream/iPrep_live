import 'package:idream/common/local_db_helper.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/boards_model.dart';

class BoardSelectionRepository {
  Future fetchLanuageList({String? subjectID}) async {
    try {
      var response = await apiHandler.getAPICall(endPointURL: "/boards");

      if (response == null) return response;

      /*await Future.forEach((response as Map).values, (chapterList) async {*/
      Map<dynamic, dynamic> values = response;
      List<String> language = [];
      values.forEach((key, bookList) {
        language.add(key);
      });

      return language;
    } catch (error) {
      print(error);
    }
  }

  Future fetchEducationBoards() async {
    try {
      String? _language = (await getStringValuesSF("language"))!.toLowerCase();
      var _locallySavedBoards = await helper.fetchBoards(language: _language);

      if (_locallySavedBoards != null) {
        List<BoardsModel>? _boardsModelList = [];
        _boardsModelList = _locallySavedBoards
            .map<BoardsModel>((i) => BoardsModel.fromJson(i))
            .toList();

        if (_boardsModelList!.length > 0) {
          return _boardsModelList;
        }
      }

      var response = await apiHandler.getAPICall(
          endPointURL: "boards/${_language.toLowerCase()}");

      if (response == null) return response;

      print(response);

      List<BoardsModel> _boardsList = [];
      await Future.forEach(response as List, (dynamic board) async {
        BoardsModel _boardsModel = BoardsModel(
          abbr: board['abbr'],
          icon: board['icon'],
          id: board['id'],
          boardName: board['name'],
          detail: board['detail'],
          language: _language.toString(),
        );
        String _dataString =
            "INSERT Into $tableEducationBoards (abbr, icon, boardID, name, detail, language)"
            " VALUES (?, ?, ?, ?, ?, ?)";

        var rowID = await helper.rawInsertBoards(
            tableData: _dataString, boardsModel: _boardsModel);
        _boardsList.add(_boardsModel);
        print(rowID.toString());
      }) /*;
      })*/
          .then((value) {
        return _boardsList;
      }).catchError((error) {
        print(error.toString());
      });
      return _boardsList;
    } catch (e) {
      print(e.toString());
    }
  }
}
