import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../../../controllers/booking/sharing/cancelled_controller.dart';
import '../../../../utils/components/loaders/build_small_loader.dart';
import 'cancelled_booking_card.dart';
import 'cancelled_booking_filer.dart';

class CancelledScreen extends StatefulWidget {
  const CancelledScreen({super.key});

  @override
  State<CancelledScreen> createState() => _CancelledScreenState();
}

class _CancelledScreenState extends State<CancelledScreen> {
  late CancelledController controller;

  @override
  void initState() {
    controller = Get.put(CancelledController(), permanent: false);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<CancelledController>();
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
              if (controller.isLoading.value && controller.currentPage.value == 1) {
                return Center(child: BuildSmallLoader());
              }

              if (controller.cancelledBookingData.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.refreshData,
                  color: appColor.blackThemeColor,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: Get.height * 0.28),
                      Center(
                        child: Text(
                          "No cancelled booking found.",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
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
                  padding: EdgeInsets.only(
                      bottom: (!controller.hasMoreData.value) ? 12.h : 32.h),
                  controller: controller.scrollController,
                  itemCount: controller.cancelledBookingData.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.cancelledBookingData.length) {
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
                    return CancelledBookingCard(index: index);
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
                        controller.getCancelledBooking();
                      },
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 35.h,
            width: 35.h,
            decoration: BoxDecoration(
              color: appColor.whiteThemeColor,
              border: Border.all(color: appColor.greyDarkThemeColor, width: 1),
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                showDialog(
                  context: context,
                  builder: (context) => CancelledBookingFiler(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
