import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/utils/extensions.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class CancelReceiptDialog extends StatelessWidget {
  final Map<String, dynamic> booking;
  const CancelReceiptDialog({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final bookingId = booking["id"]?.toString() ?? "";
    final cancelledBy = booking["cancel_by"] ?? "";
    final userName =
        '${booking["user_details"]?["first_name"]} ${booking["user_details"]?["last_name"]}';
    final bookingDate = '${booking["booking_date"]} ${booking["booking_time"]}'
        .toDateMonthYearTimeFormat();
    final bookingCreateAt = '${booking["created_at"]}'.toDateMonthYearTimeFormat();
    final pickupAddress = booking["source"] ?? "";
    final dropAddress = booking["destination"] ?? "";
    final cancelledAt = '${booking['cancel_time']}'.toDateMonthYearTimeFormat();
    final cancelReason = booking["reason"] ?? "";
    final userRefund = booking["refund_amount"]?.toString() ?? "0";
    final adminEarned = booking["admin_commission"]?.toString() ?? "0";
    final driverEarned = booking["driver_earning"]?.toString() ?? "0";
    final totalAmount = booking["total_trip_cost"]?.toString() ?? "0";
    final numberPeople = booking["number_of_people"]?.toString() ?? "0";

    final cancelFee =
        (int.tryParse(totalAmount) ?? 0) - (int.tryParse(userRefund) ?? 0);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 44.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 800.w),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 18.w),
                child: Text(
                  "Cancel Receipt",
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
              Divider(
                height: 12.h,
                color: Colors.grey,
                thickness: 0.5.sp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 3.h).copyWith(bottom: 1.h),
                              decoration: BoxDecoration(
                                color: appColor.blackThemeColor,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Text(
                                'Booking ID :- $bookingId',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: appColor.greenThemeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            3.verticalSpace,
                            _receiptRow("Username", userName),
                            _receiptRow("Pickup", pickupAddress),
                            _receiptRow("Drop off", dropAddress),
                          ],
                        )),
                        Image.asset(
                          appIcon.mie,
                          height: 60.h,
                        )
                      ],
                    ),
                    _receiptRow("Booking Date", bookingDate),
                    _receiptRow("Booking Placed", bookingCreateAt),
                    4.verticalSpace,
                    Container(
                      padding: EdgeInsets.all(12.sp),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5.sp),
                          borderRadius: BorderRadius.circular(14.r)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cancelled By :- ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                    fontSize: 12.sp),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 2)
                                    .copyWith(bottom: 1.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: appColor.greenThemeColor,
                                ),
                                child: Text(
                                  '${cancelledBy.toString().capitalizeFirst}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _receiptRow("Cancelled On", cancelledAt),
                          _receiptRow("Cancel Reason", cancelReason),
                          8.verticalSpace,
                          Text(
                            "Fare Summary",
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.bold),
                          ),
                          6.verticalSpace,
                          Container(
                            decoration: BoxDecoration(
                              color: appColor.greyThemeColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 2.h),
                                  child: Column(
                                    children: [
                                      _fareRow(
                                          "No. of Person", '0$numberPeople'),
                                      _fareRow("Cancel Fee", "\$$cancelFee"),
                                      _fareRow("User Refund", "\$$userRefund"),
                                      _fareRow(
                                          "Admin Earned", "\$$adminEarned"),
                                      _fareRow(
                                          "Driver Earned", "\$$driverEarned"),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.h, horizontal: 20.w),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(10.r),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Amount :-",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: appColor.greenThemeColor,
                                        ),
                                      ),
                                      Text(
                                        "\$$totalAmount",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                          color: appColor.greenThemeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      "Note:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                    Text(
                      "Cancellation charges are applied as per our cancellation policy.",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 10.sp,
                          letterSpacing: -0.2),
                    ),
                    25.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 110.w,
                          height: 28.h,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              padding: EdgeInsets.only(top: 2)
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        SizedBox(
                          width: 110.w,
                          height: 28.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColor.blackThemeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () async {
                              await downloadCancelReceipt(booking);
                            },
                            child: Text(
                              'Download',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title :- ",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: Colors.grey.shade600),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fareRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text("•      ",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1)),
              SizedBox(width: 6.w),
              Text(
                "$title :-",
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
              ),
            ],
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> downloadCancelReceipt(Map<String, dynamic> booking) async {
    final pdf = pw.Document();

    final bookingId = booking["id"]?.toString() ?? "";
    final cancelledBy = booking["cancel_by"] ?? "";
    final userName = booking["user_details"]?["first_name"] ?? "";
    final bookingDate = '${booking["booking_date"]} ${booking["booking_time"]}'
        .toDateMonthYearTimeFormat();
    final bookingCreateAt = '${booking["created_at"]}'.toDateMonthYearTimeFormat();
    final pickupAddress = booking["source"] ?? "";
    final dropAddress = booking["destination"] ?? "";
    final cancelledAt = '${booking['cancel_time']}'.toDateMonthYearTimeFormat();
    final cancelReason = booking["reason"] ?? "";
    final userRefund = booking["refund_amount"]?.toString() ?? "0";
    final adminEarned = booking["admin_commission"]?.toString() ?? "0";
    final driverEarned = booking["driver_earning"]?.toString() ?? "0";
    final totalAmount = booking["total_trip_cost"]?.toString() ?? "0";
    final numberPeople = booking["number_of_people"]?.toString() ?? "0";

    final cancelFee =
        (int.tryParse(totalAmount) ?? 0) - (int.tryParse(userRefund) ?? 0);

    final ByteData bytes =
        await rootBundle.load('assets/icons/home/booking/mie.png');
    final Uint8List imageData = bytes.buffer.asUint8List();
    final pw.ImageProvider logo = pw.MemoryImage(imageData);

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title
              pw.Text(
                "Cancel Receipt",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  decoration: pw.TextDecoration.underline,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          padding: pw.EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 5.sp),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.black,
                            borderRadius: pw.BorderRadius.circular(5),
                          ),
                          child: pw.Text(
                            'Booking ID :- $bookingId',
                            style: pw.TextStyle(
                              fontSize: 14.sp,
                              color: PdfColors.lightGreenAccent,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 5.h),
                        _pdfRow("Username", userName),
                        _pdfRow("Pickup", pickupAddress),
                        _pdfRow("Drop off", dropAddress),
                        pw.SizedBox(height: 8.h),
                        _pdfRow("Booking Date", bookingDate),
                        _pdfRow("Booking Placed", bookingCreateAt),
                      ],
                    ),
                  ),
                  pw.Image(logo, height: 110.h),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Container(
                padding: pw.EdgeInsets.all(12.sp),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                  borderRadius: pw.BorderRadius.circular(16.sp),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Cancelled By :- ",
                            style: pw.TextStyle(
                                fontSize: 14.sp, color: PdfColors.grey600)),
                        pw.Container(
                          padding: pw.EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.lightGreenAccent,
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                          child: pw.Text(
                            '${cancelledBy.toString().capitalizeFirst}',
                            style: pw.TextStyle(
                                fontSize: 14.sp, color: PdfColors.black),
                          ),
                        ),
                      ],
                    ),
                    _pdfRow("Cancelled On", cancelledAt),
                    _pdfRow("Cancel Reason", cancelReason),
                    pw.SizedBox(height: 12.h),
                    pw.Text("Fare Summary",
                        style: pw.TextStyle(
                            fontSize: 16.sp, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 6.h),
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey200,
                        borderRadius: pw.BorderRadius.circular(12.sp),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Padding(
                            padding:
                                pw.EdgeInsets.all(20.sp).copyWith(bottom: 10),
                            child: pw.Column(
                              children: [
                                _pdfFareRow("No. of Person", numberPeople),
                                _pdfFareRow("Cancel Fee", "\$$cancelFee"),
                                _pdfFareRow("User Refund", "\$$userRefund"),
                                _pdfFareRow("Admin Earned", "\$$adminEarned"),
                                _pdfFareRow("Driver Earned", "\$$driverEarned"),
                              ],
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 20.w),
                            decoration: pw.BoxDecoration(
                              color: PdfColors.black,
                              borderRadius: pw.BorderRadius.vertical(
                                bottom: pw.Radius.circular(12.sp),
                              ),
                            ),
                            child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text("Total Amount :-",
                                    style: pw.TextStyle(
                                      fontSize: 18.sp,
                                      color: PdfColors.lightGreenAccent,
                                    )),
                                pw.Text("\$$totalAmount",
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 18.sp,
                                      color: PdfColors.lightGreenAccent,
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 12),
              pw.Text("Note:",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 15.sp)),
              pw.Text(
                "Cancellation charges are applied as per our cancellation policy.",
                style: pw.TextStyle(fontSize: 12.sp, color: PdfColors.grey600),
              ),
            ],
          );
        },
      ),
    );

    // Save file
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Cancel_Receipt_$bookingId.pdf");
    await file.writeAsBytes(await pdf.save());

    await OpenFile.open(file.path);
  }

  pw.Widget _pdfRow(String title, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text("$title :- ",
              style: pw.TextStyle(fontSize: 14.sp, color: PdfColors.grey600)),
          pw.Expanded(
            child: pw.Text(value,
                style: pw.TextStyle(fontSize: 14.sp, color: PdfColors.black)),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfFareRow(String title, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(
            children: [
              pw.Text("*", style: pw.TextStyle(fontSize: 16.sp)),
              pw.SizedBox(width: 10.w),
              pw.Text("$title :-", style: pw.TextStyle(fontSize: 16.sp)),
            ],
          ),
          pw.Text(value,
              style:
                  pw.TextStyle(fontSize: 16.sp, fontWeight: pw.FontWeight.bold))
        ],
      ),
    );
  }
}
