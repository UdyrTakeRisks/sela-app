import 'package:flutter/material.dart';
import 'package:sela/screens/notification/services/notification_service.dart';
import 'package:sela/utils/colors.dart';

import 'components/NotificationList.dart';

class NotificationPage extends StatelessWidget {
  static String routeName = '/notification';

  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Implement refresh logic
        NotificationService.fetchOldNotifications();
        NotificationService.fetchNewNotifications();
      },
      color: primaryColor,
      backgroundColor: backgroundColor4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Notifications'),
          backgroundColor: Colors.transparent, // Customize as needed
          elevation: 0, // Customize as needed
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationCategory(context, 'New'),
              const SizedBox(height: 10),
              const NotificationList(
                  notificationType: NotificationType.newItem),
              const SizedBox(height: 20),
              _buildNotificationCategory(context, 'Oldest'),
              const SizedBox(height: 10),
              const NotificationList(
                  notificationType: NotificationType.oldestItem),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCategory(BuildContext context, String category) {
    return Text(
      category,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
