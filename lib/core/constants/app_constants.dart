class AppConstants {
  AppConstants._();

  static const int defaultLowStockThreshold = 5;

  static const String productsCollection = 'products';
  static const String salesCollection = 'sales';

  static const String lowStockNotificationChannelId = 'low_stock_channel';
  static const String lowStockNotificationChannelName = 'Low Stock Alerts';
  static const String lowStockNotificationChannelDescription =
      'Notifies you when a product drops at or below its low-stock threshold.';
}
