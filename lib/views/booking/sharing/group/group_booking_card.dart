import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/components/buttons/app_left_icon_button.dart';
import 'package:mie_admin/utils/components/dialogs/app_dialog.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/utils/extensions.dart';
import '../../../../controllers/booking/sharing/group/group_controller.dart';
import 'group_expaded_card.dart';
import 'manage/manage_group_screen.dart';

class GroupBookingCard extends StatefulWidget {
  final String groupType;
  final List bookings;
  final int index;

  const GroupBookingCard({
    super.key,
    required this.bookings,
    required this.groupType,
    required this.index,
  });

  @override
  State<GroupBookingCard> createState() => _GroupBookingCardState();
}

class _GroupBookingCardState extends State<GroupBookingCard>
    with SingleTickerProviderStateMixin {
  late GroupController controller;

  bool _expanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.find<GroupController>(tag: widget.groupType);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _firstBooking => widget.bookings.first;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: appColor.greyThemeColor,
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(color: appColor.greyDarkThemeColor, width: 0.5)),
      margin: EdgeInsets.all(10.sp).copyWith(bottom: 2.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildGroupInfo(),
          _buildExpandableContent(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(11.sp),
      decoration: BoxDecoration(
        color: appColor.color353535,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGroupIdChip(),
          _buildExpandButton(),
        ],
      ),
    );
  }

  Widget _buildGroupIdChip() {
    return Container(
      decoration: BoxDecoration(
        color: appColor.greenThemeColor,
        borderRadius: BorderRadius.circular(4.5.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h)
          .copyWith(bottom: 3),
      child: Text(
        'Group ID:- ${_firstBooking['group_id']}',
        style: TextStyle(
            fontSize: 12.5.sp,
            color: appColor.blackThemeColor,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildExpandButton() {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _expanded ? 'View Less' : 'View More',
              style: TextStyle(
                fontSize: 11.5.sp,
                decoration: TextDecoration.underline,
                decorationColor: appColor.greenThemeColor,
                color: appColor.greenThemeColor,
              ),
            ),
            const SizedBox(width: 2),
            AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: appColor.greenThemeColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                    'Source City', _firstBooking['source_city'] ?? 'N/A'),
                _buildInfoRow('Destination City',
                    _firstBooking['destination_city'] ?? 'N/A'),
                _buildInfoRow(
                    'Booking Date',
                    '${_firstBooking['booking_date']}'.toFormattedDate()),
                _buildInfoRow(
                    'Time Choice',
                    _getFormattedTimeChoice(
                        _firstBooking['time_choice'].toString())),
              ],
            ),
          ),
          if(!_expanded)Container(
            decoration: BoxDecoration(
              color: appColor.greyDarkThemeColor,
              borderRadius: BorderRadius.circular(5.r),
            ),
            padding: EdgeInsets.all(3.sp).copyWith(bottom: 0),
            child: Column(
              spacing: 2,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: Image.asset(
                    appIcon.bgperson,
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
                Text(
                  '0${_firstBooking['total_number_of_people'] ?? 1}',
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label :-  ',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: appColor.blackThemeColor,
              fontSize: 13.sp,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: appColor.color6B6B6B,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedTimeChoice(String timeChoice) {
    switch (timeChoice.toLowerCase()) {
      case 'pickupat':
        return 'Pickup';
      case 'dropoffby':
        return 'Drop Off';
      default:
        return timeChoice;
    }
  }

  Widget _buildExpandableContent() {
    return SizeTransition(
      sizeFactor: _expandAnimation,
      child: Column(
        children: widget.bookings.map<Widget>((booking) {
          return GroupExpendedCard(booking);
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: appColor.color353535,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
              label: 'To Route',
              processingText: 'Routing...',
              icon: Image.asset(appIcon.toroute, width: 12.sp, height: 12.sp),
              onPressed: () async {
                bool confirmed = await Get.dialog<bool>(
                      AppDialog(
                        icon: appIcon.routepopup,
                        title: "Send To Route",
                        onYes: () => Get.back(result: true),
                        onNo: () => Get.back(result: false),
                      ),
                    ) ??
                    false;

                if (confirmed) {
                  await controller.sendToRoute(
                    index: widget.index,
                    groupId: '${_firstBooking['group_id']}',
                  );
                }
              },
              flex: 4),
          if ((_firstBooking['total_number_of_people'] ?? 1) <= 1) ...[
            8.horizontalSpace,
            _buildActionButton(
                label: 'Switch Ride',
                icon: Image.asset(
                  appIcon.switchride,
                  width: 18.sp,
                  height: 18.sp,
                ),
                processingText: 'Sending...',
                onPressed: () async {
                  bool confirmed = await Get.dialog<bool>(
                        AppDialog(
                          icon: appIcon.routepopup,
                          title: "Switching to Personal",
                          onYes: () => Get.back(result: true),
                          onNo: () => Get.back(result: false),
                        ),
                      ) ??
                      false;

                  if (confirmed) {
                    await controller.sendSwitchRideRequest(
                      bookingId: '${_firstBooking['id']}',
                    );
                  }
                },
                flex: 5)
          ],
          8.horizontalSpace,
          _buildActionButton(
              label: 'Manage',
              icon: Image.asset(appIcon.manage, width: 14.sp, height: 14.sp),
              onPressed: () {
                Get.to(() => ManageGroupScreen(bookings: widget.bookings,),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: 300));
              },
              flex: 4),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      {required String label,
      required Widget icon,
      required VoidCallback onPressed,
      String? processingText,
      flex}) {
    return Expanded(
      flex: flex,
      child: AppLeftIconButton(
          textColor: appColor.blackThemeColor,
          backgroundColor: appColor.greenThemeColor,
          onPressed: onPressed,
          btnText: label,
          processingText: processingText,
          icon: icon),
    );
  }
}
