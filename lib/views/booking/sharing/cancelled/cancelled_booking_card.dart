import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import 'package:mie_admin/utils/extensions.dart';
import 'package:mie_admin/views/booking/sharing/cancelled/refund_dialog.dart';
import '../../../../controllers/booking/sharing/cancelled_controller.dart';
import '../../../../utils/constants.dart';
import 'cancelled_booking_recept.dart';

class CancelledBookingCard extends StatelessWidget {
  final int index;
  CancelledBookingCard({super.key, required this.index});

  final CancelledController controller = Get.find<CancelledController>();
  final RxBool isUpdating = false.obs;

  Map<String, dynamic> get booking => controller.cancelledBookingData[index];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Obx(
          () => IgnorePointer(
            ignoring: isUpdating.value,
            child: Opacity(
              opacity: isUpdating.value ? 0.4 : 1,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    Padding(
                      padding: EdgeInsets.all(12.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoRow('Username :- ',
                                    '${booking["user_details"]['first_name']} ${booking["user_details"]['last_name']}'),
                              ),
                              Text(
                                '${booking["booking_date"]} ${booking['booking_time']}'
                                    .toDateMonthYearTimeFormat(),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: appColor.color6B6B6B,
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                          2.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(
                                      'Pickup Address :- ', booking['source']),
                                  2.verticalSpace,
                                  _buildInfoRow('Drop-off Address :- ',
                                      booking["destination"]),
                                ],
                              )),
                              Container(
                                decoration: BoxDecoration(
                                  color: appColor.greyDarkThemeColor,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                padding:
                                    EdgeInsets.all(2.sp).copyWith(bottom: 0),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4.r),
                                      child: Image.asset(
                                        appIcon.bgperson,
                                        width: 18.w,
                                        height: 18.w,
                                      ),
                                    ),
                                    Text(
                                      '0${booking['total_number_of_people'] ?? 1}',
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    _buildActionButtons()
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(() => isUpdating.value
            ? CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              )
            : SizedBox.shrink())
      ],
    );
  }

  Widget _buildActionButtons() {
    final double totalTripCost =
        double.tryParse(booking['total_trip_cost'].toString()) ?? 0.0;
    final double refundAmount =
        double.tryParse(booking['refund_amount'].toString()) ?? 0.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.sp),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statusButton(
            "Cancel Receipt",
            appColor.greenThemeColor,
            onPressed: () => Get.dialog(CancelReceiptDialog(booking: booking)),
          ),
          14.horizontalSpace,
          if (totalTripCost != refundAmount)
            _statusButton(
              "Refund",
              appColor.greenThemeColor,
              onPressed: () async {
                print(booking);
                var chargedAmount =
                    double.parse(booking['total_trip_cost'].toString()) -
                        double.parse(booking['refund_amount'].toString());
                final result = await Get.dialog(
                  RefundDialog(
                    chargedAmount: chargedAmount,
                  ),
                );

                isUpdating.value = true;
                if (result != null && result["confirmed"] == true) {
                  Map payload = {
                    'booking_id': booking['id'],
                    'refund_amount': result['refund_amount'],
                    'refund_reason': result['refund_reason'],
                  };
                  await controller.refundAmount(payload: payload, index: index);
                  isUpdating.value = false;
                }
              },
            )
          else if ((booking['cancel_by'] ?? '') != 'admin')
            _statusButton("Refund Issued", Colors.white)
        ],
      ),
    );
  }

  Widget _statusButton(String label, Color bgColor, {Function()? onPressed}) {
    return Expanded(
      child: AppButton(
        btnText: label,
        onPressed: onPressed ?? () {},
        textColor: Colors.black,
        backgroundColor: bgColor,
        paddingVertical: 6.5.h,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: label,
              style: TextStyle(
                fontSize: 12.sp,
                color: appColor.blackThemeColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 12.sp,
                color: valueColor ?? appColor.color6B6B6B,
                fontWeight: FontWeight.w400,
              ),
            ),
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
          _buildBookingId(),
          _buildCancelledBy(),
        ],
      ),
    );
  }

  Widget _buildBookingId() {
    return Container(
      decoration: BoxDecoration(
        color: appColor.greenThemeColor,
        borderRadius: BorderRadius.circular(4.5.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h)
          .copyWith(bottom: 2.h),
      child: Text(
        'Booking ID:- ${booking['id']}',
        style: TextStyle(
            fontSize: 12.sp,
            letterSpacing: -0.3,
            color: appColor.blackThemeColor,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildCancelledBy() {
    return Container(
      decoration: BoxDecoration(
        color: appColor.whiteThemeColor,
        borderRadius: BorderRadius.circular(4.5.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h)
          .copyWith(bottom: 2.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Cancelled By :- ',
            style: TextStyle(
                fontSize: 12.sp,
                letterSpacing: -0.3,
                color: appColor.blackThemeColor,
                fontWeight: FontWeight.w700),
          ),
          Text(
            '${booking['cancel_by'].toString().capitalizeFirst}',
            style: TextStyle(
                fontSize: 12.sp,
                letterSpacing: -0.3,
                color: appColor.blackThemeColor,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
