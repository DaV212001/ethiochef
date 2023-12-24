import 'package:ethio_chef/models/competitor.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoteCard extends StatefulWidget {
  final Competitor competitor;
  const VoteCard({super.key, required this.competitor});

  @override
  State<VoteCard> createState() => _VoteCardState();
}

class _VoteCardState extends State<VoteCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppTheme.allBorderRadius,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 100.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: CachedImage(
                      url: widget.competitor.image!,
                      fit: BoxFit.fill,
                    ),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Text(
                widget.competitor.fullName!,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
