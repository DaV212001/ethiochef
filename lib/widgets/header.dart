import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final bool showMore;
  final Function()? onTap;
  final String? showMoreText;

  const Header({
    super.key,
    required this.title,
    this.showMore = false,
    this.onTap,
    this.showMoreText,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 5),
      // padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              title,
              style: TextStyle(
                letterSpacing: 0.5,
                fontSize: 15,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          if (showMore) Spacer(),
          if (showMore)
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: Text(
                  showMoreText ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
