import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/views/root.dart';

import '../../repo/one_signal.dart';

class LoginController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;

  final storage = GetStorage();

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email required";
    if (!GetUtils.isEmail(value)) return "Enter valid email";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password required";
    if (value.length < 6) return "At least 6 characters";
    return null;
  }


  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final emailError = validateEmail(email.value);
    final passError = validatePassword(password.value);

    if (emailError != null) {
      EasyLoading.showToast(emailError);
      return;
    }
    if (passError != null) {
      EasyLoading.showToast(passError);
      return;
    }

    isLoading.value = true;

    final response = await networkClient.postRequest(
      endPoint: 'login',
      payload: {
        'email': email.value,
        'password': password.value,
      },
    );

    isLoading.value = false;

    if (response.statusCode == 200 && response.data['token'] != null) {
      final data = response.data;
      storage.write(userNameKey, data['data']['first_name']);
      storage.write(userEmailKey, data['data']['email']);
      storage.write(authTokenKey, data['token']);
      storage.write(userIdKey, data['data']['id'].toString());
      OneSignalServices.sendOneSignalSubscriptionId();
      authToken = await storageService.read(authTokenKey);
      userId = await storageService.read(userIdKey);
      userName = await storageService.read(userNameKey);
      userEmail = await storageService.read(userEmailKey);
      Get.offAll(() => const Root());
    } else {
      EasyLoading.showToast(response.data['message'] ?? 'Login failed');
    }
  }
}
