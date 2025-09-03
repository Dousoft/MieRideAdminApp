import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/controllers/booking/sharing/accepted_controller.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import 'package:mie_admin/utils/components/buttons/app_left_icon_button.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/utils/enums/manage_type.dart';
import 'package:mie_admin/utils/extensions.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/components/dialogs/payment_details_dialog.dart';
import '../manage/manage_screen.dart';
import 'accepted_expanded_card.dart';

class AcceptedBookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final int index;

  AcceptedBookingCard({
    super.key,
    required this.booking,
    required this.index,
  });

  final AcceptedController controller = Get.find<AcceptedController>();

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
                Get.to(() => ManageScreen(bookings: _getbooking,type: ManageType.accepted,),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: 300));
              },
            ),
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
                          tipAmount: _getbooking['tip_amount'].toString(),
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
                        child: AcceptedExpandedCard(item: _getbooking),
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
    final timeChoice = {
          'dropoffby': 'Drop Off ',
          'pickupat': 'Pickup ',
        }[_getbooking['time_choice']] ??
        'N/A';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Column(
        spacing: 6.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn('Source City', '${_getbooking['pickup_city']}'),
              _infoColumn('Destination City', '${_getbooking['dropoff_city']}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn('Booking Date',
                  '${_getbooking['first_pickup_date']}'.toFormattedDate()),
              _infoColumn('First Pickup Time',
                  '${_getbooking['first_pickup_time']}'.toFormattedTime()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn(
                'Total Route Time',
                _getbooking['total_trip_time'].toString().toHourMinuteFormat(),
              ),
              Expanded(
                child: Row(
                  children: [
                    _infoColumn(
                      'Time Choice',
                      timeChoice,
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
                            borderRadius: BorderRadius.circular(6.r),
                            child: Image.asset(
                              appIcon.bgperson,
                              width: 20.w,
                              height: 20.w,
                            ),
                          ),
                          Text(
                            '0${_getbooking['total_number_of_people'] ?? 1}',
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
            ],
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
          SizedBox(width: 8.w),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 3.h).copyWith(bottom: 1.h),
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
                      "(${double.parse((booking['driver_rating']??0).toString()).toStringAsFixed(1)})",
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
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h).copyWith(bottom: 5.h),
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
          Text(label, style: TextStyle(fontSize: 13.2.sp,fontWeight: FontWeight.w400, color: appColor.blackThemeColor)),
          Text(
            value,
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700,color: appColor.blackThemeColor),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(11.sp),
      decoration: BoxDecoration(
        color: appColor.color353535,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: appColor.greenThemeColor,
              borderRadius: BorderRadius.circular(4.5.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h)
                .copyWith(bottom: 2.h),
            child: Text(
              'Group ID:- ${_getbooking['group_id']}',
              style: TextStyle(
                  fontSize: 12.5.sp,
                  color: appColor.blackThemeColor,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
