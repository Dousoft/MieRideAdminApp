import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';

class EmailDetailsScreen extends StatelessWidget {
  final Map emailData;

  const EmailDetailsScreen({super.key, required this.emailData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.greyThemeColor,
      appBar: AppBar(
        title: Text(emailData['fullName'] ?? 'Email Details'),
        centerTitle: true,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                margin: EdgeInsets.only(left: 10.w),
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: appColor.whiteThemeColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.arrow_back_ios_new),

              ),
            ),
          ],
        ),
        backgroundColor: appColor.greyThemeColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: appColor.whiteThemeColor,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: Image.memory(
                          _extractBase64Image(emailData['html']),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.email, size: 28, color: Colors.grey),
                        )
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(emailData['fullName'] ?? '',
                                  style: TextStyle(
                                      color: appColor.blackThemeColor,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold)),
                              Text( _formatTimeAgo(emailData['date']),
                                  style: TextStyle(color: Colors.black54, fontSize: 12.sp))
                            ],
                          ),
                          6.verticalSpace,
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'To: ',
                                  style: TextStyle(
                                    color: appColor.blackThemeColor,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'MIE RIDE INC. ',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 11.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          // RichText(
                          //   text: TextSpan(
                          //     children: [
                          //       TextSpan(
                          //         text: 'Reply To: ',
                          //         style: TextStyle(
                          //           color: appColor.blackThemeColor,
                          //           fontSize: 13.sp,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //       TextSpan(
                          //         text: 'John Doe. ',
                          //         style: TextStyle(
                          //           color: Colors.black54,
                          //           fontSize: 12.sp,
                          //         ),
                          //       ),
                          //       WidgetSpan(
                          //         alignment: PlaceholderAlignment.middle,
                          //         child: Icon(
                          //           Icons.question_mark,
                          //           size: 11.sp,
                          //           color: Colors.black54,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          //   overflow: TextOverflow.ellipsis,
                          //   maxLines: 1,
                          // )
                        ],
                      ))
                ],
              ),
            ),
            10.verticalSpace,
            Text(
              emailData['subject'] ?? '',
              style:
              TextStyle(color: appColor.blackThemeColor, fontSize: 16.sp),
            ),
            Text(
                emailData['text'] ?? '',
                style: TextStyle(
                    color: Colors.black54, fontSize: 15.sp, height: 1.1),
            ),
            Divider(height: 20.h),
            Image.memory(
              _extractBase64Image(emailData['html']),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.email, size: 28, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Uint8List _extractBase64Image(String html) {
    final regex = RegExp(r'data:image\/\w+;base64,([A-Za-z0-9+/=]+)');
    final match = regex.firstMatch(html);
    if (match != null) {
      return base64Decode(match.group(1)!);
    }
    return Uint8List(0);
  }
}
