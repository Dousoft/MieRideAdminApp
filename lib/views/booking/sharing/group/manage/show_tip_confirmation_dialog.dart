import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants.dart';

class ShowTipConfirmationDialog extends StatelessWidget {
  final double totalTripAmount;
  final double tipAmount;
  final double bookingDriverEarning;

  ShowTipConfirmationDialog({
    super.key,
    required this.totalTripAmount,
    required this.tipAmount,
    required this.bookingDriverEarning,
  });

  final RxDouble inputTip = 0.0.obs;

  double get keepPayout => totalTripAmount + tipAmount + bookingDriverEarning;

  double get changePayout =>
      totalTripAmount + bookingDriverEarning + tipAmount - inputTip.value;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: Get.width * 0.85,
        decoration: BoxDecoration(
          color: appColor.blackThemeColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.only(top: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 10.h),
              child: Text("Tip Confirmation",
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
            ),
            Container(
              decoration: BoxDecoration(
                color: appColor.whiteThemeColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Existing tip on this route: ',
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black,
                            fontFamily: appFont)),
                    TextSpan(
                        text: '\$${tipAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: appFont)),
                  ])),
                  SizedBox(height: 22.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Get.back(result: {
                          "confirmed": true,
                          "tip_status": 'keep',
                          "decreas_amount": null,
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 6.h),
                      ),
                      child: Text(
                        "Keep Tip",
                        style: TextStyle(
                            color: appColor.blackThemeColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Total Driver Payout : ',
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black,
                            fontFamily: appFont)),
                    TextSpan(
                        text: '\$${keepPayout.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: appFont)),
                  ])),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        if (inputTip.value <= 0) {
                          EasyLoading.showToast("Please enter tip amount");
                          return;
                        }

                        Get.back(result: {
                          "confirmed": true,
                          "tip_status": 'debit',
                          "decreas_amount": inputTip.value,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColor.blackThemeColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 6.h),
                      ),
                      child: Text(
                        "Change Tip",
                        style: TextStyle(
                            color: appColor.whiteThemeColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: 100.w,
                    height: 28.h,
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                        TipRangeFormatter(min: 1, max: tipAmount),
                      ],
                      onChanged: (val) {
                        double entered = double.tryParse(val) ?? 0.0;
                        if(entered>tipAmount){
                          EasyLoading.showToast("Can not decrease more than given tip amount.");
                          return;
                        }
                        inputTip.value = double.tryParse(val) ?? 0.0;
                      },
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "\$00.00",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 13.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 4.h, horizontal: 6.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Obx(() => RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Total Driver Payout : ',
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.black,
                                fontFamily: appFont)),
                        TextSpan(
                            text: '\$${changePayout.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: appFont)),
                      ]))),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TipRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  TipRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final double? value = double.tryParse(newValue.text);
    if (value == null) {
      return oldValue; // invalid number → reject
    }

    if (value < min || value > max) {
      return oldValue; // reject out of range
    }

    return newValue; // accept valid
  }
}

