import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/components/custom_text_filed.dart';
import 'package:event_hub/src/configs/components/round_button.dart';
import 'package:event_hub/src/configs/routes/navigation_services.dart';
import 'package:event_hub/src/configs/utils.dart';
import 'package:event_hub/src/features/admin/view/admin_dashboard.dart';
import 'package:event_hub/src/features/auth/view/registration_screen.dart';
import 'package:event_hub/src/features/forget_password/forgot_password_screen.dart';
import 'package:event_hub/src/features/student/view/student_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:event_hub/src/features/auth/view_model/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit(AuthViewModel authVM) async {
    if (!_formKey.currentState!.validate()) return;

    final error = await authVM.loginWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (error != null) {
      print('$error');
      Utils.snackBar(error, context);
    } else {
      if (authVM.currentUser?.role == 'admin') {
        NavigationService.pushReplacement(AdminDashboard());
      } else {
        NavigationService.pushReplacement(StudentDashboard());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(title: const SizedBox()),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(height: 12.h),

                  Column(
                    children: [
                      SvgPicture.asset('assets/svg/e.svg'),
                      SizedBox(height: 12.h),
                      Text(
                        'Event Hub',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomTextFormField(
                    showTitle: false,
                    hintText: "Email",
                    controller: _emailController,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextFormField(
                    showTitle: false,
                    hintText: "Password",
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () {
                      NavigationService.push(ForgotPasswordScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text('Forgot Password?')],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  RoundButton(
                    title: "Login",
                    loading: authVM.isLoading,
                    onPress: () => _submit(authVM),
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          bottomSheet: Padding(
            padding: EdgeInsets.only(bottom: 38.sp),
            child: InkWell(
              onTap: () {
                NavigationService.push(RegistrationScreen());
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account? '),
                  Text('Sign up', style: TextStyle(color: AppColors.primary)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
