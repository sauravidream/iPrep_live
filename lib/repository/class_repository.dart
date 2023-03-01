import 'package:idream/common/local_db_helper.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/class_model.dart';

class ClassRepository {
  Future fetchClasses({String? boardName}) async {
    try {
      String? _educationBoard =
          boardName ?? await getStringValuesSF("educationBoard");
      String _language = (await getStringValuesSF("language"))!.toLowerCase();
      // if (_educationBoard == "CBSE") _educationBoard = "C_E_B";
      if (_educationBoard != null) {
        _educationBoard = _educationBoard.toLowerCase();
      }

      var _locallySavedClasses =
          await helper.fetchClassesBasisEducationBoardAndLanguage(
        boardName: _educationBoard ?? "cbse",
        language: _language,
      );

      if (_locallySavedClasses != null) {
        List<ClassStandard>? _classesModelList = [];
        _classesModelList = _locallySavedClasses
            .map<ClassStandard>((i) => ClassStandard.fromJson(i))
            .toList();

        if (_classesModelList!.length > 0) return _classesModelList;
      }

      var response = await apiHandler.getAPICall(
          endPointURL:
              "classes/${_educationBoard ?? "cbse"}/$_language/" /*+
              "Categories/" +
              "English/" + //TODO: Alert -- Sachin -- Change this hardcoded value //$subjectName
              "books_ncert/" +
              "Topics/"*/
          );

      if (response == null) return response;

      //use for convert  map into list

      // if (_educationBoard != 'cbse') {
      //   response = response.values.toList();
      // }
      print(response);

      List<ClassStandard> _classesList = [];
      await Future.forEach(response as List, (dynamic classes) async {
        ClassStandard _classesModel = ClassStandard(
          boardName: _educationBoard ?? "cbse",
          classID: classes['id'],
          className: classes['name'],
          icon: classes['icon'],
          language: _language,
        );
        String _dataString =
            "INSERT Into $tableClasses (icon, boardName, classID, className, language)"
            " VALUES (?, ?, ?, ?, ?)";

        var rowID = await helper.rawInsertClasses(
            tableData: _dataString, classesModel: _classesModel);
        _classesList.add(_classesModel);
        print(rowID.toString());
      }) /*;
      })*/
          .then((value) {
        return _classesList;
      }).catchError((error) {
        print(error.toString());
      });
      return _classesList;
    } catch (e) {
      print(e.toString());
    }
  }
}
