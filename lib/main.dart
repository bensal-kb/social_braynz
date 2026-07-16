import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'core/base/base_bloc/bloc_observer.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/low_stock_notifier_service.dart';
import 'dependencies/dependencies.dart';
import 'dependencies/get_dependencies.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initInjections();

  await notificationService.init();
  await notificationService.requestPermission();
  sl<LowStockNotifierService>().start();
  sl<ConnectivityService>().start();

  runApp(const App());
}
