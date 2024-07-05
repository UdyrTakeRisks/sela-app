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
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryColor, // Customize as needed
          child:
              _getNotificationIcon(), // Determine icon based on notification content
        ),
        title: Text(
          notification,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        onTap: () {
          // Implement action when notification is tapped
        },
      ),
    );
  }

  Icon _getNotificationIcon() {
    // Logic to determine which icon to display based on notification content
    if (notification.contains('Date') &&
        notification.contains('Time') &&
        notification.contains('You have successfully logged in.')) {
      return const Icon(Icons.check_circle_rounded, color: Colors.white);
    } else if (notification.contains('The Post Created Successfully')) {
      return const Icon(Icons.add_box, color: Colors.white);
    } else {
      return const Icon(Icons.notifications_active, color: Colors.white);
    }
  }
}
