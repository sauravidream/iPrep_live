import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:idream/ui/network_error_page.dart';

class NetworkProvider extends ChangeNotifier {
  final Connectivity connectivity = Connectivity();
  late StreamSubscription streamSubscription;

  bool isAvailable = true;

  checkInterNetStatus() {
    streamSubscription = connectivity.onConnectivityChanged.listen((event) {
      debugPrint('statue of internet $event');
      if (event == ConnectivityResult.none) {
        debugPrint('statue of internet -- $event');
        isAvailable = false;
        notifyListeners();
      } else {
        debugPrint('statue of internet !- $event');
        isAvailable = true;
        notifyListeners();
      }
    });
    notifyListeners();
  }
}
