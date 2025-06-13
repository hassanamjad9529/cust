import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:event_hub/src/configs/components/custom_text_filed.dart';
import 'package:event_hub/src/configs/components/round_button.dart';
import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      Utils.snackBar('Password reset link sent to your email.', context);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Utils.snackBar(e.message ?? 'An error occurred', context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: _emailController,
                hintText: 'Enter your registered email',
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              RoundButton(
                title: "Send Reset Link",
                loading: _isLoading,
                onPress: _sendResetEmail,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
