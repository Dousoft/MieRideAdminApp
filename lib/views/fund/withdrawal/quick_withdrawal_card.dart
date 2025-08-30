import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mie_admin/controllers/fund/quick_withdrawal_controller.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import 'package:mie_admin/utils/constants.dart';
import 'account_info_dialog.dart';

class QuickWithdrawalCard extends StatelessWidget {
  final Map quickWithdrawal;
  final int index;

  QuickWithdrawalCard(
      {super.key, required this.quickWithdrawal, required this.index});

  final controller = Get.find<QuickWithdrawalController>();
  final RxBool isUpdating = false.obs;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? driver = quickWithdrawal['driver_details'];

    final DateTime? dateTime =
        DateTime.tryParse('${quickWithdrawal['created_at']}');

    final formattedDate = dateTime != null
        ? DateFormat('dd MMM, yyyy (hh:mm a)').format(dateTime)
        : 'N/A';

    final String status = quickWithdrawal['status'] ?? '0';

    return Stack(
      alignment: Alignment.center,
      children: [
        Obx(
          () => IgnorePointer(
            ignoring: isUpdating.value,
            child: Opacity(
              opacity: isUpdating.value ? 0.4 : 1,
              child: Container(
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
                    _buildHeader(driver, formattedDate),
                    _buildContents(driver, status, context),
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

  Widget _buildContents(user, status, context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Column(
              children: [
                _infoRow(
                  label: "Name :-  ",
                  value: "${user?['first_name'] ?? ''} ${user?['last_name'] ?? ''}",
                ),
                2.verticalSpace,
                _infoRow(
                  label: "Total Wallet Amt. :- ",
                  value: "\$${quickWithdrawal['wallet']}",
                  boldValue: true,
                ),
                2.verticalSpace,
                _infoRow(
                  label: "Requested Amt. :- ",
                  value: "\$${quickWithdrawal['transfer_amount']}",
                  boldValue: true,
                ),
                2.verticalSpace,
                _infoRow(
                  label: "Transaction Fee :- ",
                  value: "\$${quickWithdrawal['transfer_fee']}",
                  boldValue: true,
                ),
                2.verticalSpace,
                _infoRow(
                  label: "Total Transfer amt. :- ",
                  value: "\$${quickWithdrawal['transfer_amount']}",
                  boldValue: true,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _statusButton(context),
                10.verticalSpace,
                PopupMenuButton<int>(
                  onSelected: (value) async {
                    isUpdating.value = true;
                    await controller.updateQuickWithdrawalStatus(
                        index: index,
                        requestId: quickWithdrawal['id'].toString(),
                        status: value.toString());
                    isUpdating.value = false;
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text("Accept", style: TextStyle(fontSize: 12.sp)),
                    ),
                    PopupMenuItem(
                      value: -1,
                      child: Text("Reject", style: TextStyle(fontSize: 12.sp)),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  offset: const Offset(0, 30),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select Action",
                          style:
                              TextStyle(fontSize: 12.sp, color: Colors.white),
                        ),
                        Icon(
                          CupertinoIcons.chevron_down,
                          color: Colors.white,
                          size: 14.sp,
                        )
                      ],
                    ),
                  ),
                )
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
          style: TextStyle(fontSize: 13.sp, color: Colors.black),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey.shade600,
            fontWeight: boldValue ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(user, formattedDate) {
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
          Container(
            decoration: BoxDecoration(
              color: appColor.greenThemeColor,
              borderRadius: BorderRadius.circular(4.5.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
            child: Text(
              "Driver ID :- ${user?['id'] ?? 'N/A'}",
              style: TextStyle(fontSize: 13.sp, color: Colors.black),
            ),
          ),
          Text(formattedDate,
              style:
                  TextStyle(fontSize: 12.sp, color: appColor.greenThemeColor)),
        ],
      ),
    );
  }

  Widget _statusButton(context) {
    return AppButton(
      btnText: "Account Info",
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AccountInfoDialog(data: quickWithdrawal['driver_account_details']),
              );
            });
      },
      backgroundColor: Color(0xff00A431),
      paddingVertical: 6.h,
    );
  }
}
