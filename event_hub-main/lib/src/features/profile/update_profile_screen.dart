import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/components/custom_text_filed.dart';
import 'package:event_hub/src/configs/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../configs/utils.dart';
import '../auth/view_model/auth_view_model.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _yearController;
  late final TextEditingController _rollNumberController;
  late final TextEditingController _departmentController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthViewModel>(context, listen: false).currentUser;

    _nameController = TextEditingController(text: user?.name ?? '');
    _yearController = TextEditingController(text: user?.studentYear ?? '');
    _rollNumberController = TextEditingController(text: user?.rollNumber ?? '');
    _departmentController = TextEditingController(
      text: user?.studentDepartment ?? '',
    );
  }

  void _submit(AuthViewModel authVM) async {
    if (!_formKey.currentState!.validate()) return;

    final error = await authVM.updateProfile(
      name: _nameController.text.trim(),
      studentYear: _yearController.text.trim(),
      rollNumber: _rollNumberController.text.trim(),
      studentDepartment: _departmentController.text.trim(),
    );

    if (error != null) {
      Utils.snackBar(error, context);
    } else {
      Utils.snackBar('Profile updated successfully!', context);
      Navigator.pop(context); // or push dashboard if you want
    }
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        final user = authVM.currentUser;
        return Scaffold(
          appBar: AppBar(title: const Text("Update Profile")),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  CustomTextFormField(
                    hintText: "Full Name",
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  ),

                  if (user?.role == 'student') ...[
                    SizedBox(height: 10.h),
                    CustomTextFormField(
                      hintText: "Year",
                      controller: _yearController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Year is required';
                        } else if (!RegExp(r'^\d{4}$').hasMatch(value.trim())) {
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
                    title: "Save Changes",
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
