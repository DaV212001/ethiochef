import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class RecipeSteps extends StatelessWidget {
  final List<String> steps;

  const RecipeSteps({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            children: [
              SvgIcon(
                image: Assets.iconsCooking,
                color: theme.colorScheme.tertiary,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Cooking Steps",
                style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.tertiary
                ),
              )
            ],
          ),
          ListView.builder(
            padding: EdgeInsets.only(top: 8),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 35,
                      width: 35, // Set the width as per your requirement
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Add spacing between leading and title
                    Expanded(
                      child: Text(
                        steps[index],
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}