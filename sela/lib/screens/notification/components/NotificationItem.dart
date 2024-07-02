import 'package:flutter/material.dart';
import 'package:sela/utils/colors.dart';

class NotificationItem extends StatelessWidget {
  final String notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor4,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryColor, // Customize as needed
          child:
              _getNotificationIcon(), // Method to determine icon based on notification type
        ),
        title: Text(notification),
        onTap: () {
          // Implement action when notification is tapped
        },
      ),
    );
  }

  Icon _getNotificationIcon() {
    // Logic to determine which icon to display based on notification content
    // Example logic, customize as per your actual notification types
    if (notification.contains('new')) {
      return const Icon(Icons.add, color: Colors.white);
    } else if (notification.contains('message')) {
      return const Icon(Icons.message, color: Colors.white);
    } else {
      return const Icon(Icons.bookmark, color: Colors.white);
    }
  }
}
