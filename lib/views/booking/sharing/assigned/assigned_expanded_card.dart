import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/views/booking/sharing/manual/manual_expanded_card.dart';
import '../../../../utils/constants.dart';
import 'package:timezone/timezone.dart' as tz;

class AssignedExpandedCard extends StatelessWidget {
  final Map item;
  const AssignedExpandedCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // same as manual
    return ManualExpandedCard(item: item);
  }
}

class AssignedDriverList extends StatelessWidget {
  final List drivers;
  final String groupId;

  const AssignedDriverList(
      {super.key, required this.drivers, required this.groupId});

  @override
  Widget build(BuildContext context) {
    // final uniqueDrivers = drivers.toSet().toList();
    final uniqueDrivers = drivers
        .map((e) => jsonEncode(e))
        .toSet()
        .map((e) => jsonDecode(e))
        .toList();
    return Container(
      decoration: BoxDecoration(
        color: appColor.greyThemeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Column(
              children: uniqueDrivers.map((driver) {
                String icon;
                if (driver['status'] == 'manual') {
                  icon = appIcon.hold;
                } else if (driver['status'] == 'assigned') {
                  icon = appIcon.assigned;
                } else {
                  icon = appIcon.reject;
                }

                return SizedBox(
                  height: 40.h,
                  child: ListTile(
                    title: Text(
                      driver['first_name'] ?? '',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    subtitle: Text(
                      "${driver['vehicle_no'] ?? ''}",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    trailing: Image.asset(
                      icon,
                      width: 18.sp,
                      height: 18.sp,
                    ),
                    dense: true,
                  ),
                );
              }).toList(),
            ),
            10.verticalSpace,
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(3.sp),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    spreadRadius: 4,
                  )
                ], color: appColor.blackThemeColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.close,
                  size: 40.sp,
                  color: appColor.greyThemeColor,
                ),
              ),
            ),
            16.verticalSpace,
          ],
        ),
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
          Text(' Route',
              style: TextStyle(
                  color: appColor.greenThemeColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
          _buildGroupIdChip(),
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
        'Group ID :- ${groupId}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }
}

class AssignmentTimer extends StatefulWidget {
  final String createdAt;

  const AssignmentTimer({super.key, required this.createdAt});

  @override
  State<AssignmentTimer> createState() => _AssignmentTimerState();
}

class _AssignmentTimerState extends State<AssignmentTimer> {
  late DateTime createdAt;
  late DateTime expiryTime;
  Timer? _timer;
  Duration remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    // canada time zone
    final canada = tz.getLocation('America/Toronto');

    try {
      // here canada normal time to parse date time
      final parsed = DateTime.parse(widget.createdAt);

      // here set canada time zone to parsed date
      createdAt = tz.TZDateTime(
        canada,
        parsed.year,
        parsed.month,
        parsed.day,
        parsed.hour,
        parsed.minute,
        parsed.second,
        parsed.millisecond,
        parsed.microsecond,
      );
      expiryTime = createdAt.add(const Duration(minutes: 2));

      _startTimer();
    } catch (e) {
      remaining = Duration.zero;
    }
  }

  void _startTimer() {
    _updateRemaining();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    final canada = tz.getLocation('America/Toronto');
    final now = tz.TZDateTime.now(canada);
    final diff = expiryTime.difference(now);

    if (diff.isNegative) {
      setState(() {
        remaining = Duration.zero;
      });
      _timer?.cancel();
    } else {
      setState(() {
        remaining = diff;
      });
    }
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: Text(
        remaining > Duration.zero ? formatDuration(remaining) : "Expired",
        style: TextStyle(
            fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
