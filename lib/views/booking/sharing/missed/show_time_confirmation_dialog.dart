import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/booking/sharing/missed_controller.dart';
import '../../../../utils/constants.dart';

class ShowTimeConfirmationDialog extends StatelessWidget {
  final String time;
  ShowTimeConfirmationDialog({super.key,required this.time}){
    originalTime.value = time;
  }

  final MissedController controller = Get.find<MissedController>();

  final RxString originalTime = "00:00".obs;
  final RxBool isKeepSame = true.obs;
  final RxInt increaseMinutes = 0.obs;

  String get displayOriginalTime {
    return _formatTo12Hour(originalTime.value);
  }

  String get displayUpdatedTime {
    if (increaseMinutes.value == 0) return displayOriginalTime;
    final parts = originalTime.value.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    DateTime dt = DateTime(2025, 1, 1, hour, minute)
        .add(Duration(minutes: increaseMinutes.value));

    return DateFormat("hh:mm a").format(dt);
  }

  static String _formatTo12Hour(String time24) {
    final parts = time24.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    DateTime dt = DateTime(2025, 1, 1, hour, minute);
    return DateFormat("hh:mm a").format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: Get.width * 0.85,
        decoration: BoxDecoration(
          color: appColor.blackThemeColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 0.h).copyWith(top: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 10.h),
              child: Text("Confirm Pickup Time",
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
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Do you want to keep the same pickup\ntime or increase it?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.sp),
                  ),
                  SizedBox(height: 16.h),
                  Obx(() => Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: isKeepSame.value,
                            onChanged: (val) {
                              isKeepSame.value = val!;
                            },
                            materialTapTargetSize: MaterialTapTargetSize
                                .shrinkWrap, // remove extra space
                            visualDensity: VisualDensity(
                              horizontal: VisualDensity.compact.horizontal,
                              vertical: VisualDensity.compact.vertical,
                            ),
                            activeColor: Colors.black,
                          ),
                          Text(
                            "Keep Same Time – Continue with  ",
                            style:
                                TextStyle(fontSize: 12.sp, letterSpacing: -0.2),
                          ),
                          Text(
                            displayOriginalTime,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      )),
                  Obx(() => Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: isKeepSame.value,
                            onChanged: (val) {
                              isKeepSame.value = val!;
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity(
                              horizontal: VisualDensity.compact.horizontal,
                              vertical: VisualDensity.compact.vertical,
                            ),
                            activeColor: Colors.black,
                          ),
                          Text("Increase Time ",
                              style: TextStyle(fontSize: 12.sp)),
                          SizedBox(width: 4.w),
                          SizedBox(
                            width: 60.w,
                            height: 20.h,
                            child: TextField(
                              enabled: !isKeepSame.value,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13.sp),
                              decoration: InputDecoration(
                                hintText: "mins",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 4.w),
                              ),
                              onChanged: (val) {
                                if (val.isEmpty) {
                                  increaseMinutes.value = 0;
                                } else {
                                  increaseMinutes.value =
                                      int.tryParse(val) ?? 0;
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 4.w),
                          if (!isKeepSame.value)
                            Text(
                              displayUpdatedTime,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      )),
                  SizedBox(height: 16.h),
                  _footer()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
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
                FocusManager.instance.primaryFocus?.unfocus();
                if (!isKeepSame.value && increaseMinutes.value <= 0) {
                  EasyLoading.showToast("Please enter minutes");
                  return;
                }
                Get.back(result: {
                  "confirmed": true,
                  "keepSame": isKeepSame.value,
                  "minutes": increaseMinutes.value,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appColor.blackThemeColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
              ),
              child: Text(
                "Confirm",
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
