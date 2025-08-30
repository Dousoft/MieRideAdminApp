import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/components/shimmers/home_shimmer_loader.dart';
import 'package:mie_admin/utils/components/widgets/count_badge.dart';
import 'package:mie_admin/utils/constants.dart';
import '../../controllers/nav/home_controller.dart';
import '../../controllers/root_controller.dart';
import '../../models/dashboard_model.dart';
import '../home/notification_screen.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final rootController = Get.find<RootController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.whiteThemeColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: _buildHeader(context),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 12.sp),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const HomeShimmerLoader();
          } else if (controller.dashBoardData.isEmpty) {
            return Center(
              child: Text(
                "No Data Found",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            );
          }
          return Column(
            spacing: 14.h,
            children: [
              // // User Driver Cards
              _buildUserDriverCards(),

              // Booking Ride Cards
              _buildDashboardCards(
                cards: controller.getBookingRideCards,
                aspectRatio: 1.3,
                borderColor: appColor.orangeThemeColor,
                iconBgColor: const Color(0xffFEF1E4),
              ),

              // shift Ride Cards
              _buildDashboardCards(
                cards: controller.getShiftRideCards,
                aspectRatio: 1.55,
                titleMaxLines: 1,
                titleLetterSpacing: -0.4,
                borderColor: appColor.greenThemeColor,
                iconBgColor: const Color(0xffF9FFDF),
              ),

              // Booking Cards
              _buildDashboardCards(
                cards: controller.getBookingCards,
                aspectRatio: 1.3,
                borderColor: const Color(0xff3B82F6),
                iconBgColor: const Color(0xffE2EDFF),
                iconPadding: EdgeInsets.all(7.sp),
              ),

              // Support & Approval Cards
              _buildDashboardCards(
                cards: controller.getSupportAndApprovalCards,
                aspectRatio: 1.5,
                borderColor: appColor.blackThemeColor,
                iconBgColor: const Color(0xff353535),
                showPercentage: false,
                showSubtitle: false,
              ),

              10.verticalSpace,
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDashboardCards({
    required List<DashboardModel> cards,
    required double aspectRatio,
    Color? containerColor,
    Color? borderColor,
    Color? iconBgColor,
    double? titleLetterSpacing,
    int? titleMaxLines,
    EdgeInsets? iconPadding,
    bool showPercentage = true,
    bool showSubtitle = true,
    double mainAxisSpacing = 16,
  }) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: containerColor ?? appColor.greyThemeColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
          ),
        ],
      ),
      child: GridView.builder(
        itemCount: cards.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: aspectRatio,
        ),
        itemBuilder: (context, index) {
          final card = cards[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: borderColor != null
                  ? Border(bottom: BorderSide(color: borderColor, width: 2.h))
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h)
                .copyWith(right: 1.w, bottom: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3.h,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30.h,
                      height: 30.h,
                      padding: iconPadding ?? EdgeInsets.all(5.sp),
                      decoration: BoxDecoration(
                        color: iconBgColor ?? appColor.greenThemeColor,
                        borderRadius: BorderRadius.circular(7.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(card.icon,
                          color: iconBgColor == const Color(0xff353535)
                              ? Colors.white
                              : null),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        card.value,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(),
                Text(
                  card.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.2,
                    letterSpacing: titleLetterSpacing,
                    color: appColor.blackThemeColor,
                  ),
                  maxLines: titleMaxLines??2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (showPercentage || showSubtitle)
                  Row(
                    children: [
                      Text(
                        "${card.percentage}%  ",
                        style: TextStyle(
                            fontSize: 11.5.sp,
                            letterSpacing: -0.3,
                            color: card.trend == "up"
                                ? Colors.green
                                : card.trend == "down"
                                ? Colors.red
                                : Colors.orange,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(card.subTitle,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                letterSpacing: -0.3,
                                fontSize: 11.sp, color: Colors.grey.shade400)),
                      )
                    ],
                  )
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildUserDriverCards() {
    return GridView.builder(
      padding: EdgeInsets.only(top: 6.h),
      itemCount: controller.getUserDriverCards.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 1.65,
      ),
      itemBuilder: (context, index) {
        final card = controller.getUserDriverCards[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: Offset(3, 3),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h)
              .copyWith(right: 4.w, bottom: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.h,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 30.h,
                    height: 30.h,
                    padding: EdgeInsets.all(5.sp),
                    decoration: BoxDecoration(
                      color: appColor.greenThemeColor,
                      borderRadius: BorderRadius.circular(7.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(card.icon),
                  ),
                  // Icon(card.icon, size: 20.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      card.value,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(),
              Text(
                card.title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: appColor.blackThemeColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Text(
                    "${card.percentage}%  ",
                    style: TextStyle(
                        fontSize: 11.5.sp,
                        color: card.trend == "up"
                            ? Colors.green
                            : card.trend == "down"
                                ? Colors.red
                                : Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(card.subTitle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11.sp, color: Colors.grey.shade400)),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h)
          .copyWith(bottom: 0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(
              appIcon.admin,
              height: 35.h,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome !!',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  '$userName',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          _buildNotificationBell(),
        ],
      ),
    );
  }

  Widget _buildCityDropdown() {
    return Container(
      height: 28.h,
      width: 95.w,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(7.r),
        color: appColor.whiteSecondary,
      ),
      child: DropdownButton<String>(
        value: "Select City",
        icon: Icon(Icons.keyboard_arrow_down, size: 16.sp, color: Colors.black),
        isExpanded: true,
        underline: SizedBox(),
        style: TextStyle(fontSize: 12.sp, color: Colors.black),
        items: const [
          DropdownMenuItem(
            value: "Select City",
            child: Text("Select City"),
          ),
        ],
        onChanged: null, // Disabled for now
      ),
    );
  }

  Widget _buildNotificationBell() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () => Get.to(()=>NotificationScreen(),duration: Duration(milliseconds: 300),transition: Transition.rightToLeft),
          child: Container(
            margin: EdgeInsets.all(6.sp),
            padding: EdgeInsets.all(7.w),
            decoration: BoxDecoration(
              color: appColor.whiteSecondary,
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Image.asset(
              appIcon.notification,
              height: 22.sp,
            ),
          ),
        ),
        Obx(() => CountBadge(count: rootController.notificationData['totalNotificationsCount']??0),),
      ],
    );
  }
}
