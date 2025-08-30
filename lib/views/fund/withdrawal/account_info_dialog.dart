import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/constants.dart';

class AccountInfoDialog extends StatelessWidget {
  final Map data;
  const AccountInfoDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    bool isIntreac = data['type'].toString() == '0';
    return Container(
      decoration: BoxDecoration(
        color: appColor.blackThemeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(isIntreac),
          Container(
            decoration: BoxDecoration(
              color: appColor.whiteThemeColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            padding: EdgeInsets.only(bottom: 14.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                12.verticalSpace,
                if(isIntreac)...[
                  _infoField("Email Address", data['email'] ?? "", copyable: true),
                ]else ...[
                  _infoField("Bank Name", data['bank_name'] ?? ""),
                  10.verticalSpace,
                  _infoField("Transit Number", data['transit_no'] ?? "", copyable: true),
                  10.verticalSpace,
                  _infoField("Institution Number", data['institution_no'] ?? "", copyable: true),
                  10.verticalSpace,
                  _infoField("Account Number", data['account'] ?? "", copyable: true),
                ],
                10.verticalSpace,
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(3.sp),
                    margin: EdgeInsets.all(10.sp),
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
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(isIntreac) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: appColor.blackThemeColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.r),
        ),
      ),
      alignment: Alignment.center,
      child: Text(isIntreac?'Interac E-Transfer':'Direct Deposit Details',style: TextStyle(color: appColor.whiteThemeColor,fontSize: 12.sp,fontWeight: FontWeight.bold,letterSpacing: 1)),
    );
  }

  Widget _infoField(String label, String value, {bool copyable = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h).copyWith(left: 18.w),
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: appColor.greyThemeColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value.isEmpty ? label : value,
              style: TextStyle(
                fontSize: 14.sp,
                color: value.isEmpty ? Colors.grey : Colors.black,
              ),
            ),
          ),
          if (copyable)
            GestureDetector(
              onTap: () => Clipboard.setData(ClipboardData(text: value)),
              child: Image.asset(appIcon.copy,width: 18.sp,height: 18.sp,),
            ),
        ],
      ),
    );
  }
}

