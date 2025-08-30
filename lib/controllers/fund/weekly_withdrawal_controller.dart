import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mie_admin/utils/constants.dart';

class WeeklyWithdrawalController extends GetxController {
  TextEditingController searchKeyController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = false.obs;
  final RxList weeklyWithdrawalData = [].obs;
  final RxInt currentPage = 1.obs;
  final RxString overallPendingPayoutAmount = '00.00'.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getWeeklyWithdrawal();
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

  Future<void> getWeeklyWithdrawal() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
      weeklyWithdrawalData.clear();
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
          endPoint: 'list-payable-drivers', payload: payload);

      if (response.data['statusCode'].toString() == '200') {
        final newItems = response.data['data'];
        if (currentPage.value == 1) {
          weeklyWithdrawalData.value = newItems;
        } else {
          weeklyWithdrawalData.addAll(newItems);
        }
        hasMoreData.value = newItems.length > 0;
        overallPendingPayoutAmount.value = response.data['overallPendingPayoutAmount'].toString();
      }
    } catch (e) {
      weeklyWithdrawalData.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> payWeeklyWithdrawal(
      {required String driverId,
      required String payableAmount}) async {

    final now = DateTime.now();
    final transferDate = DateFormat('yyyy-MM-dd').format(now);
    final transferTime = DateFormat('HH:mm:ss').format(now);
    Map<String, dynamic> payload = {
      'driver_id': driverId,
      'transfer_amount': payableAmount,
      'transfer_date': transferDate,
      'transfer_time': transferTime
    };
    try {
      final response = await networkClient.postRequest(
          endPoint: 'driver-weekly-withdraw-by-admin', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        currentPage.value = 1;
        await getWeeklyWithdrawal();
      }
      EasyLoading.showToast(data['message']);
      Get.back();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refreshData() async {
    searchKeyController.clear();
    currentPage.value = 1;
    getWeeklyWithdrawal();
  }

  Future<void> loadMoreData() async {
    if (!hasMoreData.value) return;

    isLoadingMore.value = true;
    currentPage.value++;
    final prevLength = weeklyWithdrawalData.length;

    await getWeeklyWithdrawal();

    final newLength = weeklyWithdrawalData.length;
    hasMoreData.value = newLength > prevLength;

    isLoadingMore.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
