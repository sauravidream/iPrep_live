import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:idream/provider/network_provider.dart';

class NetworkError extends StatefulWidget {
  const NetworkError({Key? key}) : super(key: key);

  @override
  State<NetworkError> createState() => _NetworkErrorState();
}

class _NetworkErrorState extends State<NetworkError> {
  late Connectivity connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
  }

  late NetworkProvider networkProvider;

//   final Stream<bool> _bids = (() {
//     late final StreamController<bool> controller;
//     controller = StreamController<bool>(
//       onListen: () async {
//         await Future<void>.delayed(const Duration(seconds: 1));
//         Connectivity().onConnectivityChanged.listen((event) {
//           if (event == ConnectivityResult.mobile ||
//               event == ConnectivityResult.wifi) {
//             controller.add(true);
//           } else {
//             controller.add(false);
//           }
//           debugPrint('Check 1 event$');
//         });
// debugPrint('Check 1');
//         await Future<void>.delayed(const Duration(seconds: 1));
//
//       },
//     );
//     return controller.stream;
//   })();

  @override
  Widget build(BuildContext context) {
    networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossA,
        children: [
          getText1(),
          const SizedBox(height: 18),
          getText2(),
          getImage1(),
          const SizedBox(height: 38),
          getText3(),
          getRetryButton(),
        ],
      ),
    );
  }

  Widget getRetryButton() {
    return IconButton(
        onPressed: () {
          networkProvider.checkInterNetStatus();


        },
        icon: const Icon(Icons.wifi_protected_setup));
  }

  Widget getImage1() {
    return Image.asset('assets/images/internet_error.png');
  }

  Widget getText3() {
    return const Text(
      'Please check you internet connected\n setting and try again.',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w400, fontFamily: 'inter'),
    );
  }

  Widget getText2() {
    return const Text(
      'It seems like you are not connected\n to internet',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        fontFamily: 'inter',
      ),
    );
  }

  Widget getText1() {
    return const Text(
      'Oops!',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        fontFamily: 'inter',
      ),
    );
  }
}
