import 'package:dio/dio.dart';
import 'package:mie_admin/repo/ably_services.dart';
import '../repo/network_client.dart';
import '../repo/storage_services.dart';
import 'assets/icons.dart';
import 'assets/images.dart';
import 'colors.dart';

/// test mode base url
String appApiBaseUrl = 'https://testapi.mieride.ca/api/';
String appImageBaseUrl = 'https://testapi.mieride.ca/storage/';

// /// production mode base url
// String appApiBaseUrl = 'https://api.mieride.ca/api/';
// String appImageBaseUrl = 'https://api.mieride.ca/storage/';

/// one signal app id
String appNotificationId = 'dbeb1ae1-7735-4df3-9a49-ddc21011243c';

/// ably client option key
String appAblyClientKey = 'cgbtZA.AQetNw:hE5TCgJHH9F4gWbFqv6pD5ScBM-A_RnW0RQG7xwQg-Y';

/// keys and value
String authTokenKey = 'AUTH_TOKEN';
String userIdKey = 'USER_ID';
String userNameKey = 'USER_NAME';
String userEmailKey = 'USER_EMAIL';
String? authToken;
String? userId;
String? userName;
String? userEmail;

/// font here
// String appFont = 'PowerGrotesk';
// String appFont = 'Inter';
String appFont = 'Nexa';
// String appFont = 'NexaBold';

/// single tone instance
StorageService storageService = StorageService();
NetworkClient networkClient = NetworkClient();
AblyService? ablyService;
AppColor appColor = AppColor();
AppIcon appIcon = AppIcon();
AppImages appImage = AppImages();
Dio dio = Dio();
