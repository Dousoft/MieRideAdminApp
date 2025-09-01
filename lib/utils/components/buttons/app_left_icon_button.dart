import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLeftIconButton extends StatefulWidget {
  final String btnText;
  final FutureOr<void> Function()? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Widget icon;
  final BorderRadiusGeometry? borderRadius;
  final String? processingText;
  final double? fontSize;
  final double? paddingVertical;

  const AppLeftIconButton({
    super.key,
    required this.btnText,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.borderRadius,
    this.processingText,
    this.fontSize,
    this.paddingVertical,
  });

  @override
  State<AppLeftIconButton> createState() => _AppLeftIconButtonState();
}

class _AppLeftIconButtonState extends State<AppLeftIconButton> {
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
      borderRadius: BorderRadius.circular(6.r),
      onTap: isProcessing ? null : _handleTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 2.w, vertical: widget.paddingVertical??3.h),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius??BorderRadius.circular(5.r),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon,
            8.horizontalSpace,
            Column(
              children: [
                3.verticalSpace,
                Text(
                  isProcessing
                      ? widget.processingText ?? 'Processing...'
                      : widget.btnText,
                  style: TextStyle(
                    fontSize: widget.fontSize ?? 12.sp,
                    fontWeight: FontWeight.w400,
                    color: widget.textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
