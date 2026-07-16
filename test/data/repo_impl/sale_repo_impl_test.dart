import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:social_braynz_task/data/repo/sale_repo.dart';
import 'package:social_braynz_task/data/repo_impl/sale_repo_impl.dart';

// fake_cloud_firestore always has connectivity, so it can only exercise the
// runTransaction (online) branch of SaleRepoImpl.logSale — the offline
// WriteBatch fallback is a real-device/emulator concern, verified manually
// (airplane mode) per the plan, not unit-testable against this fake.
void main() {
  late FakeFirebaseFirestore firestore;
  late SaleRepo saleRepo;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    saleRepo = SaleRepoImpl(firestore);
    await firestore.collection('products').doc('p1').set({
      'name': 'Widget',
      'quantity': 10,
      'price': 5.0,
      'lowStockThreshold': 5,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  });

  test('logSale decrements stock and records a sale when stock is sufficient', () async {
    await saleRepo.logSale(
      productId: 'p1',
      productName: 'Widget',
      quantitySold: 3,
      unitPrice: 5.0,
    );

    final product = await firestore.collection('products').doc('p1').get();
    expect(product.data()!['quantity'], 7);

    final sales = await firestore
        .collection('sales')
        .where('productId', isEqualTo: 'p1')
        .get();
    expect(sales.docs, hasLength(1));
    expect(sales.docs.first.data()['quantitySold'], 3);
    expect(sales.docs.first.data()['total'], 15.0);
  });

  test('logSale throws InsufficientStockException and leaves stock untouched '
      'when quantitySold exceeds available stock', () async {
    expect(
      () => saleRepo.logSale(
        productId: 'p1',
        productName: 'Widget',
        quantitySold: 999,
        unitPrice: 5.0,
      ),
      throwsA(isA<InsufficientStockException>()),
    );

    // Allow the rejected transaction to finish before asserting no side effects.
    await Future<void>.delayed(Duration.zero);

    final product = await firestore.collection('products').doc('p1').get();
    expect(product.data()!['quantity'], 10);

    final sales = await firestore
        .collection('sales')
        .where('productId', isEqualTo: 'p1')
        .get();
    expect(sales.docs, isEmpty);
  });
}
