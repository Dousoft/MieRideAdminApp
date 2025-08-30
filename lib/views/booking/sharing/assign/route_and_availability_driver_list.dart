import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../../../controllers/booking/sharing/assigne_driver_controller.dart';

class RouteAndAvailabilityDriverList extends StatefulWidget {
  final bool didAllSelect;
  final String type; // "availability" or "route" 

  RouteAndAvailabilityDriverList({
    super.key,
    required this.didAllSelect,
    required this.type,
  });

  @override
  State<RouteAndAvailabilityDriverList> createState() => _RouteAndAvailabilityDriverListState();
}

class _RouteAndAvailabilityDriverListState extends State<RouteAndAvailabilityDriverList> {
  final controller = Get.find<AssignedDriverController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
        controller.selectedDriverIds.clear();
      },
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List drivers = widget.type == "availability"
          ? controller.driverAvailabilities
          : controller.sharedRoutesDetails;

      if (drivers.isEmpty) {
        return Column(
          children: [
            50.verticalSpace,
            Text(
              "No driver available",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        );
      }

      return Column(
        children: [
          // Header
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
                    widget.type == "availability" ? "Driver Availability" : "Driver Routes",
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
                        Obx(() => Checkbox(
                          value: controller.selectedDriverIds.length ==
                              drivers.length,
                          onChanged: (val) {
                            if (val??false) {
                              controller.selectedDriverIds.clear();
                              for (final driver in drivers) {
                                final driverId =
                                driver['driver_details']['id'].toString();
                                controller.selectedDriverIds.add(driverId);
                              }
                            } else {
                              controller.selectedDriverIds.clear();
                            }
                          },
                          checkColor: appColor.blackThemeColor,
                          activeColor: appColor.greenThemeColor,
                          side: const BorderSide(color: Colors.white, width: 2),
                        ))
                      ],
                    )
                ],
              ),
            ),
          ),
          12.verticalSpace,
          Expanded(
            child: ListView.builder(
              itemCount: drivers.length,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final driver = drivers[index];

                return _buildItem(driver);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildItem(driver){
    final driverId = driver['driver_details']['id'].toString();
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
              '$appImageBaseUrl${driver['driver_details']['image']}',
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
                // Driver Name
                Text(
                  '${driver['driver_details']['first_name']}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Vehicle No
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
                        "${driver['driver_details']['vehicle_no']}",
                        style: TextStyle(
                            color: Colors.black, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() => Checkbox(
            checkColor: appColor.greenThemeColor,
            activeColor: Colors.black,
            value: controller.selectedDriverIds.contains(driverId),
            side: const BorderSide(color: Colors.black, width: 2),
            onChanged: (val) {
              if (val??false) {
                controller.selectedDriverIds.add(driverId);
              } else {
                controller.selectedDriverIds.remove(driverId);
              }
            },
          ),),
        ],
      ),
    );
  }
}
