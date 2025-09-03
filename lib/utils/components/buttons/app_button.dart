import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/extensions.dart';

class AppButton extends StatefulWidget {
  final String btnText;
  final FutureOr<void> Function()? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final String? processingText;
  final double? fontSize;
  final double? paddingVertical;
  final BorderRadiusGeometry? borderRadius;
  const AppButton({
    super.key,
    required this.btnText,
    required this.onPressed,
    this.backgroundColor = Colors.black87,
    this.textColor = Colors.white,
    this.processingText,
    this.borderRadius,
    this.fontSize,
    this.paddingVertical,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool isProcessing = false;

  Future<void> _handleTap() async {
    if (isProcessing || widget.onPressed == null) return;

    setState(() => isProcessing = true);

    final result = widget.onPressed!();
    if (result is Future) {
      await result;
    }

    if (mounted) setState(() => isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: isProcessing ? null : _handleTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 2, vertical: widget.paddingVertical ?? 0).copyWith(bottom: (widget.paddingVertical??2.h)-2.h),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Text(
          isProcessing
              ? widget.processingText ?? 'Processing...'
              : widget.btnText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: widget.fontSize ?? 12.5.sp,
            color: widget.textColor,
            fontWeight: FontWeight.w400
          ),
        ),
      ),
    );
  }
}
