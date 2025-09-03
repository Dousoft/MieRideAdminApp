import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';

class EmailListController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = false.obs;
  final RxList emailListData = [].obs;
  final RxInt currentPage = 1.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getEmailData();
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

  Future<void> getEmailData() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
      emailListData.clear();
    }

    Map<String, dynamic> payload = {
      'page': currentPage.value,
      'limit': '10',
    };

    try {
      final response = await networkClient.postRequest(api: 'https://midridechat.vercel.app/api/email/list',
          endPoint: '', payload: payload);
      if (response.data['success'] == true) {
        final newItems = List<Map<String, dynamic>>.from(response.data['data']);

        newItems.sort((a, b) {
          final dateA = DateTime.parse(a['date']).toLocal();
          final dateB = DateTime.parse(b['date']).toLocal();
          return dateB.compareTo(dateA);
        });
        if (currentPage.value == 1) {
          emailListData.value = newItems;
        } else {
          emailListData.addAll(newItems);
        }
        hasMoreData.value = newItems.isNotEmpty;
      }
    } catch (e) {
      emailListData.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsReadEmail(int index, String id) async {
    try {
      final response = await networkClient.postRequest(api: 'https://midridechat.vercel.app/api/email/mark-as-read',
          endPoint: '', payload: {'emailUID': id});
      if (response.data['success'] == true) {
        emailListData.removeAt(index);
      }
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
    final prevLength = emailListData.length;

    await getEmailData();

    final newLength = emailListData.length;
    hasMoreData.value = newLength > prevLength;

    isLoadingMore.value = false;
  }

  Future<void> refreshData() async{
    currentPage.value = 1;
    await getEmailData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
