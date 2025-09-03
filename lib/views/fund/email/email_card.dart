import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/controllers/fund/email_list_controller.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/views/fund/email/email_details_screen.dart';

class EmailCard extends StatelessWidget {
  final Map data;
  final int index;

  EmailCard({super.key, required this.data, required this.index});

  final controller = Get.find<EmailListController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.markAsReadEmail(index, data['uid'].toString());
        Get.to(()=> EmailDetailsScreen(emailData: data));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: appColor.whiteThemeColor,
          borderRadius: BorderRadius.circular(12.r),
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
                    _extractBase64Image(data['html']),
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
                    Text(data['fullName'] ?? '',
                        style: TextStyle(
                            color: appColor.blackThemeColor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold)),
                    Text( _formatTimeAgo(data['date']),
                        style: TextStyle(color: Colors.black54, fontSize: 12.sp))
                  ],
                ),
                Text(
                  data['subject'] ?? '',
                  style:
                      TextStyle(color: appColor.blackThemeColor, fontSize: 13.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                    data['text'] ?? '',
                    style: TextStyle(
                        color: Colors.black54, fontSize: 12.sp, height: 1.1),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis)
              ],
            ))
          ],
        ),
      ),
    );
  }

  Uint8List _extractBase64Image(String html) {
    final regex = RegExp(r'data:image\/\w+;base64,([A-Za-z0-9+/=]+)');
    final match = regex.firstMatch(html);
    if (match != null) {
      return base64Decode(match.group(1)!);
    }
    return Uint8List(0);
  }

  String _formatTimeAgo(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
