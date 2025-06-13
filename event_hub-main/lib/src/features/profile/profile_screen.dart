import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/components/round_button.dart';
import 'package:event_hub/src/features/profile/update_profile_screen.dart';
import 'package:event_hub/src/features/profile/update_email_screen.dart';
import 'package:event_hub/src/features/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final user = authVM.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body:
          user == null
              ? const Center(child: Text("No user data available."))
              : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Full Name: ${user.name}",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Email: ${user.email}",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    if (user.role == 'student') ...[
                      SizedBox(height: 8.h),
                      Text(
                        "Year: ${user.studentYear}",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Roll Number: ${user.rollNumber}",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Department: ${user.studentDepartment}",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ],
                    const Spacer(),
                    Center(
                      child: Column(
                        children: [
                          RoundButton(
                            title: "Edit Profile",
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const UpdateProfileScreen(),
                                ),
                              );
                            },
                            color: AppColors.primary,
                          ),
                          SizedBox(height: 12.h),
                          RoundButton(
                            title: "Edit Email",
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const UpdateEmailScreen(),
                                ),
                              );
                            },
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
