import '../models/sale_model.dart';

class InsufficientStockException implements Exception {
  const InsufficientStockException({required this.available});

  final int available;

  @override
  String toString() => 'InsufficientStockException(available: $available)';
}

abstract class SaleRepo {
  Stream<List<SaleModel>> watchSalesForProduct(String productId, {int limit = 10});

  /// Deducts [quantitySold] from the product's stock and records a sale.
  ///
  /// Resolves once the write has been issued to the local cache — it does
  /// NOT wait for server acknowledgment, so it's safe to await from UI code
  /// even while offline. Throws [InsufficientStockException] only when
  /// stock could be validated against a live server read (i.e. while
  /// online); offline writes are not blocked on stock validation.
  Future<void> logSale({
    required String productId,
    required String productName,
    required int quantitySold,
    required double unitPrice,
  });
}
