import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mie_admin/utils/constants.dart';

class QuickDepositController extends GetxController {
  TextEditingController searchKeyController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = false.obs;
  final RxList quickDepositData = [].obs;
  final RxInt currentPage = 1.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getQuickDeposit();
    scrollController.addListener(_scrollListener);
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
    if (selectedPaymentTypeValue.value != null) {
      payload['source'] = selectedPaymentTypeValue.value.toString() ?? '';
    }

    return payload;
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoadingMore.value &&
        hasMoreData.value) {
      loadMoreData();
    }
  }

  Future<void> getQuickDeposit() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
      quickDepositData.clear();
    }
    try {
      final response = await networkClient.postRequest(
          endPoint: 'list-quick-deposit-payment', payload: _buildPayload());

      if (response.data['statusCode'].toString() == '200') {
        final newItems = response.data['data'];
        if (currentPage.value == 1) {
          quickDepositData.value = newItems;
        } else {
          quickDepositData.addAll(newItems);
        }
        hasMoreData.value = newItems.length > 0;
      }
    } catch (e) {
      quickDepositData.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void updateStatus(int index, String newStatus) {
    final updated = {...quickDepositData[index], 'status': newStatus};
    quickDepositData[index] = updated;
  }

  Future<void> updateIntracTransferStatus(
      {required String intracId,
      required String status,
      required int index}) async {
    Map<String, dynamic> payload = {
      'id': intracId,
      'status': status,
      'comment': 'Incorrect Transfer Amount'
    };
    try {
      final response = await networkClient.postRequest(
          endPoint: 'update-intrac-e-transfer-status', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        // here im upadte locally data whn api response seccessfully update
        updateStatus(index, status);
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
    final prevLength = quickDepositData.length;

    await getQuickDeposit();

    final newLength = quickDepositData.length;
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
  RxnInt selectedStatusValue = RxnInt(null);
  RxString searchStatus = ''.obs;
  RxnString selectedPaymentTypeValue = RxnString(null);
  RxString searchPaymentTypeFilter = ''.obs;

  void updateStartDate(DateTime date) {
    startDate.value = date;
  }

  void updateEndDate(DateTime date) {
    endDate.value = date;
  }

  void selectStatus(int? value) {
    selectedStatusValue.value = value;
  }

  void clearFilters() {
    startDate.value = null;
    endDate.value = null;
    selectedStatusValue.value = null;
    selectedPaymentTypeValue.value = null;
    searchStatus.value = '';
    searchPaymentTypeFilter.value = '';
    searchKeyController.clear();
    getQuickDeposit();
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
      if (selectedPaymentTypeValue.value == null) {
        EasyLoading.showToast("Please select a payment type.");
        return;
      }
    }

    currentPage.value = 1;
    getQuickDeposit();
    Get.back();
  }

  Future<void> refreshData() async{
    clearAndApplyFilters();
  }

  void clearAndApplyFilters() {
    clearFilters();
    currentPage.value = 1;
    getQuickDeposit();
  }
}
