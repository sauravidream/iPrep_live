import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'common/global_variables.dart';
import 'core/app.dart';
import 'core/config/app_environment.dart';
import 'core/config/config_reader.dart';
import 'firebase_options.dart';

Future<void> mainCommon(AppEnvironment env) async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigReader.initialize(env);
  ConfigReader.getBaseUrl();
  firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
