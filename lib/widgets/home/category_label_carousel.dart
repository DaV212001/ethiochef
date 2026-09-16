import '../../models/category.dart';
import '../../widgets/small_label_button.dart';
import 'package:flutter/material.dart';
import '../../models/language.dart';

class CategoryLabelCarousel extends StatelessWidget {
  final List<Category> categories;
  final Color? color;

  const CategoryLabelCarousel(
      {super.key, required this.categories, this.color});

  @override
  Widget build(BuildContext context) {
    List<SmallLabelButton> labels = categories
        .map((e) => SmallLabelButton(text: e.name!.toString(), color: color, onTap: () {}))
        .toList();
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: List.generate(
            labels.length,
            (index) => Row(
              children: [
                labels[index],
                if (index < labels.length - 1) SizedBox(width: 5.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
