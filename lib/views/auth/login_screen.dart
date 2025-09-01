import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import '../../controllers/auth/login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            padding: EdgeInsets.symmetric(vertical: 30.w,horizontal: 24.w).copyWith(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.13),
                  offset: const Offset(6, 6),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  offset: const Offset(-6, -6),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.13),
                        offset: const Offset(6, 6),
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        offset: const Offset(-6, -6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/icons/img.png',
                    height: Get.height * 0.23,
                  ),
                ),
                SizedBox(height: Get.height*0.05),
                Text(
                  "Please log in to access your dashboard.",
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: appColor.blackThemeColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 22.h),
                _innerShadowTextField(
                  "Email",
                  icon: Icons.email,
                  onChanged: controller.setEmail,
                  validator: controller.validateEmail,
                ),
                SizedBox(height: 14.h),
                _innerShadowTextField(
                  "Password",
                  icon: Icons.lock,
                  isPassword: true,
                  onChanged: controller.setPassword,
                  validator: controller.validatePassword,
                ),
                SizedBox(height: Get.height*0.07),
                Container(
                  height: 38.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFd6ff01),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(4, 4),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4, -4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: AppButton(
                    backgroundColor: appColor.greenThemeColor,
                    textColor: Colors.black,
                    paddingVertical: 14,
                    btnText: 'Login',
                    fontSize: 14.sp,
                    onPressed: controller.login,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "🔒 This portal is for authorized MIE RIDE team members only. "
                  "All activity is monitored. For access issues, please contact the Super Admin.",
                  style: TextStyle(
                      fontSize: 11.5.sp,
                      color: appColor.blackThemeColor,
                      letterSpacing: -0.3,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _innerShadowTextField(
    String hint, {
    bool isPassword = false,
    IconData? icon,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      height: 38.h,
      decoration: BoxDecoration(
        color: appColor.whiteThemeColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13),
            offset: Offset(3, 3),
            blurRadius: 6,
            inset: true,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.013),
            offset: Offset(-3, -3),
            blurRadius: 6,
            inset: true,
          ),
        ],
      ),
      child: TextFormField(
        // obscureText: isPassword,
        onChanged: onChanged,
        validator: validator,
        style: TextStyle(color: Colors.black87, fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w),
        ),
      ),
    );
  }
}
