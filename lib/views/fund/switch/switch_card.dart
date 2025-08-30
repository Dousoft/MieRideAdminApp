import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/controllers/fund/interac_transfer_controller.dart';

import '../../../controllers/fund/switch_controller.dart';

class SwitchCard extends StatelessWidget {
  final Map switchAccount;
  final int index;

  SwitchCard({super.key, required this.switchAccount, required this.index});

  final SwitchController controller = Get.find<SwitchController>();
  final RxBool isUpdating = false.obs;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? driver = switchAccount['driver'];
    final String status = switchAccount['status'] ?? '0';
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
                    _buildHeader(),
                    _buildContents(driver, status),
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

  Widget _buildContents(user, status) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Name :-  ",
                  style: TextStyle(fontSize: 13.sp, color: Colors.black)),
              Text("${user?['first_name'] ?? ''} ${user?['last_name'] ?? ''}",
                  style:
                      TextStyle(fontSize: 13.sp, color: Colors.grey.shade600)),
            ],
          ),
          4.verticalSpace,
          Row(
            children: [
              Text("Switch From :-  ",
                  style: TextStyle(fontSize: 13.sp, color: Colors.black)),
              Text(getMethodName(switchAccount['switch_from']),
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          4.verticalSpace,
          Row(
            children: [
              Text("Switch To. :-  ",
                  style: TextStyle(fontSize: 13.sp, color: Colors.black)),
              Text(getMethodName(switchAccount['switch_to']),
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Color(0xffFFB500),
                      fontWeight: FontWeight.bold)),
            ],
          ),
          if ((switchAccount['driver_account_details']['file'] ?? '').toString().isNotEmpty)
          ...[
            4.verticalSpace,
            Row(
              children: [
                Text("Account :-   ",
                    style: TextStyle(fontSize: 13.sp)),
                GestureDetector(
                  onTap: () => Get.dialog(
                    Dialog(
                      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            constraints: BoxConstraints(minHeight: 210.h,minWidth: double.infinity),
                            decoration: BoxDecoration(
                              color: appColor.whiteThemeColor,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: appColor.greyDarkThemeColor,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  offset: const Offset(0, 4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(10.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                '$appImageBaseUrl${switchAccount['driver_account_details']['file']}',
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return SizedBox(
                                    height: 200.h,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return SizedBox(
                                    height: 200.h,
                                    child: Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 40.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          // Close Button
                          Positioned(
                            top: -10.h,
                            right: -10.w,
                            child: InkWell(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: EdgeInsets.all(5.w),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 22.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  child: Image.asset(
                    appIcon.payment,
                    height: 20.sp,
                  ),
                )
              ],
            )
          ],
          8.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: (status == '1')
                ? _statusButton("Accepted", Color(0xff00A431))
                : (status == '-1')
                    ? _statusButton("Rejected", Color(0xffDD4132))
                    : Row(
                        children: [
                          Expanded(
                              child: _statusButton(
                                  "New Request", Color(0xff3B82F6))),
                          10.horizontalSpace,
                          Expanded(
                            child: PopupMenuButton<int>(
                              onSelected: (value) async {
                                isUpdating.value = true;
                                await controller.updateSwitchAccountStatus(
                                    index: index,
                                    requestId: switchAccount['id'].toString(),
                                    status: value.toString());
                                isUpdating.value = false;
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: Text("Accept",
                                      style: TextStyle(fontSize: 12.sp)),
                                ),
                                PopupMenuItem(
                                  value: -1,
                                  child: Text("Reject",
                                      style: TextStyle(fontSize: 12.sp)),
                                ),
                              ],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              offset: const Offset(0, 30),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Select Action",
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.white),
                                    ),
                                    Icon(
                                      CupertinoIcons.chevron_down,
                                      color: Colors.white,
                                      size: 14.sp,
                                    )
                                  ],
                                ),
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

  String getMethodName(String value) {
    return value == '1' ? "Direct Deposit" : "Interac E-Transfer";
  }

  Widget _buildHeader() {
    final now = DateTime.parse(switchAccount['created_at'].toString());
    final formattedDateTime = DateFormat("dd MMM yyyy (hh:mm a)").format(now);
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
              "Driver ID :- ${switchAccount['driver_id'] ?? 'N/A'}",
              style: TextStyle(fontSize: 13.sp, color: Colors.black),
            ),
          ),
          Text(formattedDateTime,
              style:
                  TextStyle(fontSize: 12.sp, color: appColor.greenThemeColor)),
        ],
      ),
    );
  }

  Widget _statusButton(String label, Color color) {
    return AppButton(
      btnText: label,
      onPressed: () {},
      backgroundColor: color,
      paddingVertical: 6.h,
    );
  }
}
