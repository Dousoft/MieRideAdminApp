import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mie_admin/utils/constants.dart';

class QuickWithdrawalController extends GetxController {
  TextEditingController searchKeyController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = false.obs;
  final RxList quickWithdrawalData = [].obs;
  final RxInt currentPage = 1.obs;
  final RxString overallPendingPayoutAmount = '00.00'.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getQuickWithdrawal();
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

  Future<void> getQuickWithdrawal() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
      quickWithdrawalData.clear();
    }

    final payload = {
      'page_no': currentPage.value,
      'per_page': '10',
    };

    final searchKey = searchKeyController.text.trim();
    if (searchKey.isNotEmpty) {
      payload['search_key'] = searchKey;
    }

    try {
      final response = await networkClient.postRequest(
          endPoint: 'driver-quick-withdraw-list', payload: payload);

      if (response.data['statusCode'].toString() == '200') {
        final newItems = response.data['data'];
        if (currentPage.value == 1) {
          quickWithdrawalData.value = newItems;
        } else {
          quickWithdrawalData.addAll(newItems);
        }
        hasMoreData.value = newItems.length > 0;
        overallPendingPayoutAmount.value = response.data['overallPendingPayoutAmount'].toString();
      }
    } catch (e) {
      quickWithdrawalData.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateQuickWithdrawalStatus(
      {required String requestId,
      required String status,
      required int index}) async {
    Map<String, dynamic> payload = {
      'id': requestId,
      'status': status,
    };
    try {
      final response = await networkClient.postRequest(
          endPoint: 'update-quick-withdraw-request-status', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        quickWithdrawalData.removeAt(index);
      }
      EasyLoading.showToast(data['message']);
    } catch (e) {
      rethrow;
    }
  }


  Future<void> refreshData() async {
    searchKeyController.clear();
    currentPage.value = 1;
    getQuickWithdrawal();
  }

  Future<void> loadMoreData() async {
    if (!hasMoreData.value) return;

    isLoadingMore.value = true;
    currentPage.value++;
    final prevLength = quickWithdrawalData.length;

    await getQuickWithdrawal();

    final newLength = quickWithdrawalData.length;
    hasMoreData.value = newLength > prevLength;

    isLoadingMore.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
