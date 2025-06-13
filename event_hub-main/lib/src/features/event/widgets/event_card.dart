import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/extensions.dart';
import 'package:event_hub/src/configs/routes/navigation_services.dart';
import 'package:event_hub/src/features/event/view/event_detail_screen.dart';
import 'package:event_hub/src/configs/components/image_stack_widget.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final eventDate = event.startDate.toDateTime();
    const placeholderImage = 'assets/images/placeholder_event.png';

    return GestureDetector(
      onTap: () {
        NavigationService.push(EventDetailScreen(event: event));
      },
      child: Card(
        shadowColor: Colors.transparent,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child:
                  event.imageUrl == null
                      ? Image.asset(
                        placeholderImage,
                        height: 120.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 120.h,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          );
                        },
                      )
                      : Image.network(
                        event.imageUrl!,
                        height: 120.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (
                          BuildContext context,
                          Widget child,
                          ImageChunkEvent? loadingProgress,
                        ) {
                          if (loadingProgress == null) {
                            return child; // Return the image when it's fully loaded
                          } else {
                            // While the image is loading, show a gradient or a blurred effect
                            return Stack(
                              children: [
                                // Gradient Background as Placeholder
                                Container(
                                  height: 120.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.grey.shade200,
                                        Colors.grey.shade400,
                                      ],
                                    ),
                                  ),
                                ),
                                // Optional: You can also use a blurred image as the placeholder
                                // if you want a blurred effect while the image loads
                                Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                    strokeWidth: 3.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue,
                                    ), // Change color if you want
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // If the image fails to load, show a fallback UI with a stylish design
                          return Container(
                            height: 120.h,
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[600],
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
            ),

            // Positioned(
            //   top: 8.h,
            //   right: 8.w,
            //   child: Container(
            //     height: 30.h,
            //     width: 35.w,
            //     margin: EdgeInsets.all(4.w),
            //     padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
            //     decoration: BoxDecoration(
            //       color: Color(0xfffff7f2),
            //       borderRadius: BorderRadius.circular(8.r),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black12,
            //           blurRadius: 4,
            //           offset: Offset(0, 2),
            //         ),
            //       ],
            //     ),
            //     child: SvgPicture.asset('assets/svg/book_mark.svg'),
            //   ),
            // ),
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: Color(0xfffff7f2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    Text(
                      eventDate!.day.toString(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      eventDate.month
                          .toMonthName(abbreviated: true)
                          .toUpperCase(),
                      style: TextStyle(fontSize: 12.sp, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 120.h,
                left: 8.w,
                right: 8.w,
                bottom: 8.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title.length > 20
                        ? '${event.title.substring(0, 17)}...'
                        : event.title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  if (event.attendees.isNotEmpty)
                    Row(
                      children: [
                        SizedBox(
                          width: 60.w,
                          height: 24.h,
                          child: ImageStackWidget(),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                           ' ${event.attendees.length.toString()} Going',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      event.category.name,
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                    ),

                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          event.venue,
                          style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
