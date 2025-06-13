import 'dart:math';

import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/extensions.dart';
import 'package:event_hub/src/configs/routes/navigation_services.dart';
import 'package:event_hub/src/data/response/status.dart';
import 'package:event_hub/src/features/event/view/event_detail_screen.dart';
import 'package:event_hub/src/features/event/view_model/event_view_model.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsCalendarScreen extends StatefulWidget {
  const EventsCalendarScreen({super.key});

  @override
  State<EventsCalendarScreen> createState() => _EventsCalendarScreenState();
}

class _EventsCalendarScreenState extends State<EventsCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _selectedDay = DateTime.now();
      Provider.of<EventViewModel>(context, listen: false).fetchAllEvents();
    });
  }

  List<EventModel> _getEventsForDay(DateTime day, List<EventModel> allEvents) {
    return allEvents.where((event) {
      return isSameDay(event.startDate.toDateTime(), day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventViewModel>(context);
    final response = eventViewModel.eventsResponse;
    final events = response.data ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body:
          response.status == Status.loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      eventLoader: (day) => _getEventsForDay(day, events),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        formatButtonShowsNext: false,
                        headerPadding: EdgeInsets.symmetric(vertical: 8.0),
                      ),
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.deepOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        dowBuilder: (context, day) {
                          final text =
                              [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun',
                              ][day.weekday - 1];
                          return Center(
                            child: Text(
                              text,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child:
                        _selectedDay == null
                            ? const Center(child: Text('Select a date'))
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xffeff0ff),
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(8.sp),
                                        child: Column(
                                          children: [
                                            Text(
                                              _selectedDay!.month.toMonthName(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            Text(
                                              _selectedDay!.day.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        _selectedDay!.toFormattedString(),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 3.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(left: 58.sp),

                                    itemCount:
                                        _getEventsForDay(
                                          _selectedDay!,
                                          events,
                                        ).length,
                                    itemBuilder: (context, index) {
                                      // List of soft colors and gradients
                                      final colors = [
                                        Colors.cyan,
                                        Color(0xFFfe9c72),
                                        Color(0xFFb6abff),
                                        Color(0xFFf7c6d1),
                                      ];
                                      // Generate a random color from the list
                                      final randomColor =
                                          colors[Random().nextInt(
                                            colors.length,
                                          )];
                                      final event =
                                          _getEventsForDay(
                                            _selectedDay!,
                                            events,
                                          )[index];
                                      return InkWell(
                                        onTap: () {
                                          NavigationService.push(EventDetailScreen(event: event));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8.sp),
                                          margin: EdgeInsets.all(8.sp),
                                          decoration: BoxDecoration(
                                            // Applying gradient
                                            gradient: LinearGradient(
                                              colors: [
                                                randomColor.withOpacity(0.8),
                                                randomColor.withOpacity(0.4),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              15.sp,
                                            ),
                                          ),
                                          child: ListTile(
                                            leading:
                                                event.imageUrl != null
                                                    ? CircleAvatar(
                                                      radius: 25.sp,
                                                      backgroundImage:
                                                          NetworkImage(
                                                            event.imageUrl!,
                                                          ),
                                                    )
                                                    : const Icon(
                                                      Icons.event,
                                                      size: 50,
                                                      color: Colors.white,
                                                    ),
                                            title: Text(
                                              '${event.startTime}  -  ${event.endTime}',
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              event.title,
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                  ),
                ],
              ),
    );
  }
}
