import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/utils/components/buttons/app_button.dart';
import '../../controllers/auth/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          height: 1.sh,
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: controller.formKey,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                110.verticalSpace,
                Image.asset(
                  appIcon.logo,
                ),
                10.verticalSpace,
                Text(
                  'Let\'s Start!',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                10.verticalSpace,
                Text(
                  'Login to continue as admin...',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white70,
                  ),
                ),
                40.verticalSpace,
                TextFormField(
                  onChanged: controller.setEmail,
                  validator: controller.validateEmail,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Email', Icons.email),
                ),
                20.verticalSpace,
                TextFormField(
                  onChanged: controller.setPassword,
                  validator: controller.validatePassword,
                  // obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Password', Icons.lock),
                ),
                40.verticalSpace,
                AppButton(
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  paddingVertical: 14,
                  btnText: 'Login',
                  fontSize: 14.sp,
                  onPressed: controller.login,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white10,
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }
}
