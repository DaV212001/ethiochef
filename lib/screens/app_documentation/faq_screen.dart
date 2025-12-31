import 'package:easy_localization/easy_localization.dart' as e;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/faq_controller.dart';
import '../../widgets/main_app_bar.dart';
import '../../widgets/main_button.dart';

class FaqScreen extends StatelessWidget {
  final FaqController faqController = Get.put(FaqController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: e.tr("faq"),
        hasMainIcons: false,
      ),
      body: Obx(() {
        if (faqController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (faqController.faqs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(e.tr("no") + " " + e.tr("faq")),
                MainButton(
                    text: e.tr('refresh'),
                    onPress: () => faqController.fetchFaqs())
              ],
            ),
          );
        }

        return ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: faqController.faqs.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(faqController.faqs[index].question ?? ''),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(faqController.faqs[index].answer ?? ''),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
