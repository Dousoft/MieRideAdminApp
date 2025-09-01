import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/utils/extensions.dart';

class EnrouteExpandedCard extends StatelessWidget {
  final Map item;
  const EnrouteExpandedCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final List pickupPoints = item['pickup_points'] ?? [];
    final List dropoffPoints = item['dropoff_points'] ?? [];
    final String timeChoice = item['time_choice'] ?? '';

    final List<Widget> pickupWidgets = pickupPoints.map((src) {
      final bookingId = src['booking_id'];
      final pickupData = (item['pickupPointsData'] as List?)?.firstWhere(
              (p) => p['booking_id'] == bookingId,
              orElse: () => {}) ??
          {};

      return _buildBookingCardSource(
        bookingId.toString(),
        pickupData['username']?.toString() ?? "Unknown",
        pickupData['source']?.toString() ?? src['place_name'].toString(),
        timeChoice == 'pickupat' ? src['booking_time'].toString() : '',
      );
    }).toList();

    final List<Widget> dropoffWidgets = dropoffPoints.map((dest) {
      final bookingId = dest['booking_id'];
      final dropoffData = (item['dropoffPointsData'] as List?)?.firstWhere(
              (p) => p['booking_id'] == bookingId,
              orElse: () => {}) ??
          {};

      return _buildBookingCardDestination(
        bookingId.toString(),
        dropoffData['username']?.toString() ?? "Unknown",
        dropoffData['destination']?.toString() ?? dest['place_name'].toString(),
        timeChoice == 'dropoffby' ? dest['booking_time'].toString() : '',
      );
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: appColor.greyThemeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.only(bottom: 14.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            12.verticalSpace,
            ...pickupWidgets,
            ...dropoffWidgets,
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
                  size: 40.sp,
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
          Text(' Route',
              style: TextStyle(
                  color: appColor.greenThemeColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h).copyWith(bottom: 2.h),
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

  Widget _buildBookingCardSource(
      String bookingID, String userName, String source, String arrivalTime) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 7.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: appColor.greyDarkThemeColor, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(appIcon.redlocation, width: 25.sp, height: 25.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  child: Text(
                    'Booking ID :- $bookingID',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Username :- ',
                        style: TextStyle(fontSize: 13.sp, color: Colors.black),
                      ),
                      TextSpan(
                        text: userName,
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Source :- ',
                        style: TextStyle(fontSize: 13.sp, color: Colors.black),
                      ),
                      TextSpan(
                        text: source,
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                arrivalTime.toFormattedTime() ?? '',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: appColor.greyDarkThemeColor,
                  borderRadius: BorderRadius.circular(7.r),
                ),
                padding: EdgeInsets.all(3.sp).copyWith(bottom: 0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.r),
                      child: Image.asset(
                        appIcon.bgperson,
                        width: 26.w,
                        height: 26.w,
                      ),
                    ),
                    Text(
                      '0${item['number_of_people'] ?? '1'}',
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBookingCardDestination(String bookingID, String userName,
      String destination, String arrivalTime) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 7.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: appColor.greyDarkThemeColor, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(appIcon.greenlocation, width: 25.sp, height: 25.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                      child: Text(
                        'Booking ID :- $bookingID',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      arrivalTime.toFormattedTime() ?? '',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Username :- ',
                        style: TextStyle(fontSize: 13.sp, color: Colors.black),
                      ),
                      TextSpan(
                        text: userName,
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Destination :- ',
                        style: TextStyle(fontSize: 13.sp, color: Colors.black),
                      ),
                      TextSpan(
                        text: destination,
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
