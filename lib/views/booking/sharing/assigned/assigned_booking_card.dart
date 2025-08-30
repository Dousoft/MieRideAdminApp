import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/utils/extensions.dart';
import '../../../../controllers/booking/sharing/assigned_controller.dart';
import '../../../../utils/components/dialogs/payment_details_dialog.dart';
import 'accepted_expanded_card.dart';

class AssignedBookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final int index;

  AssignedBookingCard({
    super.key,
    required this.booking,
    required this.index,
  });

  final AssignedController controller = Get.find<AssignedController>();

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
          color: Colors.black,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12.r),
          ),
        ),
        child: Row(
          spacing: 8.w,
          children: [
            _buildActionButton(
                label: 'Drivers',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: AssignedDriverList(
                            drivers: _getbooking['assigned_drivers'] ?? [],
                            groupId: _getbooking['group_id'].toString()),
                      );
                    },
                  );
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
        paddingVertical: 6.h,
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
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
                        spacing: 2,
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
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13.sp)),
          SizedBox(height: 1.h),
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
    return Container(
      padding: EdgeInsets.all(11.sp),
      decoration: BoxDecoration(
        color: appColor.blackThemeColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: appColor.greenThemeColor,
              borderRadius: BorderRadius.circular(4.5.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5),
            child: Text(
              'Group ID:- ${_getbooking['group_id']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          Spacer(),
          Image.asset(
            appIcon.timer,
            width: 18.sp,
            height: 18.sp,
          ),
          4.horizontalSpace,
          AssignmentTimer(
            createdAt: DateTime.now().toString(),
            // AssignmentTimer(createdAt: _getbooking['created_at'].toString(),
            key: ValueKey('${_getbooking['group_id']}'),
          )
        ],
      ),
    );
  }
}
