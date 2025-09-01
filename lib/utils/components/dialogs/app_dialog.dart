import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';

class AppDialog extends StatelessWidget {
  final String icon;
  final String title;
  final bool showTwoButtons;
  final VoidCallback? onYes;
  final VoidCallback? onNo;

  const AppDialog({
    super.key,
    required this.icon,
    required this.title,
    this.showTwoButtons = true,
    this.onYes,
    this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      backgroundColor: appColor.whiteThemeColor,
      child: Padding(
        padding: EdgeInsets.all(25.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            20.verticalSpace,
            Image.asset(
              icon,
              height: 80.h,
            ),
            25.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 12.w).copyWith(bottom: 8),
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: appColor.greyThemeColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            25.verticalSpace,
            showTwoButtons
                ? Row(
              spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildButton("NO", Colors.white, Colors.black, onNo)),
                      Expanded(child: _buildButton("YES", Colors.black, Colors.white, onYes)),
                    ],
                  )
                : Center(child: _buildCircleCloseButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleCloseButton() {
    return InkWell(
      onTap: () => Get.back(),
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
            color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(Icons.close, size: 28.sp, color: Colors.white),
      ),
    );
  }

  Widget _buildButton(
      String text, Color bg, Color fg, VoidCallback? onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 4,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
          side: BorderSide(color: Colors.black, width: 1.w),
        ),
      ),
      onPressed: onPressed ?? () => Get.back(),
      child: Text(text, style: TextStyle(fontSize: 14.sp)),
    );
  }
}
