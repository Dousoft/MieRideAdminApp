import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/components/loaders/build_small_loader.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../controllers/root_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final controller = Get.find<RootController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.whiteThemeColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appColor.whiteThemeColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: appColor.greyThemeColor,
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
              'Notifications',
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
      body: Obx(
        () {
          var notificationList = controller.notificationData['data']??[];
          return RefreshIndicator(
          onRefresh: () => controller.getNotificationData(refresh: true),
          color: Colors.black,
          backgroundColor: appColor.greenThemeColor,
          child: controller.isLoading.value
              ? const Center(child: BuildSmallLoader())
              : notificationList.isEmpty
                  ? Center(
                      child: Text(
                        "No notifications found",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(12.w),
                      itemCount: notificationList.length,
                      itemBuilder: (context, index) {
                        final item = notificationList[index];
                        final createdAt =
                            DateTime.tryParse(item['created_at'].toString());
                        final timeAgo = createdAt != null
                            ? timeago.format(createdAt, allowFromNow: true)
                            : "";

                        return Container(
                          margin: EdgeInsets.only(bottom: 15.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item['title'] ?? '',
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          timeAgo,
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      item['message'] ?? '',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        );
        },
      ),
    );
  }
}
