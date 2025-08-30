import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension Spaces on int {
  Radius get radius => Radius.circular(toDouble().r);

  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: toDouble().w);

  EdgeInsets get allPadding => EdgeInsets.all(toDouble().sp);

  EdgeInsets get verticalPadding =>
      EdgeInsets.symmetric(vertical: toDouble().h);

  BorderRadius get borderRadius => BorderRadius.circular(toDouble());


  RoundedRectangleBorder get shapeBorderRadius =>
      RoundedRectangleBorder(borderRadius: borderRadius);

  SizedBox get height => SizedBox(
    height: toDouble().h,
  );
  SizedBox get square => SizedBox(
    height: toDouble().h,
    width: toDouble().w,
  );

  SizedBox get width => SizedBox(
    width: toDouble().w,
  );
}

extension Responsive on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  Size get deviceSize => MediaQuery.of(this).size;

  Orientation get deviceOrientation => MediaQuery.of(this).orientation;

  bool get isMobile => MediaQuery.of(this).size.width < 850;

  bool get isTablet =>
      MediaQuery.of(this).size.width < 3000 &&
          MediaQuery.of(this).size.width >= 750;

  void push(Widget screen) {
    Navigator.push(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
        ));
  }

  void pushReplace(Widget screen) {
    Navigator.pushReplacement(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
        ));
  }

  void get pop {
    Navigator.pop(this);
  }

  showSnackBar(text) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(text)));
  }
}

extension DateTimeFormatting on DateTime {
  /// Formats to something like "5 minutes ago"
  String timeAgo() {
    return timeago.format(this.toLocal());
  }

  /// Formats to something like "02 Aug, 2025 05:45 PM"
  String formatOrderDate() {
    return DateFormat('dd MMM, yyyy hh:mm a').format(this);
  }
}

extension StringDateFormatting on String {
  /// Parses an ISO string and returns time ago format
  String toTimeAgo() {
    try {
      final parsedDate = DateTime.parse(this);
      return parsedDate.timeAgo();
    } catch (_) {
      return '';
    }
  }

  String toFormattedOrderDate() {
    try {
      final parsedDate = DateTime.parse(this);
      return parsedDate.formatOrderDate();
    } catch (_) {
      return '';
    }
  }

  String toMonthYearTimeFormat() {
    try {
      DateTime dateTime = DateTime.parse(this);
      final monthYear = DateFormat('dd MMM, yyyy').format(dateTime);
      final time = DateFormat('hh:mm a').format(dateTime);
      return '$monthYear ($time)';
    } catch (e) {
      return this; // fallback if parsing fails
    }
  }

  /// Convert time like "13:30" → "01:30 PM"
  String toFormattedTime() {
    try {
      final dateTime = DateFormat("HH:mm").parse(this);
      return DateFormat("hh:mm a").format(dateTime);
    } catch (e) {
      return this; // fallback if format fails
    }
  }

  /// Convert date like "2025-09-06" → "Sep 06, 2025"
  String toFormattedDate() {
    try {
      final date = DateFormat("yyyy-MM-dd").parse(this);
      return DateFormat("MMM dd, yyyy").format(date);
    } catch (e) {
      return this; // fallback if format fails
    }
  }

  // ("02:02") to "02 Hr 02 Mins"
  String toHourMinuteFormat() {
    try {
      final parts = split(':');
      if (parts.length != 2) return this;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final hourStr = hour.toString().padLeft(2, '0');
      final minStr = minute.toString().padLeft(2, '0');

      return '$hourStr Hr $minStr Mins';
    } catch (_) {
      return this;
    }
  }
}


