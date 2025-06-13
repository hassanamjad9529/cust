import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_hub/src/features/search_events/event_filter_screen.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:flutter/material.dart';

class EventSearchViewModel with ChangeNotifier {
  final _db = FirebaseFirestore.instance;

  List<EventModel> _allEvents = [];
  List<EventModel> _filteredEvents = [];

  List<EventModel> get filteredEvents => _filteredEvents;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAllEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot =
          await _db.collection('events').orderBy('startDate').get();
      _allEvents =
          snapshot.docs
              .map((doc) => EventModel.fromMap(doc.data(), doc.id))
              .toList();
      _filteredEvents = _allEvents;
    } catch (e) {
      _allEvents = [];
      _filteredEvents = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
      _filteredEvents = _allEvents;
    } else {
      final q = query.toLowerCase();
      _filteredEvents =
          _allEvents.where((event) {
            return event.title.toLowerCase().contains(q) ||
                event.description.toLowerCase().contains(q);
          }).toList();
    }
    notifyListeners();
  }

  void applyFilters(EventFilter filter) {
    _filteredEvents =
        _allEvents.where((event) {
          final matchCategory =
              filter.category == null || event.category == filter.category;
          final matchType = filter.type == null || event.type == filter.type;
          final matchPaid =
              filter.isPaid == null || event.isPaid == filter.isPaid;
          final matchDate =
              filter.startDate == null ||
              DateTime.parse(event.startDate).isAfter(filter.startDate!);

          return matchCategory && matchType && matchPaid && matchDate;
        }).toList();

    notifyListeners();
  }
}
