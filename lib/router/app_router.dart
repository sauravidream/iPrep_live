import 'package:flutter/material.dart';
import '../ui/onboarding/login_options.dart';
import '../ui/onboarding/splash_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case SplashScreen.id:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case LoginOptions.id:
        return MaterialPageRoute(
          builder: (_) => const LoginOptions(),
        );
      // case OnBoardingPage.id:
      //   return MaterialPageRoute(
      //     builder: (_) => const OnBoardingPage(),
      //   );
      // case HomePage.id:
      //   return MaterialPageRoute(
      //     builder: (_) => const HomePage(),
      //   );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
