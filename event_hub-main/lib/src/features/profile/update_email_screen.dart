import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:event_hub/src/configs/components/custom_text_filed.dart';
import 'package:event_hub/src/configs/components/round_button.dart';
import 'package:event_hub/src/configs/color/color.dart';

class UpdateEmailScreen extends StatefulWidget {
  const UpdateEmailScreen({super.key});

  @override
  State<UpdateEmailScreen> createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen> {
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _updateEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Reauthenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: _currentEmailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await user?.reauthenticateWithCredential(credential);

      // Send verification email to the new email and update after confirmation
      await user?.verifyBeforeUpdateEmail(_newEmailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A verification link has been sent to your new email. Please verify to complete the update.',
          ),
        ),
      );
      _checkAndUpdateFirestoreEmail();
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkAndUpdateFirestoreEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Reload to get updated info

    if (user != null && user.emailVerified) {
      // Now update Firestore
      final newEmail = user.email;
      print(';;; $newEmail');
      await FirebaseFirestore.instance
          .collection('users') // adjust path if needed
          .doc(user.uid)
          .update({'email': newEmail});

      // Optionally notify the user or navigate
      print('Firestore email updated!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CustomTextFormField(
              controller: _currentEmailController,
              hintText: 'Current Email',
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: _newEmailController,
              hintText: 'New Email',
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: _passwordController,
              hintText: 'Password',
              isPassword: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            RoundButton(
              title: "Update Email",
              loading: _isLoading,
              onPress: _updateEmail,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
