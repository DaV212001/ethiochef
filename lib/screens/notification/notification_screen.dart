import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/notification.dart';
import '../../services/notification_service.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/info_card.dart';
import '../../widgets/main_app_bar.dart';
import '../../widgets/notification/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<List<NotificationData>> _notifications =
      NotificationService().fetchNotifications();

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: MainAppBar(
        title: 'notifications'.tr(),
        hasSearchField: false,
        hasMainIcons: false,
        specialAction: [
          TextButton(
            onPressed: () async {
              NotificationService service = NotificationService();
              service.markAllNotificationAsRead();
              setState(() {
                _notifications = NotificationService().fetchNotifications();
              });
            },
            child: Text(
              'mark_all_as_read'.tr(),
              style: TextStyle(
                color: theme.buttonTheme.colorScheme?.primary,
                fontSize: isTablet ? 10.sp : null,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<NotificationData>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: InfoCard(
                onPress: () => setState(() => _notifications =
                    NotificationService().fetchNotifications()),
                infoTitle: 'Error',
                infoBody: 'Getting failed',
                buttonText: 'Reload',
                closeText: '',
              ),
            );
          }

          final notifications = snapshot.data!;

          if (notifications.isEmpty) {
            return Center(
              child: InfoCard(
                onPress: () => setState(() {
                  _notifications = NotificationService().fetchNotifications();
                }),
                infoTitle: 'No Notification',
                infoBody: 'There is no Notification',
                buttonText: 'Reload',
                closeText: '',
              ),
            );
          }

          final readNotifications =
              notifications.where((n) => n.isRead).toList();
          final unreadNotifications =
              notifications.where((n) => !n.isRead).toList();

          return SafeArea(
            child: DefaultTabController(
              length: 3,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ButtonsTabBar(
                    onTap: (index) => setState(() => selectedIndex = index),
                    backgroundColor: theme.colorScheme.primary,
                    unselectedBackgroundColor: Colors.transparent,
                    unselectedLabelStyle: TextStyle(
                        fontSize: isTablet ? 11.sp : 15.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.primary),
                    labelStyle: TextStyle(
                        fontSize: isTablet ? 11.sp : 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    radius: 5,
                    tabs: [
                      Tab(text: 'read'.tr()),
                      Tab(text: 'unread'.tr()),
                      Tab(text: 'all'.tr()),
                    ],
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: selectedIndex,
                      children: [
                        _buildNotificationList(context, readNotifications),
                        _buildNotificationList(context, unreadNotifications),
                        _buildNotificationList(context, notifications),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  int selectedIndex = 0;

  Widget _buildNotificationList(
      BuildContext context, List<NotificationData> notifications) {
    final bool isTablet = ScreenUtils.isTablet(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: notifications.length,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) => NotificationCard(
        isRead: notifications[index].isRead,
        reFresh: () => setState(
            () => _notifications = NotificationService().fetchNotifications()),
        delete: () => NotificationService()
            .markNotificationAsRead(notifications[index].id),
        data: notifications[index],
      ),
    );
  }
}
