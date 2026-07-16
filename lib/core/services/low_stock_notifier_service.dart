import 'dart:async';

import '../../data/models/product_model.dart';
import '../../data/repo/product_repo.dart';
import '../../dependencies/get_dependencies.dart';
import 'notification_service.dart';

/// Watches products and fires a local notification the moment a product
/// transitions from not-low-stock to low-stock. Never fires on the initial
/// snapshot (cold start) — otherwise every already-low product would alert
/// on every app launch.
class LowStockNotifierService {
  LowStockNotifierService(this._productRepo, this._notificationService);

  final ProductRepo _productRepo;
  final NotificationService _notificationService;

  StreamSubscription<List<ProductModel>>? _sub;
  final Map<String, bool> _lowStockState = {};
  bool _initialized = false;

  void start() {
    _sub = _productRepo.watchProducts().listen(
      _onProducts,
      onError: (Object e, StackTrace st) =>
          logger.e('LowStockNotifierService stream failed', error: e, stackTrace: st),
    );
  }

  void _onProducts(List<ProductModel> products) {
    final currentIds = products.map((p) => p.id).toSet();
    _lowStockState.removeWhere((id, _) => !currentIds.contains(id));

    for (final product in products) {
      final wasLow = _lowStockState[product.id] ?? false;
      if (_initialized && !wasLow && product.isLowStock) {
        _notificationService.showLowStockAlert(product);
      }
      _lowStockState[product.id] = product.isLowStock;
    }
    _initialized = true;
  }

  void dispose() => _sub?.cancel();
}
