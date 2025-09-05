import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/controllers/booking/sharing/assigned_controller.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../../../utils/components/loaders/build_small_loader.dart';
import 'assigned_booking_card.dart';
import 'assigned_expanded_card.dart';

class AssignedScreen extends StatefulWidget {
  const AssignedScreen({super.key});

  @override
  State<AssignedScreen> createState() => _AssignedScreenState();
}

class _AssignedScreenState extends State<AssignedScreen> {
  late AssignedController controller;

  @override
  void initState() {
    controller = Get.put(AssignedController(),permanent: false);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<AssignedController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.greyThemeColor,
      body: Obx(() {
        if (controller.isLoading.value && controller.currentPage.value == 1) {
          return Center(child: BuildSmallLoader());
        }

        if (controller.assignedBookingData.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: appColor.blackThemeColor,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: Get.height * 0.34),
                Center(
                  child: Text(
                    "No assigned booking found.",
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
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: (!controller.hasMoreData.value)?12.h:32.h),
            controller: controller.scrollController,
            itemCount: controller.assignedBookingData.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.assignedBookingData.length) {
                if (controller.isLoadingMore.value) {
                  return BuildSmallLoader();
                } else if (!controller.hasMoreData.value) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
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
              return AssignedBookingCard(
                  booking: controller.assignedBookingData[index],
                  index: index);
            },
          ),
        );
      }),
    );
  }
}
