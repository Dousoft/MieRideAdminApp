import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mie_admin/controllers/fund/quick_deposit_controller.dart';
import 'package:mie_admin/utils/constants.dart';

import '../../../controllers/fund/interac_transfer_controller.dart';

class InteracTransferFiler extends StatelessWidget {
  final QuickDepositController controller = Get.find<QuickDepositController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 350.w,
        height: 280.h,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Obx(() => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sidebar(),
                              SizedBox(width: 10.w),
                              Expanded(child: _contentArea()),
                              SizedBox(width: 16.w),
                            ],
                          )),
                    ),
                    _footer()
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

  Widget _sidebar() {
    return Container(
      width: 120.w,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r)),
      ),
      child: Column(
        children: [
          12.verticalSpace,
          _sidebarItem('Date'),
          _sidebarItem('Status'),
          _sidebarItem('Payment Type'),
        ],
      ),
    );
  }

  Widget _sidebarItem(String title) {
    return Obx(() => InkWell(
          onTap: () => controller.selectedTab.value = title,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h).copyWith(left: 16.w),
            decoration: BoxDecoration(
              color: controller.selectedTab.value == title
                  ? Colors.grey.shade300
                  : Colors.grey.shade100,
            ),
            alignment: Alignment.centerLeft,
            child: Text(title, style: TextStyle(fontSize: 14.sp)),
          ),
        ));
  }

  Widget _contentArea() {
    switch (controller.selectedTab.value) {
      case 'Status':
        return _statusFilter();
      case 'Payment Type':
        return _paymentTypeFilter();
      case 'Date':
      default:
        return _dateFilter();
    }
  }

  Widget _dateFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        12.verticalSpace,
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
        Text("To", style: TextStyle(fontSize: 12.sp, color: Colors.black)),
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
          const Icon(Icons.calendar_today_outlined, size: 18),
        ],
      ),
    );
  }

  Widget _statusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        12.verticalSpace,
        TextField(
          onChanged: (value) => controller.searchStatus.value = value,
          decoration: InputDecoration(
            hintText: "Search...",
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: appColor.blackThemeColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: appColor.blackThemeColor)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: appColor.blackThemeColor)),
            isDense: true,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() {
          final statusMap = {
            'Accepted': 1,
            'Pending': 0,
            'Rejected': -1,
          };

          final filtered = statusMap.keys
              .where((e) => e
                  .toLowerCase()
                  .contains(controller.searchStatus.value.toLowerCase()))
              .toList();

          return Column(
            children: filtered
                .map((status) => SizedBox(
                      height: 25.h,
                      child: CheckboxListTile(
                        title: Text(status, style: TextStyle(fontSize: 12.sp)),
                        value: controller.selectedStatusValue.value ==
                            statusMap[status],
                        onChanged: (checked) {
                          if (checked == true) {
                            controller.selectStatus(statusMap[status]);
                          } else {
                            controller.selectStatus(null);
                          }
                        },
                        dense: true,
                        contentPadding: EdgeInsets.all(0),
                        checkColor: appColor.whiteThemeColor,
                        activeColor: appColor.blackThemeColor,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ))
                .toList(),
          );
        })
      ],
    );
  }

  Widget _paymentTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        12.verticalSpace,
        TextField(
          onChanged: (value) => controller.searchPaymentTypeFilter.value = value,
          decoration: InputDecoration(
            hintText: "Search...",
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: appColor.blackThemeColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: appColor.blackThemeColor)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: appColor.blackThemeColor)),
            isDense: true,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() {
          final paymentTypeMap = {
            'Credit Card':'Card',
            'Google Pay':'G Pay',
            'Apple Pay':'Apple Pay'
          };

          final filtered = paymentTypeMap.keys
              .where((e) => e
                  .toLowerCase()
                  .contains(controller.searchPaymentTypeFilter.value.toLowerCase()))
              .toList();

          return Column(
            children: filtered
                .map((status) => SizedBox(
                      height: 25.h,
                      child: CheckboxListTile(
                        title: Text(status, style: TextStyle(fontSize: 12.sp)),
                        value:
                            controller.selectedPaymentTypeValue.value == paymentTypeMap[status],
                        onChanged: (checked) {
                          if (checked == true) {
                            controller.selectedPaymentTypeValue.value = paymentTypeMap[status];
                          } else {
                            controller.selectedPaymentTypeValue.value = null;
                          }
                        },
                        dense: true,
                        contentPadding: EdgeInsets.all(0),
                        checkColor: appColor.whiteThemeColor,
                        activeColor: appColor.blackThemeColor,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ))
                .toList(),
          );
        })
      ],
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
