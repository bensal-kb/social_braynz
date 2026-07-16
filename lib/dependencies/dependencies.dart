import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

import '../core/services/connectivity_service.dart';
import '../core/services/low_stock_notifier_service.dart';
import '../core/services/notification_service.dart';
import '../core/styles/app_theme.dart';
import '../data/repo/product_repo.dart';
import '../data/repo/sale_repo.dart';
import '../data/repo_impl/product_repo_impl.dart';
import '../data/repo_impl/sale_repo_impl.dart';
import 'get_dependencies.dart';

Future<void> initInjections() async {
  // 1. Firestore offline persistence — its local cache IS the offline
  //    store; the SDK queues/syncs writes and merges on reconnect.
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  // 2. Core singletons
  sl.registerSingleton<Logger>(Logger());
  sl.registerSingleton<AppTheme>(AppTheme());
  sl.registerLazySingleton<NotificationService>(() => NotificationService());

  // 3. Repos
  sl.registerLazySingleton<ProductRepo>(() => ProductRepoImpl(sl()));
  sl.registerLazySingleton<SaleRepo>(() => SaleRepoImpl(sl()));

  // 4. Global services reacting to repo streams
  sl.registerLazySingleton<LowStockNotifierService>(
    () => LowStockNotifierService(sl(), sl()),
  );

  // 5. Bridges OS connectivity changes into Firestore's network state so
  //    offline/online detection isn't left to Firestore's own passive
  //    (and sometimes slow) stream-failure detection.
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(sl(), sl()),
  );
}
