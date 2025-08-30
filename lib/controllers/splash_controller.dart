import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../utils/constants.dart';
import '../views/auth/login_screen.dart';
import '../views/root.dart';

class SplashController extends GetxController {
  RxBool isLoading = false.obs;

  @override
  onInit() {
    _init();
    super.onInit();
  }

  _init() async {
    await GetStorage.init();
    Future.delayed(Duration(seconds: 2), () async {
      authToken = await storageService.read(authTokenKey);
      userId = await storageService.read(userIdKey);
      userName = await storageService.read(userNameKey);
      userEmail = await storageService.read(userEmailKey);
      if (authToken != null && userId != null && userEmail != null && userName != null) {
        Get.offAll(() => Root());
      } else {
        Get.offAll(() => LoginScreen());
      }
    });
  }
}
