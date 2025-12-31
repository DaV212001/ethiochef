import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/auth/auth_btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/forgot_password_controller.dart';
import '../../../widgets/input_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordController controller =
      Get.put(ForgotPasswordController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (controller.step.value == 1) ...[
                InputField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  icon: Icons.email,
                  type: InputField.EmailType,
                  inputType: TextInputType.emailAddress,
                  onChanged: (val) => controller.email.value = val,
                ),
                const SizedBox(height: 20),
                AuthBtn(
                    onPress:
                        controller.isLoading.value ? () {} : controller.sendOtp,
                    isLoading: controller.isLoading.value,
                    text: 'Send OTP'),
                // ElevatedButton(
                //   onPressed:
                //       controller.isLoading.value ? null : controller.sendOtp,
                //   child: controller.isLoading.value
                //       ? const CircularProgressIndicator(color: Colors.white)
                //       : const Text('Send OTP'),
                // ),
              ],
              if (controller.step.value == 2) ...[
                InputField(
                  controller: otpController,
                  label: 'OTP',
                  hint: 'Enter the OTP sent to your email',
                  icon: Icons.lock,
                  onChanged: (val) => controller.otp.value = val,
                ),
                const SizedBox(height: 20),
                AuthBtn(
                    onPress: controller.isLoading.value
                        ? () {}
                        : controller.verifyOtp,
                    isLoading: controller.isLoading.value,
                    text: 'Verify OTP'),
              ],
              if (controller.step.value == 3) ...[
                InputField(
                  controller: passwordController,
                  label: 'New Password',
                  hint: 'Enter your new password',
                  icon: Icons.lock,
                  isObscure: true,
                  onChanged: (val) => controller.newPassword.value = val,
                ),
                const SizedBox(height: 20),
                AuthBtn(
                    onPress: controller.isLoading.value
                        ? () {}
                        : controller.changePassword,
                    isLoading: controller.isLoading.value,
                    text: 'Change Password'),
                // ElevatedButton(
                //   onPressed: controller.isLoading.value
                //       ? null
                //       : controller.changePassword,
                //   child: controller.isLoading.value
                //       ? const CircularProgressIndicator(color: Colors.white)
                //       : const Text('Change Password'),
                // ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
