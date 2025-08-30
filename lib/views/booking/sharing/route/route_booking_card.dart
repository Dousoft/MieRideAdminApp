import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/utils/enums/manage_type.dart';
import 'package:mie_admin/utils/extensions.dart';
import '../../../../controllers/booking/sharing/route_controller.dart';
import '../../../../utils/components/dialogs/app_dialog.dart';
import '../../../../utils/components/dialogs/payment_details_dialog.dart';
import '../manage/manage_screen.dart';
import 'route_expanded_card.dart';

class RouteBookingCard extends StatefulWidget {
  final Map<String, dynamic> route;
  final int index;

  const RouteBookingCard({
    super.key,
    required this.route,
    required this.index,
  });

  @override
  State<RouteBookingCard> createState() => _RouteBookingCardState();
}

class _RouteBookingCardState extends State<RouteBookingCard>
    with SingleTickerProviderStateMixin {
  final RouteController controller = Get.find<RouteController>();

  bool _expanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
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

  Map<String, dynamic> get _getRoute => widget.route;

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
        color: appColor.whiteThemeColor,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(color: appColor.greyDarkThemeColor,width: 0.5)
      ),
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

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          _buildActionButton(
              label: 'Assign Driver',
              onPressed: () async {
                bool confirmed = await Get.dialog<bool>(
                  AppDialog(
                    icon: appIcon.manualpopup,
                    title: "Assign To Drivers",
                    onYes: () => Get.back(result: true),
                    onNo: () => Get.back(result: false),
                  ),
                ) ?? false;

                if (confirmed) {
                  await controller.assignedDriver(
                    index: widget.index,
                    routeId: _getRoute['id'].toString(),
                  );
                }
              },
              processingText: 'Assigning...',
              flex: 6),
          8.horizontalSpace,
          _buildActionButton(
              label: 'Manage',
              onPressed: () {
                Get.to(
                        () => ManageScreen(
                      bookings: _getRoute,
                          type: ManageType.route,
                    ),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: 300));
              },
              flex: 5),
          8.horizontalSpace,
          _buildActionButton(
              label: 'Send to Manual',
              onPressed: () async {
                bool confirmed = await Get.dialog<bool>(
                  AppDialog(
                    icon: appIcon.manualpopup,
                    title: "Send To Manual",
                    onYes: () => Get.back(result: true),
                    onNo: () => Get.back(result: false),
                  ),
                ) ?? false;

                if (confirmed) {
                  await controller.sendToManual(
                    index: widget.index,
                    routeId: _getRoute['id'].toString(),
                  );
                }
              },
              processingText: 'Sending...',
              flex: 7),
        ],
      ),
    );
  }

  Widget _buildGroupInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10),
      child: Column(
        spacing: 6.h,
        children: [
          if(!_expanded)Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn('Source City',
                  '${_getRoute['pickup_city']}'.toFormattedDate()),
              _infoColumn('Destination City',
                  '${_getRoute['dropoff_city']}'.toFormattedTime()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn('Booking Date',
                  '${_getRoute['first_pickup_date']}'.toFormattedDate()),
              _infoColumn('First Pickup Time',
                  '${_getRoute['first_pickup_time']}'.toFormattedTime()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn('Total Route Time',
                  _getRoute['total_trip_time'].toString().toHourMinuteFormat()),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment :-', style: TextStyle(fontSize: 14.sp)),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                                    child: PaymentDetailsDialog(
                                      pMethod: _getRoute['payment_method']??'Via',
                                      person: '${_getRoute['total_number_of_people']??1}',
                                      bookingAmount: _getRoute['total_trip_cost'].toString(),
                                      surgeAmount: _getRoute['total_extra_charge'].toString(),
                                      totalAmount: _getRoute['total_trip_cost'].toString(),
                                      adminFee: _getRoute['total_admin_commission'].toString(),
                                      driverEarn: _getRoute['total_driver_earning'].toString(),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Image.asset(
                              appIcon.payment,
                              width: 25.sp,
                              height: 25.sp,
                            ),
                          ),
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
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.r),
                            child: Image.asset(
                              appIcon.bgperson,
                              width: 20.w,
                              height: 20.w,
                            ),
                          ),
                          Text(
                            '0${_getRoute['total_number_of_people']??1}',
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableContent() {
    return SizeTransition(
      sizeFactor: _expandAnimation,
      child: RouteExpandedCard(item: _getRoute,),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13.5.sp)),
          Text(
            value,
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      {required String label,
      required VoidCallback onPressed,
      String? processingText,
      flex}) {
    return Expanded(
      flex: flex,
      child: AppButton(
        backgroundColor: appColor.greenThemeColor,
        textColor: Colors.black,
        btnText: label,
        onPressed: onPressed,
        processingText: processingText,
        paddingVertical: 6.h,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(11.sp),
      decoration: BoxDecoration(
        color: appColor.blackThemeColor,
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5),
      child: Text(
        'Group ID:- ${_getRoute['group_id']}',
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
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
}
