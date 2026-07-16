import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../data/models/product_model.dart';
import '../constants/app_constants.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            AppConstants.lowStockNotificationChannelId,
            AppConstants.lowStockNotificationChannelName,
            description: AppConstants.lowStockNotificationChannelDescription,
            importance: Importance.high,
          ),
        );
  }

  Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> showLowStockAlert(ProductModel product) {
    return _plugin.show(
      product.id.hashCode,
      'Low stock: ${product.name}',
      'Only ${product.quantity} left (threshold ${product.lowStockThreshold}).',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.lowStockNotificationChannelId,
          AppConstants.lowStockNotificationChannelName,
          channelDescription: AppConstants.lowStockNotificationChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
