import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/controllers/fund/weekly_withdrawal_controller.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/views/fund/Weekly/confirm_withdrawal_dialog.dart';

import '../withdrawal/account_info_dialog.dart';

class WeeklyWithdrawalCard extends StatelessWidget {
  final Map weeklyWithdrawal;
  final int index;

  WeeklyWithdrawalCard(
      {super.key, required this.weeklyWithdrawal, required this.index});

  final controller = Get.find<WeeklyWithdrawalController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appColor.whiteThemeColor,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(
          color: appColor.greyDarkThemeColor,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildContents(context),
        ],
      ),
    );
  }

  Widget _buildContents(context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(
                  label: "Name :-  ",
                  value: "${weeklyWithdrawal['name'] ?? ''}",
                ),
                4.verticalSpace,
                _infoRow(
                  label: "Total Amount :- ",
                  value: "\$${weeklyWithdrawal['wallet_balance']}",
                  boldValue: true,
                ),
                4.verticalSpace,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2).copyWith(bottom: 0),
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: appColor.greyDarkThemeColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Payable Amount :- ',
                        style: TextStyle(fontSize: 11.5.sp, color: appColor.blackThemeColor),
                      ),
                      Text(
                        "\$${double.parse(weeklyWithdrawal['total_payable_till_last_sunday']??0.toString()).toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _statusButton(
                  'Account Info',
                  appColor.blackThemeColor,
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding:
                                EdgeInsets.symmetric(horizontal: 24.w),
                            // same as quick withdrawal ui so i use it
                            child: AccountInfoDialog(
                                data:
                                    weeklyWithdrawal['driver_account_details']),
                          );
                        });
                  },
                ),
                6.verticalSpace,
                _statusButton(
                  "Pay",
                  Color(0xff00A431),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding:
                            EdgeInsets.symmetric(horizontal: 24.w),
                            child: ConfirmWithdrawalDialog(
                                data: weeklyWithdrawal,index: index,),
                          );
                        });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoRow({
    required String label,
    required String value,
    bool boldValue = false,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: appColor.blackThemeColor),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            color: appColor.color6B6B6B,
            fontWeight: boldValue ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: appColor.greenThemeColor,
              borderRadius: BorderRadius.circular(4.5.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h)
                .copyWith(bottom: 2.h),
            child: Text(
              "Driver ID :- ${weeklyWithdrawal['id'] ?? 'N/A'}",
              style: TextStyle(
                  fontSize: 13.sp,
                  color: appColor.blackThemeColor,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Text('${weeklyWithdrawal['contact']}',
              style:
                  TextStyle(fontSize: 12.sp, color: appColor.whiteThemeColor,fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _statusButton(String label, Color color,
      {required Function()? onPressed}) {
    return AppButton(
      btnText: label,
      borderRadius: BorderRadius.circular(5.r),
      onPressed: onPressed,
      backgroundColor: color,
      fontSize: 11.sp,
      paddingVertical: 7.h,
    );
  }
}
