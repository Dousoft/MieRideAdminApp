import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/components/widgets/count_badge.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/utils/extensions.dart';
import '../controllers/root_controller.dart';
import 'nav/account_screen.dart';
import 'nav/home_screen.dart';
import 'nav/my_bookings_screen.dart';
import 'nav/notification_screen.dart';
import 'nav/funds_management_screen.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final RootController _controller = Get.put(RootController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          switch (_controller.selectedIndex.value) {
            case 0:
              return HomeScreen();
            case 1:
              return FundsManagementScreen();
            case 2:
              return MyBookingsScreen();
            case 3:
              return NotificationScreen();
            case 4:
              return AccountScreen();
            default:
              return HomeScreen();
          }
        }),
        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildBottomIcon(
                  imageSrc: appIcon.home,
                  text: "HOME",
                  index: 0,
                ),
                buildBottomIcon(
                  imageSrc: appIcon.wallet,
                  text: "WALLET",
                  index: 1,
                ),
                buildBottomIcon(
                  imageSrc: appIcon.booking,
                  text: "MIE RIDES",
                  index: 2,
                  height: 50.h,
                  width: 50.h,
                  flex: 5,
                  count: _controller.notificationData['totalBookingNotifications']??0
                ),
                buildBottomIcon(
                  imageSrc: appIcon.message,
                  text: "ALERTS",
                  index: 3,
                ),
                buildBottomIcon(
                  imageSrc: appIcon.account,
                  text: "ACCOUNT",
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomIcon({
    required String imageSrc,
    required int index,
    String? text,
    double? height,
    double? width,
    double? iconPadding,
    int? flex,
    dynamic count
  }) {
    final isSelected = _controller.selectedIndex.value == index;

    return Expanded(
      flex: flex ?? 4,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          GestureDetector(
            onTap: () => _controller.changeTab(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(6.sp),
                  height: height ?? 40.h,
                  width: width ?? 40.h,
                  decoration: BoxDecoration(
                    borderRadius: 14.borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: isSelected ? 4 : 5,
                        spreadRadius: 1,
                        inset: isSelected,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(iconPadding ?? 12.sp),
                    child: Image.asset(
                      imageSrc,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
         if(!isSelected) CountBadge(count: count??0,)
        ],
      ),
    );
  }
}
