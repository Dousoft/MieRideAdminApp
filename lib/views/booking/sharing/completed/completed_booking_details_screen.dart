import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/constants.dart';

class CompletedBookingDetailsScreen extends StatelessWidget {
  final Map booking;
  const CompletedBookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.greyThemeColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appColor.greyThemeColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 16.sp,
                ),
              ),
            ),
            Text(
              booking.isNotEmpty
                  ? "Group ID :- ${booking['group_id']}"
                  : "Group Details",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
            SizedBox(width: 35.w),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(13.sp),
        child: Column(
          spacing: 15.h,
          children: [
            _buildDriverDetails(),
            Container(
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
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 7.h,
                children: [
                  Text(
                    'Payment Details',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      _infoColumn('Booking Amount',
                          '\$${booking['total_trip_cost']}', 3),
                      _infoColumn('Admin Fee',
                          '\$${booking['total_admin_commission']}', 2),
                    ],
                  ),
                  Row(
                    children: [
                      _infoColumn('Surge Amount',
                          '\$${booking['total_extra_charge'] ?? 0}', 3),
                      _infoColumn('Driver Earn',
                          '\$${booking['total_driver_earning'] ?? 0}', 2),
                    ],
                  ),
                  Row(
                    children: [
                      _infoColumn('Total Amount',
                          '\$${booking['total_trip_cost'] ?? 0}', 3),
                      if (booking['tip_amount'] != null &&
                          booking['tip_amount'].toString() != '0' &&
                          booking['tip_amount'].toString() != 'null')
                        _infoColumn(
                            'Tip Amount', '\$${booking['tip_amount'] ?? 0}', 2),
                    ],
                  ),
                ],
              ),
            ),
            _buildBookingCards()
          ],
        ),
      ),
    );
  }

  Widget _buildDriverDetails() {
    final driverDetails = booking['driverDetails'] ?? {};
    return Container(
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
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.sp),
      child: Row(
        children: [
          Container(
            width: 62.w,
            height: 62.w,
            decoration: BoxDecoration(
                color: appColor.greyThemeColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2))
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                '$appImageBaseUrl${driverDetails['image'] ?? ''}',
                width: 62.w,
                height: 62.w,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 62.w,
                      height: 62.w,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 62.w,
                    height: 62.w,
                    color: appColor.greyThemeColor,
                    child: Image.asset(
                      appIcon.driver,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    "ID :- ${driverDetails['id']}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                1.verticalSpace,
                Text(
                  '${driverDetails['first_name']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  spacing: 2.w,
                  children: [
                    Text(
                      "(${double.parse((booking['driver_rating'] ?? 0).toString()).toStringAsFixed(1)})",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Icon(Icons.star, size: 14.sp, color: Colors.black),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              spacing: 5.h,
              children: [
                Text(
                  '${driverDetails['vehicle_brand']} (${driverDetails['vehicle_colour']})',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${driverDetails['vehicle_no']}',
                    style: TextStyle(
                      color: appColor.greenThemeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value, int flex) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
          Text(
            value,
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCards() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.sp),
      decoration: BoxDecoration(
        color: appColor.whiteThemeColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: (booking['pickup_points'] ?? []).map<Widget>((booking) {
          return _buildBookingCard(booking['booking']);
        }).toList(),
      ),
    );
  }

  Widget _buildBookingCard(Map data) {
    print(data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: appColor.whiteThemeColor,
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
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: appColor.blackThemeColor,
                    borderRadius: BorderRadius.circular(4.r),
                    border:
                        Border.all(color: Colors.grey.shade400, width: 0.6.sp),
                  ),
                  child: Text(
                    "Booking ID :- ${data['id']}",
                    style: TextStyle(
                      color: appColor.whiteThemeColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Username :- ',
                      style: TextStyle(
                          fontFamily: appFont,
                          color: appColor.blackThemeColor,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '${data['username']}',
                      style: TextStyle(
                        fontFamily: appFont,
                        color: appColor.blackThemeColor,
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
                      text: 'Source :- ',
                      style: TextStyle(
                          fontFamily: appFont,
                          color: appColor.blackThemeColor,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '${data['source']}',
                      style: TextStyle(
                        fontFamily: appFont,
                        color: appColor.blackThemeColor,
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
                          color: appColor.blackThemeColor,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '${data['destination']}',
                      style: TextStyle(
                        fontFamily: appFont,
                        color: appColor.blackThemeColor,
                        fontSize: 12.5.sp,
                      ),
                    ),
                  ]),
                ),
                1.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Booking Amount :- ",
                      style: TextStyle(
                          color: appColor.blackThemeColor,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: appColor.blackThemeColor,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 6.w)
                          .copyWith(top: 1),
                      child: Text(
                        '\$${data["booking_amount"]}',
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
                  '0${data['number_of_people'] ?? 1}',
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
    );
  }
}
