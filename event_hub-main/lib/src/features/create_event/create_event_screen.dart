import 'package:dotted_border/dotted_border.dart';
import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/components/custom_drop_down.dart';
import 'package:event_hub/src/configs/components/custom_text_filed.dart';
import 'package:event_hub/src/configs/components/round_button.dart';
import 'package:event_hub/src/configs/extensions.dart';
import 'package:event_hub/src/configs/theme/theme_text.dart';
import 'package:event_hub/src/configs/utils.dart';
import 'package:event_hub/src/features/event/view_model/event_view_model.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:event_hub/src/features/create_event/create_event_view_model.dart';
import 'package:event_hub/src/features/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CreateEventScreen extends StatelessWidget {
  final EventModel? event;
  final bool showAppbar;
  const CreateEventScreen({super.key, this.event, this.showAppbar = true});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateEventViewModel(event: event),
      child: Consumer<CreateEventViewModel>(
        builder:
            (context, vm, _) => Scaffold(
              appBar:
                  showAppbar
                      ? AppBar(
                        title: Text(
                          vm.isEditing ? "Update Event" : "Create Event",
                        ),
                      )
                      : PreferredSize(
                        preferredSize: Size.fromHeight(0),
                        child: SizedBox(),
                      ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: vm.formKey,
                  child: ListView(
                    children: [
                      // Image selection with dotted border or preview
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (vm.imageFile == null &&
                              vm.existingImageUrl == null)
                            GestureDetector(
                              onTap: vm.pickImage,
                              child: DottedBorder(
                                dashPattern: const <double>[10, 5],
                                color: Colors.black38,
                                borderType: BorderType.RRect,
                                radius: Radius.circular(12),
                                padding: EdgeInsets.all(6),
                                child: SizedBox(
                                  height: context.mediaQueryHeight / 5.4,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/upload.svg',
                                        height: 40,
                                        color: Colors.black38,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Select Image',
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Container(
                                        height: 26.h,
                                        width: 120.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Colors.black38,
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Center(
                                          child: Text(
                                            'Upload File',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          else
                            Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child:
                                        vm.imageFile != null
                                            ? Image.file(
                                              vm.imageFile!,

                                              height:
                                                  context.mediaQueryHeight /
                                                  5.4,

                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.network(
                                              vm.existingImageUrl!,
                                              height:
                                                  context.mediaQueryHeight /
                                                  5.4,

                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                ),

                                Positioned(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: vm.pickImage,
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: AppColors.white,
                                        child: Icon(
                                          Icons.change_circle,
                                          color: AppColors.black,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        hintText: "Event Title",
                        controller: vm.titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Event title is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        hintText: 'Description',
                        controller: vm.descController,
                        maxLines: 5,
                        minLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomDropdown<EventType>(
                        'Type',
                        vm.selectedType,
                        EventType.values,
                        (val) => vm.setSelectedType(val!),
                      ),
                      SizedBox(height: 15.h),
                      CustomDropdown<EventCategory>(
                        'Category',
                        vm.selectedCategory,
                        EventCategory.values,
                        (val) => vm.setSelectedCategory(val!),
                      ),

                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        controller: vm.venueController,
                        hintText: 'Venue',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Venue is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            vm.registrationDeadlineController.text =
                                picked.toString().split(' ').first;
                          }
                        },
                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            controller: vm.registrationDeadlineController,
                            hintText: 'Registration Deadline (Optional)',
                            maxLines: 1,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  vm.startDateController.text =
                                      picked.toString().split(' ').first;
                                }
                              },
                              child: AbsorbPointer(
                                child: CustomTextFormField(
                                  controller: vm.startDateController,
                                  maxLines: 1,
                                  hintText: 'Start Date',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Start Date is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.h),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  vm.endDateController.text =
                                      picked.toString().split(' ').first;
                                }
                              },
                              child: AbsorbPointer(
                                child: CustomTextFormField(
                                  controller: vm.endDateController,
                                  maxLines: 1,
                                  hintText: 'End Date',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'End Date is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  final formattedTime =
                                      MaterialLocalizations.of(
                                        context,
                                      ).formatTimeOfDay(picked);
                                  vm.startTimeController.text = formattedTime;
                                }
                              },
                              child: AbsorbPointer(
                                child: CustomTextFormField(
                                  controller: vm.startTimeController,
                                  maxLines: 1,
                                  hintText: 'Start Time',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Start Time is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.h),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  final formattedTime =
                                      MaterialLocalizations.of(
                                        context,
                                      ).formatTimeOfDay(picked);
                                  vm.endTimeController.text = formattedTime;
                                }
                              },
                              child: AbsorbPointer(
                                child: CustomTextFormField(
                                  controller: vm.endTimeController,
                                  maxLines: 1,
                                  hintText: 'End Time',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'End Time is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      SwitchListTile(
                        contentPadding: EdgeInsets.all(0),
                        activeColor: AppColors.white,
                        activeTrackColor: AppColors.primary,
                        value: vm.isUnlimited,
                        onChanged: vm.setIsUnlimited,
                        title: Text(
                          "Unlimited Capacity",
                          style: Themetext.textTheme.bodyMedium,
                        ),
                      ),
                      if (!vm.isUnlimited)
                        CustomTextFormField(
                          controller: vm.capacityController,
                          hintText: 'Capacity',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (!vm.isUnlimited &&
                                (value == null || value.isEmpty)) {
                              return 'Capacity is required';
                            }
                            return null;
                          },
                        ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.all(0),
                        activeColor: AppColors.white,
                        activeTrackColor: AppColors.primary,
                        value: vm.isPaid,
                        onChanged: vm.setIsPaid,
                        title: Text(
                          "Is Paid Event",
                          style: Themetext.textTheme.bodyMedium,
                        ),
                      ),
                      if (vm.isPaid)
                        CustomTextFormField(
                          controller: vm.priceController,
                          hintText: 'Price',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (vm.isPaid && (value == null || value.isEmpty)) {
                              return 'Price is required';
                            }
                            return null;
                          },
                        ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.all(0),
                        activeColor: AppColors.white,
                        activeTrackColor: AppColors.primary,
                        value: vm.isFeatured,
                        onChanged: vm.setIsFeatured,
                        title: Text(
                          "Feature Event",
                          style: Themetext.textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RoundButton(
                        loading: vm.isLoading || vm.isUploadingImage,
                        title: vm.isEditing ? 'Update Event' : 'Create Event',
                        onPress: () async {
                          if (!vm.isEditing && vm.imageFile == null) {
                            Utils.snackBar('Please select Image', context);
                            return;
                          }
                          final authVM = context.read<AuthViewModel>();
                          final eventVM = context.read<EventViewModel>();
                          final error = await vm.submitForm(
                            context,
                            authVM,
                            eventVM,
                          );
                          if (error == null) {
                            Navigator.pop(context);
                          } else {
                            Utils.snackBar(error, context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
