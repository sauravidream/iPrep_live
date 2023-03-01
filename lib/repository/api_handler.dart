import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:idream/common/constants.dart';

class APIHandler {
  HttpClient client = HttpClient();

  static late String clientAuth;

  Future postAPICall({apiInputParameters, required endPointURL}) async {
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client
          .postUrl(Uri.parse("${Constants.apiUrl + endPointURL}.json"));
      // request.headers.set('Authorization', clientAuth);
      request.headers.set('content-type', 'application/json');
      request.headers.set('accept', 'application/json');

      if (apiInputParameters != null) {
        debugPrint(json.encode(apiInputParameters));
        request.add(utf8.encode(json.encode(apiInputParameters)));
      }
      HttpClientResponse response = await request.close();
      var reply = await response.transform(utf8.decoder).join();
      Map<String, dynamic>? map = json.decode(reply);
      return map;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future getAPICall({required endPointURL}) async {
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client
          .getUrl(Uri.parse("${Constants.apiUrl + endPointURL}.json"));

      // request.headers.set('Authorization', clientAuth);
      request.headers.set('content-type', 'application/json');
      request.headers.set('accept', 'application/json');
      HttpClientResponse response = await request.close();
      var reply = await response.transform(utf8.decoder).join();

      // Map<String, dynamic> map = json.decode(reply);
      // return map;

      return json.decode(reply);
      // return _list;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future getAPICallChangeWithBaseUrl(
      {endPointURL, baseURL, bool? jsonb}) async {
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request;
      if (jsonb == false) {
        request = await client.getUrl(Uri.parse(baseURL + endPointURL));
      } else {
        request =
            await client.getUrl(Uri.parse(baseURL + endPointURL + ".json"));
      }

      // request.headers.set('Authorization', clientAuth);
      request.headers.set('content-type', 'application/json');
      request.headers.set('accept', 'application/json');
      HttpClientResponse response = await request.close();
      var reply = await response.transform(utf8.decoder).join();

      // Map<String, dynamic> map = json.decode(reply);
      // return map;

      return json.decode(reply);
      // return _list;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future deleteAPICall(endPointURL, {apiInputParameters}) async {
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request =
          await client.deleteUrl(Uri.parse(Constants.apiUrl + endPointURL));

      request.headers.set('Authorization', clientAuth);
      request.headers.set('content-type', 'application/json');
      request.headers.set('accept', 'application/json');

      if (apiInputParameters != null) {
        request.add(utf8.encode(json.encode(apiInputParameters)));
      }
      HttpClientResponse response = await request.close();
      var reply = await response.transform(utf8.decoder).join();
      Map<String, dynamic>? map = json.decode(reply);
      return map;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future putAPICall({required endPointURL, apiInputParameters}) async {
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request =
          await client.putUrl(Uri.parse(Constants.apiUrl + endPointURL));

      request.headers.set('Authorization', clientAuth);
      request.headers.set('content-type', 'application/json');
      request.headers.set('accept', 'application/json');

      request.add(utf8.encode(json.encode(apiInputParameters)));
      debugPrint(json.encode(apiInputParameters));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      Map<String, dynamic>? map = json.decode(reply);
      return map;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
