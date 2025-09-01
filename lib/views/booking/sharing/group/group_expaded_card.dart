import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/extensions.dart';

import '../../../../utils/components/dialogs/payment_details_dialog.dart';
import '../../../../utils/constants.dart';

class GroupExpendedCard extends StatelessWidget {
  final Map<String, dynamic> booking;

  const GroupExpendedCard(this.booking, {super.key});

  @override
  Widget build(BuildContext context) {
    final user = booking['user_details'] ?? {};
    final bookingId = booking['id'].toString();
    final userName = user['first_name'] ?? '';
    final bookingPlaced = booking['confirm_time'] ?? '';
    final bookingTime = booking['booking_time'] ?? '';
    final bookingDate = booking['booking_date'] ?? '';
    final source = booking['source'] ?? '';
    final destination = booking['destination'] ?? '';
    final adminFee = booking['admin_commission'] ?? '0';
    final driverEarn = booking['driver_earning'] ?? '0';
    final surgeAmount = booking['extra_charge'] ?? '0';
    final bookingAmount = booking['booking_amount'] ?? '0';
    final totalAmount = booking['total_trip_cost'] ?? '0';

    return Container(
      margin: EdgeInsets.all(10.sp).copyWith(top: 0),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(bookingId, bookingTime, bookingDate),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 6.h),
                  _buildInfoRow('Username :-  ', userName),
                  SizedBox(height: 3.h),
                  _buildInfoRow('Source :-  ', source),
                  SizedBox(height: 3.h),
                  _buildInfoRow('Destination :-  ', destination),
                  SizedBox(height: 3.h),
                ],
              )),
              Container(
                decoration: BoxDecoration(
                  color: appColor.greyDarkThemeColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                padding: EdgeInsets.all(3.sp).copyWith(bottom: 0),
                child: Column(
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
                      '0${booking['number_of_people'] ?? '1'}',
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
          Row(
            children: [
              Text(
                'Payment :-  ',
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: PaymentDetailsDialog(
                          pMethod: booking['payment_method']??'Via',
                          person: '${booking['number_of_people']??'1'}',
                          totalAmount: totalAmount,
                          adminFee: adminFee,
                          bookingAmount: bookingAmount,
                          driverEarn: driverEarn,
                          surgeAmount: surgeAmount,
                        ),
                      );
                    },
                  );
                },
                child: Image.asset(
                  appIcon.payment,
                  height: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildInfoRow('Booking Placed :-  ',
              bookingPlaced.toString().toMonthYearTimeFormat()),
        ],
      ),
    );
  }

  Widget _buildHeader(
      String bookingId, String bookingTime, String bookingDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: appColor.color353535,
            borderRadius: BorderRadius.circular(5.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.5.h).copyWith(bottom: 1),
          child: Text(
            'Booking ID :- $bookingId',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          bookingDate.toFormattedDate(),
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(fontSize: 12.sp, color: appColor.blackThemeColor),
          ),
          TextSpan(
            text: value,
            style: TextStyle(fontSize: 12.sp, color: appColor.color6B6B6B),
          ),
        ],
      ),
    );
  }
}
