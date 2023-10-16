import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CompetitionScreen extends StatelessWidget {
  const CompetitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("competition".tr()),
      ),
    );
  }
}
