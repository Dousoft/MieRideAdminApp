import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';

import '../../models/dashboard_model.dart';

class HomeController extends GetxController {

  var isLoading = false.obs;
  var dashBoardData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getDashboardData();
  }

  Future<void> getDashboardData() async {
    isLoading.value = true;
    try {
      final response = await networkClient.postRequest(endPoint: 'get-dashboard-analytics-new', payload: {});
      dashBoardData.value = response.data['data'] ?? {};
    } catch (e) {
      dashBoardData.clear();
    } finally {
      isLoading.value = false;
    }
  }

  List<DashboardModel> get getUserDriverCards {
    final data = dashBoardData;
    if (data.isEmpty) return [];

    return [
      DashboardModel(
        title: "Total User",
        value: data["total_users"].toString(),
        percentage: (data["users_percentage"] ?? 0).toDouble(),
        trend: data["users_trend"] ?? "equal",
        icon: 'assets/icons/home/user.png',
        subTitle: 'From the last month'
      ),
      DashboardModel(
        title: "Total Driver",
        value: data["total_drivers"].toString(),
        percentage: (data["drivers_percentage"] ?? 0).toDouble(),
        trend: data["drivers_trend"] ?? "equal",
        icon: 'assets/icons/home/driver.png',
        subTitle: 'From the last month'
      )
    ];
  }

  List<DashboardModel> get getBookingRideCards {
    final data = dashBoardData;
    if (data.isEmpty) return [];

    return [
      DashboardModel(
        title: "Monthly Sharing Bookings",
        value: data["sharing_monthly"].toString(),
        percentage: (data["sharing_month_percentage"] ?? 0).toDouble(),
        trend: data["sharing_month_trend"] ?? "equal",
        icon: 'assets/icons/home/user.png',
          subTitle: 'From the last month'
      ),
      DashboardModel(
        title: "Weekly Sharing Bookings",
        value: data["sharing_weekly"].toString(),
        percentage: (data["sharing_week_percentage"] ?? 0).toDouble(),
        trend: data["sharing_week_trend"] ?? "equal",
        icon: 'assets/icons/home/driver.png',
          subTitle: 'From the last week'
      ),
      DashboardModel(
        title: "Monthly Personal Bookings",
        value: data["personal_monthly"].toString(),
        percentage: (data["personal_month_percentage"] ?? 0).toDouble(),
        trend: data["personal_month_trend"] ?? "equal",
        icon: 'assets/icons/home/driver.png',
          subTitle: 'From the last month'
      ),
      DashboardModel(
        title: "Weekly Personal Bookings",
        value: data["personal_weekly"].toString(),
        percentage: (data["personal_week_percentage"] ?? 0).toDouble(),
        trend: data["personal_week_trend"] ?? "equal",
        icon: 'assets/icons/home/driver.png',
          subTitle: 'From the last week'
      ),
      DashboardModel(
        title: "Monthly Family Bookings",
        value: (data["f_monthly"]??0).toString(),
        percentage: (data["f_month_percentage"] ?? 0).toDouble(),
        trend: data["f_month_trend"] ?? "equal",
        icon: 'assets/icons/home/driver.png',
          subTitle: 'From the last month'
      ),
      DashboardModel(
        title: "Weekly Family Bookings",
        value: (data["f_weekly"]??0).toString(),
        percentage: (data["f_week_percentage"] ?? 0).toDouble(),
        trend: data["f_week_trend"] ?? "equal",
        icon: 'assets/icons/home/driver.png',
          subTitle: 'From the last week'
      ),
    ];
  }

  List<DashboardModel> get getShiftRideCards {
    final data = dashBoardData;
    if (data.isEmpty) return [];

    return [
      DashboardModel(
        title: "Booking: 12 AM – 4 AM",
        value: (data["shift"]??0).toString(),
        percentage: (data["shift"] ?? 0).toDouble(),
        trend: data["shift"] ?? "equal",
        icon: 'assets/icons/home/user.png',
          subTitle: 'From the last week'
      ),
      DashboardModel(
        title: "Booking: 4 AM – 8 AM",
        value: (data["shift"]??0).toString(),
        percentage: (data["shift"] ?? 0).toDouble(),
        trend: data["shift"] ?? "equal",
          icon: 'assets/icons/home/user.png',
          subTitle: 'From the last week'
      ),
      DashboardModel(
        title: "Booking: 8 AM – 12 PM",
        value: (data["shift"]??0).toString(),
        percentage: (data["shift"] ?? 0).toDouble(),
        trend: data["personal_month_trend"] ?? "equal",
          icon: 'assets/icons/home/user.png',
          subTitle: 'From the last week'
      ),
      DashboardModel(
        title: "Booking: 12 PM – 4 PM",
        value: (data["shift"]??0).toString(),
        percentage: (data["shift"] ?? 0).toDouble(),
        trend: data["shift"] ?? "equal",
          icon: 'assets/icons/home/user.png',
          subTitle: 'From the last week'
      ),
      DashboardModel(
        title: "Booking: 4 PM – 8 PM",
        value: (data["shift"]??0).toString(),
        percentage: (data["shift"] ?? 0).toDouble(),
        trend: data["shift"] ?? "equal",
          icon: 'assets/icons/home/user.png',
          subTitle: 'From the last week'
      ),
      DashboardModel(
        title: "Booking: 8 PM – 12 AM",
        value: (data["shift"]??0).toString(),
        percentage: (data["shift"] ?? 0).toDouble(),
        trend: data["shift"] ?? "equal",
          icon: 'assets/icons/home/user.png',
          subTitle: 'From the last week'
      ),
    ];
  }

  List<DashboardModel> get getBookingCards {
    final data = dashBoardData;
    if (data.isEmpty) return [];

    return [
      DashboardModel(
          title: "Interac Transfers (Monthly)",
          value: "\$${data["interac_monthly_amount"]}",
          percentage: (data["interac_monthly_percentage"] ?? 0).toDouble(),
          trend: data["interac_monthly_trend"] ?? "equal",
          icon: 'assets/icons/home/interactransfers.png',
          subTitle: 'From the last month'
      ),
      DashboardModel(
        title: "Interac Transfers (Today)",
        value: "\$${data["interac_today_amount"]}",
        percentage: (data["interac_today_percentage"] ?? 0).toDouble(),
        trend: data["interac_today_trend"] ?? "equal",
        icon: 'assets/icons/home/interactransfers.png',
          subTitle: 'From yesterday'
      ),
      DashboardModel(
          title: "Quick Transfers (Monthly)",
          value: "\$${data["quick_monthly_amount"]}",
          percentage: (data["quick_monthly_percentage"] ?? 0).toDouble(),
          trend: data["quick_monthly_trend"] ?? "equal",
          icon: 'assets/icons/home/quickdeposit.png',
          subTitle: 'From the last month'
      ),
      DashboardModel(
        title: "Quick Transfers (Today)",
        value: "\$${data["quick_today_amount"]}",
        percentage: (data["quick_today_percentage"] ?? 0).toDouble(),
        trend: data["quick_today_trend"] ?? "equal",
        icon: 'assets/icons/home/quickdeposit.png',
          subTitle: 'From yesterday'
      ),
      DashboardModel(
        title: "Weekly Amount Collected",
        value: "\$${data["total_weekly_earning"]}",
        percentage: (data["total_weekly_earning_percentage"] ?? 0).toDouble(),
        trend: data["total_weekly_earning_trend"] ?? "equal",
        icon: 'assets/icons/nav/img_1.png',
          subTitle: 'From the last week'
      ),
      DashboardModel(
        title: "Driver Payouts (Weekly)",
        value: "\$${data["driver_weekly_payout"]}",
        percentage: (data["driver_weekly_payout_percentage"] ?? 0).toDouble(),
        trend: data["driver_weekly_payout_trend"] ?? "equal",
        icon: 'assets/icons/home/driverpayout.png',
          subTitle: 'From the last week'
      ),
    ];
  }

  List<DashboardModel> get getSupportAndApprovalCards {
    final data = dashBoardData;
    if (data.isEmpty) return [];

    return [
      DashboardModel(
        title: "Unread Support Chats",
        value: "${data["unread_support_chats"]}",
        percentage: 0.0,
        trend: '',
        icon: 'assets/icons/home/chat.png',
          subTitle: ''
      ),
      DashboardModel(
        title: "Pending Driver Approvals",
        value: "${data["pending_driver_approvals"]}",
        percentage: 0.0,
        trend: '',
        icon: 'assets/icons/home/user.png',
          subTitle: ''
      )
    ];
  }

  List<DashboardModel> get getMonthlyEarningCards {
    final data = dashBoardData;
    if (data.isEmpty) return [];

    return [
      DashboardModel(
        title: "Monthly Earning",
        value: "\$${data["total_monthly_earning"]}",
        percentage: (data["total_monthly_percentage"] ?? 0).toDouble(),
        trend: data["total_earning_trend"] ?? "equal",
        icon: 'assets/icons/home/user.png',
          subTitle: ''
      ),
      DashboardModel(
        title: "My Monthly Earning",
        value: "\$${data["my_monthly_earning"]}",
        percentage: (data["my_monthly_percentage"] ?? 0).toDouble(),
        trend: data["my_earning_trend"] ?? "equal",
        icon: 'assets/icons/home/user.png',
        subTitle: '',
      ),
    ];
  }
}

