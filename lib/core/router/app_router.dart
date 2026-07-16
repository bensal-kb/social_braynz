import 'package:go_router/go_router.dart';

import '../../features/log_sale/view/log_sale_page.dart';
import '../../features/product_detail/view/product_detail_page.dart';
import '../../features/product_form/view/product_form_page.dart';
import '../../features/product_list/view/product_list_page.dart';
import '../base/base_ui/base_ui.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.productList,
    routes: [
      GoRoute(
        path: Routes.productList,
        builder: (context, state) => const ProductListPage(),
      ),
      GoRoute(
        path: Routes.lowStock,
        builder: (context, state) => const ProductListPage(lowStockOnly: true),
      ),
      GoRoute(
        path: Routes.addProduct,
        builder: (context, state) => const ProductFormPage(),
      ),
      GoRoute(
        path: Routes.productDetail,
        builder: (context, state) =>
            ProductDetailPage(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.editProduct,
        builder: (context, state) =>
            ProductFormPage(productId: state.pathParameters['id']),
      ),
      GoRoute(
        path: Routes.logSale,
        builder: (context, state) =>
            _LogSaleLoader(productId: state.pathParameters['id']!),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}

class _LogSaleLoader extends StatelessWidget {
  const _LogSaleLoader({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: productRepo.getProduct(productId),
      builder: (context, snapshot) {
        final product = snapshot.data;
        if (product != null) return LogSalePage(product: product);
        if (snapshot.hasError ||
            (snapshot.connectionState == ConnectionState.done)) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Product could not be loaded.')),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
