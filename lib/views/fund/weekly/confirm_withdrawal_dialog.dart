import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import 'package:mie_admin/utils/constants.dart';

import '../../../controllers/fund/weekly_withdrawal_controller.dart';

class ConfirmWithdrawalDialog extends StatelessWidget {
  final Map data;
  final int index;
  ConfirmWithdrawalDialog({super.key, required this.data, required this.index});

  final controller = Get.find<WeeklyWithdrawalController>();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
  final formattedDateTime = DateFormat("dd MMM yyyy (hh:mm a)").format(now);
    return Container(
      decoration: BoxDecoration(
        color: appColor.blackThemeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Container(
            decoration: BoxDecoration(
              color: appColor.whiteThemeColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            padding: EdgeInsets.all(20.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                  decoration: BoxDecoration(
                    color: appColor.greyDarkThemeColor,
                    borderRadius: BorderRadius.circular(4.5.r),
                  ),
                  child: Text(
                    formattedDateTime,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black),
                  ),
                ),
                5.verticalSpace,
                  _infoField("Driver Name :", data['name'] ?? ""),
                  5.verticalSpace,
                  _infoField("Withdrawal Amount :", "\$${data['wallet_balance']}"),
                8.verticalSpace,
                Text(
                  "Please review the details before processing the withdrawal.",
                  style: TextStyle(
                    fontSize: 12.sp,
                      color: appColor.blackThemeColor,
                      letterSpacing: 1),
                ),
                20.verticalSpace,
                _buildFooter()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: appColor.blackThemeColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.r),
        ),
      ),
      alignment: Alignment.center,
      child: Text('Confirm Driver Withdrawal',style: TextStyle(color: appColor.whiteThemeColor,fontSize: 12.sp,fontWeight: FontWeight.bold,letterSpacing: 1)),
    );
  }

  Widget _infoField(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Get.back();
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
            ),
            child: Text(
              "Edit",
              style: TextStyle(
                  color: appColor.blackThemeColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1),
            ),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: AppButton(btnText: 'Proceed',
            paddingVertical: 7.h,
            fontSize: 14.sp,
            borderRadius: BorderRadius.circular(10.r),
            onPressed:() async => await controller.payWeeklyWithdrawal(driverId: data['id'].toString(), payableAmount: data['total_payable_amount'].toString()),),
        ),
      ],
    );
  }
}

