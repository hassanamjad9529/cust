import 'package:event_hub/src/configs/components/custom_lottie_animation.dart';
import 'package:event_hub/src/data/response/status.dart';
import 'package:event_hub/src/features/event/view_model/event_view_model.dart';
import 'package:event_hub/src/features/event/widgets/event_card.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ListOfEventsByEventStatus extends StatelessWidget {
  final EventStatus? statusFilter;

  const ListOfEventsByEventStatus({super.key, this.statusFilter});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventViewModel>(
      builder: (context, eventVM, _) {
        final response = eventVM.eventsResponse;

        switch (response.status) {
          case Status.loading:
            return const Center(child: CircularProgressIndicator());

          case Status.error:
            return Center(child: Text("Error: ${response.message}"));

          case Status.completed:
            final events = response.data ?? [];

            // final filteredEvents =
            //     statusFilter == null
            //         ? events
            //         : events.where((e) => e.status == statusFilter).toList();

            final now = DateTime.now();

            final filteredEvents =
                events.where((e) {
                  final end = DateTime.parse(e.endDate);

                  if (statusFilter == null) {
                    // ✅ All events
                    return true;
                  } else if (statusFilter == EventStatus.ongoing) {
                    // ✅ Ongoing: event hasn't ended yet
                    return now.isBefore(end);
                  } else if (statusFilter == EventStatus.completed) {
                    // ✅ Completed: event has ended
                    return now.isAfter(end) &&
                        e.status != EventStatus.cancelled;
                  } else if (statusFilter == EventStatus.cancelled) {
                    // ✅ Cancelled only
                    return e.status == EventStatus.cancelled;
                  }

                  return false;
                }).toList();

            if (filteredEvents.isEmpty) {
              // return const Center(child: Text("No events found."));
              return CustomLottieAnimation();
            }
            // ✅ Sort by createdAt descending (latest first)
            filteredEvents.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            return ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return EventCard(event: event);
              },
            );

          case Status.notStarted:
          default:
            return const Center(child: Text("Initializing..."));
        }
      },
    );
  }
}
