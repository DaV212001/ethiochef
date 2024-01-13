import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/screens/competition/layout/vertical_competition_list.dart';
import 'package:ethio_chef/services/competition_service.dart';
import 'package:ethio_chef/widgets/screen_head.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../widgets/pull_to_refresh.dart';
import 'layout/upload_video.dart';

class CompetitionsScreen extends StatefulWidget {
  const CompetitionsScreen({super.key});

  @override
  State<CompetitionsScreen> createState() => _CompetitionsScreenState();
}

class _CompetitionsScreenState extends State<CompetitionsScreen> {
  late Future<List<Competition>> items;

  final PagingController<int, Competition> _pagingController =
      PagingController(firstPageKey: 1);

  Future<List<Competition>> fetchData(int pageKey) async {
    try {
      final service = CompetitionService();
      final data = await service.fetchCompetitions(pageKey);
      return data;
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchData(pageKey).then((data) {
        _pagingController.appendPage(data, pageKey + 1);
      }).catchError((error) {
        _pagingController.error = error;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return RefreshWidget(
      child: Scaffold(
          body: SafeArea(
        child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(children: [
              ScreenHead(
                hasNotification: true,
                screen: 1,
                searchHint: "search_for_category".tr(),
              ),
              SizedBox(
                  height: 930.h,
                  child: VerticalCompetitionList(
                      pagingController: _pagingController))
            ])),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
          onPressed: () {
            pushNewScreen(context,
                screen: UploadCompetitionVideo(), withNavBar: false);
          },
        child: Icon(Icons.add,color: Colors.white)
      ),
      ),
        onRefresh:()async{
          setState(() {
            _pagingController.refresh();
          });
        }
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
