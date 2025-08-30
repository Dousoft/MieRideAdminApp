import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/components/loaders/build_small_loader.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../../../controllers/booking/sharing/assigne_driver_controller.dart';

class ManualAndAllDriverList extends StatefulWidget {
  final bool didAllSelect;
  final String type; // "manual" or "all"

  const ManualAndAllDriverList({
    super.key,
    required this.didAllSelect,
    required this.type,
  });

  @override
  State<ManualAndAllDriverList> createState() => _ManualAndAllDriverListState();
}

class _ManualAndAllDriverListState extends State<ManualAndAllDriverList> {
  final controller = Get.find<AssignedDriverController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.searchKeyController.clear();
        controller.selectedDriverIds.clear();
        controller.currentPage.value = 1;
        controller.getDriverList();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.all(2.sp),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 0.h, 6.w, 0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.type == "manual" ? "Manual Drivers" : "All Drivers",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
              if (widget.didAllSelect)
                Row(
                  children: [
                    Text(
                      "Select All",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                    Obx(() {
                      bool isAllSelected = controller.driverListData.isNotEmpty &&
                        controller.selectedDriverIds.length == controller.driverListData.length;
                    return Checkbox(
                      value: isAllSelected,
                      onChanged: (val)=> controller.toggleSelectAll(controller.driverListData, val??false),
                      checkColor: appColor.blackThemeColor,
                      activeColor: appColor.greenThemeColor,
                      side:
                      const BorderSide(color: Colors.white, width: 2),
                    );
                    })
                  ],
                )
              else
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 28.h,
                    margin: EdgeInsets.symmetric(vertical: 5.h)
                        .copyWith(left: 30.w),
                    decoration: BoxDecoration(
                      color: appColor.whiteThemeColor,
                      border: Border.all(
                          color: appColor.greyDarkThemeColor, width: 1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.search,
                            color: Colors.black54),
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
                              controller.getDriverList();
                            },
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
      12.verticalSpace,
      _buildList()
    ]);
  }

  Widget _buildList() {
    return Obx(
      () {
        final drivers = controller.driverListData;
        if (controller.isDriverListLoading.value &&
            controller.currentPage.value == 1) {
          return Column(
            children: [
              70.verticalSpace,
              BuildSmallLoader(),
            ],
          );
        }

        if (drivers.isEmpty) {
          return Column(
            children: [
              50.verticalSpace,
              Text(
                "No drivers available",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          );
        }
        return Expanded(
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
                bottom: (!controller.hasMoreData.value) ? 12.h : 32.h),
            controller: controller.scrollController,
            itemCount: controller.driverListData.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.driverListData.length) {
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
              final driver = drivers[index];

              return _buildItem(driver);
            },
          ),
        );
      },
    );
  }

  Widget _buildItem(driver) {
    final driverId = driver['id'].toString();
    return Container(
      margin: EdgeInsets.all(2.sp).copyWith(bottom: 10.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundImage: NetworkImage(
              '$appImageBaseUrl${driver['image']}',
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Driver ID
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 1.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: Colors.black87,
                  ),
                  child: Text(
                    'Driver ID :- $driverId',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Text(
                  '${driver['first_name']} ${driver['last_name'] ?? ''}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 1.h, horizontal: 6.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: Colors.white,
                    border:
                    Border.all(color: Colors.grey, width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.directions_car,
                          color: Colors.black, size: 15),
                      SizedBox(width: 4.w),
                      Text(
                        "${driver['vehicle_no'] ?? '--'}",
                        style: TextStyle(
                            color: Colors.black, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(
                () => Checkbox(
              checkColor: appColor.greenThemeColor,
              activeColor: Colors.black,
              value: controller.selectedDriverIds.contains(driverId),
              side: const BorderSide(color: Colors.black, width: 2),
              onChanged: (val) {
                if (val == true) {
                  controller.selectedDriverIds.add(driverId);
                } else {
                  controller.selectedDriverIds.remove(driverId);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
