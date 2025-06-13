import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/components/custom_text_filed.dart';
import 'package:event_hub/src/configs/components/round_button.dart';
import 'package:event_hub/src/configs/routes/navigation_services.dart';
import 'package:event_hub/src/configs/utils.dart';
import 'package:event_hub/src/features/admin/view/admin_dashboard.dart';
import 'package:event_hub/src/features/auth/view_model/auth_view_model.dart';
import 'package:event_hub/src/features/student/view/student_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _yearController = TextEditingController();
  final _rollNumberController = TextEditingController();
  final _departmentController = TextEditingController();

  String _selectedRole = 'student';

  void _submit(AuthViewModel authVM) async {
    if (!_formKey.currentState!.validate()) return;

    final error = await authVM.signUpWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      role: _selectedRole,
      studentYear:
          _selectedRole == 'student' ? _yearController.text.trim() : null,
      rollNumber:
          _selectedRole == 'student' ? _rollNumberController.text.trim() : null,
      studentDepartment:
          _selectedRole == 'student' ? _departmentController.text.trim() : null,
    );

    if (error != null) {
      Utils.snackBar(error, context);
    } else {
      authVM
          .loginWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          )
          .then((_) {
            if (authVM.currentUser?.role == 'admin') {
              NavigationService.pushReplacement(AdminDashboard());
            } else {
              NavigationService.pushReplacement(StudentDashboard());
            }
          })
          .catchError((error) {
            Utils.snackBar(error.toString(), context);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        return Scaffold(
          appBar: AppBar(title: const Text("Sign Up")),
          bottomSheet: Padding(
            padding: EdgeInsets.only(bottom: 38.sp),
            child: InkWell(
              onTap: () {
                NavigationService.pop();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? '),
                  Text('Sign In', style: TextStyle(color: AppColors.primary)),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(height: 10.h),
                  CustomTextFormField(
                    hintText: "Full Name",
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Full name is required';
                      } else if (RegExp(r'[0-9]').hasMatch(value)) {
                        return 'Name cannot contain numbers';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  CustomTextFormField(
                    hintText: "University Email",
                    controller: _emailController,
                  ),
                  SizedBox(height: 10.h),
                  CustomTextFormField(
                    hintText: "Password",
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  // SizedBox(height: 10.h),
                  // DropdownButtonFormField<String>(
                  //   value: _selectedRole,
                  //   decoration: const InputDecoration(
                  //     labelText: "Role",
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   items: const [
                  //     DropdownMenuItem(
                  //       value: "student",
                  //       child: Text("Student"),
                  //     ),
                  //     DropdownMenuItem(value: "admin", child: Text("Admin")),
                  //   ],
                  //   onChanged: (val) => setState(() => _selectedRole = val!),
                  // ),
                  if (_selectedRole == 'student') ...[
                    SizedBox(height: 10.h),
                    CustomTextFormField(
                      hintText: "Year",
                      controller: _yearController,
                      validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Year is required';
    } else if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
      return 'Only numeric values allowed';
    } else if (value.length != 4) {
      return 'Enter a valid 4-digit year';
    }
    return null;
  },
                    ),
                    SizedBox(height: 10.h),
                    CustomTextFormField(
                      hintText: "Roll Number",
                      controller: _rollNumberController,
                    ),
                    SizedBox(height: 10.h),
                    CustomTextFormField(
                      hintText: "Department",
                      controller: _departmentController,
                    ),
                  ],
                  SizedBox(height: 20.h),
                  RoundButton(
                    title: "Register",
                    loading: authVM.isLoading,
                    onPress: () => _submit(authVM),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
