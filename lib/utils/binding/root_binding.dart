import 'package:get/get.dart';

import '../../controllers/booking/sharing/group/group_controller.dart';
import '../../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RootController());
    Get.lazyPut<GroupController>(() => GroupController(groupType: 'current'), tag: "current");
  }
}
