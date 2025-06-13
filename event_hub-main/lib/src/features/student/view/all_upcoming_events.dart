import 'package:event_hub/src/features/admin/widgets/list_of_events_by_event_status.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:flutter/material.dart';

class AllUpcomingEvents extends StatelessWidget {
  const AllUpcomingEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Upcoming Events')),
      body: ListOfEventsByEventStatus(statusFilter: EventStatus.ongoing),
    );
  }
}
