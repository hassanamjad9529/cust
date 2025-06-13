import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_hub/src/data/response/api_response.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:event_hub/src/notification_services/firebase_notification_sender.dart';
import 'package:flutter/material.dart';

class EventViewModel with ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final List<EventModel> _events = [];
  List<EventModel> get events => _events;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Create a new event
  Future<String?> createEvent(EventModel event) async {
    try {
      setLoading(true);
      final ref = _db.collection('events').doc(); // auto-generate ID
      final newEvent = event.copyWith(id: ref.id);
      await ref.set(newEvent.toMap());
      _events.add(newEvent);

      // Compose dynamic notification content
      final formattedDate = "${event.startDate} at ${event.startTime}";

      final notificationTitle =
          "New ${event.category.name} ${event.type.name}!";
      final notificationBody =
          "${event.title} is happening on $formattedDate at ${event.venue}. Tap to know more!";

      // Send notification
      await FirebaseNotificationSender.sendToTopic(
        topic: 'updates',
        title: notificationTitle,
        body: notificationBody,
      );

      setLoading(false);
      return null;
    } catch (e) {
      setLoading(false);
      return 'Failed to create event';
    }
  }

  /// Update an event
  Future<String?> updateEvent(EventModel event) async {
    try {
      setLoading(true);
      await _db.collection('events').doc(event.id).update(event.toMap());
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) _events[index] = event;
      setLoading(false);
      // Compose update notification
      final formattedDate = "${event.startDate} at ${event.startTime}";
      final notificationTitle = "Updated: ${event.title}";
      final notificationBody =
          "${event.title} has been updated. Check out the latest details for the event on $formattedDate at ${event.venue}.";

      // Send notification
      await FirebaseNotificationSender.sendToTopic(
        topic: 'updates',
        title: notificationTitle,
        body: notificationBody,
      );

      return null;
    } catch (e) {
      setLoading(false);
      return 'Failed to update event';
    }
  }

  /// Delete an event
  Future<String?> deleteEvent(String eventId) async {
    try {
      setLoading(true);
      await _db.collection('events').doc(eventId).delete();
      _events.removeWhere((e) => e.id == eventId);
      fetchAllEvents(); // Refresh the list
      setLoading(false);
      return null;
    } catch (e) {
      setLoading(false);
      return 'Failed to delete event';
    }
  }

  /// Cancel an event
  Future<String?> cancelEvent(
    String eventId,
    String title,
    String venue,
    String startDate,
    String startTime,
  ) async {
    try {
      setLoading(true);
      await _db.collection('events').doc(eventId).update({
        'status': 'cancelled',
      });

      // Optionally update local cache if you're maintaining it
      final index = _events.indexWhere((e) => e.id == eventId);
      if (index != -1) {
        _events[index].status = EventStatus.cancelled;
      }
      fetchAllEvents(); // Refresh the list
      setLoading(false);

      // Compose cancellation notification
      final formattedDate = "$startDate at $startTime";
      final notificationTitle = "Event Cancelled: $title";
      final notificationBody =
          "The event \"$title\" scheduled on $formattedDate at $venue has been cancelled.";

      // Send notification to subscribers
      await FirebaseNotificationSender.sendToTopic(
        topic: 'updates',
        title: notificationTitle,
        body: notificationBody,
      );

      return null;
    } catch (e) {
      setLoading(false);
      return 'Failed to cancel event';
    }
  }

  /// Fetch all events
  ApiResponse<List<EventModel>> _eventsResponse = ApiResponse.notStarted();
  ApiResponse<List<EventModel>> get eventsResponse => _eventsResponse;

  Future<void> fetchAllEvents() async {
    if (eventsResponse.data == null) {
      _eventsResponse = ApiResponse.loading();
    }
    notifyListeners();

    try {
      final snapshot =
          await _db.collection('events').orderBy('startDate').get();
      final events =
          snapshot.docs
              .map((doc) => EventModel.fromMap(doc.data(), doc.id))
              .toList();
      _eventsResponse = ApiResponse.completed(events);
      notifyListeners();
    } catch (e) {
      _eventsResponse = ApiResponse.error("Failed to load events");
      notifyListeners();
    }
  }

  // Store the current event here
  EventModel? _currentEvent;
  EventModel? get currentEvent => _currentEvent;

  /// Fetch a single event by its ID
  Future<String?> fetchEventById(String eventId) async {
    print('object');
    try {
      setLoading(true);

      // Get event from Firestore by ID
      final docSnapshot = await _db.collection('events').doc(eventId).get();

      if (docSnapshot.exists) {
        // Map the Firestore document to an EventModel object
        final event = EventModel.fromMap(docSnapshot.data()!, docSnapshot.id);

        // Store the event in _currentEvent
        _currentEvent = event;

        setLoading(false);
        notifyListeners();
        return null; // No error
      } else {
        setLoading(false);
        notifyListeners();
        return 'Event not found'; // Event doesn't exist
      }
    } catch (e) {
      setLoading(false);
      notifyListeners();
      print("Error fetching event: $e");
      return 'Failed to fetch event';
    }
  }

  EventModel? getEventById(String id) {
    return _currentEvent;
  }

  /// Register a user to an event
  Future<String?> registerUserToEvent({
    required EventModel event,
    required String userId,
  }) async {
    try {
      setLoading(true);

      final DateTime now = DateTime.now();
      final DateTime eventStartDate = DateTime.parse(event.startDate);
      final TimeOfDay eventStartTime = _parseTimeOfDay(event.startTime);

      if (eventStartDate.isBefore(DateTime(now.year, now.month, now.day))) {
        setLoading(false);
        return 'Event has already started.';
      }
      if (eventStartDate.isAtSameMomentAs(
        DateTime(now.year, now.month, now.day),
      )) {
        if (_isTimeBeforeNow(eventStartTime)) {
          setLoading(false);
          return 'Event has already started today.';
        }
      }
      if (event.status != EventStatus.ongoing) {
        setLoading(false);
        return 'Event is not ongoing.';
      }
      if (event.registrationDeadline != null &&
          event.registrationDeadline!.toDate().isBefore(now)) {
        setLoading(false);
        return 'Registration deadline passed.';
      }

      // 2. Check if already registered
      final bool alreadyRegistered = event.attendees.any(
        (attendee) => attendee.uid == userId,
      );
      if (alreadyRegistered) {
        setLoading(false);
        return 'Already registered.';
      }
      // 3. Determine if user should be waitlisted
      // final bool shouldWaitlist =
      //     !event.isUnlimitedCapacity &&
      //     (event.capacity == null ||
      //         event.attendees.where((a) => !a.isInWaitingList).length >=
      //             event.capacity!);

      // 4. Prepare new attendee
      final Attendee attendee = Attendee(
        uid: userId,
        status: AttendeeStatus.isInWaitingList,
        hasPaid: false,
        confirmedSeat: false,
        registeredAt: Timestamp.now(),
        // isInWaitingList: shouldWaitlist,
        isInvited: false,
      );

      // 5. Update Firestore
      await _db.collection('events').doc(event.id).update({
        'attendees': FieldValue.arrayUnion([attendee.toMap()]),
      });

      // 6. Update local list too
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        final updatedAttendees = List<Attendee>.from(_events[index].attendees)
          ..add(attendee);
        _events[index] = _events[index].copyWith(attendees: updatedAttendees);
      }

      setLoading(false);
      return null;
    } catch (e) {
      setLoading(false);
      print('${e}');
      return 'Failed to register for event.';
    }
  }
}

TimeOfDay _parseTimeOfDay(String timeStr) {
  // Clean weird spaces
  timeStr = timeStr.replaceAll('\u00A0', ' ').trim();

  final parts = timeStr.split(' '); // [12:23, AM] or [7:15, PM]
  final timePart = parts[0]; // '12:23'
  final period =
      parts.length > 1 ? parts[1].toUpperCase() : 'AM'; // 'AM' or 'PM'

  final timeParts = timePart.split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);

  if (period == 'PM' && hour < 12) {
    hour += 12;
  } else if (period == 'AM' && hour == 12) {
    hour = 0;
  }

  return TimeOfDay(hour: hour, minute: minute);
}

/// Helper to check if a given time is before now (today)
bool _isTimeBeforeNow(TimeOfDay timeOfDay) {
  final now = TimeOfDay.now();
  if (timeOfDay.hour < now.hour) return true;
  if (timeOfDay.hour == now.hour && timeOfDay.minute < now.minute) return true;
  return false;
}
