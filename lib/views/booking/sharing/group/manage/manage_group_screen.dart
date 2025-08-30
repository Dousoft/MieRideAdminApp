import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/controllers/booking/sharing/group/manage_group_controller.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../../../../utils/components/buttons/app_button.dart';
import 'manage_booking_card.dart';

class ManageGroupScreen extends StatefulWidget {
  ManageGroupScreen({super.key, required this.bookings});

  final List<dynamic> bookings;

  @override
  State<ManageGroupScreen> createState() => _ManageGroupScreenState();
}

class _ManageGroupScreenState extends State<ManageGroupScreen> {
  late ManageGroupController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        Get.put(ManageGroupController(bookingsList: widget.bookings.obs));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: appColor.greyThemeColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: appColor.greyThemeColor,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 16.sp,
                    ),
                  ),
                ),
                Text(
                  widget.bookings.isNotEmpty
                      ? "Group ID :- ${widget.bookings.first['group_id']}"
                      : "Group Details",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(width: 35.w),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Obx(() {
              bool isBookingSelected = controller.isBookingSelected;
              bool isGroupIdSelected = controller.isGroupIdSelected;
              return Column(
                children: [
                  _buildBookingCards(),
                  Container(
                    margin: EdgeInsets.all(16.sp).copyWith(top: 8.h),
                    padding: EdgeInsets.all(14.sp),
                    decoration: BoxDecoration(
                      color: appColor.whiteThemeColor,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      spacing: 12.h,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            IgnorePointer(
                              ignoring: controller.isGroupLoading.value || !controller.isBookingSelected,
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: controller.isGroupLoading.value?appColor.greyDarkThemeColor:appColor.whiteThemeColor,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                      color: Colors.grey.shade400, width: 0.6.sp),
                                ),
                                child: Column(
                                  spacing: 12.h,
                                  children: [
                                    _buildGroupDropdown(),
                                    AppButton(
                                      btnText: "Shift",
                                      paddingVertical: 8.h,
                                      fontSize: 16.sp,
                                      onPressed: isGroupIdSelected ? () async => controller.shiftBooking() : null,
                                      backgroundColor: isGroupIdSelected
                                          ? appColor.greenThemeColor
                                          : appColor.darkGreyColor,
                                      textColor: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (controller.isGroupLoading.value)
                              CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: appColor.whiteThemeColor,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                                color: Colors.grey.shade400, width: 0.6.sp),
                          ),
                          child: Column(
                            spacing: 12.h,
                            children: [
                              AppButton(
                                btnText: "Unlink",
                                paddingVertical: 8.h,
                                fontSize: 16.sp,
                                textColor: appColor.greenThemeColor,
                                onPressed: isBookingSelected
                                    ? () async => controller.unlinkBooking()
                                    : null,
                                backgroundColor: isBookingSelected
                                    ? appColor.blackThemeColor
                                    : appColor.darkGreyColor,
                              ),
                              AppButton(
                                btnText: "Cancel",
                                paddingVertical: 8.h,
                                fontSize: 16.sp,
                                onPressed: isBookingSelected
                                    ? () async => controller.cancelBooking()
                                    : null,
                                backgroundColor: isBookingSelected
                                    ? appColor.blackThemeColor
                                    : appColor.darkGreyColor,
                                textColor: appColor.greenThemeColor,
                              ),
                              AppButton(
                                btnText: "Switch Time Slot",
                                paddingVertical: 8.h,
                                fontSize: 16.sp,
                                onPressed: isBookingSelected ? () async {} : null,
                                backgroundColor: isBookingSelected
                                    ? appColor.blackThemeColor
                                    : appColor.darkGreyColor,
                                textColor: appColor.greenThemeColor,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        Obx(
          () {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        )
      ],
    );
  }

  Widget _buildBookingCards() {
    return Container(
      margin: EdgeInsets.all(16.sp),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.sp),
      decoration: BoxDecoration(
        color: appColor.whiteThemeColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: controller.bookingsList.value.map<Widget>((booking) {
          final isSelected =
              controller.selectedBookingId.value == booking['id'];
          return ManageBookingCard(
            booking: booking,
            isSelected: isSelected,
            onTap: () => controller.selectBooking(booking['id']),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGroupDropdown() {
    return Obx(() {
      return IgnorePointer(
        ignoring: controller.groupIds.isEmpty,
        child: Container(
          height: 36.h,
          padding: EdgeInsets.only(right: 10.w, left: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: DropdownButton<int>(
            value: controller.selectedGroupId.value,
            hint: Text(
              controller.groupIds.isEmpty?"No Booking Group Found":"Select Group ID",
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                  fontFamily: appFont),
            ),
            icon: Icon(CupertinoIcons.chevron_down,
                size: 16.sp, color: Colors.black),
            isExpanded: true,
            underline: const SizedBox(),
            style: TextStyle(fontSize: 12.sp, color: Colors.black),
            items: controller.groupIds
                .map((item) => DropdownMenuItem<int>(
                      value: item['group_id'],
                      child: Text(
                        "${item['group_id']} ${item['type']}",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontFamily: appFont),
                      ),
                    ))
                .toList(),
            onChanged: (val) => controller.selectGroup(val),
          ),
        ),
      );
    });
  }
}
