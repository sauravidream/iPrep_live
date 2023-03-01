import 'package:idream/common/local_db_helper.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/streams_model.dart';

class StreamSelectionRepository {
  Future fetchStreams({String? boardName, String? classID}) async {
    try {
      String? _educationBoard = boardName ??
          (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String? _classID = classID ?? await getStringValuesSF("classNumber");
      var _locallySavedStreams =
          await helper.fetchStreamsBasisEducationBoardAndClass(
              boardName: _educationBoard, className: _classID);

      if (_locallySavedStreams != null) {
        List<StreamsModel>? _boardsModelList = [];
        _boardsModelList = _locallySavedStreams
            .map<StreamsModel>((i) => StreamsModel.fromJson(i))
            .toList();

        if (_boardsModelList!.isNotEmpty) return _boardsModelList;
      }
      String? language = await (getStringValuesSF("language"));

      var response = await apiHandler.getAPICall(
          endPointURL:
              "streams/${_educationBoard.toLowerCase()}/${language!.toLowerCase()}/${_classID!.substring(0, 2)}");

      if (response == null) return response;

      print(response);

      // List _streamMapList = (response as Map)["$_classID"];
      List<StreamsModel> _streamsList = [];
      /*await Future.forEach((response as Map).values, (classWiseStreams) async {*/
      await Future.forEach(response, (dynamic streams) async {
        StreamsModel _streamsModel = StreamsModel(
          boardName: _educationBoard,
          classID: _classID,
          streamID: streams['id'],
          streamName: streams['name'],
          icon: streams['icon'],
        );
        String _dataString =
            "INSERT Into $tableStreams (boardName, classID, streamID, streamName, icon)"
            " VALUES (?, ?, ?, ?, ?)";

        var rowID = await helper.rawInsertStreams(
          tableData: _dataString,
          streamsModel: _streamsModel,
        );
        _streamsList.add(_streamsModel);
        print(rowID.toString());
      }) /*;
      })*/
          .then((value) {
        return _streamsList;
      }).catchError((error) {
        print(error.toString());
      });

      // List<StreamsModel> _streamsList = List<StreamsModel>();
      // await Future.forEach(response as List, (streams) async {
      //   StreamsModel _streamsModel = StreamsModel(
      //       boardName: streams['boardName'],
      //       classID: streams['classID'],
      //       streamID: streams['streamID'],
      //       streamName: streams['streamName']);
      //   String _dataString =
      //       "INSERT Into $tableStreams (boardName, classID, streamID, streamName)"
      //       " VALUES (?, ?, ?, ?)";
      //
      //   var rowID = await helper.rawInsertStreams(
      //       tableData: _dataString, streamsModel: _streamsModel);
      //   _streamsList.add(_streamsModel);
      //   print(rowID.toString());
      // })/*;
      // })*/
      //     .then((value) {
      //   return _streamsList;
      // }).catchError((error) {
      //   print(error.toString());
      // });
      return _streamsList;
    } catch (e) {
      print(e.toString());
    }
  }
}
