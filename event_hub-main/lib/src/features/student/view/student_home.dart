import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/routes/slide_transition_page.dart';
import 'package:event_hub/src/features/event/view_model/event_view_model.dart';
import 'package:event_hub/src/features/search_events/event_filter_screen.dart';
import 'package:event_hub/src/features/search_events/event_search_screen.dart';
import 'package:event_hub/src/features/search_events/event_search_view_model.dart';
import 'package:event_hub/src/features/student/widgets/feature_event_card.dart';
import 'package:event_hub/src/features/student/widgets/list_of_events_by_event_category.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int _selectedTabIndex = 0;

  late List<EventCategory> _categories;

  @override
  void initState() {
    super.initState();
    _categories = EventCategory.values;
    Future.microtask(() {
      Provider.of<EventViewModel>(context, listen: false).fetchAllEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
          SizedBox(height: 15.h),
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final colors = [
                  Color(0xFFf59762),
                  Color.fromARGB(255, 35, 175, 124),
                  Color.fromARGB(255, 31, 189, 242),
                  Color(0xfff0635a),
                  const Color.fromARGB(255, 53, 107, 201),
                  Colors.pinkAccent,
                  const Color.fromARGB(255, 6, 142, 110),
                  Colors.deepPurpleAccent,
                  const Color.fromARGB(255, 38, 103, 71),
                  Colors.orangeAccent,
                  const Color.fromARGB(255, 11, 94, 94),
                  Colors.redAccent,
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
                          _categories[index].name,
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
                        width: 30.w, // length of line
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
          SizedBox(height: 15.h),
          ListOfEventsByEventCategory(
            categoryFilter: _categories[_selectedTabIndex],
          ),
          SizedBox(height: 15.h), FeaturedEventCard(),
        ],
      ),
    );
  }
}
