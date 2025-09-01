import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountBadge extends StatelessWidget {
  final dynamic count;

  const CountBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    if (int.parse(count.toString()) == 0) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(4.sp).copyWith(bottom:1.sp),
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle
      ),
      child: Text(
        "$count",
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
