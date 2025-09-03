import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/constants.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            appIcon.commingsoon,
            width: 45.sp,
            height: 45.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            'Work in Progress',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xffFF8400),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
