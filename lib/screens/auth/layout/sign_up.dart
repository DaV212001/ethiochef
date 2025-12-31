import 'package:easy_localization/easy_localization.dart' as e;
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/widgets/auth/auth_btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../controllers/registration_controller.dart';
import '../../../widgets/auth/auth_link.dart';
import '../../../widgets/auth/phone_input_field.dart';
import '../../../widgets/input_field.dart';
import '../auth_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return Obx(() {
      if (controller.isLoading.value && controller.grades.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.isNotEmpty) {
        return Center(child: Text(controller.error.value));
      }

      return SingleChildScrollView(
        // padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              Image.asset(Assets.imagesLogo),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InputField(
                      controller: controller.firstNameController,
                      label: 'First Name',
                      hint: 'Enter your first name',
                      icon: Icons.person,
                      type: InputField.NameType,
                    ),
                    InputField(
                      controller: controller.lastNameController,
                      label: 'Last Name',
                      hint: 'Enter your last name',
                      icon: Icons.person_outline,
                      type: InputField.NameType,
                    ),
                    InputField(
                      controller: controller.emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      type: InputField.EmailType,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(children: [
                          PhoneInputField(
                              formKey: null,
                              controller: controller.phoneController,
                              validate: true)
                        ])),
                    // InputField(
                    //   controller: controller.phoneController,
                    //   label: 'Phone',
                    //   hint: 'Enter your phone number',
                    //   icon: Icons.phone,
                    //   inputType: TextInputType.phone,
                    // ),
                    InputField(
                      controller: controller.passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      icon: Icons.lock,
                      isObscure: true,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      initialValue: controller.selectedGradeId.value,
                      hint: const Text('Select Grade'),
                      items: controller.grades
                          .map<DropdownMenuItem<int>>(
                            (g) => DropdownMenuItem<int>(
                              value: g['id'],
                              child: Text('Grade ${g['name']}'),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => controller.selectedGradeId.value = v,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Grade',
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(() => AuthBtn(
                          text: 'Register',
                          isLoading: controller.isLoading.value,
                          onPress: controller.isLoading.value
                              ? () {}
                              : () => controller.register(),
                        )),
                    AuthLink(
                        text: e.tr("dont_have_an_account"),
                        buttonText: e.tr("sign_in_button"),
                        onPress: () {
                          PersistentNavBarNavigator.pushNewScreen(context,
                              screen: AuthScreen(
                                isSignIn: true,
                              ));
                        }),
                  ],
                ),
              ),

              // SizedBox(
              //   width: double.infinity,
              //   height: 48,
              //   child: ElevatedButton(
              //     onPressed: controller.isLoading.value
              //         ? null
              //         : () => controller.register(),
              //     child: controller.isLoading.value
              //         ? const CircularProgressIndicator(color: Colors.white)
              //         : const Text('Register'),
              //   ),
              // ),
            ],
          ),
        ),
      );
    });
  }
}
