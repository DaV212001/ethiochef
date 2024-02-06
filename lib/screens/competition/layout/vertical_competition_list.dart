import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/widgets/competiton/competiton_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class VerticalCompetitionList extends StatefulWidget {
  final PagingController<int, Competition> pagingController;
final BannerAd? bannerAd;
  const VerticalCompetitionList({super.key, required this.pagingController,
    this.bannerAd
  });

  @override
  State<VerticalCompetitionList> createState() =>
      _VerticalCompetitionListState();
}

class _VerticalCompetitionListState extends State<VerticalCompetitionList> {
  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Competition>(
      shrinkWrap: true,
      itemExtent: 285.h,
      pagingController: widget.pagingController,

      builderDelegate: PagedChildBuilderDelegate<Competition>(
        noMoreItemsIndicatorBuilder: (_) => SizedBox.shrink(),
        itemBuilder: (context, competition, index) {
          if (index == 2 ) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 0.h),
              child: Column(
                children: [
                  if(widget.bannerAd != null)
                  Align(
                    alignment: Alignment.topCenter,
                    child: SafeArea(
                      child: SizedBox(
                        width: widget.bannerAd!.size.width.toDouble(),
                        height: widget.bannerAd!.size.height*0.4.toDouble(),
                        child: AdWidget(ad: widget.bannerAd!),
                      )
                    )
                  ),
                  CompetitionsCard(competition: competition),
                ],
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
              child: CompetitionsCard(competition: competition),
            );
          }
        },
      ),
    );
  }
}
