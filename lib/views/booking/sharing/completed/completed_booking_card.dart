import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/extensions.dart';
import '../../../../utils/constants.dart';
import 'completed_booking_details_screen.dart';

class CompletedBookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;

  const CompletedBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    if (booking["driverDetails"] == null) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () => Get.to(() => CompletedBookingDetailsScreen(booking: booking),
          duration: Duration(
            milliseconds: 300,
          ),
          transition: Transition.rightToLeft),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: appColor.whiteThemeColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            )
          ],
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: appColor.blackThemeColor,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Group ID :- ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: booking["group_id"].toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '${booking["first_pickup_date"]} ${booking["first_pickup_time"]}'
                      .toMonthYearTimeFormat(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            _buildInfoRow(
                'Driver Name :- ', booking["driverDetails"]['first_name']),
            _buildInfoRow('Pickup City :- ', booking['pickup_city']),
            _buildInfoRow('Drop-off City :- ', booking["dropoff_city"]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow(
                  'Time Choice :- ',
                  booking["time_choice"] == 'pickupat'
                      ? 'Pickup'
                      : booking["time_choice"] == 'dropoffby'
                          ? 'DropOff'
                          : '',
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Earning :- ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: appColor.blackThemeColor,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  child: Text(
                    '\$${booking["total_driver_earning"]}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: appColor.greenThemeColor,
                      fontWeight: FontWeight.w400,
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

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 12.sp,
                color: valueColor ?? Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
