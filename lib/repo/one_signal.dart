import 'dart:io';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../utils/constants.dart';

class OneSignalServices {
  static Future<String?> getOnesignalSubscriptionId() async {
    try {
      String? oneSignalDeviceToken = await OneSignal.User.getOnesignalId();
      if (oneSignalDeviceToken != null) {
        final url =
            "https://api.onesignal.com/apps/$appNotificationId/users/by/onesignal_id/$oneSignalDeviceToken";
        var res = await dio.get(url);
        if (res.statusCode == 200) {
          return res.data['subscriptions'][0]['id'];
        }
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  static Future<void> sendOneSignalSubscriptionId() async {
    try {
      String? subscriptionId = await getOnesignalSubscriptionId();
      String driverDeviceId = '', iosDriverDeviceId = '';
      if (subscriptionId != null) {
        driverDeviceId = (Platform.isAndroid ? subscriptionId : '');
        iosDriverDeviceId = (Platform.isIOS ? subscriptionId : '');
      }

      var payload = {
        'device_id': driverDeviceId,
        'iosdevice_id': iosDriverDeviceId,
      };

      await networkClient.postRequest(
        endPoint: 'update-admin-device-id',
        payload: payload,
      );
    } catch (e) {
      return;
    }
  }
}
