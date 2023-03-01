import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idream/app_lifecycle/app_life_cycle.dart';
import 'package:idream/provider/bell_animation_provider.dart';
import 'package:idream/provider/chat_input.dart';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/provider/stem_video_provider.dart';
import 'package:idream/provider/student/coach/dashboard_coach_provider.dart';
import 'package:idream/provider/student/joined_batches_provider.dart';
import 'package:idream/provider/video_provider.dart';
import 'package:idream/ui/onboarding/splash_screen.dart';
import 'package:idream/ui/test_prep/test_prep_provider/test_proivider.dart';
import 'package:provider/provider.dart';

final routeObserver = RouteObserver();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        // set Status bar icons color in Android devices.
        statusBarBrightness: Brightness.dark,
        //set Status bar icon color in iOS.
      ),
    );
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => StemVideoProvider()),
          ChangeNotifierProvider(create: (context) => JoinedBatchesProvider()),
          ChangeNotifierProvider(create: (context) => DashboardCoachProvider()),
          ChangeNotifierProvider(create: (context) => ChatInput()),
          ChangeNotifierProvider(create: (context) => VideoProvider()),
          ChangeNotifierProvider(create: (context) => BellAnimationProvider()),
          ChangeNotifierProvider(create: (context) => NetworkProvider()),
          ChangeNotifierProvider(create: (context) => TestProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'iPrep App',
          navigatorObservers: [
            routeObserver,
          ],
          theme: ThemeData(
            dividerColor: Colors
                .transparent, // added this for removing separator line on how the app works
            fontFamily: GoogleFonts.inter().fontFamily,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
