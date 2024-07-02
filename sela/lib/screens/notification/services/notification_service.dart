class NotificationService {
  static Future<List<String>> fetchNotifications() async {
    // Example implementation, replace with actual API call or data fetching logic
    await Future.delayed(const Duration(seconds: 2)); // Simulating delay
    return [
      'Notification 1',
      'Notification 2',
      'Notification 3',
    ];
  }
}
