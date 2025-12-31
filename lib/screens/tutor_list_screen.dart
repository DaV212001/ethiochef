import 'package:ethio_chef/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tutor_list_controller.dart';

class TutorListScreen extends StatelessWidget {
  final TutorListController controller = Get.put(TutorListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Available Tutors',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tutors.isEmpty) {
          return const Center(child: Text('No tutors found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.tutors.length,
          itemBuilder: (context, index) {
            final tutor = controller.tutors[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(tutor.profileImage),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tutor.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${tutor.cityName} • ${tutor.gender.capitalizeFirst}',
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Experience: ${tutor.yearOfExperience} years',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tutor.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone,
                                  size: 16, color: Colors.green),
                              const SizedBox(width: 4),
                              Text(tutor.phone),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
