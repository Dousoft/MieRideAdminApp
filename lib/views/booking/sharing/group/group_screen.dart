import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/components/loaders/build_small_loader.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../../../controllers/booking/sharing/group/group_controller.dart';
import 'group_booking_card.dart';

class GroupScreen extends StatefulWidget {
  final String groupType;

  const GroupScreen({super.key, required this.groupType});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  late GroupController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = Get.put(GroupController(groupType: widget.groupType),permanent: false,tag: widget.groupType);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<GroupController>(tag: widget.groupType);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.whiteThemeColor,
      body: Obx(() {
        if (controller.isLoading.value && controller.currentPage.value == 1) {
          return Center(child: BuildSmallLoader());
        }

        if (controller.groupBookingData.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: appColor.blackThemeColor,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: Get.height * 0.34),
                Center(
                  child: Text(
                    "No ride group found.",
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
            itemCount: controller.groupBookingData.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.groupBookingData.length) {
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

              return GroupBookingCard(
                bookings: controller.groupBookingData[index],
                index: index,groupType: widget.groupType);
            },
          ),
        );
      }),
    );
  }
}
