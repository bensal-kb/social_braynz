import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'package:social_braynz_task/core/services/connectivity_service.dart';
import 'package:social_braynz_task/core/styles/app_theme.dart';
import 'package:social_braynz_task/data/models/product_model.dart';
import 'package:social_braynz_task/data/repo/product_repo.dart';
import 'package:social_braynz_task/data/repo/sale_repo.dart';
import 'package:social_braynz_task/data/repo_impl/product_repo_impl.dart';
import 'package:social_braynz_task/data/repo_impl/sale_repo_impl.dart';
import 'package:social_braynz_task/features/product_list/view/product_list_page.dart';

void main() {
  setUp(() async {
    await GetIt.instance.reset();
    final fakeFirestore = FakeFirebaseFirestore();
    GetIt.instance
      ..registerSingleton<FirebaseFirestore>(fakeFirestore)
      ..registerSingleton<Logger>(Logger())
      ..registerSingleton<AppTheme>(AppTheme())
      ..registerLazySingleton<ProductRepo>(() => ProductRepoImpl(fakeFirestore))
      ..registerLazySingleton<SaleRepo>(() => SaleRepoImpl(fakeFirestore))
      // .start() is never called, so the real connectivity_plus platform
      // channel is never touched — onlineStatus just stays quiet, which is
      // fine for these widget tests.
      ..registerLazySingleton<ConnectivityService>(
        () => ConnectivityService(fakeFirestore, Connectivity()),
      );
  });

  testWidgets('Product list shows the empty state with no products', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProductListPage()));
    await tester.pumpAndSettle();

    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('No products yet. Tap + to add your first one.'), findsOneWidget);
  });

  testWidgets('Product list shows a product seeded in Firestore', (
    WidgetTester tester,
  ) async {
    final firestore = GetIt.instance<FirebaseFirestore>();
    final product = ProductModel(id: 'p1', name: 'Widget', quantity: 2, price: 9.99);
    await firestore.collection('products').doc('p1').set(product.toJson());

    await tester.pumpWidget(const MaterialApp(home: ProductListPage()));
    await tester.pumpAndSettle();

    expect(find.text('Widget'), findsOneWidget);
    expect(find.text('2 in stock'), findsOneWidget);
  });
}
