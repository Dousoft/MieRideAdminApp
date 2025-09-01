import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import 'package:mie_admin/utils/components/buttons/app_left_icon_button.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/utils/enums/manage_type.dart';
import 'package:mie_admin/utils/extensions.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controllers/booking/sharing/enroute_controller.dart';
import '../../../../utils/components/dialogs/payment_details_dialog.dart';
import '../manage/manage_screen.dart';
import 'enroute_expanded_card.dart';

class EnrouteBookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final int index;

  EnrouteBookingCard({
    super.key,
    required this.booking,
    required this.index,
  });

  final EnrouteController controller = Get.find<EnrouteController>();

  Map<String, dynamic> get _getbooking => booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: appColor.whiteThemeColor,
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(color: appColor.greyDarkThemeColor, width: 0.5)),
      margin: EdgeInsets.all(10.sp).copyWith(bottom: 2.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildGroupInfo(context),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(context) {
    return Container(
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: appColor.color353535,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12.r),
          ),
        ),
        child: Row(
          spacing: 8.w,
          children: [
            _buildActionButton(
                label: 'Manage',
                onPressed: () {
                  Get.to(
                      () => ManageScreen(
                            bookings: _getbooking,
                            type: ManageType.enroute,
                          ),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 300));
                }),
            _buildActionButton(
                label: 'Payment',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: PaymentDetailsDialog(
                          pMethod: _getbooking['payment_method'] ?? 'Via',
                          person: '${_getbooking['number_of_people'] ?? '1'}',
                          bookingAmount:
                              _getbooking['total_trip_cost'].toString(),
                          surgeAmount:
                              _getbooking['total_extra_charge'].toString(),
                          totalAmount:
                              _getbooking['total_trip_cost'].toString(),
                          adminFee:
                              _getbooking['total_admin_commission'].toString(),
                          driverEarn:
                              _getbooking['total_driver_earning'].toString(),
                        ),
                      );
                    },
                  );
                }),
            _buildActionButton(
                label: 'Route',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: EnrouteExpandedCard(item: _getbooking),
                      );
                    },
                  );
                }),
          ],
        ));
  }

  Widget _buildActionButton(
      {required String label,
      required VoidCallback onPressed,
      String? processingText}) {
    return Expanded(
      child: AppButton(
        backgroundColor: appColor.greenThemeColor,
        textColor: Colors.black,
        btnText: label,
        onPressed: onPressed,
        processingText: processingText,
        paddingVertical: 8.h,
      ),
    );
  }

  Widget _buildGroupInfo(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        spacing: 6.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn('Booking Date',
                  '${_getbooking['first_pickup_date']}'.toFormattedDate()),
              _infoColumn('Booking Time',
                  '${_getbooking['first_pickup_time']}'.toFormattedTime()),
            ],
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 4.h),
            decoration: BoxDecoration(
              color: appColor.blackThemeColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h)
                .copyWith(bottom: 8.h),
            child: Text(
              _getbooking['driver_last_location_update'],
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildDriverDetails(),
          AppLeftIconButton(
            btnText: ' Call Now',
            fontSize: 15.sp,
            paddingVertical: 8.h,
            textColor: Colors.black,
            borderRadius: BorderRadius.circular(8.r),
            backgroundColor: appColor.greenThemeColor,
            onPressed: () {
              _makePhoneCall(booking['driverDetails'] ?? {});
            },
            icon: Icon(Icons.call, size: 20.sp, color: Colors.black),
          )
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(driverDetails) async {
    final countryCode = driverDetails['country_code']?.toString() ?? "91";
    final contact = driverDetails['contact']?.toString() ?? "";
    final phoneNumber = "+$countryCode$contact";
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Widget _buildDriverDetails() {
    final driverDetails = booking['driverDetails'] ?? {};
    return Container(
      margin: EdgeInsets.only(top: 2.h, bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 62.w,
            height: 62.w,
            decoration: BoxDecoration(
                color: appColor.color353535,
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
          SizedBox(width: 8.w),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h)
                      .copyWith(bottom: 1),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    "ID :- ${driverDetails['id']}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
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
                  '${driverDetails['vehicle_name']} (${driverDetails['vehicle_colour']})',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h)
                      .copyWith(bottom: 5.h),
                  decoration: BoxDecoration(
                    color: appColor.color353535,
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

  Widget _infoColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13.2.sp,
                  fontWeight: FontWeight.w400,
                  color: appColor.blackThemeColor)),
          Text(
            value,
            style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: appColor.blackThemeColor),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final timeChoice = {
          'dropoffby': 'Drop Off ',
          'pickupat': 'Pickup ',
        }[_getbooking['time_choice']] ??
        'N/A';
    return Container(
      padding: EdgeInsets.all(11.sp),
      decoration: BoxDecoration(
        color: appColor.color353535,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: appColor.greenThemeColor,
              borderRadius: BorderRadius.circular(4.5.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h)
                .copyWith(bottom: 2.h),
            child: Text(
              'Group ID:- ${_getbooking['group_id']}',
              style: TextStyle(
                  fontSize: 12.5.sp,
                  color: appColor.blackThemeColor,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            timeChoice,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}
