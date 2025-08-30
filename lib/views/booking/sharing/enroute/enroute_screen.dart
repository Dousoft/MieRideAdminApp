import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../../../controllers/booking/sharing/enroute_controller.dart';
import '../../../../utils/components/loaders/build_small_loader.dart';
import 'enroute_booking_card.dart';

class EnrouteScreen extends StatefulWidget {
  const EnrouteScreen({super.key});

  @override
  State<EnrouteScreen> createState() => _EnrouteScreenState();
}

class _EnrouteScreenState extends State<EnrouteScreen> {
  late EnrouteController controller;

  @override
  void initState() {
    controller = Get.put(EnrouteController(),permanent: false);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<EnrouteController>();
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
          return const Center(
            child: Text(
              "No enroute booking found.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
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
            return EnrouteBookingCard(
                booking: controller.acceptedBookingData[index],
                index: index);
          },
        );
      }),
    );
  }
}
