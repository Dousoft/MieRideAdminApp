import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/booking/sharing/assigne_driver_controller.dart';
import '../../../../utils/tabs/app_custom_tab.dart';
import 'manual_and_all_driver_list.dart';
import 'route_and_availability_driver_list.dart';

class AssignDriverScreen extends StatefulWidget {
  final String groupId;

  const AssignDriverScreen({
    super.key,
    required this.groupId,
  });

  @override
  State<AssignDriverScreen> createState() => _AssignDriverScreenState();
}

class _AssignDriverScreenState extends State<AssignDriverScreen> {
  late AssignedDriverController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = Get.put(AssignedDriverController(groupId: widget.groupId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: appColor.greyThemeColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: appColor.greyThemeColor,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  Text(
                    'Assign Driver',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(width: 35.w),
                ],
              ),
            ),
            body: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                );
              }

              if (controller.routeDetails.isEmpty) {
                return const Center(
                    child: Text("No assigned details available"));
              }

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTopCards(),
                            16.verticalSpace,
                            _buildCenterCard(),
                            8.verticalSpace,
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: _buildTabsBar(),
              );
            }),
            bottomNavigationBar: Container(
              height: 42.h,
              margin: EdgeInsets.all(16.sp).copyWith(top: 10),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(3, 4),
                    blurRadius: 8)
              ]),
              child: AppButton(
                btnText: 'Submit',
                processingText: 'Assigning to drivers...',
                onPressed: () => controller.assignDriver(
                    rootId: controller.routeDetails['id'].toString()),
                backgroundColor: appColor.greenThemeColor,
                textColor: Colors.black,
                paddingVertical: 10.h,
                fontSize: 16.sp,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
        Obx(
          () {
            if (controller.isAssignedLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        )
      ],
    );
  }

  Widget _buildCenterCard() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
          color: appColor.whiteThemeColor,
          borderRadius: BorderRadius.circular(14.r)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: appColor.greyThemeColor,
                borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              children: [
                Obx(() => Checkbox(
                      checkColor: appColor.greenThemeColor,
                      activeColor: Colors.black,
                      side: BorderSide(color: Colors.black, width: 2.w),
                      value: controller.isExtraCharges.value,
                      onChanged: (val) {
                        controller.isExtraCharges.value = val!;
                        if (!val) {
                          controller.extraChargeController.clear();
                        }
                      },
                    )),
                Text('Extra charges', style: TextStyle(fontSize: 14.sp)),
                const Spacer(),
                Obx(() => Container(
                  margin: EdgeInsets.all(6),
                  width: 70.w,
                  height: 36.h,
                  child: TextField(
                    controller: controller.extraChargeController,
                    enabled: controller.isExtraCharges.value,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '\$00',
                      filled: true,
                      fillColor: appColor.whiteThemeColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(8.r),
                    ),
                  ),
                ),),
              ],
            ),
          ),
          10.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color: appColor.greyThemeColor,
                borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              children: [
                Obx(() => Checkbox(
                      checkColor: appColor.greenThemeColor,
                      activeColor: Colors.black,
                      side: BorderSide(color: Colors.black, width: 2.w),
                      value: controller.isIncreasePickupTime.value,
                      onChanged: (val) {
                        controller.isIncreasePickupTime.value = val!;
                        if (!val) {
                          controller.pickupTimeController.clear();
                        }
                      },
                    )),
                Text('Increase Pickup Time', style: TextStyle(fontSize: 14.sp)),
                const Spacer(),
                Obx(() => Container(
                  margin: EdgeInsets.all(6),
                  width: 70.w,
                  height: 36.h,
                  child: TextField(
                    controller: controller.pickupTimeController,
                    enabled: controller.isIncreasePickupTime.value,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'min.',
                      filled: true,
                      fillColor: appColor.whiteThemeColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(8.r),
                    ),
                  ),
                ),),
              ],
            ),
          ),
          10.verticalSpace,
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  isDense: true,
                  hint: Text('Vehicle Size', style: TextStyle(fontSize: 14.sp)),
                  items: const [
                    DropdownMenuItem(
                      value: '4 Seater',
                      child: Text('4 Seater'),
                    ),
                    DropdownMenuItem(
                      value: '6 Seater',
                      child: Text('6 Seater'),
                    ),
                  ],
                  onChanged: (val) {},
                  icon: Icon(
                    CupertinoIcons.chevron_down,
                    size: 16.sp,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: appColor.greyThemeColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 16.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCard(
          color: appColor.blackThemeColor,
          children: [
            Text("Total Driver",
                style: TextStyle(
                    color: appColor.greenThemeColor, fontSize: 13.sp)),
            10.verticalSpace,
            Text("\$${controller.routeDetails['total_trip_amount']}",
                style: TextStyle(
                    color: appColor.greenThemeColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        8.horizontalSpace,
        _buildCard(
          color: appColor.greenThemeColor,
          children: [
            Text("First Pickup\nTime",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: appColor.blackThemeColor, fontSize: 13.sp)),
            5.verticalSpace,
            Text("${controller.routeDetails['first_pickup_time']}",
                style: TextStyle(
                    color: appColor.blackThemeColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        8.horizontalSpace,
        _buildCard(
          color: appColor.blackThemeColor,
          children: [
            Text(
              'Pending...',
              style: TextStyle(color: appColor.greenThemeColor),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildCard({required Color color, required List<Widget> children}) {
    return Expanded(
      child: Container(
        height: 90.h,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 2), blurRadius: 5)
            ]),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  Widget _buildTabsBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AppCustomTab(
        selectedLabelColor: appColor.whiteThemeColor,
        unSelectedLabelColor: appColor.blackThemeColor,
        tabBackGroundColor: appColor.greyThemeColor,
        indicatorSelectedColor: appColor.blackThemeColor,
        indicatorUnSelectedColor: appColor.greyDarkThemeColor,
        tabTitles: [
          'Route',
          'Availability',
          'Manual',
          'All',
        ],
        tabViews: [
          RouteAndAvailabilityDriverList(didAllSelect: true, type: "route"),
          RouteAndAvailabilityDriverList(
              didAllSelect: true, type: "availability"),
          ManualAndAllDriverList(didAllSelect: false, type: "manual"),
          ManualAndAllDriverList(didAllSelect: true, type: "all"),
        ],
        decoratedBoxRadius: 0,
        indicatorRadius: 20.r,
      ),
    );
  }
}
