import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/controllers/booking/sharing/completed_controller.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../../../controllers/booking/sharing/manual_controller.dart';
import '../../../../utils/components/loaders/build_small_loader.dart';
import 'completed_booking_card.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  late CompletedController controller;

  @override
  void initState() {
    controller = Get.put(CompletedController(),permanent: false);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<CompletedController>();
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

        if (controller.completedBookingData.isEmpty) {
          return const Center(
            child: Text(
              "No ride completed found.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.only(bottom: (!controller.hasMoreData.value)?12.h:32.h),
          controller: controller.scrollController,
          itemCount: controller.completedBookingData.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.completedBookingData.length) {
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
            return CompletedBookingCard(
                booking: controller.completedBookingData[index]);
          },
        );
      }),
    );
  }
}
