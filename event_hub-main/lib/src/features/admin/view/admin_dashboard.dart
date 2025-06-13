import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/features/admin/view/admin_home.dart';
import 'package:event_hub/src/features/create_event/create_event_screen.dart';
import 'package:event_hub/src/features/events_in_calender/calender_view.dart';
import 'package:event_hub/src/features/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AdvancedDrawerController _drawerController = AdvancedDrawerController();

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AdminHome(),
    const CreateEventScreen(showAppbar: false),
    EventsCalendarScreen(),
  ];

  final List<String> _menuItems = [
    'Dashboard',
    'Create Event',
    'Calendar',
    'Logout',
  ];

  final List<IconData> _menuIcons = [
    Icons.dashboard,
    Icons.event,
    Icons.calendar_today,
    Icons.exit_to_app,
  ];

  void _handleMenuItemTap(int index) {
    if (index == 3) {
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
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              _drawerController.showDrawer();
            },
            icon: SvgPicture.asset('assets/svg/burger.svg'),
          ),
          title: Text(
            _selectedIndex == 1 ? 'Create Event' : 'Event Hub',
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: _screens[_selectedIndex],
      ),
    );
  }
}
