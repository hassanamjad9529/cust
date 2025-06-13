import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String name;
  final String role; // 'admin' or 'student'
  final String? profileImageUrl;
  final Timestamp createdAt;

  // Student-specific
  final String? studentYear;
  final String? rollNumber;
  final String? studentDepartment;
  final String? fcm;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.profileImageUrl,
    required this.createdAt,
    this.studentYear,
    this.rollNumber,
    this.studentDepartment,
    this.fcm,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String documentId) {
    return AppUser(
      uid: documentId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'student',
      profileImageUrl: data['profileImageUrl'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
      studentYear: data['studentYear'],
      rollNumber: data['rollNumber'],
      studentDepartment: data['studentDepartment'],
      fcm: data['fcm'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
      'studentYear': studentYear,
      'rollNumber': rollNumber,
      'studentDepartment': studentDepartment,
      'fcm': fcm,
    };
  }
}
