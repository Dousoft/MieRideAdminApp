import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';

class AssignedController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxList assignedBookingData = [].obs;
  final RxInt currentPage = 1.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getAssignedBooking();
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

  Future<void> getAssignedBooking() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
      assignedBookingData.clear();
    }

    Map<String, dynamic> payload = {
      'page_no': currentPage.value,
      'per_page': '3',
    };

    try {
      final response = await networkClient.postRequest(
          endPoint: 'get-assigned-booking-by-group', payload: payload);

      if (response.data['statusCode'].toString() == '200') {
        final newItems = response.data['data'];
        if (currentPage.value == 1) {
          assignedBookingData.value = newItems;
        } else {
          assignedBookingData.addAll(newItems);
        }
        hasMoreData.value = newItems.length > 0;
      }
    } catch (e) {
      assignedBookingData.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreData() async {
    if (!hasMoreData.value) return;

    isLoadingMore.value = true;
    currentPage.value++;
    final prevLength = assignedBookingData.length;

    await getAssignedBooking();

    final newLength = assignedBookingData.length;
    hasMoreData.value = newLength > prevLength;

    isLoadingMore.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> refreshData() async {
    currentPage.value = 1;
    hasMoreData.value = true;
    await getAssignedBooking();
  }
}
