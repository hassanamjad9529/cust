import 'dart:io';

import 'package:event_hub/src/configs/routes/navigation_services.dart';
import 'package:event_hub/src/model/app_user.dart';
import 'package:event_hub/src/features/auth/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class AuthViewModel with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  /// Check if a user is already logged in
  Future<bool> isUserLoggedIn() async {
    final user = _auth.currentUser;
    return user != null;
  }

  /// Sign up and save user info to Firestore
  Future<String?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String role, // 'admin' or 'student'
    String? studentYear,
    String? rollNumber,
    String? studentDepartment,
  }) async {
    try {
      setLoading(true);
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = result.user!.uid;

      final user = AppUser(
        uid: uid,
        email: email,
        name: name,
        role: role,
        profileImageUrl: null,
        createdAt: Timestamp.now(),
        studentYear: studentYear,
        rollNumber: rollNumber,
        studentDepartment: studentDepartment,
      );

      await _firestore.collection('users').doc(uid).set(user.toMap());

      _currentUser = user;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      setLoading(false);

      return e.message;
    } catch (e) {
      setLoading(false);

      return 'Something went wrong';
    }
  }

  /// Log in with email and password
  Future<String?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      setLoading(true);

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await getCurrentUser().then((_) {
        currentUser?.role != 'admin' ? saveFcmTokenToFirestore() : null;
      });
      setLoading(false);

      return null;
    } on FirebaseAuthException catch (e) {
      setLoading(false);

      return e.message;
    } catch (e) {
      setLoading(false);
      return 'Login failed';
    }
  }

  /// Fetch current user profile from Firestore
  Future<void> getCurrentUser() async {
    setLoading(true);

    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists) {
        _currentUser = AppUser.fromMap(doc.data()!, doc.id);
        notifyListeners();
      }
    }
    setLoading(false);
  }

  Future<void> saveFcmTokenToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final fcmToken =
        Platform.isIOS ? 'null' : await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'fcmToken': fcmToken},
      );
    }
  }

  Future<void> removeFcmTokenFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'fcmToken': '',
    });
  }

  Future<String?> updateProfile({
    required String name,
    String? studentYear,
    String? rollNumber,
    String? studentDepartment,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return 'User not logged in';

      final userMap = {
        'name': name,
        'studentYear': studentYear,
        'rollNumber': rollNumber,
        'studentDepartment': studentDepartment,
      }..removeWhere((key, value) => value == null); // remove nulls

      await _firestore.collection('users').doc(uid).update(userMap);
      await getCurrentUser(); // refresh local user

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Logout
  Future<void> signOut() async {
    await removeFcmTokenFromFirestore().then((_) async {
      await _auth.signOut();
      _currentUser = null;
      NavigationService.pushAndRemoveAll(LoginScreen());
      notifyListeners();
    });
  }


}
