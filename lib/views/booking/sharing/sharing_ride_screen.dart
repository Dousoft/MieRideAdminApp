import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/tabs/app_custom_tab.dart';
import '../../../utils/constants.dart';
import '../family/faimaly_ride_screen.dart';
import 'accepted/accepted_screen.dart';
import 'assigned/assigned_screen.dart';
import 'cancelled/cancelled_screen.dart';
import 'completed/completed_screen.dart';
import 'enroute/enroute_screen.dart';
import 'group/group_screen.dart';
import 'manual/manual_screen.dart';
import 'missed/missed_screen.dart';
import 'route/route_screen.dart';

class SharingRideScreen extends StatelessWidget {
  const SharingRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCustomTab(
      selectedLabelColor: appColor.whiteThemeColor,
      unSelectedLabelColor: appColor.blackThemeColor,
      tabBackGroundColor: appColor.greyThemeColor,
      indicatorSelectedColor: appColor.blackThemeColor,
      indicatorUnSelectedColor: appColor.greyDarkThemeColor,
      tabTitles: [
        'Analytics',
        'Upcoming Group',
        'Current Group',
        'Route',
        'Assigned',
        'Accepted',
        'Manual',
        'Missed',
        'Enroute',
        'Completed',
        'Cancelled',
      ],
      tabViews: [
        ComingSoon(),
        GroupScreen(groupType: 'upcoming',),
        GroupScreen(groupType: 'current',),
        RouteScreen(),
        AssignedScreen(),
        AcceptedScreen(),
        ManualScreen(),
        MissedScreen(),
        EnrouteScreen(),
        CompletedScreen(),
        CancelledScreen(),
      ],
      decoratedBoxRadius: 0,
      indicatorRadius: 20.r,
    );
  }
}
