import 'package:ethio_chef/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/astegni_controller.dart';
import '../../widgets/auth/auth_btn.dart';
import '../../widgets/input_field.dart';

class AstegniFormScreen extends StatelessWidget {
  const AstegniFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AstegniController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Astegni Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.grades.isEmpty &&
            controller.cities.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile picture picker
              GestureDetector(
                onTap: controller.pickImage,
                child: Obx(() {
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.imageFile.value != null
                        ? FileImage(controller.imageFile.value!)
                        : null,
                    child: controller.imageFile.value == null
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null,
                  );
                }),
              ),
              const SizedBox(height: 20),

              InputField(
                controller: controller.fullNameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                icon: Icons.person,
                type: InputField.NameType,
              ),
              InputField(
                controller: controller.phoneController,
                label: 'Phone',
                hint: 'Enter your phone number',
                icon: Icons.phone,
                inputType: TextInputType.phone,
              ),
              InputField(
                controller: controller.addressController,
                label: 'Address',
                hint: 'Enter your address',
                icon: Icons.home,
              ),
              InputField(
                controller: controller.experienceController,
                label: 'Years of Experience',
                hint: 'Enter years of experience',
                icon: Icons.work_outline,
                inputType: TextInputType.number,
              ),
              InputField(
                controller: controller.descriptionController,
                label: 'Description',
                hint: 'Describe yourself',
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Gender selection
              DropdownButtonFormField<String>(
                initialValue: controller.selectedGender.value.isEmpty
                    ? null
                    : controller.selectedGender.value,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                ],
                onChanged: (v) => controller.selectedGender.value = v ?? '',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Gender',
                ),
              ),
              const SizedBox(height: 12),

              // City dropdown
              DropdownButtonFormField<int>(
                initialValue: controller.selectedCityId.value,
                hint: const Text('Select City'),
                items: controller.cities
                    .map<DropdownMenuItem<int>>(
                      (c) => DropdownMenuItem<int>(
                        value: c['id'],
                        child: Text(c['name']),
                      ),
                    )
                    .toList(),
                onChanged: (v) => controller.selectedCityId.value = v,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'City',
                ),
              ),
              const SizedBox(height: 12),

              // Grade dropdown
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
                    text: 'Submit',
                    isLoading: controller.isLoading.value,
                    onPress: controller.isLoading.value
                        ? () {}
                        : () => controller.submitForm(),
                  )),
              // SizedBox(
              //   width: double.infinity,
              //   height: 48,
              //   child: ElevatedButton(
              //     onPressed: controller.isLoading.value
              //         ? null
              //         : () => controller.submitForm(),
              //     child: controller.isLoading.value
              //         ? const CircularProgressIndicator(color: Colors.white)
              //         : const Text('Submit'),
              //   ),
              // ),
            ],
          ),
        );
      }),
    );
  }
}
