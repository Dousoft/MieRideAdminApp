import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../utils/constants.dart';
import '../../../utils/enums/manage_type.dart';

class ManageController extends GetxController {
  ManageController({required this.type, required this.bookingsList});

  RxBool isLoading = false.obs;
  RxBool isGroupLoading = false.obs;
  RxInt selectedBookingId = (-1).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    everAll([selectedBookingId], (callback) => getBookingGroup());
  }

  final List<dynamic> bookingsList;
  final ManageType type;

  void selectBooking(int id) {
    if (selectedBookingId.value == id) {
      selectedBookingId.value = -1;
    } else {
      selectedBookingId.value = id;
    }
  }

  bool get isBookingSelected => selectedBookingId.value != -1;

  Future<void> unlinkBooking() async {
    Map<String, dynamic> payload = {
      "booking_id": selectedBookingId.value.toString(),
    };
    isLoading.value = true;
    try {
      final response = await networkClient.postRequest(
          endPoint: 'unlink-booking-from-group', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        removeBooking(selectedBookingId.value);
        refreshData(type);
      }
      EasyLoading.showToast(data['message']);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelBooking() async {
    Map<String, dynamic> payload = {
      "booking_id": selectedBookingId.value.toString(),
    };
    isLoading.value = true;
    try {
      final response = await networkClient.postRequest(
          endPoint: 'cancel-sharing-booking-by-admin', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        removeBooking(selectedBookingId.value);
        refreshData(type);
      }
      EasyLoading.showToast(data['message']);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void removeBooking(int bookingId) {
    bookingsList.removeWhere((element) => element['booking_id'] == bookingId);
    if (selectedBookingId.value == bookingId) {
      selectedBookingId.value = -1;
      if (bookingsList.isEmpty) Get.back();
    }
  }

  RxList<Map<String, dynamic>> groupIds = <Map<String, dynamic>>[].obs;
  RxnInt selectedGroupId = RxnInt();

  void selectGroup(int? id) {
    selectedGroupId.value = id;
  }

  bool get isGroupIdSelected => selectedGroupId.value != null;

  Future<void> getBookingGroup() async {
    groupIds.clear();
    selectedGroupId.value = null;
    Map<String, dynamic> payload = {
      "booking_id": selectedBookingId.value.toString(),
    };
    isGroupLoading.value = true;
    try {
      final response = await networkClient.postRequest(
          endPoint: 'fetch-blank-group-for-reverse-group', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        for (var data in data['groups'] ?? []) {
          groupIds.add({"group_id": data['group_id'], "type": ""});
        }
        for (var data in data['alreadyEnrouteGroups'] ?? []) {
          groupIds
              .add({"group_id": data['group_id'], "type": "(Already Enroute)"});
        }
        refreshData(type);
      }
    } catch (e) {
      rethrow;
    } finally {
      isGroupLoading.value = false;
    }
  }

  Future<void> shiftBooking() async {
    Map<String, dynamic> payload = {
      'group_id': selectedGroupId.value.toString(),
      "booking_id": selectedBookingId.value.toString(),
    };
    isLoading.value = true;
    try {
      final response = await networkClient.postRequest(
          endPoint: 'merge-reverse-groups', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        removeBooking(selectedBookingId.value);
        refreshData(type);
      }
      EasyLoading.showToast(data['message']);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData(ManageType type) {
    try {
      switch (type) {
        case ManageType.route:
          ablyService?.routeRefresh();
          break;

        case ManageType.manual:
          ablyService?.manualRefresh();
          break;

        case ManageType.accepted:
          ablyService?.acceptedRefresh();
          break;

        case ManageType.enroute:
          ablyService?.enrouteRefresh();
          break;
      }
    } catch (e) {
      rethrow;
    }
  }

}
