import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mie_admin/repo/ably_services.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/views/root.dart';
import 'package:mie_admin/views/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.initialize(appNotificationId);
  OneSignal.Notifications.requestPermission(true);
  tz.initializeTimeZones();
  await GetStorage.init();
  ablyService = AblyService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'MIE Admin',
          theme: ThemeData(
            fontFamily: appFont,
            useMaterial3: true,
          ),
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
