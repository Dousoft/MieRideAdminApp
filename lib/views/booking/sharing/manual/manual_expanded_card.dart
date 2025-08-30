import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/constants.dart';

import '../route/route_expanded_card.dart';

class ManualExpandedCard extends StatelessWidget {
  final Map item;
  const ManualExpandedCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appColor.greyThemeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.only(bottom: 14.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // same as RouteExpandedCard so i use here to only return
            _buildHeader(),
            12.verticalSpace,
            RouteExpandedCard(item: item),
            10.verticalSpace,
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(3.sp),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    spreadRadius: 4,
                  )
                ], color: appColor.blackThemeColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.close,
                  size: 45.sp,
                  color: appColor.greyThemeColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(11.sp),
      decoration: BoxDecoration(
        color: appColor.blackThemeColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(' Route',style: TextStyle(color: appColor.greenThemeColor,fontSize: 16.sp,fontWeight: FontWeight.bold,letterSpacing: 1)),
          _buildGroupIdChip(),
        ],
      ),
    );
  }

  Widget _buildGroupIdChip() {
    return Container(
      decoration: BoxDecoration(
        color: appColor.greenThemeColor,
        borderRadius: BorderRadius.circular(4.5.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5),
      child: Text(
        'Group ID :- ${item['group_id']}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }
}

