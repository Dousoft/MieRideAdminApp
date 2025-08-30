import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildSmallLoader extends StatelessWidget {
  const BuildSmallLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          height: 20.w,
          width: 20.w,
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.black,
            strokeWidth: 2.sp,
          )),
        ),
      ],
    );
  }
}
