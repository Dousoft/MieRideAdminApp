import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../../controllers/fund/weekly_withdrawal_controller.dart';
import '../../../utils/components/loaders/build_small_loader.dart';
import 'weekly_withdrawal_card.dart';

class WeeklyWithdrawalScreen extends StatefulWidget {
  WeeklyWithdrawalScreen({super.key});

  @override
  State<WeeklyWithdrawalScreen> createState() => _WeeklyWithdrawalScreenState();
}

class _WeeklyWithdrawalScreenState extends State<WeeklyWithdrawalScreen> {
  late WeeklyWithdrawalController controller;

  @override
  void initState() {
    controller = Get.put(WeeklyWithdrawalController(),permanent: false);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<WeeklyWithdrawalController>();
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

              if (controller.weeklyWithdrawalData.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.refreshData,
                  color: appColor.blackThemeColor,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: Get.height * 0.32),
                      Center(
                        child: Text(
                          "No Weekly Withdrawal found.",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshData,
                color: appColor.blackThemeColor,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: controller.scrollController,
                  itemCount: controller.weeklyWithdrawalData.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.weeklyWithdrawalData.length) {
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

                    return WeeklyWithdrawalCard(
                        weeklyWithdrawal: controller.weeklyWithdrawalData[index],
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
                        controller.getWeeklyWithdrawal();
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
