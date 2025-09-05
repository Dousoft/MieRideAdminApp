import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/controllers/booking/sharing/accepted_controller.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/views/booking/sharing/accepted/accepted_booking_card.dart';
import '../../../../utils/components/loaders/build_small_loader.dart';

class AcceptedScreen extends StatefulWidget {
  const AcceptedScreen({super.key});

  @override
  State<AcceptedScreen> createState() => _AcceptedScreenState();
}

class _AcceptedScreenState extends State<AcceptedScreen> {
  late AcceptedController controller;

  @override
  void initState() {
    controller = Get.put(AcceptedController(),permanent: false);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<AcceptedController>();
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

        if (controller.acceptedBookingData.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: appColor.blackThemeColor,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: Get.height * 0.34),
                Center(
                  child: Text(
                    "No accepted booking found.",
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
            itemCount: controller.acceptedBookingData.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.acceptedBookingData.length) {
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
              return AcceptedBookingCard(
                  booking: controller.acceptedBookingData[index],
                  index: index);
            },
          ),
        );
      }),
    );
  }
}
