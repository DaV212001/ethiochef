import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountdownDialog extends StatefulWidget {
  final VoidCallback onCountdownFinished;

  CountdownDialog({required this.onCountdownFinished});

  @override
  _CountdownDialogState createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<CountdownDialog> {
  late Timer _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          widget.onCountdownFinished();
          Get.back();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enter Your PIN"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Please enter your PIN in the prompt that appears."),
          SizedBox(height: 20),
          CircularProgressIndicator()
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            _timer.cancel();
            Get.back();
          },
        ),
      ],
    );
  }
}
