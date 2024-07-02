import 'package:flutter/material.dart';

import 'NotificationItem.dart';

enum NotificationType {
  newItem,
  todayItem,
  oldestItem,
}

class NotificationList extends StatelessWidget {
  final NotificationType notificationType;

  const NotificationList({super.key, required this.notificationType});

  @override
  Widget build(BuildContext context) {
    List<String> notifications = _getNotifications(notificationType);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        String notification = notifications[index];
        return NotificationItem(notification: notification);
      },
    );
  }

  List<String> _getNotifications(NotificationType type) {
    switch (type) {
      case NotificationType.newItem:
        return [
          "A new Organization has been added",
          "You have a message",
          "A new Organization has been added"
        ];
      case NotificationType.todayItem:
        return [
          "You have a message",
          "You Saved a Organization",
          "A new Organization has been added",
        ];
      case NotificationType.oldestItem:
        return [
          "You Saved a Organization",
          "You Saved a Organization",
          "You have a message",
          "You have a message"
        ];
      default:
        return [];
    }
  }
}
