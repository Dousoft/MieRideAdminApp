import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/constants.dart';

class ManageBookingCard extends StatelessWidget {
  final Map<dynamic, dynamic> booking;
  final bool isSelected;
  final VoidCallback onTap;

  const ManageBookingCard({
    super.key,
    required this.booking,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color:
              isSelected ? appColor.blackThemeColor : appColor.whiteThemeColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade400, width: 0.6.sp),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h).copyWith(bottom: 1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? appColor.greenThemeColor
                          : appColor.blackThemeColor,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                          color: Colors.grey.shade400, width: 0.6.sp),
                    ),
                    child: Text(
                      "Booking ID :- ${booking['id']??booking['booking_id']}",
                      style: TextStyle(
                        color: isSelected
                            ? appColor.blackThemeColor
                            : appColor.whiteThemeColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Source :- ',
                        style: TextStyle(
                            fontFamily: appFont,
                            color: isSelected
                                ? appColor.whiteThemeColor
                                : appColor.blackThemeColor,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '${booking['source']}',
                        style: TextStyle(
                          fontFamily: appFont,
                          color: isSelected
                              ? appColor.whiteThemeColor
                              : appColor.blackThemeColor,
                          fontSize: 12.5.sp,
                        ),
                      ),
                    ]),
                  ),
                  2.verticalSpace,
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Destination :- ',
                        style: TextStyle(
                            fontFamily: appFont,
                            color: isSelected
                                ? appColor.whiteThemeColor
                                : appColor.blackThemeColor,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '${booking['destination']}',
                        style: TextStyle(
                          fontFamily: appFont,
                          color: isSelected
                              ? appColor.whiteThemeColor
                              : appColor.blackThemeColor,
                          fontSize: 12.5.sp,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: appColor.greyDarkThemeColor,
                borderRadius: BorderRadius.circular(5.r),
              ),
              padding: EdgeInsets.all(3.sp).copyWith(bottom: 0),
              child: Column(
                spacing: 2,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: Image.asset(
                      appIcon.bgperson,
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                  Text(
                    '0${booking['number_of_people'] ?? 1}',
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
