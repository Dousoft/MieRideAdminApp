import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/controllers/fund/switch_controller.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../../utils/components/loaders/build_small_loader.dart';
import 'switch_card.dart';
import 'switch_filer.dart';

class SwitchScreen extends StatefulWidget {
  SwitchScreen({super.key});

  @override
  State<SwitchScreen> createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  late SwitchController controller;

  @override
  void initState() {
    controller = Get.put(SwitchController(),permanent: false);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<SwitchController>();
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
              if (controller.isLoading.value &&
                  controller.currentPage.value == 1) {
                return BuildSmallLoader();
              }

              if (controller.switchAccountData.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.refreshData,
                  color: appColor.blackThemeColor,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: Get.height * 0.34),
                      Center(
                        child: Text(
                          "No Switch Account found.",
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
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: (!controller.hasMoreData.value)?12.h:32.h),
                  controller: controller.scrollController,
                  itemCount: controller.switchAccountData.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.switchAccountData.length) {
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
                    return SwitchCard(
                        switchAccount: controller.switchAccountData[index],
                        index: index);
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
                        controller.getSwitchAccount();
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
                  builder: (context) => SwitchFiler(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
