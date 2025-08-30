import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';

class MissedController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxList missedBookingData = [].obs;
  final RxInt currentPage = 1.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getMissedBooking();
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

  Future<void> getMissedBooking() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
      missedBookingData.clear();
    }

    Map<String, dynamic> payload = {
      'page_no': currentPage.value,
      'per_page': '3',
    };

    try {
      final response = await networkClient.postRequest(
          endPoint: 'get-missed-booking-by-group', payload: payload);

      if (response.data['statusCode'].toString() == '200') {
        final newItems = response.data['data'];

        if (currentPage.value == 1) {
          missedBookingData.value = newItems;
        } else {
          missedBookingData.addAll(newItems);
        }
        hasMoreData.value = newItems.length > 0;
      }
    } catch (e) {
      missedBookingData.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reAssignToDriver({required String groupId, required int index}) async {
    Map<String, dynamic> payload = {
      "group_id": groupId,
    };
    try {
      final response = await networkClient.postRequest(
          endPoint: 'reassign-driver-for-missed-booking', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        missedBookingData.removeAt(index);
      }
      EasyLoading.showToast(data['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmMissedRide({required String groupId, required int index, int? increasedTime}) async {
    Map<String, dynamic> payload = {
      "group_id": groupId,
      if(increasedTime != null)"increased_time": increasedTime,
    };
    try {
      final response = await networkClient.postRequest(
          endPoint: 'continue-with-same-driver', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        missedBookingData.removeAt(index);
      }
      EasyLoading.showToast(data['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadMoreData() async {
    if (!hasMoreData.value) return;

    isLoadingMore.value = true;
    currentPage.value++;
    final prevLength = missedBookingData.length;

    await getMissedBooking();

    final newLength = missedBookingData.length;
    hasMoreData.value = newLength > prevLength;

    isLoadingMore.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // confirm logic
}
