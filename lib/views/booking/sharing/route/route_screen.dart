import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../../../controllers/booking/sharing/route_controller.dart';
import 'route_booking_card.dart';

class RouteScreen extends StatefulWidget {
  RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  late RouteController controller;

  @override
  void initState() {
    controller = Get.put(RouteController(),permanent: false);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<RouteController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.greyThemeColor,
      body: Obx(() {
        if (controller.isLoading.value && controller.currentPage.value == 1) {
          return Center(child: _buildLoader());
        }

        if (controller.routeBookingData.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: appColor.blackThemeColor,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: Get.height * 0.34),
                Center(
                  child: Text(
                    "No ride route found.",
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
            itemCount: controller.routeBookingData.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.routeBookingData.length) {
                if (controller.isLoadingMore.value) {
                  return _buildLoader();
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
              // return Text(index.toString());

              return RouteBookingCard(
                  route: controller.routeBookingData[index],
                  index: index);
            },
          ),
        );
      }),
    );
  }

  Widget _buildLoader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          height: 20.w,
          width: 20.w,
          child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2.sp,
              )),
        ),
      ],
    );
  }
}
