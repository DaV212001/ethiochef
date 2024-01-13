import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Center(
      child: SpinKitDoubleBounce(
        color: theme.colorScheme.primary,
        size: 130.0
      ),
    );
  }
}
