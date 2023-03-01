import 'dart:convert';
import 'package:flutter/services.dart';
import 'app_environment.dart';

abstract class ConfigReader {
  static Map<String, dynamic> _config = <String, dynamic>{};

  static Future<void> initialize(AppEnvironment env) async {
    String configString;
    switch (env) {
      case AppEnvironment.DEBUG:
        configString = await rootBundle.loadString('config/debug.json');
        break;
      case AppEnvironment.PROFILE:
        configString = await rootBundle.loadString('config/profile.json');
        break;
      case AppEnvironment.RELEASE:
        configString = await rootBundle.loadString('config/release.json');
        break;
    }
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getBaseUrl() {
    return _config['baseUrl'] as String;
  }

  static int getCountryId() {
    return _config['countryId'] as int;
  }

  static String getAppVariant() {
    return _config['app_variant'] as String;
  }

  static String getCountryPartner() {
    return _config['countryPartner'] as String;
  }

  static String getMode() {
    return _config['mode'] as String;
  }
}
