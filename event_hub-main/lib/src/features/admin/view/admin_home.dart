import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/routes/slide_transition_page.dart';
import 'package:event_hub/src/features/event/view_model/event_view_model.dart';
import 'package:event_hub/src/features/create_event/create_event_screen.dart';
import 'package:event_hub/src/features/admin/widgets/list_of_events_by_event_status.dart';
import 'package:event_hub/src/features/search_events/event_filter_screen.dart';
import 'package:event_hub/src/features/search_events/event_search_screen.dart';
import 'package:event_hub/src/features/search_events/event_search_view_model.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedTabIndex = 0;

  final List<String> _tabs = ['All', 'OnGoing', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<EventViewModel>(context, listen: false).fetchAllEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search + Filter Section
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EventSearchScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),

                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/svg/search.svg'),
                                  SizedBox(width: 8.w),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),

                                  Text(
                                    'Search events...',
                                    style: TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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

                            Navigator.push(
                              context,
                              SlideTransitionPage(
                                page: EventSearchScreen(),
                                slideDirection: SlideDirection.right,
                              ),
                            );
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
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              itemBuilder: (context, index) {
                // List of soft colors and gradients
                final colors = [
                  Color(0xFFf59762),
                  Color(0xFF29d697),
                  Color(0xFF46cdfb),
                  Color(0xfff0635a),
                ];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors[index],
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          _tabs[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h), // small space
                      Container(
                        height: 2.h, // thickness of line
                        width: 20.w, // length of line
                        decoration: BoxDecoration(
                          color:
                              _selectedTabIndex == index
                                  ? AppColors.primary
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ListOfEventsByEventStatus(
              statusFilter:
                  _selectedTabIndex == 0
                      ? null
                      : _selectedTabIndex == 1
                      ? EventStatus.ongoing
                      : _selectedTabIndex == 2
                      ? EventStatus.completed
                      : EventStatus.cancelled,
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEventScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
