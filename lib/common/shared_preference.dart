import 'package:shared_preferences/shared_preferences.dart';

addStringToSF(String name, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(name, value);
}

removeStringToSF(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(name);
}

Future<String?> getStringValuesSF(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stringValue = prefs.getString(name);
  return stringValue;
}
