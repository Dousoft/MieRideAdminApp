import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mie_admin/controllers/booking/sharing/accepted_controller.dart';
import 'package:mie_admin/controllers/booking/sharing/assigned_controller.dart';
import 'package:mie_admin/controllers/booking/sharing/cancelled_controller.dart';
import 'package:mie_admin/controllers/booking/sharing/completed_controller.dart';
import 'package:mie_admin/controllers/booking/sharing/enroute_controller.dart';
import 'package:mie_admin/controllers/booking/sharing/manual_controller.dart';
import 'package:mie_admin/controllers/booking/sharing/missed_controller.dart';
import 'package:mie_admin/utils/constants.dart';
import '../controllers/booking/sharing/group/group_controller.dart';
import '../controllers/booking/sharing/route_controller.dart';

class AblyService {
  late ably.Realtime _realtime;

  static final AblyService _instance = AblyService._internal();

  factory AblyService() {
    return _instance;
  }

  AblyService._internal() {
    _initialize();
  }

  final List<ChannelEventModel> _channelEvents = [
    ChannelEventModel(name: "booking-updates", events: ["group-updated", "new-group-created"]),
    ChannelEventModel(name: "manual-booking-arrived", events: ["new-manual-booking"]),
    ChannelEventModel(name: "missed-booking-arrived", events: ["new-missed-booking"]),
    ChannelEventModel(name: "admin-booking-canceled-auto", events: ["booking-canceled-auto"]),
    ChannelEventModel(name: "route-updates", events: ["route-created"]),
    ChannelEventModel(name: "booking-assigned", events: ["booking-assigned"]),
    ChannelEventModel(name: "admin-booking-updates", events: ["admin-booking-update"]),
    ChannelEventModel(name: "admin-ride-status-updated", events: ["ride-started", "ride-canceled", "ride-status-updated", "booking-enroute", "booking-arrived", "booking-dropped", "booking-missed", "booking-cancelled"]),
    ChannelEventModel(name: "admin-route-recreated", events: ["admin-group-recreate", "group-modified"]),
  ];

  void _initialize() {
    _realtime = ably.Realtime(
      options: ably.ClientOptions.fromKey(appAblyClientKey),
    );

    for (var channelEvent in _channelEvents) {
      final channel = _realtime.channels.get(channelEvent.name);

      channel.subscribe().listen((ably.Message message) {
        if (channelEvent.events.contains(message.name)) {
          debugPrint('🔔 Handling Event: ${message.name}, Data: ${message.data}');
          if(message.name != null)handleEvent(message.name);
        }
      });
    }
  }

  void handleEvent(String? eventName) {
    switch (eventName) {
      case "group-updated":
      case "group-modified":
      case "new-group-created":
      case "admin-group-recreate":
        groupRefresh();
        routeRefresh();
        break;

      case "new-manual-booking":
        assignedRefresh();
        manualRefresh();
        break;

      case "route-created":
        groupRefresh();
        routeRefresh();
        break;

      case "booking-assigned":
        assignedRefresh();
        manualRefresh();
        routeRefresh();
        break;

      case "ride-canceled":
      case "booking-cancelled":
      case "booking-canceled-auto":
        groupRefresh();
        routeRefresh();
        assignedRefresh();
        acceptedRefresh();
        manualRefresh();
        enrouteRefresh();
        missedRefresh();
        cancelledRefresh();
        break;

      case "new-missed-booking":
        acceptedRefresh();
        missedRefresh();
        break;

      case "booking-enroute":
        acceptedRefresh();
        enrouteRefresh();
        break;

      case "admin-booking-update":
        acceptedRefresh();
        enrouteRefresh();
        assignedRefresh();
        break;

      case "ride-started":
      case "ride-status-updated":
      case "booking-arrived":
      case "booking-dropped":
      case "booking-missed":
        acceptedRefresh();
        enrouteRefresh();
        completedRefresh();
      break;

      default:
        debugPrint('🔕 Unknown event : $eventName');
        break;
    }
  }

  void groupRefresh() {
    if (Get.isRegistered<GroupController>(tag: 'current')) {
      final group = Get.find<GroupController>(tag: 'current');
      group.currentPage(1);
      group.getGroupBooking();
    } else if (Get.isRegistered<GroupController>(tag: 'upcoming')) {
      final group = Get.find<GroupController>(tag: 'upcoming');
      group.currentPage(1);
      group.getGroupBooking();
    } else {
      debugPrint("GroupController not registered");
    }
  }

  void routeRefresh() {
    if (Get.isRegistered<RouteController>()) {
      final route = Get.find<RouteController>();
      route.currentPage(1);
      route.getRouteBooking();
    } else {
      debugPrint("RouteController not registered");
    }
  }

  void assignedRefresh() {
    if (Get.isRegistered<AssignedController>()) {
      final assign = Get.find<AssignedController>();
      assign.currentPage(1);
      assign.getAssignedBooking();
    } else {
      debugPrint("AssignedController not registered");
    }
  }

  void acceptedRefresh() {
    if (Get.isRegistered<AcceptedController>()) {
      final accepted = Get.find<AcceptedController>();
      accepted.currentPage(1);
      accepted.getAcceptedBooking();
    } else {
      debugPrint("AcceptedController not registered");
    }
  }

  void manualRefresh() {
    if (Get.isRegistered<ManualController>()) {
      final manual = Get.find<ManualController>();
      manual.currentPage(1);
      manual.getManualBooking();
    } else {
      debugPrint("ManualController not registered");
    }
  }

  void missedRefresh() {
    if (Get.isRegistered<MissedController>()) {
      final missed = Get.find<MissedController>();
      missed.currentPage(1);
      missed.getMissedBooking();
    } else {
      debugPrint("MissedController not registered");
    }
  }

  void enrouteRefresh() {
    if (Get.isRegistered<EnrouteController>()) {
      final enroute = Get.find<EnrouteController>();
      enroute.currentPage(1);
      enroute.getEnrouteBooking();
    } else {
      debugPrint("EnrouteController not registered");
    }
  }

  void completedRefresh() {
    if (Get.isRegistered<CompletedController>()) {
      final complete = Get.find<CompletedController>();
      complete.currentPage(1);
      complete.getCompletedBooking();
    } else {
      debugPrint("CompletedController not registered");
    }
  }

  void cancelledRefresh() {
    if (Get.isRegistered<CancelledController>()) {
      final cancel = Get.find<CancelledController>();
      cancel.currentPage(1);
      cancel.getCancelledBooking();
    } else {
      debugPrint("CancelledController not registered");
    }
  }

}

class ChannelEventModel {
  final String name;
  final List<String> events;

  ChannelEventModel({required this.name, required this.events});
}
