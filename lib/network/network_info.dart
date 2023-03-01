import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity = Connectivity();

  @override
  Future<bool> get isConnected async {
    ConnectivityResult connectionResult =
        await connectivity.checkConnectivity();
    debugPrint(connectionResult.toString());
    if (connectionResult == ConnectivityResult.mobile ||
        connectionResult == ConnectivityResult.wifi) {
      return Future.value(true);
    }
    return Future.value(false);
  }
}
