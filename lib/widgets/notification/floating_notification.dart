import 'package:flutter/material.dart';
import 'notification_item.dart';

class FloatingNotification extends StatelessWidget {
  final bool visible;
  final List<Map<String, dynamic>> notifications;
  final void Function(Map<String, dynamic>) onTapItem;
  final double topOffset; // posisi dari atas

  const FloatingNotification({
    super.key,
    required this.visible,
    required this.notifications,
    required this.onTapItem,
    this.topOffset = 80,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Positioned(
      top: topOffset,
      right: 16, // tempel ke kanan
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, // biar semua ke kanan
          children: notifications.map((notif) {
            return NotificationItem(
              title: notif['title'] ?? "",
              onTap: () => onTapItem(notif),
            );
          }).toList(),
        ),
      ),
    );
  }
}
