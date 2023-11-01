import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/screens/competition/layout/vertical_competition_list.dart';
import 'package:ethio_chef/services/competition_service.dart';
import 'package:ethio_chef/widgets/screen_head.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CompetitionScreen extends StatefulWidget {
  const CompetitionScreen({super.key});

  @override
  State<CompetitionScreen> createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreen> {
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
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(children: [
            ScreenHead(
              hasNotification: true,
              screen: 1,
              searchHint: "Search for competition",
            ),
            SizedBox(
                height: 700.h,
                child: VerticalCompetitionList(
                    pagingController: _pagingController))
          ])),
    ));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
