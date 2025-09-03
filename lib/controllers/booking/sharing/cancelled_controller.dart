import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mie_admin/utils/constants.dart';

class CancelledController extends GetxController {
  TextEditingController searchKeyController = TextEditingController();
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxList cancelledBookingData = [].obs;
  final RxInt currentPage = 1.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getCancelledBooking();
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
    if (selectedStatusValue.value != null) {
      payload['status'] = selectedStatusValue.value.toString() ?? '';
    }
    if (selectedStatusValue.value != null) {
      payload['refund_type'] = selectedStatusValue.value.toString() ?? '';
    }
    if (selectedCancelledByValue.value != null) {
      payload['cancel_by'] = selectedCancelledByValue.value.toString() ?? '';
    }

    return payload;
  }

  Future<void> getCancelledBooking() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
      cancelledBookingData.clear();
    }

    try {
      final response = await networkClient.postRequest(
          endPoint: 'get-canceled-booking-by-group', payload: _buildPayload());

      if (response.data['statusCode'].toString() == '200') {
        final newItems = response.data['data'];
        if (currentPage.value == 1) {
          cancelledBookingData.value = newItems;
        } else {
          cancelledBookingData.addAll(newItems);
        }
        hasMoreData.value = newItems.length > 0;
      }
    } catch (e) {
      cancelledBookingData.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refundAmount({required Map payload, required int index}) async {
    try {
      final response = await networkClient.postRequest(
          endPoint: 'refund-user-cancellation-charge', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        // locally refresh here for instannt change
        final refundValue = double.parse(payload['refund_amount'].toString()) +
            double.parse(cancelledBookingData[index]['refund_amount'].toString() ?? '0');
        cancelledBookingData[index]['refund_amount'] = refundValue;
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
    final prevLength = cancelledBookingData.length;

    await getCancelledBooking();

    final newLength = cancelledBookingData.length;
    hasMoreData.value = newLength > prevLength;

    isLoadingMore.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // filerlization here with every
  RxString selectedTab = 'Date'.obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  RxnString selectedStatusValue = RxnString(null);
  RxString searchStatus = ''.obs;
  RxnString selectedCancelledByValue = RxnString(null);
  RxString searchCancelledByFilter = ''.obs;

  void updateStartDate(DateTime date) {
    startDate.value = date;
  }

  void updateEndDate(DateTime date) {
    endDate.value = date;
  }

  void selectStatus(String? value) {
    selectedStatusValue.value = value;
  }

  void clearFilters() {
    startDate.value = null;
    endDate.value = null;
    selectedStatusValue.value = null;
    selectedCancelledByValue.value = null;
    searchStatus.value = '';
    searchCancelledByFilter.value = '';
    searchKeyController.clear();
    getCancelledBooking();
  }

  void applyFilters() {
    if (selectedTab.value == 'Date') {
      if (startDate.value == null || endDate.value == null) {
        EasyLoading.showToast("Please select both start and end date.");
        return;
      }
    }

    if (selectedTab.value == 'Status') {
      if (selectedStatusValue.value == null) {
        EasyLoading.showToast("Please select a status.");
        return;
      }
    }

    if (selectedTab.value == 'Payment Type') {
      if (selectedCancelledByValue.value == null) {
        EasyLoading.showToast("Please select a payment type.");
        return;
      }
    }

    currentPage.value = 1;
    getCancelledBooking();
    Get.back();
  }

  void clearAndApplyFilters() {
    clearFilters();
    currentPage.value = 1;
    getCancelledBooking();
  }
}
