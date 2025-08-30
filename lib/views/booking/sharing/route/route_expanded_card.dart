import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/utils/extensions.dart';

class RouteExpandedCard extends StatelessWidget {
  final Map item;
  const RouteExpandedCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final List source = item['pickup_points'];
    final List destination = item['dropoff_points'];
    final String timeChoice = item['time_choice']??'';

    final List<Widget> sourceWidgets = source
        .where((src) => src['booking'] != null)
        .map((src) => _buildBookingCardSource(
      src['booking']['id'].toString(),
      src['booking']['username'].toString(),
      src['booking']['source'].toString(),
      timeChoice == 'pickupat' ? src['booking']['booking_time'].toString() : '',
      src['booking']['number_of_people']??'1',
    ))
        .toList();

    final List<Widget> destinationWidgets = destination
        .where((dest) => dest['booking'] != null)
        .map((dest) => _buildBookingCardDestination(
      dest['booking']['id'].toString(),
      dest['booking']['username'].toString(),
      dest['booking']['destination'].toString(),
      timeChoice == 'dropoffby' ? dest['booking']['booking_time'].toString() : '',
    ))
        .toList();

    return Column(
      children: [
        ...sourceWidgets,
        ...destinationWidgets,
      ],
    );
  }

  Widget _buildBookingCardSource(String bookingID, String userName, String source, String arrivalTime, String people) {
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  child: Text(
                    'Booking ID :- $bookingID',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.end,
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
                  borderRadius: BorderRadius.circular(5.r),
                ),
                padding: EdgeInsets.all(3.sp).copyWith(bottom: 0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.r),
                      child: Image.asset(
                        appIcon.bgperson,
                        width: 20.w,
                        height: 20.w,
                      ),
                    ),
                    Text(
                      '0$people',
                      style: TextStyle(
                          fontSize: 14.sp,
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

  Widget _buildBookingCardDestination(String bookingID, String userName, String destination, String arrivalTime) {
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
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      child: Text(
                        'Booking ID :- $bookingID',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.white,
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

