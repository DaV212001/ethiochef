import 'package:flutter/material.dart';

class SubscriptionHeader extends StatelessWidget {
  final bool isStepper;
  const SubscriptionHeader({super.key, required this.isStepper});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Stack(
        children: [
          Image.asset("assets/images/sign_up_image.png",
            fit: BoxFit.fill,),
          isStepper == false ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(100)),
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onPrimary),

                      child: Icon(
                        Icons.arrow_back,
                        color: theme.colorScheme
                            .onSecondary,
                      ),
                    )),


              ],
            ),
          ) : SizedBox(),
        ]
    );
  }
}
