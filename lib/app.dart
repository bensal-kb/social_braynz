import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'dependencies/get_dependencies.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Inventory & Stock Manager',
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(),
      routerConfig: AppRouter.router,
    );
  }
}
