import 'package:dio/dio.dart';

class DioClient {
  final Dio dio = Dio();

  final liveBaseUrl = 'https://iprep-live.firebaseio.com/';
  final devBaseUrl = 'https://iprep-super-app.herokuapp.com/iprepapp/api/';

  Future getData(dynamic endPointURL) async {
    return await dio.get(liveBaseUrl + endPointURL);
  }

  Future get(dynamic endPointURL) async {
    final baseUrl = devBaseUrl;
    return await dio.get(baseUrl + endPointURL);
  }
}
