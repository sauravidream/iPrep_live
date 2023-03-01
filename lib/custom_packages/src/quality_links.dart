import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "dart:collection";

class QualityLinks {
  String? videoId;

  QualityLinks(this.videoId);

  getQualitiesSync() {
    return getQualitiesAsync();
  }

  // Future<SplayTreeMap?> getQualitiesAsync() async {
  //   try {
  //     var response = await http
  //         .get(Uri.parse('https://player.vimeo.com/video/$videoId/config'));
  //     var jsonData =
  //         jsonDecode(response.body)['request']['files']['progressive'];
  //     SplayTreeMap videoList = SplayTreeMap.fromIterable(
  //       jsonData,
  //       key: (item) => "${item['quality']} ${item['fps']}",
  //       value: (item) => item['url'],
  //     );
  //
  //     return videoList;
  //   } catch (error) {
  //     debugPrint('=====> REQUEST ERROR: $error');
  //     return null;
  //   }
  // }
  Future<SplayTreeMap?> getQualitiesAsync() async {
    try {
      var response = await Dio().get(
        'https://api.vimeo.com/videos/$videoId/',
        options: Options(
          headers: {
            "Authorization": "Bearer c031492656c179bb54d1fa6f063a56e9",
          },
        ),
      );
      SplayTreeMap videoList = SplayTreeMap.fromIterable(
        response.data['files'],
        key: (item) => "${item['public_name']}",
        value: (item) => item['link'],
      );

      return videoList;
    } catch (error) {
      debugPrint('=====> REQUEST ERROR: $error');
      return null;
    }
  }
}

class VideoRepository {
  Future<SplayTreeMap?> getQualitiesAsync(videoId) async {
    try {
      var response = await http
          .get(Uri.parse('https://player.vimeo.com/video/$videoId/config'));
      var jsonData =
          jsonDecode(response.body)['request']['files']['progressive'];
      SplayTreeMap videoList = SplayTreeMap.fromIterable(
        jsonData,
        key: (item) => "${item['quality']} ${item['fps']}",
        value: (item) => item['url'],
      );

      return videoList;
    } catch (error) {
      debugPrint('=====> REQUEST ERROR: $error');
      return null;
    }
  }
}
