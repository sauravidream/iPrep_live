import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:idream/ui/network_error_page.dart';
import 'package:idream/ui/onboarding/login_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/custom_widgets/custom_pop_up.dart';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/ui/teacher/dashboard_coach.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const id = 'splash_page';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late NetworkProvider networkProvider;
  late LocationPermission permission;

  @override
  void initState() {
    super.initState();

    startTime(context);

    locationPermission().then((value) {});
  }

  Future locationPermission() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
  }

  startTime(context) async {
    Constants.rateMyApp.init();
    var _duration = const Duration(seconds: 3);

    return Timer(_duration, navigationPage);
    // return navigationPage;
  }

  Future navigationPage() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        await userActiveStatus(context);

        return null;
      }

      print(e.code);
    }

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        debugPrint('User is currently signed out!');

        await Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => const LoginOptions(),
          ),
        );
      } else {
        debugPrint('User is signed in!');
        networkProvider.checkInterNetStatus();

        String? onBoarding = await getStringValuesSF("onBoarding");

        try {
          if (onBoarding != null) {
            await userRepository.initializeUserObjectFromLocallySavedInfo();
            String userType = await getStringValuesSF("UserType") ?? "Student";
            await userRepository.checkAndUpdateFCMTokenForCurrentUser();

            var validUser = await userRepository.checkIfUserIdLoggedIn();
            if (validUser == null || !validUser) {
              if (!mounted) return;
              await userRepository.removeSavedInstances(context);
              if (!mounted) return;
              var response1 = await logOutPopUp(context);
              debugPrint(response1.toString());

              if (!mounted) return;
              await Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => const LoginOptions(),
                ),
              );
            } else {
              if (userType == "Coach") {
                if (!mounted) return;
                await Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const DashboardCoach(),
                  ),
                );
              } else {
                if (!mounted) return;
                await Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              }
            }
          } else {
            if (!mounted) return;
            await Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => const LoginOptions(),
              ),
            );
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    networkProvider = Provider.of<NetworkProvider>(context, listen: false);

    return Consumer<NetworkProvider>(
      builder: (_, interNetProvider, __) => interNetProvider.isAvailable == true
          ? Container(
              color: Colors.white,
              child: SafeArea(
                bottom: false,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Image.asset(
                      "assets/images/splash_logo.png",
                      height: MediaQuery.of(context).size.height * 155 / 640,
                      width: MediaQuery.of(context).size.width * 72 / 360,
                    ),
                  ),
                ),
              ),
            )
          : const NetworkError(),
    );
  }
}
