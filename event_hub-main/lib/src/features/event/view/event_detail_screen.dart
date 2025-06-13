import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/components/round_button.dart';
import 'package:event_hub/src/configs/extensions.dart';
import 'package:event_hub/src/configs/routes/navigation_services.dart';
import 'package:event_hub/src/configs/utils.dart';
import 'package:event_hub/src/features/attendees/view/user_attending_event.dart';
import 'package:event_hub/src/features/attendees/view_model/attendees_view_model.dart';
import 'package:event_hub/src/features/create_event/create_event_screen.dart';
import 'package:event_hub/src/features/admin/widgets/date_range_with_days_widget.dart';
import 'package:event_hub/src/configs/components/image_stack_widget.dart';
import 'package:event_hub/src/features/auth/view_model/auth_view_model.dart';
import 'package:event_hub/src/features/event/view_model/event_view_model.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel? event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<AuthViewModel>(context, listen: false).currentUser;

    final currentUserId = currentUser?.uid;
    final eventVM = Provider.of<EventViewModel>(context, listen: false);
    Future.microtask(() {
      eventVM.fetchEventById(event?.id ?? '');
    });
    return Scaffold(
      backgroundColor: AppColors.white,

      bottomSheet: Padding(
        padding: EdgeInsets.only(bottom: 26.sp),
        child: Consumer<EventViewModel>(
          builder: (context, eventViewModel, child) {
            EventModel? updatedEvent = eventViewModel.getEventById(event!.id);

            var currentUserAttendee = updatedEvent?.attendees.firstWhere(
              (attendee) => attendee.uid == currentUserId,
              orElse:
                  () => Attendee(
                    uid: '',
                    status: AttendeeStatus.notDecided,
                    hasPaid: false,
                    confirmedSeat: false,
                    registeredAt: Timestamp.now(),
                    // isInWaitingList: false,
                    isInvited: false,
                  ),
            );

            String _getButtonText() {
              if (currentUserId == updatedEvent?.createdBy) {
                return 'Edit';
              } else {
                switch (currentUserAttendee?.status) {
                  case AttendeeStatus.notDecided:
                    return 'Register Now';
                  case AttendeeStatus.isInWaitingList:
                    return 'In Waiting List';
                  case AttendeeStatus.going:
                    bool isPaidEvent = (updatedEvent?.price ?? 0) > 0;
                    if (isPaidEvent) {
                      if (currentUserAttendee?.hasPaid == true) {
                        return 'Paid';
                      } else {
                        return 'Payment Pending';
                      }
                    } else {
                      return 'Seat Confrimed'; // free event, no payment needed
                    }
                  case AttendeeStatus.notGoing:
                    return 'Not Going';

                  default:
                    return 'Join';
                }
              }
            }

            String buttonText = _getButtonText();

            return RoundButton(
              loading: eventViewModel.isLoading,
              title: buttonText,
              onPress: () async {
                if (currentUser == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Please login first')));
                  return;
                }
                if (buttonText == 'In Waiting List') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('You Are on the Waiting List'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'You have been added to the waiting list. '
                                'We will notify you if a spot becomes available.',
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                var currentUserUid =
                                    FirebaseAuth.instance.currentUser?.uid;
                                Provider.of<AttendeesViewModel>(
                                      context,
                                      listen: false,
                                    )
                                    .cancelReservation(
                                      eventId: event?.id ?? '',
                                      userId: currentUserUid ?? '˝',
                                    )
                                    .then((_) {
                                      eventVM
                                          .fetchEventById(event?.id ?? '')
                                          .then((_) {
                                            Navigator.pop(context);
                                          });
                                    });
                              },
                              child: Text('Cancel my reservation'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                  );
                }

                if (buttonText == 'Seat Confrimed') {
                  final isPaidEvent = event?.isPaid ?? false;

                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text(
                            isPaidEvent ? 'Remove from Event?' : 'Leave Event?',
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isPaidEvent
                                    ? 'This is a paid event.\n\nBefore removing yourself, please make sure to contact the admin for a refund. '
                                        'Once you remove your seat, there will be no way to claim a refund later.'
                                    : 'You will be removed from the event. If you decide to join later, you’ll have to register again and may be placed on the waiting list.',
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final currentUserUid =
                                    FirebaseAuth.instance.currentUser?.uid;
                                if (currentUserUid != null) {
                                  final vm = Provider.of<AttendeesViewModel>(
                                    context,
                                    listen: false,
                                  );

                                  // Only unconfirm if user accepts
                                  await vm.cancelReservation(
                                    eventId: event?.id ?? '',
                                    userId: currentUserUid,
                                  );

                                  await eventVM.fetchEventById(event?.id ?? '');
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Remove Me'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                          ],
                        ),
                  );
                }

                if (buttonText == 'Join' || buttonText == 'Payment Pending') {
                  if (buttonText == 'Join' || buttonText == 'Payment Pending') {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text('Pay to Organizer'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Please pay manually to the organizer at the venue.',
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  var currentUserUid =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  Provider.of<AttendeesViewModel>(
                                        context,
                                        listen: false,
                                      )
                                      .cancelReservation(
                                        eventId: event?.id ?? '',
                                        userId: currentUserUid ?? '˝',
                                      )
                                      .then((_) {
                                        eventVM
                                            .fetchEventById(event?.id ?? '')
                                            .then((_) {
                                              Navigator.pop(context);
                                            });
                                      });
                                },
                                child: Text('Cancel my reservation'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Close'),
                              ),
                            ],
                          ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to load organizer details'),
                      ),
                    );
                  }
                } else if (buttonText == 'Seat Confrimed' ||
                    buttonText == 'Not Going' ||
                    buttonText == 'Interested' ||
                    buttonText == 'Paid') {
                  // Maybe allow updating status if needed
                } else if (buttonText == 'Register Now') {
                  final result = await eventViewModel.registerUserToEvent(
                    event: updatedEvent!,
                    userId: currentUser.uid,
                  );

                  if (result == null) {
                    // Fetch updated event to check if the user is on waiting list
                    await eventViewModel.fetchEventById(event?.id ?? '');
                    final updatedEvent = eventViewModel.currentEvent;

                    // final isWaitlisted =
                    //     updatedEvent?.attendees.any(
                    //       (attendee) =>
                    //           attendee.uid == currentUser.uid
                    //           //  && attendee.isInWaitingList,
                    //     ) ??
                    //     false;

                    final message =
                        // isWaitlisted
                        // ? 'You’ve been added to the waiting list.'
                        // :
                        'Successfully registered for the event!';

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(message)));

                    await eventViewModel.fetchEventById(updatedEvent?.id ?? '');
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(result)));
                  }
                } else if (buttonText == 'Edit') {
                  NavigationService.push(
                    CreateEventScreen(event: updatedEvent),
                  );
                }
              },
            );
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Stack(
          children: [
            // body
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // event image
                    if (event?.imageUrl != null) ...[
                      Image.network(
                        event!.imageUrl.toString(),
                        height: 200.h,
                        width: context.mediaQueryWidth,
                        fit: BoxFit.fitWidth,
                      ),
                    ] else ...[
                      Image.asset(
                        'assets/images/placeholder_event.png',
                        height: 200.h,
                        width: context.mediaQueryWidth,
                        fit: BoxFit.fitWidth,
                      ),
                    ],

                    SizedBox(height: 40.h),

                    // title
                    Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: context.mediaQueryWidth / 1.2,
                                child: Text(
                                  event?.title.capitalizeFirstLetter() ?? '',

                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 30.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/calender.svg',
                            height: 40.h,
                            width: 40.h,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: DateRangeWithDaysWidget(
                              startDate: event?.startDate,
                              endDate: event?.endDate,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 38.h,
                            width: 43.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.primaryLight,
                            ),
                            child: Icon(Icons.watch, color: AppColors.primary),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              _formatTimeRange(
                                event?.startTime,
                                event?.endTime,
                              ),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Text(
                        'About Event',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Text(
                        event?.description ?? "",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),

                    // Inside the Column, after the "About Event" section
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Text(
                        'Event Details',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event Type and Category
                          Row(
                            children: [
                              Icon(
                                Icons.event,
                                size: 20.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Type: ${event?.type.toString().split('.').last}',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                'Category: ${event?.category.toString().split('.').last}',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          // Location and Venue
                          Row(
                            children: [
                              Icon(
                                Icons.place,
                                size: 20.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'Venue: ${event?.venue ?? 'Not specified'}',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          // Price
                          Row(
                            children: [
                              Icon(
                                Icons.attach_money,
                                size: 20.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                event?.isPaid == true
                                    ? 'Price: ${event?.price.toStringAsFixed(2)}'
                                    : 'Free Event',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          // Registration Deadline
                          if (event?.registrationDeadline != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  size: 20.sp,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Registration Deadline: ${_formatTimestamp(event!.registrationDeadline!)}',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
                            ),
                          SizedBox(height: 8.h),
                          // Event Status
                          // Row(
                          //   children: [
                          //     Icon(
                          //       Icons.info,
                          //       size: 20.sp,
                          //       color: AppColors.primary,
                          //     ),
                          //     SizedBox(width: 8.w),
                          //     Text(
                          //       'Status: ${event?.status.toString().split('.').last.capitalizeFirstLetter()}',
                          //       style: TextStyle(fontSize: 14.sp),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: 8.h),

                          // Featured Event
                          if (event?.isFeatured == true)
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 20.sp,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Featured Event',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 100.h),
                        ],
                      ),
                    ),
                  ],
                ),

                // people who are going
                Positioned(
                  top: 210.sp,
                  right: 50.sp,
                  left: 50.sp,
                  child: Container(
                    height: context.mediaQueryHeight / 17,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.1,
                          ), // Shadow color (semi-transparent)
                          offset: Offset(
                            0,
                            4,
                          ), // Offset in the bottom direction (x, y)
                          blurRadius: 8, // The amount of blur
                          spreadRadius: 1, // The spread of the shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Show attendees if there are any
                        if (event!.attendees.isNotEmpty)
                          Row(
                            children: [
                              // Display image stack for attendees
                              SizedBox(
                                width: 60.w,
                                height: 24.h,
                                child: ImageStackWidget(),
                              ),
                              SizedBox(width: 8.w),
                              // Show how many people are going
                              Text(
                                '${event!.attendees.length} Going',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                        // Spacer to keep things aligned properly
                        if (event!.attendees.isNotEmpty) Spacer(),

                        // Handle the event's capacity
                        if (event!.isUnlimitedCapacity == false) ...[
                          // If there is limited capacity, show how many seats are left
                          Text(
                            event!.capacity != null &&
                                    event!.capacity! > event!.attendees.length
                                ? 'Seats Left: ${event!.capacity! - event!.attendees.length}'
                                : 'Event Fully Booked', // Show remaining seats or booked status
                            style: TextStyle(
                              fontSize: 12.sp,
                              color:
                                  event!.capacity != null &&
                                          event!.capacity! >
                                              event!.attendees.length
                                      ? AppColors.primary
                                      : Colors
                                          .red, // Change text color to red if booked
                            ),
                          ),
                          SizedBox(width: 8.sp),
                        ] else ...[
                          // If unlimited seats, show message
                          Text(
                            event!.attendees.isEmpty
                                ? 'Unlimited Seats Are Available'
                                : 'Unlimited Seats',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // app bar
            Positioned(
              top: 50.sp,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        NavigationService.pop();
                      },
                      child: Icon(Icons.arrow_back, color: AppColors.white),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      event?.title.capitalizeFirstLetter() ?? '',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 21.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (currentUser?.role == 'admin')
              Positioned(
                top: 50.sp,
                right: 20.sp,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'people':
                          NavigationService.push(
                            UserAttendingEvent(eventModel: event!),
                          );
                          break;
                        case 'edit':
                          NavigationService.push(
                            CreateEventScreen(event: event!),
                          );
                          break;
                        case 'delete':
                          // Add confirmation before delete
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text('Delete Event'),
                                  content: Text(
                                    'Are you sure you want to delete this event?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        eventVM
                                            .deleteEvent(event?.id ?? '')
                                            .then((_) {
                                              // Call your delete function here
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Utils.snackBar(
                                                'Event deleted Successfully',
                                                context,
                                              );
                                            });
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                          );
                          break;
                        case 'cancel':
                          // Add confirmation before delete
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text('Cancel Event'),
                                  content: Text(
                                    'Are you sure you want to cancel this event?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        eventVM
                                            .cancelEvent(
                                              event?.id ?? '',
                                              event?.title ?? '',
                                              event?.venue ?? '',
                                              event?.startDate ?? '',
                                              event?.startTime ?? '',
                                            )
                                            .then((_) {
                                              // Call your delete function here
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Utils.snackBar(
                                                'Event canceled Successfully',
                                                context,
                                              );
                                            });
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                ),
                          );
                          break;
                      }
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.sp),
                        color: Color.fromARGB(255, 210, 205, 205),
                      ),
                      padding: EdgeInsets.all(5.sp),
                      child: Icon(Icons.more_vert),
                    ),
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            value: 'people',
                            child: Text('People Going'),
                          ),
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                          PopupMenuItem(
                            value: 'cancel',
                            child: Text('Mark as Cancel'),
                          ),
                        ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Helper function for formatting time range
String _formatTimeRange(String? startTime, String? endTime) {
  // Case 1: Both start and end times are missing
  if ((startTime == null || startTime.isEmpty) &&
      (endTime == null || endTime.isEmpty)) {
    return ''; // Show nothing when both are missing
  }

  // Case 2: Only startTime is available
  if (startTime != null &&
      startTime.isNotEmpty &&
      (endTime == null || endTime.isEmpty)) {
    return startTime; // Just show the start time
  }

  // Case 3: Both startTime and endTime are available
  if (startTime != null &&
      startTime.isNotEmpty &&
      endTime != null &&
      endTime.isNotEmpty) {
    return '$startTime - $endTime'; // Show the full range
  }

  // Fallback: If startTime is missing, but endTime is available
  if ((startTime == null || startTime.isEmpty) &&
      endTime != null &&
      endTime.isNotEmpty) {
    return endTime; // Show only the end time
  }

  return ''; // Fallback for any other cases (this should never happen)
}

String _formatTimestamp(Timestamp timestamp) {
  final dateTime = timestamp.toDate();
  return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
}
