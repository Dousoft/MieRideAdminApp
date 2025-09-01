import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../../controllers/fund/quick_withdrawal_controller.dart';
import '../../../utils/components/loaders/build_small_loader.dart';
import 'quick_withdrawal_card.dart';

class QuickWithdrawalScreen extends StatefulWidget {
  QuickWithdrawalScreen({super.key});

  @override
  State<QuickWithdrawalScreen> createState() => _QuickWithdrawalScreenState();
}

class _QuickWithdrawalScreenState extends State<QuickWithdrawalScreen> {
  late QuickWithdrawalController controller;

  @override
  void initState() {
    controller = Get.put(QuickWithdrawalController(),permanent: false);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<QuickWithdrawalController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.greyThemeColor,
      body: Column(
        children: [
          _buildFilerSearchBar(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.currentPage.value == 1) {
                return BuildSmallLoader();
              }

              if (controller.quickWithdrawalData.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.refreshData,
                  color: appColor.blackThemeColor,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: Get.height*0.6, child: Center(
                        child: Text(
                          "No Quick Withdrawal found.",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      )),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshData,
                color: appColor.blackThemeColor,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: (!controller.hasMoreData.value)?12.h:32.h),
                  controller: controller.scrollController,
                  itemCount: controller.quickWithdrawalData.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.quickWithdrawalData.length) {
                      if (controller.isLoadingMore.value) {
                        return BuildSmallLoader();
                      } else if (!controller.hasMoreData.value) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.sp),
                          child: Center(
                            child: Text(
                              "No more data",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }

                    if (controller.quickWithdrawalData[index]['driver_details'] ==
                        null) {
                      return _riderDetailsNotFound(
                          controller.quickWithdrawalData[index]);
                    }

                    return QuickWithdrawalCard(
                        quickWithdrawal: controller.quickWithdrawalData[index],
                        index: index);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _riderDetailsNotFound(request) {
    return Container(
      padding: EdgeInsets.all(11.sp),
      margin: EdgeInsets.symmetric(horizontal: 12.w,vertical: 6.h),
      decoration: BoxDecoration(
        color: appColor.blackThemeColor,
        borderRadius: BorderRadius.all(Radius.circular(8.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.redAccent.shade200,
              borderRadius: BorderRadius.circular(4.5.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
            child: Text(
              "Request ID :- ${request?['id'] ?? 'N/A'}",
              style: TextStyle(fontSize: 13.sp, color: Colors.black),
            ),
          ),
          Text('Driver Details Not Found',
              style: TextStyle(
                  fontSize: 13.sp,
                  color: appColor.whiteThemeColor,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFilerSearchBar(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w).copyWith(top: 2),
            height: 35.h,
            decoration: BoxDecoration(
              color: appColor.greyThemeColor,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Obx(() => Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Payout:- ',
                    style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                  ),
                  TextSpan(
                    text: '\$${double.parse(controller.overallPendingPayoutAmount.value).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 13.sp, color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),),
          ),
          10.horizontalSpace,
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 35.h,
              decoration: BoxDecoration(
                color: appColor.whiteThemeColor,
                border:
                Border.all(color: appColor.greyDarkThemeColor, width: 1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/home/search.png',
                    width: 22.sp,
                    height: 22.sp,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                      controller: controller.searchKeyController,
                      onChanged: (value) {
                        controller.currentPage.value = 1;
                        controller.getQuickWithdrawal();
                      },
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
