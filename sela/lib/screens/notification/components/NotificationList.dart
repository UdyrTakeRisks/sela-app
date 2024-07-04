import 'package:flutter/material.dart';
import 'package:sela/utils/colors.dart';

import '../services/notification_service.dart';
import 'NotificationItem.dart';

enum NotificationType {
  newItem,
  oldestItem,
}

class NotificationList extends StatelessWidget {
  final NotificationType notificationType;

  const NotificationList({super.key, required this.notificationType});

  Future<List<String>> _getNotifications(NotificationType type) async {
    switch (type) {
      case NotificationType.newItem:
        return await NotificationService.fetchNewNotifications();
      case NotificationType.oldestItem:
        return await NotificationService.fetchOldNotifications();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getNotifications(notificationType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: primaryColor,
            backgroundColor: backgroundColor4,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No notifications available'));
        } else if (snapshot.data!.contains("No messages in the queue.") ||
            snapshot.data!.contains("No Notifications Found")) {
          return const SizedBox(
              height: 50,
              child: Center(child: Text('No New Notifications Available')));
        } else {
          List<String> notifications = snapshot.data!;
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              String notification = notifications[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: NotificationItem(notification: notification),
              );
            },
          );
        }
      },
    );
  }
}
