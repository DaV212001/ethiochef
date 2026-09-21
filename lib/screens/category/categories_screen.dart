import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/category_controller.dart';
import '../../widgets/error_card.dart';
import '../../widgets/loading.dart';
import '../../widgets/pull_to_refresh.dart';
import 'layout/category_tab.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with AutomaticKeepAliveClientMixin {
  final CategoryController controller = Get.put(CategoryController());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.categories.isEmpty) {
          return Loading();
        }
        if (controller.hasError.value && controller.categories.isEmpty) {
          return Center(
            child: ErrorCard(
              errorType: controller.errorMessage.value,
              refresh: () => controller.fetchCategories(),
            ),
          );
        }
        return RefreshWidget(
          onRefresh: () => controller.fetchCategories(),
          child: CategoryCustomTab(
            key: const PageStorageKey('category_custom_tab'),
            category: controller.categories,
          ),
        );
      }),
    );
  }
}
