import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';

class EnrouteController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxList acceptedBookingData = [].obs;
  final RxInt currentPage = 1.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getEnrouteBooking();
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

  Future<void> getEnrouteBooking() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
      acceptedBookingData.clear();
    }

    Map<String, dynamic> payload = {
      'page_no': currentPage.value,
      'per_page': '4',
    };

    try {
      final response = await networkClient.postRequest(
          endPoint: 'get-enroute-booking-by-group', payload: payload);

      if (response.data['statusCode'].toString() == '200') {
        final newItems = response.data['data'];
        if (currentPage.value == 1) {
          acceptedBookingData.value = newItems;
        } else {
          acceptedBookingData.addAll(newItems);
        }
        hasMoreData.value = newItems.length > 0;
      }
    } catch (e) {
      acceptedBookingData.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreData() async {
    if (!hasMoreData.value) return;

    isLoadingMore.value = true;
    currentPage.value++;
    final prevLength = acceptedBookingData.length;

    await getEnrouteBooking();

    final newLength = acceptedBookingData.length;
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
    await getEnrouteBooking();
  }
}
