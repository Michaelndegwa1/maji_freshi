import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color iconColor;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.iconColor,
  });
}

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<NotificationModel> _notifications = [
    const NotificationModel(
      id: '1',
      title: 'Your order is on the way!',
      body: 'Order #1235 is out for delivery. Estimated arrival: 11:30 AM.',
      time: '10:45 AM',
      icon: Icons.local_shipping,
      iconColor: Colors.cyan, // AppColors.secondary
    ),
    const NotificationModel(
      id: '2',
      title: 'Payment confirmed',
      body: 'Your payment of KSH 500 for order #1235 has been confirmed.',
      time: '09:15 AM',
      icon: Icons.check_circle,
      iconColor: Colors.green,
    ),
    const NotificationModel(
      id: '3',
      title: 'Order delivered',
      body: 'Your order #1234 has been successfully delivered. Thank you!',
      time: 'Yesterday, 11:45 AM',
      icon: Icons.inventory_2,
      iconColor: Colors.blue,
    ),
    const NotificationModel(
      id: '4',
      title: 'Special Offer!',
      body: 'Get 15% off on your next order. Use code: FRESH15. T&C apply.',
      time: 'Yesterday, 09:00 AM',
      icon: Icons.campaign,
      iconColor: Colors.orange,
    ),
  ];

  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
