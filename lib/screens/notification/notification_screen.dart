import 'package:buttons_tabbar/buttons_tabbar.dart';
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
import '../../widgets/svg_icon.dart';

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
    print("fetch notifications");
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
            return buildTabs(snapshot.data as List<NotificationData>);
          }),
    );
  }
  int selectedIndex = 0;

  @override
  Widget buildTabs(List<NotificationData> notification) {
    List<NotificationData> readNotifications = [];
    List<NotificationData> unreadNotifications = [];
    if(notification.length!=0){
      print("Organized");
      for (NotificationData notification in notification) {
        if (notification.isRead) {
          readNotifications.add(notification);
        } else {
          unreadNotifications.add(notification);
        }
      }
    }
    List<Widget> tabViews = [
      ListView.builder(
          shrinkWrap: true,
          itemCount: readNotifications.length,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return NotificationCard(
              isRead: true,
              reFresh: (){
                setState(() {
                  notifications = fetchData();
                });
              },
              delete: (){
                print("Delete at Screen");
              },
              data: notification[index],
            );
          }),
      ListView.builder(
          shrinkWrap: true,
          itemCount: unreadNotifications.length,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            print("notification[index].isRead true ${notification[index].isRead}");
            return NotificationCard(
              isRead: false,
              reFresh: (){
                setState(() {
                  notifications = fetchData();
                });
              },
              delete: (){
                print("Delete at Screen");
                markNotificationAsRead(notification[index].id);
              },
              data: notification[index],
            );
          }),
      ListView.builder(
          shrinkWrap: true,
          itemCount: notification.length,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return NotificationCard(
              isRead: true,
              reFresh: (){
                setState(() {
                  notifications = fetchData();
                });
              },
              delete: (){
                print("Delete at Screen");
              },
              data: notification[index],
            );
          })
    ];
    if(notification.length==0) {
      return Center(
          child: InfoCard(
              onPress: (){
                setState(() {
                  notifications = fetchData();
                });
              },
              infoTitle: "No Notification",
              infoBody: "There is no Notification",
              closeText: "",
              buttonText: "Reload",
              infoImage: "",
              closeBtn: false
          ));
    }
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ButtonsTabBar(
              onTap: (index) {
                print("selectedIndex $selectedIndex");
                print("index $index");
                setState(() {
                  selectedIndex = index;
                });
                print("selectedIndex $selectedIndex");
                print("index $index");
              },
              backgroundColor: theme.colorScheme.primary,
              unselectedBackgroundColor: Colors.transparent,
              unselectedLabelStyle: theme.textTheme.labelMedium
                  ?.copyWith(
                  color: theme.colorScheme.tertiary
              ),
              labelStyle: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onTertiary),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              radius: 5,
              tabs: [
                Tab(text: 'read'.tr()),
                Tab(text: 'unread'.tr(),),
                Tab(text: 'all'.tr(),)
              ],
            ),
            Expanded(child: tabViews[selectedIndex])
          ],
        ),
      ),
    );

  }

  void markNotificationAsRead(int id) {
    print("id $id");
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
