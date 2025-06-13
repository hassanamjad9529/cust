import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_hub/src/notification_services/firebase_notification_sender.dart';
import 'package:flutter/material.dart';

import '../../../model/app_user.dart';
import '../../../model/event.dart';

class AttendeeWithUser {
  final AppUser user;
  final Attendee attendee;

  AttendeeWithUser({required this.user, required this.attendee});
}

class AttendeesViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<AttendeeWithUser> _attendees = [];
  List<AttendeeWithUser> get attendees => _attendees;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchAttendees(String eventId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final eventDoc = await _db.collection('events').doc(eventId).get();
      if (!eventDoc.exists) throw 'Event not found';

      final attendeesList =
          (eventDoc['attendees'] as List)
              .map((a) => Attendee.fromMap(a))
              .where(
                (a) =>
                    a.status == AttendeeStatus.going ||
                    a.status == AttendeeStatus.isInWaitingList,
              )
              .toList();

      List<AttendeeWithUser> result = [];

      for (var attendee in attendeesList) {
        final userDoc = await _db.collection('users').doc(attendee.uid).get();
        if (userDoc.exists) {
          final user = AppUser.fromMap(userDoc.data()!, userDoc.id);
          result.add(AttendeeWithUser(user: user, attendee: attendee));
        }
      }

      _attendees = result;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsPaidAndConfirmSeat({
    required String eventId,
    required String userId,
  }) async {
    try {
      final eventRef = _db.collection('events').doc(eventId);
      final snapshot = await eventRef.get();

      final attendees = List<Map<String, dynamic>>.from(snapshot['attendees']);
      final index = attendees.indexWhere((a) => a['uid'] == userId);
      if (index != -1) {
        attendees[index]['hasPaid'] = true;
        attendees[index]['confirmedSeat'] = true;
        attendees[index]['isInWaitingList'] = false;
        attendees[index]['status'] = 'going';
        attendees[index]['confirmedSeat'] = true;

        await eventRef.update({'attendees': attendees});
        await fetchAttendees(eventId);

        // 🔥 Fetch the FCM token of the user from Firestore
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();
        final fcmToken = userDoc.data()?['fcmToken'];

        if (fcmToken != null && fcmToken is String) {
          await FirebaseNotificationSender.sendToToken(
            token: fcmToken,
            title: 'Seat Confirmed!',
            body:
                'You’ve successfully paid. Your seat has been confirmed for the event!',
          );
        }
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> cancelReservation({
    required String eventId,
    required String userId,
  }) async {
    try {
      final eventRef = _db.collection('events').doc(eventId);
      final snapshot = await eventRef.get();

      final attendees = List<Map<String, dynamic>>.from(snapshot['attendees']);

      // Find and remove the attendee
      attendees.removeWhere((a) => a['uid'] == userId);

      // Update the document with the new list
      await eventRef.update({'attendees': attendees});

      // Refresh the local state
      await fetchAttendees(eventId);
      // Notify user
      final userDoc = await _db.collection('users').doc(userId).get();
      final fcmToken = userDoc.data()?['fcmToken'];
      if (fcmToken != null) {
        await FirebaseNotificationSender.sendToToken(
          token: fcmToken,
          title: 'Reservation Cancelled',
          body: 'Your reservation for the event has been cancelled.',
        );
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> refundPayment({
    required String eventId,
    required String userId,
  }) async {
    try {
      final eventRef = _db.collection('events').doc(eventId);
      final snapshot = await eventRef.get();
      final attendees = List<Map<String, dynamic>>.from(snapshot['attendees']);

      final index = attendees.indexWhere((a) => a['uid'] == userId);
      if (index != -1) {
        attendees[index]['hasPaid'] = false;
        attendees[index]['confirmedSeat'] = false;
        await eventRef.update({'attendees': attendees});
        await fetchAttendees(eventId);
        // Notify user
        final userDoc = await _db.collection('users').doc(userId).get();
        final fcmToken = userDoc.data()?['fcmToken'];
        if (fcmToken != null) {
          await FirebaseNotificationSender.sendToToken(
            token: fcmToken,
            title: 'Refund Processed',
            body: 'Your payment for the event has been refunded.',
          );
        }
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<String?> getUserFcmToken({required String userId}) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists && doc.data()?['fcmToken'] != null) {
      return doc.data()!['fcmToken'];
    }
    return null;
  }

  Future<void> unconfirmSeat({
    required String eventId,
    required String userId,
  }) async {
    try {
      final eventRef = _db.collection('events').doc(eventId);
      final snapshot = await eventRef.get();

      final attendees = List<Map<String, dynamic>>.from(snapshot['attendees']);
      final index = attendees.indexWhere((a) => a['uid'] == userId);

      if (index != -1) {
        attendees[index]['confirmedSeat'] = false;
        attendees[index]['isInWaitingList'] = true;
        attendees[index]['hasPaid'] = false;
        attendees[index]['status'] = 'isInWaitingList';

        await eventRef.update({'attendees': attendees});
        await fetchAttendees(eventId);
        // Notify user
        final userDoc = await _db.collection('users').doc(userId).get();
        final fcmToken = userDoc.data()?['fcmToken'];
        if (fcmToken != null) {
          await FirebaseNotificationSender.sendToToken(
            token: fcmToken,
            title: 'Seat Unconfirmed',
            body:
                'Your seat for the event has been unconfirmed. You are now on the waiting list.',
          );
        }
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> sendInvite(
    BuildContext context,
    AttendeesViewModel vm,
    AttendeeWithUser item,
    String title,
    String eventId,
  ) async {
    final token = await vm.getUserFcmToken(userId: item.user.uid);

    if (token != null) {
      await FirebaseNotificationSender.sendToToken(
        token: token,
        title: 'You’re Invited!',
        body: 'A spot opened up for "$title". Join now!',
        data: {'eventId': eventId},
      );

      // 🔥 Update isInvited field in Firestore
      final eventRef = FirebaseFirestore.instance
          .collection('events')
          .doc(eventId);
      final snapshot = await eventRef.get();

      final attendees = List<Map<String, dynamic>>.from(snapshot['attendees']);
      final index = attendees.indexWhere((a) => a['uid'] == item.user.uid);
      if (index != -1) {
        attendees[index]['isInvited'] = true;
        await eventRef.update({'attendees': attendees});
        await vm.fetchAttendees(eventId);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invitation sent to ${item.user.name}')),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User is not available for notifications.')),
        );
      }
    }
  }
}
