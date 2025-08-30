import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';

import '../../../utils/components/dialogs/app_dialog.dart';

class RouteController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxList routeBookingData = [].obs;
  final RxInt currentPage = 1.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getRouteBooking();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoadingMore.value &&
        hasMoreData.value) {
      loadMoreData();
    }
  }

  Future<void> getRouteBooking() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
      routeBookingData.clear();
    }

    Map<String, dynamic> payload = {
      'page_no': currentPage.value,
      'per_page': '3',
    };

    try {
      final response = await networkClient.postRequest(
          endPoint: 'get-booking-routes', payload: payload);

      if (response.data['statusCode'].toString() == '200') {
        final newItems = response.data['data'];

        if (currentPage.value == 1) {
          routeBookingData.value = newItems;
        } else {
          routeBookingData.addAll(newItems);
        }
        hasMoreData.value = newItems.length > 0;
      }
    } catch (e) {
      routeBookingData.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendToManual(
      {required String routeId, required int index}) async {
    Map<String, dynamic> payload = {
      'route_id': routeId,
    };
    try {
      final response = await networkClient.postRequest(
          endPoint: 'send-bookings-to-manual', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        routeBookingData.removeAt(index);
      }
      EasyLoading.showToast(data['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> assignedDriver(
      {required String routeId, required int index}) async {
    Map<String, dynamic> payload = {
      'booking_route_id': routeId,
    };
    try {
      final response = await networkClient.postRequest(
          endPoint: 'assign-driver-logic-mannual', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        routeBookingData.removeAt(index);
        Get.dialog(
          AppDialog(
            icon: appIcon.assigningpopup,
            title: "Assigning",
            showTwoButtons: false,
          ),
        );
      } else {
        EasyLoading.showToast(data['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadMoreData() async {
    if (!hasMoreData.value) return;

    isLoadingMore.value = true;
    currentPage.value++;
    final prevLength = routeBookingData.length;

    await getRouteBooking();

    final newLength = routeBookingData.length;
    hasMoreData.value = newLength > prevLength;

    isLoadingMore.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
