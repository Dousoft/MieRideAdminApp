import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/controllers/booking/sharing/cancelled_controller.dart';
import 'package:mie_admin/controllers/booking/sharing/completed_controller.dart';
import 'package:mie_admin/utils/constants.dart';

class CompletedBookingFiler extends StatelessWidget {
  final CompletedController controller = Get.find<CompletedController>();

  CompletedBookingFiler({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 350.w,
        height: 270.h,
        decoration: BoxDecoration(
          color: appColor.blackThemeColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 0.h).copyWith(top: 12.h),
        child: Column(
          children: [
            _header(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: appColor.whiteThemeColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child:Column(
                  children: [
                    _dateFilter(),
                    Spacer(),
                    _footer(),
                    5.verticalSpace
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          15.horizontalSpace,
          Text("Filter",
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        25.verticalSpace,
        Obx(() => InkWell(
          onTap: () async {
            final picked = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100));
            if (picked != null) controller.updateStartDate(picked);
          },
          child: _dateBox(controller.startDate.value),
        )),
        SizedBox(height: 8.h),
        Text("To", style: TextStyle(fontSize: 14.sp, color: Colors.black,fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),
        Obx(() => InkWell(
          onTap: () async {
            final picked = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100));
            if (picked != null) controller.updateEndDate(picked);
          },
          child: _dateBox(controller.endDate.value),
        )),
      ],
    );
  }

  Widget _dateBox(DateTime? date) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              date == null
                  ? "Select date"
                  : date.toLocal().toString().split(' ')[0],
              style: TextStyle(fontSize: 12.sp)),
          Image.asset(appIcon.date,width: 14.h,height: 14.h,)
          // const Icon(Icons.calendar_today_outlined, size: 18),
        ],
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                controller.clearAndApplyFilters();
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
              ),
              child: Text(
                "Clear",
                style: TextStyle(
                    color: appColor.blackThemeColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                controller.applyFilters();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appColor.blackThemeColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
              ),
              child: Text(
                "Apply",
                style: TextStyle(
                    color: appColor.whiteThemeColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
