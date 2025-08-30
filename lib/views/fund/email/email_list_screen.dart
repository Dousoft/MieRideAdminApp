import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/controllers/fund/email_list_controller.dart';
import 'package:mie_admin/utils/constants.dart';

import '../../../utils/components/loaders/build_small_loader.dart';
import 'email_card.dart';

class EmailListScreen extends StatefulWidget {
  EmailListScreen({super.key});

  @override
  State<EmailListScreen> createState() => _EmailListScreenState();
}

class _EmailListScreenState extends State<EmailListScreen> {
  late EmailListController controller;

  @override
  void initState() {
    controller = Get.put(EmailListController(),permanent: false);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<EmailListController>();
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

        if (controller.emailListData.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: appColor.blackThemeColor,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: Get.height*0.7, child: Center(
                  child: Text(
                    "No Email found.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: appColor.blackThemeColor,
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: (!controller.hasMoreData.value)?12.h:32.h, top: 10.h),
            controller: controller.scrollController,
            itemCount: controller.emailListData.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.emailListData.length) {
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
              return EmailCard(
                  data: controller.emailListData[index],
                  index: index);
            },
          ),
        );
      }),
    );
  }

}
