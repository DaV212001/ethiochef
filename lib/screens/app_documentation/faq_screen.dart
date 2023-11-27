import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../models/faqs.dart';
import '../../services/app_doc_services.dart';
import '../../widgets/main_app_bar.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<FAQ> faqs = [];

  @override
  void initState() {
    super.initState();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    faqs = await AppDocServices().fetchFaqs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: "FAQ".tr(),
        hasMainIcons: false,
      ),
      body: faqs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqs[index].question!),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(faqs[index].answer!),
              )
            ],
          );
        },
      ),
    );
  }
}
