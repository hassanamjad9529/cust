import 'package:event_hub/src/configs/routes/navigation_services.dart';
import 'package:event_hub/src/features/auth/view_model/auth_view_model.dart';
import 'package:event_hub/src/features/events_in_calender/calender_view.dart';
import 'package:event_hub/src/features/profile/profile_screen.dart';

import 'package:event_hub/src/features/student/view/events_tabbar.dart';
import 'package:event_hub/src/features/student/view/student_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:event_hub/src/configs/color/color.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final AdvancedDrawerController _drawerController = AdvancedDrawerController();

  int _selectedIndex = 0;

  // Dummy Screens for the tabs
  final List<Widget> _screens = [
    StudentHome(),
    EventsTabbar(),
    EventsCalendarScreen(),
  ];

  final List<String> _menuItems = [
    'Explore',
    'Events',
    'Calendar',
    'Profile',
    'Contact Us',
    'Logout',
  ];

  final List<IconData> _menuIcons = [
    Icons.dashboard,
    Icons.event,
    Icons.calendar_today,
    Icons.person,
    Icons.contact_mail,
    Icons.exit_to_app,
  ];

  void _handleMenuItemTap(int index) {
    if (index == 3) {
      // Profile - navigate separately

      Future.delayed(const Duration(milliseconds: 300), () {
        NavigationService.push(ProfileScreen());

        _drawerController.hideDrawer();
      });
    } else if (index == 4) {
      _launchEmail();
    } else if (index == 5) {
      // Handle logout separately
      // For example, you can show a confirmation dialog or navigate to login screen
      _showLogoutDialog();
    } else {
      // Change after drawer is fully hidden
      _selectedIndex = index;
      if (mounted) setState(() {});

      Future.delayed(const Duration(milliseconds: 10), () {
        _drawerController.hideDrawer();
      });
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'cs.aust.events@gmail.com',
      query: Uri.encodeFull('subject=Event Hub Inquiry&body=Hi Team,'),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // You can show a snackbar or alert
      debugPrint('Could not launch email client');
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.white,
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<AuthViewModel>().signOut();
                },
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: AppColors.white,
      controller: _drawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      openScale: 0.85,
      openRatio: 0.6,
      childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(60.r)),
      drawer: SafeArea(
        child: Column(
          children: [
            Container(
              width: 128.0.h,
              height: 128.0.h,
              margin: const EdgeInsets.only(top: 24.0, bottom: 64.0),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: SvgPicture.asset('assets/svg/splash.svg'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_menuItems.length, (index) {
                  return ListTile(
                    onTap: () => _handleMenuItemTap(index),
                    leading: Icon(
                      _menuIcons[index],
                      color:
                          _selectedIndex == index ? Colors.black : Colors.grey,
                    ),
                    title: Text(
                      _menuItems[index],
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight:
                            _selectedIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const Spacer(),
            DefaultTextStyle(
              style: TextStyle(fontSize: 10.sp, color: Colors.black),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.sp),
                child: Column(
                  children: [
                    Text('© Department of CS, AUST'),
                    SizedBox(height: 4),
                    Text('Developed by M. Mustafa & Talha Ahmed'),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              _selectedIndex == 1 ? AppColors.whiteSccafold : AppColors.primary,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              _drawerController.showDrawer();
            },
            icon: SvgPicture.asset(
              'assets/svg/burger.svg',
              color: _selectedIndex == 1 ? AppColors.primary : AppColors.white,
            ),
          ),
          title: Text(
            _selectedIndex == 1 ? 'Events' : 'Event Hub',
            style: TextStyle(
              color:
                  _selectedIndex == 1
                      ? AppColors.primary
                      : AppColors.whiteSccafold,
            ),
          ),
          centerTitle: true,
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.black,
          unselectedItemColor: AppColors.grey,
          selectedFontSize: 14.sp,
          unselectedFontSize: 12.sp,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Explore',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
          ],
        ),
      ),
    );
  }
}
