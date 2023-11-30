import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/notification.dart';
import '../../services/notification_service.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/info_card.dart';
import '../../widgets/main_app_bar.dart';
import '../../widgets/notification/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<NotificationData>> notifications;
  final PagingController<int, NotificationData> _pagingController =
  PagingController(firstPageKey: 1);

  Future<List<NotificationData>> fetchData() async {
    try {
      final service = NotificationService();
      final data = await service.fetchNotifications();
      return data;
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    notifications = fetchData();
    // _pagingController.addPageRequestListener((pageKey) {
    //   fetchData(pageKey).then((data){
    //     if (data.length < 15) {
    //       _pagingController.appendLastPage(data);
    //     } else {
    //       _pagingController.appendPage(data, pageKey + 1);
    //     }
    //   }).catchError((error) {
    //     _pagingController.error = error;
    //   });
    // });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: MainAppBar(
        title: "notifications".tr(),
        hasSearchField: false,
        hasMainIcons: false,
        specialAction: [
          TextButton(
              onPressed: () {
                markAllNotificationAsRead();
                setState(() {
                  notifications = fetchData();
                });
              },
              child: Text(
                "mark_all_as_read".tr(),
                style: TextStyle(
                    color: theme.buttonTheme.colorScheme?.primary,
                    fontSize: isTablet ? 10.sp : null),
              ))
        ],
      ),
      body: FutureBuilder(
          future: notifications,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: InfoCard(
                      onPress: (){
                        setState(() {
                          notifications = fetchData();
                        });
                      },
                      infoTitle: "Error",
                      infoBody: "Getting failed",
                      closeText: "",
                      buttonText: "Reload",
                      infoImage: "",
                      closeBtn: false
                  ));
            }
            return buildSlidableCards(snapshot.data as List<NotificationData>);
          }),
    );
  }


  Widget buildSlidableCards(List<NotificationData> notification) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      itemCount: notification.length,
      itemExtent: 255,
      itemBuilder: (BuildContext context, int index) {
        return Ink(
          child: InkWell(
            onTap: () {
              setState(() {
                notification[index].isRead = true;
              });
              markNotificationAsRead(notification[index].id.toString());
            },
            child: NotificationCard(
              data: notification[index],
            ),
          ),
        );
      },
    );
  }

  void markNotificationAsRead(String id) {
    NotificationService service = NotificationService();
    service.markNotificationAsRead(id);
  }

  void markAllNotificationAsRead() {
    NotificationService service = NotificationService();
    service.markAllNotificationAsRead();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
