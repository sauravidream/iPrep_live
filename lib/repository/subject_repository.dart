import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/subject_model.dart';

import '../model/category_model.dart';

class SubjectRepository {
  Future fetchSubjectNameBasisOnSubjectID({String? subjectID}) async {
    try {
      String? _stream;
      String? _classNumber = await (getStringValuesSF("classNumber"));
      if ((int.parse(_classNumber!)) > 10) {
        _stream = await getStringValuesSF("stream"); //2
        _classNumber = _classNumber + "_" + _stream!;
      } else {
        _classNumber = _classNumber;
      }

      String? _educationBoard =
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String _language = (await getStringValuesSF("language"))!.toLowerCase();

      var _locallySavedSubjects = await helper
          .fetchSubjectNameBasisEducationBoardClassSubjectIDAndLanguage(
        boardName: _educationBoard,
        classID: _classNumber,
        subjectID: subjectID,
        language: _language,
      );

      List<SubjectModel>? _subjectsModelList = [];
      if (_locallySavedSubjects != null) {
        _subjectsModelList = _locallySavedSubjects
            .map<SubjectModel>((i) => SubjectModel.fromJson(i))
            .toList();

        if (_subjectsModelList!.length > 0) {
          return _subjectsModelList.first.subjectName;
        }
      } else
        return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<Category>>? fetchCategoryWiseDataBasisOnSubjectID({
    String? subjectID,
    String? board,
    String? language,
    String? classNumber,
  }) async {
    List<Category>? category = [];
    if ((subjectID == "english_grammar_basic") ||
        (subjectID == "english_grammar_intermediate") ||
        (subjectID == "english_grammar_advanced"))
      subjectID = "english_grammar";
    try {
      String? _educationBoard = board ??
          (await getStringValuesSF("educationBoard") ?? "cbse").toLowerCase();
      String? _language =
          language ?? (await getStringValuesSF("language"))!.toLowerCase();
      String? _classNumber;
      if (classNumber == null) {
        _classNumber = await getStringValuesSF("classNumber");
        if (int.parse(_classNumber!) > 10) {
          String? _stream = await getStringValuesSF("stream");
          _classNumber = "${_classNumber}_$_stream";
        }
      } else {
        _classNumber = classNumber;
      }
      // https://iprep-live.firebaseio.com

      var response = await dio.getData(
          "categories/$_educationBoard/$_language/$_classNumber/$subjectID/.json");

      await Future.forEach(response.data, (dynamic data) {
        category.add(Category(id: data["id"], name: data["name"]));
      });

      return category;
    } catch (e) {
      print(e);
      return null!;
    }
  }
}
