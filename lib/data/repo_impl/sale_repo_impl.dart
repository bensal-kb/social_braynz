import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/fire_and_forget.dart';
import '../models/sale_model.dart';
import '../repo/sale_repo.dart';

class SaleRepoImpl implements SaleRepo {
  SaleRepoImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection(AppConstants.productsCollection);

  CollectionReference<Map<String, dynamic>> get _sales =>
      _firestore.collection(AppConstants.salesCollection);

  @override
  Stream<List<SaleModel>> watchSalesForProduct(
    String productId, {
    int limit = 10,
  }) => _sales
      .where('productId', isEqualTo: productId)
      .orderBy('timestamp', descending: true)
      .limit(limit)
      .snapshots(includeMetadataChanges: true)
      .map((snap) => snap.docs.map(SaleModel.fromDoc).toList());

  @override
  Future<void> logSale({
    required String productId,
    required String productName,
    required int quantitySold,
    required double unitPrice,
  }) async {
    final productRef = _products.doc(productId);
    final saleRef = _sales.doc();
    final sale = SaleModel(
      id: saleRef.id,
      productId: productId,
      productName: productName,
      quantitySold: quantitySold,
      unitPrice: unitPrice,
      total: unitPrice * quantitySold,
      timestamp: DateTime.now(),
    );

    // Set once the offline fallback has run. The transaction handler checks
    // it after its server read: if the read only completes after we've
    // already given up (e.g. connectivity restored later), the handler
    // aborts so the sale can't be committed twice.
    var abandoned = false;

    try {
      // Transactions read the authoritative server value first, so this
      // path gives strict, race-free stock validation — but it requires
      // connectivity, and offline it can block far longer than the SDK's
      // own timeout promises (a dropped network can leave the connection
      // half-open). The Dart-side .timeout() below is the one bound that
      // always fires.
      await _firestore
          .runTransaction(timeout: const Duration(seconds: 5), maxAttempts: 1, (tx) async {
            final snap = await tx.get(productRef);
            if (abandoned) {
              throw StateError('Transaction abandoned: offline fallback already logged this sale');
            }
            if (!snap.exists) {
              throw StateError('Product $productId not found');
            }
            final currentQty = (snap.data()!['quantity'] as num).toInt();
            if (currentQty < quantitySold) {
              throw InsufficientStockException(available: currentQty);
            }
            tx.update(productRef, {
              'quantity': currentQty - quantitySold,
              'updatedAt': Timestamp.fromDate(DateTime.now()),
            });
            tx.set(saleRef, sale.toJson());
          })
          .timeout(const Duration(seconds: 5));
    } on InsufficientStockException {
      // A genuine, server-validated rejection — surface it to the UI.
      rethrow;
    } catch (_) {
      abandoned = true;
      // Any other failure here is, in practice, "we're offline". Fall back to an
      // atomic, offline-safe write: FieldValue.increment is commutative and
      // queues correctly, so concurrent/offline decrements merge safely
      // once synced — unlike a plain read-then-overwrite update. Stock is
      // deliberately NOT re-validated here: a stale local read can't be
      // trusted if another device sold stock while this device was
      // offline. Quantity can go negative while offline; this is an
      // accepted, documented trade-off (see README).
      final batch = _firestore.batch();
      batch.update(productRef, {
        'quantity': FieldValue.increment(-quantitySold),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
      batch.set(saleRef, sale.toJson());
      fireAndForget(
        batch.commit(),
        label: 'logSale offline fallback ($productId)',
      );
    }
  }
}
