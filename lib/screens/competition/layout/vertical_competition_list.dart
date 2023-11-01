import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/widgets/competiton/competiton_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class VerticalCompetitionList extends StatefulWidget {
  final PagingController<int, Competition> pagingController;

  const VerticalCompetitionList({super.key, required this.pagingController});

  @override
  State<VerticalCompetitionList> createState() =>
      _VerticalCompetitionListState();
}

class _VerticalCompetitionListState extends State<VerticalCompetitionList> {
  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Competition>(
      shrinkWrap: true,
      itemExtent: 275.h,
      pagingController: widget.pagingController,
      builderDelegate: PagedChildBuilderDelegate<Competition>(
        noMoreItemsIndicatorBuilder: (_) => SizedBox.shrink(),
        itemBuilder: (context, competition, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
            child: CompetitionsCard(competition: competition),
          );
        },
      ),
    );
  }
}
