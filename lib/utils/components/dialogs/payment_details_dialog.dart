import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import 'package:mie_admin/utils/constants.dart';

class PaymentDetailsDialog extends StatelessWidget {
  final String pMethod;
  final String person;
  final String adminFee;
  final String driverEarn;
  final String surgeAmount;
  final String bookingAmount;
  final String totalAmount;

  const PaymentDetailsDialog(
      {super.key,
      required this.pMethod,
      required this.person,
      required this.adminFee,
      required this.driverEarn,
      required this.surgeAmount,
      required this.bookingAmount,
      required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appColor.greyThemeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _paymentRow("No. of Person", '0$person'),
          _paymentRow("Booking Amount", "\$${double.parse(bookingAmount).toStringAsFixed(2)}"),
          _paymentRow("Surge Amount", "\$${double.parse(surgeAmount).toStringAsFixed(2)}"),
          _paymentRow("Total Amount", "\$${double.parse(totalAmount).toStringAsFixed(2)}"),
          _paymentRow("Admin Fee", "\$${double.parse(adminFee).toStringAsFixed(2)}"),
          _paymentRow("Driver Earn", "\$${double.parse(driverEarn).toStringAsFixed(2)}"),
          Divider(height: 35.h, thickness: 1.sp, color: Colors.grey.shade400),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Payment",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\$${double.parse(totalAmount).toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          18.verticalSpace,
          AppButton(
            btnText: 'Paid With ${pMethod.capitalizeFirst}',
            paddingVertical: 8.h,
            fontSize: 13.sp,
            onPressed: () {},
          ),
          25.verticalSpace,
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
    );
  }

  Widget _paymentRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 15.sp)),
          Text(value,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6)),
        ],
      ),
    );
  }
}
