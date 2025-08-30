import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/controllers/booking/sharing/missed_controller.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../../../utils/components/loaders/build_small_loader.dart';
import 'missed_booking_card.dart';

class MissedScreen extends StatefulWidget {
  const MissedScreen({super.key});

  @override
  State<MissedScreen> createState() => _MissedScreenState();
}

class _MissedScreenState extends State<MissedScreen> {
  late MissedController controller;

  @override
  void initState() {
    controller = Get.put(MissedController(),permanent: false);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<MissedController>();
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

        if (controller.missedBookingData.isEmpty) {
          return const Center(
            child: Text(
              "No accepted booking found.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.only(bottom: (!controller.hasMoreData.value)?12.h:32.h),
          controller: controller.scrollController,
          itemCount: controller.missedBookingData.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.missedBookingData.length) {
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
            return MissedBookingCard(
                booking: controller.missedBookingData[index],
                index: index);
          },
        );
      }),
    );
  }
}
