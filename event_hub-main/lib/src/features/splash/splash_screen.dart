import 'dart:io';

import 'package:event_hub/src/configs/extensions.dart';
import 'package:event_hub/src/configs/my_logger.dart';
import 'package:event_hub/src/configs/routes/navigation_services.dart';
import 'package:event_hub/src/features/admin/view/admin_dashboard.dart';
import 'package:event_hub/src/features/auth/view/login_screen.dart';
import 'package:event_hub/src/features/auth/view_model/auth_view_model.dart';
import 'package:event_hub/src/features/student/view/student_dashboard.dart';
import 'package:event_hub/src/notification_services/notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    NotificationServices.getDeviceToken().then((value) {
      MyLogger.info('::: device FCM token: $value');
    });

    notificationServices.firebaseInit(context);

    Future.delayed(const Duration(seconds: 2), () {
      _navigateUser();
    });
  }

  Future<void> _navigateUser() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    //  await authVM.signOut();
    final isLoggedIn = await authVM.isUserLoggedIn();

    if (isLoggedIn) {
      await authVM.getCurrentUser();
      final role = authVM.currentUser?.role;

      if (role == 'admin') {
        NavigationService.pushReplacement(AdminDashboard());
      } else {
        if (Platform.isAndroid) {
          await FirebaseMessaging.instance.subscribeToTopic('updates');
        }
        NavigationService.pushReplacement(StudentDashboard());
      }
    } else {
      NavigationService.pushReplacement(LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background SVG
          Positioned.fill(
            child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          ),

          // Foreground content
          Center(
            child: SvgPicture.asset(
              'assets/svg/splash.svg',
              fit: BoxFit.cover,
              width: context.mediaQueryWidth / 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
