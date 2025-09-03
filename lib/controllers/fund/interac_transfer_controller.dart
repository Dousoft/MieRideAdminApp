import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mie_admin/utils/constants.dart';

class InteracTransferController extends GetxController {
  TextEditingController searchKeyController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = false.obs;
  final RxList interacTransferData = [].obs;
  final RxInt currentPage = 1.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getIntracTransfer();
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

  Future<void> getIntracTransfer() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
      interacTransferData.clear();
    }
    try {
      final response = await networkClient.postRequest(
          endPoint: 'list-intrac-e-transfer', payload: _buildPayload());

      if (response.data['statusCode'].toString() == '200') {
        final newItems = response.data['data'];
        if (currentPage.value == 1) {
          interacTransferData.value = newItems;
        } else {
          interacTransferData.addAll(newItems);
        }
        hasMoreData.value = newItems.length > 0;
      }
    } catch (e) {
      interacTransferData.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void updateStatus(int index, String newStatus) {
    final updated = {...interacTransferData[index], 'status': newStatus};
    interacTransferData[index] = updated;
  }

  Future<void> updateIntracTransferStatus(
      {required String intracId,
      required String status,
      String? reason,
      required int index}) async {
    Map<String, dynamic> payload = {
      'id': intracId,
      'status': status,
      if(reason != null)'comment': reason
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

  Future<void> refreshData() async {
    clearAndApplyFilters();
  }


  Future<void> loadMoreData() async {
    if (!hasMoreData.value) return;

    isLoadingMore.value = true;
    currentPage.value++;
    final prevLength = interacTransferData.length;

    await getIntracTransfer();

    final newLength = interacTransferData.length;
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
    searchStatus.value = '';
    searchKeyController.clear();
    getIntracTransfer();
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

    currentPage.value = 1;
    getIntracTransfer();
    Get.back();
  }

  void clearAndApplyFilters() {
    currentPage.value = 1;
    clearFilters();
  }
}
