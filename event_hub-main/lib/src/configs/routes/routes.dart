import 'package:event_hub/src/configs/routes/slide_transition_page.dart';
import 'package:event_hub/src/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return SlideTransitionPage(page: SplashScreen());

      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(child: Text('No route defined')),
            );
          },
        );
    }
  }
}
