import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/components/custom_lottie_animation.dart';
import 'package:event_hub/src/configs/extensions.dart';
import 'package:event_hub/src/data/response/status.dart';
import 'package:event_hub/src/features/auth/view_model/auth_view_model.dart';
import 'package:event_hub/src/features/event/view_model/event_view_model.dart';
import 'package:event_hub/src/features/search_events/event_search_screen.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EventsTabbar extends StatefulWidget {
  const EventsTabbar({super.key});

  @override
  State<EventsTabbar> createState() => _EventsTabbarState();
}

class _EventsTabbarState extends State<EventsTabbar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['My Registrations', 'My Past Events'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    // Fetch Events once
    Future.microtask(() {
      Provider.of<EventViewModel>(context, listen: false).fetchAllEvents();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteSccafold,

      body: Column(
        children: [
          Container(
            width: context.mediaQueryWidth / 1.3,
            height: 48.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19.r),
              color: Color(0xffffffff),
            ),
            child: TabBar(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 10.sp),
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: AppColors.grey,
              ),
              labelColor: AppColors.white,
              unselectedLabelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontSize: 12.sp),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              dividerColor: Colors.transparent,
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _EventsListView(status: EventStatus.ongoing),
                _EventsListView(status: EventStatus.completed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventsListView extends StatelessWidget {
  final EventStatus status;

  const _EventsListView({required this.status});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventViewModel>(
      builder: (context, eventVM, _) {
        final response = eventVM.eventsResponse;

        if (response.status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (response.status == Status.error) {
          return Center(child: Text('Error: ${response.message}'));
        } else if (response.status == Status.completed) {
          final allEvents = response.data ?? [];
          final now = DateTime.now();
          final currentUserId = context.read<AuthViewModel>().currentUser?.uid;

          // Filter events by registration
          final userRegisteredEvents =
              allEvents.where((event) {
                return event.attendees.any((att) => att.uid == currentUserId);
              }).toList();

          // Filter by date
          final filteredEvents =
              userRegisteredEvents.where((event) {
                final endDate = DateTime.parse(event.endDate);
                final isPast = endDate.isBefore(now);
                final isFuture = endDate.isAfter(now);

                return status == EventStatus.completed ? isPast : isFuture;
              }).toList();

          if (filteredEvents.isEmpty) {
            return CustomLottieAnimation();
          }

          return ListView.builder(
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              final event = filteredEvents[index];
              final userAttendee = event.attendees.firstWhere(
                (att) => att.uid == currentUserId,
                orElse:
                    () => Attendee(
                      uid: '',
                      status: AttendeeStatus.notDecided,
                      hasPaid: false,
                      confirmedSeat: false,
                      registeredAt: Timestamp.now(),

                      isInvited: false
                    ),
              );

              var hasPaid = userAttendee.hasPaid;
              return Stack(
                children: [
                  EventCard1(event: event),
                  // Paid badge (top right)
                  if (event.isPaid)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Tooltip(
                        message: hasPaid ? "Paid" : "Payment Pending",
                        child: Icon(
                          hasPaid ? Icons.verified : Icons.warning,
                          color: hasPaid ? Colors.green : Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        } else {
          return const Center(child: Text('Initializing...'));
        }
      },
    );
  }
}
