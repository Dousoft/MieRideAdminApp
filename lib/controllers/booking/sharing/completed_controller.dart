import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mie_admin/utils/constants.dart';

class CompletedController extends GetxController {
  TextEditingController searchKeyController = TextEditingController();
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxList completedBookingData = [].obs;
  final RxInt currentPage = 1.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getCompletedBooking();
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

  Map<String, dynamic> _buildPayload() {
    final payload = {
      'page_no': currentPage.value,
      'per_page': '10',
    };

    final searchKey = searchKeyController.text.trim();
    if (searchKey.isNotEmpty) {
      payload['search_key'] = searchKey;
    }

    if (startDate.value != null) {
      payload['fromDate'] =
          DateFormat('yyyy-MM-dd').format((startDate.value ?? DateTime.now()));
    }
    if (endDate.value != null) {
      payload['toDate'] = DateFormat('yyyy-MM-dd').format((endDate.value ?? DateTime.now()));
    }

    return payload;
  }

  Future<void> getCompletedBooking() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
      completedBookingData.clear();
    }

    try {
      final response = await networkClient.postRequest(
          endPoint: 'get-completed-booking-by-group', payload: _buildPayload());

      if (response.data['statusCode'].toString() == '200') {
        final newItems = response.data['data'];
        if (currentPage.value == 1) {
          completedBookingData.value = newItems;
        } else {
          completedBookingData.addAll(newItems);
        }
        hasMoreData.value = newItems.length > 0;
      }
    } catch (e) {
      completedBookingData.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreData() async {
    if (!hasMoreData.value) return;

    isLoadingMore.value = true;
    currentPage.value++;
    final prevLength = completedBookingData.length;

    await getCompletedBooking();

    final newLength = completedBookingData.length;
    hasMoreData.value = newLength > prevLength;

    isLoadingMore.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // filter
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  void updateStartDate(DateTime date) {
    startDate.value = date;
  }

  void updateEndDate(DateTime date) {
    endDate.value = date;
  }

  void clearFilters() {
    startDate.value = null;
    endDate.value = null;
    searchKeyController.clear();
  }

  void applyFilters() {
    if (startDate.value == null || endDate.value == null) {
      EasyLoading.showToast("Please select both start and end date.");
      return;
    }

    currentPage.value = 1;
    getCompletedBooking();
    Get.back();
  }

  void clearAndApplyFilters() {
    clearFilters();
    currentPage.value = 1;
    getCompletedBooking();
  }
}
