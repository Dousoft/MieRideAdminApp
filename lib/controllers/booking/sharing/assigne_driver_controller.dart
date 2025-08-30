import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mie_admin/controllers/booking/sharing/manual_controller.dart';
import 'package:mie_admin/utils/constants.dart';

class AssignedDriverController extends GetxController {
  String groupId;
  AssignedDriverController({
    required this.groupId
  });

  final RxBool isLoading = false.obs;
  final RxBool isAssignedLoading = false.obs;
  final RxBool isDriverListLoading = false.obs;

  final RxMap routeDetails = {}.obs;
  final RxList bookingDetails = [].obs;
  final RxList driverAvailabilities = [].obs;
  final RxList sharedRoutesDetails = [].obs;

  RxBool isExtraCharges = false.obs;
  RxBool isIncreasePickupTime = false.obs;

  final TextEditingController extraChargeController = TextEditingController();
  final TextEditingController pickupTimeController = TextEditingController();

  RxList selectedDriverIds = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    getGroupBooking();
    scrollController.addListener(_scrollListener);
  }

  Future<void> getGroupBooking() async {
    isLoading.value = true;

    try {
      final response = await networkClient.postRequest(
        endPoint: 'get-route-bookings-by-group-id',
        payload: {"group_id": groupId},
      );

      if (response.data['statusCode'].toString() == '200') {
        final data = response.data['data'];
        routeDetails.value = data['routeDetails'] ?? {};
        bookingDetails.value = data['bookingDetails'] ?? [];
        driverAvailabilities.value = data['driverAvailabilities'] ?? [];
        sharedRoutesDetails.value = data['sharedRoutesDetails'] ?? [];
      } else {
        routeDetails.clear();
        bookingDetails.clear();
        driverAvailabilities.clear();
        sharedRoutesDetails.clear();
      }
    } catch (e) {
      routeDetails.clear();
      bookingDetails.clear();
      driverAvailabilities.clear();
      sharedRoutesDetails.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSelectAll(List drivers, bool selectAll) {
    selectedDriverIds.clear();
    if (selectAll) {
      for (final driver in drivers) {
        final driverId = driver['id'].toString();
        selectedDriverIds.add(driverId);
      }
    }
  }

  Future<void> assignDriver({required String rootId}) async {
    if (selectedDriverIds.isEmpty) {
      EasyLoading.showToast('Select your driver first.');
      return;
    }
    isAssignedLoading.value = true;
    try {
      final payload = {
        "booking_route_id": rootId,
        "driver_ids": selectedDriverIds,
        if (isExtraCharges.value)
          "tip_amount": extraChargeController.text,
        if (isIncreasePickupTime.value)
          "increased_pickup_time": pickupTimeController.text,
      };
      final response = await networkClient.postRequest(
          endPoint: 'assign-driver-to-manual-bookings', payload: payload);
      if (response.data['statusCode'].toString() == '200') {
        // manage with socake in future
        final manualController = Get.find<ManualController>();
        manualController.currentPage.value = 1;
        await manualController.getManualBooking();
        Get.back();
      }
    } catch (e) {
      rethrow;
    } finally {
      isAssignedLoading.value = false;
    }
  }

  // driver list
  TextEditingController searchKeyController = TextEditingController();
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = false.obs;
  final RxList driverListData = [].obs;
  final RxInt currentPage = 1.obs;

  final scrollController = ScrollController();

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent &&
        !isLoadingMore.value &&
        hasMoreData.value) {
      loadMoreData();
    }
  }

  Future<void> getDriverList() async {
    if (currentPage.value == 1) {
      isDriverListLoading.value = true;
      driverListData.clear();
    }

    Map<String, dynamic> payload = {
      'page': currentPage.value,
      'per_page': '10',
      'status': 'approvedAccount'
    };

    final searchKey = searchKeyController.text.trim();
    if (searchKey.isNotEmpty) {
      payload['search_key'] = searchKey;
    }

    try {
      final response = await networkClient.postRequest(endPoint: 'list-drivers', payload: payload);

      if (response.data['statusCode'].toString() == '200') {
        final newItems = response.data['data'];
        if (currentPage.value == 1) {
          driverListData.value = newItems;
        } else {
          driverListData.addAll(newItems);
        }
        hasMoreData.value = newItems.length > 0;
      }
    } catch (e) {
      driverListData.clear();
      rethrow;
    } finally {
      isDriverListLoading.value = false;
    }
  }

  Future<void> loadMoreData() async {
    if (!hasMoreData.value) return;

    isLoadingMore.value = true;
    currentPage.value++;
    final prevLength = driverListData.length;

    await getDriverList();

    final newLength = driverListData.length;
    hasMoreData.value = newLength > prevLength;

    isLoadingMore.value = false;
  }

  // scheduled booking pending
  var isScheduled = false.obs;
  var extraMinutes = 0.obs;

  void toggleSchedule(bool value) {
    isScheduled.value = value;
  }

  void increaseMinutes() {
    if (extraMinutes.value < 60) {
      extraMinutes.value += 1;
    }
  }

  void decreaseMinutes() {
    if (extraMinutes.value > 0) {
      extraMinutes.value -= 1;
    }
  }
}
