import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';

class GroupController extends GetxController {
  GroupController({required this.groupType});
  final String groupType;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxList groupBookingData = [].obs;
  final RxInt currentPage = 1.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getGroupBooking();
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

  Future<void> getGroupBooking() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
      groupBookingData.clear();
    }

    Map<String, dynamic> payload = {
      'page_no': currentPage.value,
      'per_page': '3',
      'group_type': groupType,
    };

    try {
      final response = await networkClient.postRequest(
          endPoint: 'get-sharing-booking-group', payload: payload);
      final newItems = response.data['data']['data'];

      if (response.data['statusCode'].toString() == '200') {
        if (currentPage.value == 1) {
          groupBookingData.value = newItems;
        } else {
          groupBookingData.addAll(newItems);
        }
        hasMoreData.value = newItems.length > 0;
      }
    } catch (e) {
      groupBookingData.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendToRoute({required String groupId, required int index}) async {
    Map<String, dynamic> payload = {
      "group_id": groupId,
    };
    try {
      final response = await networkClient.postRequest(
          endPoint: 'create-mannual-optimize-route', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        groupBookingData.removeAt(index);
      }
      EasyLoading.showToast(data['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendSwitchRideRequest({required String bookingId}) async {
    Map<String, dynamic> payload = {
      "booking_id": bookingId,
    };
    try {
      final response = await networkClient.postRequest(
          endPoint: 'send-switch-ride-request', payload: payload);
      final data = response.data;
      EasyLoading.showToast(data['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadMoreData() async {
    if (!hasMoreData.value) return;

    isLoadingMore.value = true;
    currentPage.value++;
    final prevLength = groupBookingData.length;

    await getGroupBooking();

    final newLength = groupBookingData.length;
    hasMoreData.value = newLength > prevLength;

    isLoadingMore.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
