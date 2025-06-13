import 'package:event_hub/src/configs/extensions.dart';
import 'package:event_hub/src/configs/routes/navigation_services.dart';
import 'package:event_hub/src/data/response/status.dart';
import 'package:event_hub/src/features/event/view/event_detail_screen.dart';
import 'package:event_hub/src/features/event/view_model/event_view_model.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FeaturedEventCard extends StatelessWidget {
  const FeaturedEventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventViewModel>(
      builder: (context, eventVM, _) {
        final response = eventVM.eventsResponse;

        switch (response.status) {
          case Status.notStarted:
            return const Center(child: Text("Initializing..."));

          case Status.loading:
            return const Center(child: CircularProgressIndicator());

          case Status.error:
            return Center(child: Text("Error: ${response.message}"));

          case Status.completed:
            final events =
                (response.data ?? [])
                    .where((e) => e.status == EventStatus.ongoing)
                    .toList();

            final filteredEvents =
                events.where((e) => e.isFeatured == true).toList();

            if (filteredEvents.isEmpty) {
              return Center(
                child: Text(
                  "You're not registered for any upcoming events yet.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              );
            }

            // We'll display only the first event card here
            final event = filteredEvents.last;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Events',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                // Display a single event card with an image background
                GestureDetector(
                  onTap: () {
                    NavigationService.push(EventDetailScreen(event: event));
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(
                      horizontal: 12.sp,
                      vertical: 16.sp,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Container(
                      width: context.mediaQueryWidth/1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        image: DecorationImage(
                          image:
                              event.imageUrl != null &&
                                      event.imageUrl!.isNotEmpty
                                  ? NetworkImage(event.imageUrl!)
                                  : AssetImage('assets/placeholder.png')
                                      as ImageProvider,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(
                              0.8,
                            ), // Apply overlay to entire image
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.startTime,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            event.title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            event.description,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );

          default:
            return const Center(child: Text("Initializing..."));
        }
      },
    );
  }
}
