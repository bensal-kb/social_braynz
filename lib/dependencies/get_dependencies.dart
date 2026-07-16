import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../core/services/connectivity_service.dart';
import '../core/services/notification_service.dart';
import '../core/styles/app_theme.dart';
import '../data/repo/product_repo.dart';
import '../data/repo/sale_repo.dart';

final GetIt sl = GetIt.instance;

Logger get logger => sl<Logger>();
AppTheme get appTheme => sl<AppTheme>();
NotificationService get notificationService => sl<NotificationService>();
ConnectivityService get connectivityService => sl<ConnectivityService>();
ProductRepo get productRepo => sl<ProductRepo>();
SaleRepo get saleRepo => sl<SaleRepo>();
