import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/faqs.dart';
import '../../services/app_doc_services.dart';
import '../../widgets/info_card.dart';
import '../../widgets/main_app_bar.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<FAQ> faqs = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    faqs = await AppDocServices().fetchFaqs();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: MainAppBar(title: "faq".tr, hasMainIcons: false),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (faqs.isEmpty) {
      return Scaffold(
        appBar: MainAppBar(title: "faq".tr, hasMainIcons: false),
        body: Center(
          child: InfoCard(
            onPress: () {
              fetchFaqs();
            },
            infoTitle: "faq".tr,
            infoBody: "no".trParams({'info': "faq".tr}),
            closeText: "",
            buttonText: "refresh".tr,
            infoImage: "",
            closeBtn: false,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: MainAppBar(title: "faq".tr, hasMainIcons: false),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqs[index].question!),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(faqs[index].answer!),
              ),
            ],
          );
        },
      ),
    );
  }
}
