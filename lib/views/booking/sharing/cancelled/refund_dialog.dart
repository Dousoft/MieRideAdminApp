import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';
import '../group/manage/show_tip_confirmation_dialog.dart';

class RefundDialog extends StatelessWidget {
  final double chargedAmount;
  RefundDialog({super.key, required this.chargedAmount});

  final RxString refundAmount = ''.obs;
  final RxString refundReason = ''.obs;

  final refundReasons = ['Driver Cancelled the Ride', 'No Driver Assigned', 'Driver Did Not Arrive on Time'];

  void setRefundAmount(String value) {
    refundAmount.value = value;
  }

  void setRefundReason(String value) {
    refundReason.value = value;
  }

  Map<String, dynamic> get payload => {
        'confirmed': true,
        "refund_amount": refundAmount.value,
        "refund_reason": refundReason.value,
      };

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: appColor.whiteThemeColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(26.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Refund Cancellation",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            12.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: appColor.greenThemeColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Amount charged    ",
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontFamily: appFont),
                    ),
                    TextSpan(
                      text: "\$${chargedAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: appFont),
                    ),
                  ],
                ),
              ),
            ),
            16.verticalSpace,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Refund Amount",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            7.verticalSpace,
            TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                TipRangeFormatter(min: 1, max: chargedAmount),
              ],
              onChanged: setRefundAmount,
              decoration: InputDecoration(
                hintText: "Enter Refund Amount",
                hintStyle: TextStyle(color: Colors.grey.shade600,fontSize: 13.sp),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 0.5.sp)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
              ),
              keyboardType: TextInputType.number,
            ),
            10.verticalSpace,
            Obx(() => DropdownButtonFormField<String>(
                  value: refundReason.value.isEmpty ? null : refundReason.value,
                  decoration: InputDecoration(
                    hintText: "Select Refund Reason",
                    hintStyle: TextStyle(fontSize: 13.sp),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                            color: Colors.grey.shade400, width: 0.5.sp)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                  ),
                  items: refundReasons
                      .map(
                        (reason) => DropdownMenuItem(
                          value: reason,
                          child: Text(reason,style: TextStyle(fontSize: 13.sp),),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setRefundReason(value);
                  },
                  icon: Icon(
                    CupertinoIcons.chevron_down,
                    size: 16.sp,
                  ),
                )),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: () {
                      if (refundAmount.value.isEmpty) {
                        EasyLoading.showToast("Enter refund amount.");
                        return;
                      }
                      if (refundReason.value.isEmpty) {
                        EasyLoading.showToast("Select refund reason.");
                        return;
                      }
                      Get.back(result: payload);
                    },
                    child: Text(
                      "Refund",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
