import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/components/custom_lottie_animation.dart';
import 'package:event_hub/src/configs/extensions.dart';
import 'package:event_hub/src/configs/routes/navigation_services.dart';
import 'package:event_hub/src/data/response/status.dart';
import 'package:event_hub/src/features/event/view_model/event_view_model.dart';
import 'package:event_hub/src/features/event/widgets/event_card.dart';
import 'package:event_hub/src/features/student/view/all_upcoming_events.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ListOfEventsByEventCategory extends StatelessWidget {
  final EventCategory? categoryFilter;

  const ListOfEventsByEventCategory({super.key, this.categoryFilter});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.mediaQueryHeight / 2.8,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Events',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    NavigationService.push(AllUpcomingEvents());
                  },
                  child: Row(
                    children: [
                      Text('See All ', style: TextStyle(color: AppColors.grey)),
                      Icon(Icons.arrow_forward, color: AppColors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Consumer<EventViewModel>(
              builder: (context, eventVM, _) {
                final response = eventVM.eventsResponse;

                switch (response.status) {
                  case Status.loading:
                    return const Center(child: CircularProgressIndicator());

                  case Status.error:
                    return Center(child: Text("Error: ${response.message}"));

                  case Status.completed:
                    final now = DateTime.now();

                    final events =
                        (response.data ?? []).where((e) {
                          final end = DateTime.parse(e.endDate);

                          // Return true if the event is ongoing or upcoming
                          return now.isBefore(end) &&
                              e.status != EventStatus.cancelled;
                        }).toList();

                    final filteredEvents =
                        categoryFilter == null
                            ? events
                            : events
                                .where((e) => e.category == categoryFilter)
                                .toList();

                    if (filteredEvents.isEmpty) {
                      return CustomLottieAnimation();
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return SizedBox(
                          width:filteredEvents.length == 1? 359.w: 320.w,
                          child: EventCard(event: event),
                        );
                      },
                    );

                  case Status.notStarted:
                  default:
                    return const Center(child: Text("Initializing..."));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
