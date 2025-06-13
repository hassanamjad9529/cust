import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/extensions.dart';
import 'package:event_hub/src/configs/routes/navigation_services.dart';
import 'package:event_hub/src/features/event/view/event_detail_screen.dart';
import 'package:event_hub/src/features/search_events/event_filter_screen.dart';
import 'package:event_hub/src/features/search_events/event_search_view_model.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class EventSearchScreen extends StatefulWidget {
  const EventSearchScreen({super.key});

  @override
  State<EventSearchScreen> createState() => _EventSearchScreenState();
}

class _EventSearchScreenState extends State<EventSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<EventSearchViewModel>(
        context,
        listen: false,
      ).fetchAllEvents();
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    Provider.of<EventSearchViewModel>(context, listen: false).search(query);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EventSearchViewModel>(context);

    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text("Search")),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: 0.h,
              top: 6.h,
              left: 12.w,
              right: 12.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/search.svg',
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '|',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 18.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: "Search events...",
                                  hintStyle: TextStyle(color: AppColors.grey),
                                  border: InputBorder.none, // <<< No border
                                  isDense: true, // <<< Reduce height a little
                                  contentPadding:
                                      EdgeInsets.zero, // <<< Tight padding
                                ),
                                onChanged: (_) => _onSearchChanged(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EventFilterScreen(),
                          ),
                        );

                        if (result != null && context.mounted) {
                          Provider.of<EventSearchViewModel>(
                            context,
                            listen: false,
                          ).applyFilters(result);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.sp,
                          vertical: 4.sp,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xff5d56f3),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.sp),
                              decoration: BoxDecoration(
                                color: Color(0xffa39ef0),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Icon(
                                Icons.filter_list,
                                color: AppColors.primary,
                                size: 14.sp,
                              ),
                            ),
                            SizedBox(width: 8.sp),
                            Text(
                              'Filters',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),

          if (viewModel.isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child:
                  viewModel.filteredEvents.isEmpty
                      ? const Center(child: Text("No events found"))
                      : ListView.builder(
                        itemCount: viewModel.filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = viewModel.filteredEvents[index];
                          return EventCard1(event: event);
                        },
                      ),
            ),
        ],
      ),
    );
  }
}

class EventCard1 extends StatelessWidget {
  final EventModel event;

  const EventCard1({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NavigationService.push(EventDetailScreen(event: event)),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.white,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child:
                    event.imageUrl != null
                        ? Image.network(
                          event.imageUrl!,
                          width: 80.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.event),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${event.startDate.toFormattedDate()} • ${event.startTime}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primary,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(event.venue, style: TextStyle(fontSize: 16.sp)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
