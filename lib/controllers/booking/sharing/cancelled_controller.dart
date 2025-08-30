import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';

class CancelledController extends GetxController {
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

  Future<void> getCancelledBooking() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
      cancelledBookingData.clear();
    }

    Map<String, dynamic> payload = {
      'page_no': currentPage.value,
      'per_page': '8',
    };

    try {
      final response = await networkClient.postRequest(
          endPoint: 'get-canceled-booking-by-group', payload: payload);

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
    isLoading.value = true;
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
    } finally {
      isLoading.value = false;
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
}
