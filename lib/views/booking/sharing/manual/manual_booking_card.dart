import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/utils/enums/manage_type.dart';
import 'package:mie_admin/utils/extensions.dart';
import '../../../../controllers/booking/sharing/manual_controller.dart';
import '../../../../utils/components/dialogs/payment_details_dialog.dart';
import '../assign/assigned_driver_screen.dart';
import '../manage/manage_screen.dart';
import 'manual_expanded_card.dart';

class ManualBookingCard extends StatelessWidget {
  final Map<String, dynamic> route;
  final int index;

  ManualBookingCard({
    super.key,
    required this.route,
    required this.index,
  });

  final ManualController controller = Get.find<ManualController>();

  Map<String, dynamic> get _getRoute => route;

  @override
  Widget build(BuildContext context) {
    print(route);
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
          color: Colors.black,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12.r),
          ),
        ),
        child: Row(
          spacing: 8.w,
          children: [
            _buildActionButton(
                label: 'Assign Driver',
                onPressed: () {
                  Get.to(
                      () => AssignDriverScreen(
                          groupId: '${_getRoute['group_id']}'),
                      duration: Duration(milliseconds: 250),
                      transition: Transition.rightToLeft);
                },
                flex: 3),
            _buildActionButton(label: 'Manage', onPressed: () {
              Get.to(
                      () => ManageScreen(
                    bookings: route,
                        type: ManageType.manual,
                  ),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 300));
            }, flex: 2),
            _buildActionButton(
                label: 'Route',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: ManualExpandedCard(item: _getRoute),
                      );
                    },
                  );
                },
                flex: 2),
          ],
        ));
  }

  Widget _buildActionButton(
      {required String label,
      required VoidCallback onPressed,
      String? processingText,
      flex}) {
    return Expanded(
      flex: flex,
      child: AppButton(
        backgroundColor: appColor.greenThemeColor,
        textColor: Colors.black,
        btnText: label,
        onPressed: onPressed,
        processingText: processingText,
        paddingVertical: 6.h,
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
              _infoColumn('Source City',
                  '${_getRoute['pickup_city']}'),
              _infoColumn('Destination City',
                  '${_getRoute['dropoff_city']}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn('Booking Date',
                  '${_getRoute['first_pickup_date']}'.toFormattedDate()),
              _infoColumn('First Pickup Time',
                  '${_getRoute['first_pickup_time']}'.toFormattedTime()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn(
                  'Total Route Time',
                  _getRoute['total_trip_time'].toString().toHourMinuteFormat(),
                  ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment', style: TextStyle(fontSize: 13.sp)),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    insetPadding:
                                        EdgeInsets.symmetric(horizontal: 24.w),
                                    child: PaymentDetailsDialog(
                                      pMethod: _getRoute['payment_method']??'Via',
                                      person: '${_getRoute['number_of_people']??'1'}',
                                      bookingAmount:
                                          _getRoute['total_trip_cost'].toString(),
                                      surgeAmount:
                                          _getRoute['total_extra_charge'].toString(),
                                      totalAmount:
                                          _getRoute['total_trip_cost'].toString(),
                                      adminFee: _getRoute['total_admin_commission']
                                          .toString(),
                                      driverEarn: _getRoute['total_driver_earning']
                                          .toString(),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Image.asset(
                              appIcon.payment,
                              width: 25.sp,
                              height: 25.sp,
                            ),
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
                            '0${_getRoute['total_number_of_people'] ?? 1}',
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
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13.5.sp)),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final timeChoice = {
          'dropoffby': 'Drop Off ',
          'pickupat': 'Pickup ',
        }[_getRoute['time_choice']] ??
        'N/A';
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
          _buildGroupIdChip(),
          Text(timeChoice,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1))
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
        'Group ID:- ${_getRoute['group_id']}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }
}
