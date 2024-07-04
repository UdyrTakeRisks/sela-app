import 'package:flutter/material.dart';
import 'package:sela/screens/notification/services/notification_service.dart';
import 'package:sela/utils/colors.dart';

import 'components/NotificationList.dart';

class NotificationPage extends StatefulWidget {
  static String routeName = '/notification';

  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isRefreshing = false;

  Future<void> _refreshNotifications() async {
    setState(() {
      _isRefreshing = true; // Set refreshing flag to true
    });

    try {
      // Simulate a delay for demonstration (remove in production)
      await Future.delayed(Duration(seconds: 2));

      await NotificationService.fetchOldNotifications();
      await NotificationService.fetchNewNotifications();

      if (mounted) {
        setState(() {
          _isRefreshing = false; // Set refreshing flag to false when done
        });
      }
    } catch (e) {
      if (mounted) {
        print('Error fetching notifications: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load notifications')),
        );
        setState(() {
          _isRefreshing = false; // Set refreshing flag to false on error
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent, // Customize as needed
        elevation: 0, // Customize as needed
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        color: primaryColor,
        backgroundColor: backgroundColor4,
        // Show a circular progress indicator while refreshing
        child: _isRefreshing
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(20),
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
