import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../utils/constants.dart';
import '../../../../views/booking/sharing/group/manage/show_tip_confirmation_dialog.dart';

class ManageGroupController extends GetxController {
  ManageGroupController({required this.bookingsList});

  RxBool isLoading = false.obs;
  RxBool isGroupLoading = false.obs;
  RxInt selectedBookingId = (-1).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    everAll([selectedBookingId], (callback) => getBookingGroup());
  }

  final RxList<dynamic> bookingsList;

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
        ablyService?.groupRefresh();
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
      }
      EasyLoading.showToast(data['message']);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void removeBooking(int bookingId) {
    bookingsList.removeWhere((element) => element['id'] == bookingId);
    if (selectedBookingId.value == bookingId) {
      selectedBookingId.value = -1;
      if (bookingsList.isEmpty) Get.back();
    }
  }

  RxList<Map<String, dynamic>> groupIds = <Map<String, dynamic>>[].obs;
  RxnInt selectedGroupId = RxnInt();

  void selectGroup(int? id) {
    selectedGroupId.value = id;
    print(selectedGroupId.value);
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
          endPoint: 'fetch-blank-group-for-manual-assign', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        for (var data in data['groups']) {
          groupIds.add({"group_id": data['group_id'], "type": ""});
        }
        for (var data in data['alreadyEnrouteGroups']) {
          groupIds.add({"group_id": data['group_id'], "type": "(Already Enroute)"});
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      isGroupLoading.value = false;
    }
  }

  Future<void> shiftBooking({String? tipStatus, String? decreaseAmount}) async {
    Map<String, dynamic> payload = {
      'group_id': selectedGroupId.value.toString(),
      "booking_id": selectedBookingId.value.toString(),
      if(tipStatus != null)"tip_status": tipStatus,
      if(decreaseAmount != null)"decreas_amount": decreaseAmount,
    };
    isLoading.value = true;
    try {
      final response = await networkClient.postRequest(
          endPoint: 'assign-booking-to-existing-group', payload: payload);
      final data = response.data;
      if (data['statusCode'].toString() == '200') {
        if(data['message'] == 'Tip already added to the given route.'){
          final result = await Get.dialog(
            ShowTipConfirmationDialog(
              totalTripAmount: double.tryParse(data['total_trip_amount'].toString()) ?? 0.0,
              tipAmount: double.tryParse(data['tip_amount'].toString()) ?? 0.0,
              bookingDriverEarning: double.tryParse(data['booking_driver_earning'].toString()) ?? 0.0,
            ),
          );
          if (result != null && result["confirmed"] == true) {
            await shiftBooking(
              tipStatus: result['tip_status'].toString(),
              decreaseAmount: result["decreas_amount"].toString(),
            );
          }
        }else{
          Get.back();
          ablyService?.groupRefresh();
        }
      }
      EasyLoading.showToast(data['message']);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
