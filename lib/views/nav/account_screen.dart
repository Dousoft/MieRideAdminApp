import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../../utils/components/dialogs/logout_dialog.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appColor.greyThemeColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Account',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.asset(
                        appIcon.admin,
                        height: 52.h,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$userName",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "$userEmail",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: appColor.greyThemeColor,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(8.w),
                      child: Icon(Icons.edit, size: 15.sp),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: appColor.whiteThemeColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  spacing: 10.h,
                  children: [
                    _buildTile(
                      icon: Icon(Icons.person, size: 22.sp),
                      label: 'User',
                    ),
                    _buildTile(
                      icon: Icon(Icons.directions_car, size: 22.sp),
                      label: 'Driver',
                    ),
                    _buildTile(
                      icon: Icon(Icons.local_offer_outlined, size: 22.sp),
                      label: 'Coupon',
                    ),
                    _buildTile(
                      icon: Icon(Icons.settings, size: 22.sp),
                      label: 'Setting',
                    ),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => Get.dialog(LogoutDialog()),
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                        spreadRadius: 1
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 22.sp),
                      SizedBox(width: 12.w),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
      {required Widget icon, required String label, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: appColor.greyThemeColor,
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
