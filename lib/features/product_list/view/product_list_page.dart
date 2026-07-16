import 'package:go_router/go_router.dart';

import '../../../core/base/base_ui/base_page.dart';
import '../../../core/base/base_ui/base_ui.dart';
import '../../../core/base/base_ui/state_widget.dart';
import '../../../core/router/app_routes.dart';
import '../../../widgets/sync_status_banner.dart';
import '../bloc/product_list_cubit/product_list_cubit.dart';
import '../bloc/product_list_cubit/product_list_state.dart';
import '../widgets/empty_products_view.dart';
import '../widgets/inventory_summary.dart';
import '../widgets/low_stock_banner.dart';
import '../widgets/product_list_tile.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key, this.lowStockOnly = false});

  final bool lowStockOnly;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductListCubit(productRepo, connectivityService, lowStockOnly: lowStockOnly)
            ..watch(),
      child: BasePage(
        appBar: AppBar(title: Text(lowStockOnly ? 'Low Stock' : 'Inventory')),
        floatingActionButton: lowStockOnly
            ? null
            : FloatingActionButton.extended(
                onPressed: () => context.push(Routes.addProduct),
                backgroundColor: context.theme.primary,
                foregroundColor: context.theme.light,
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
              ),
        child: StateWidget<ProductListCubit, ProductListState>(
          builder: (context, state) {
            final products = state.visibleProducts;

            if (products.isEmpty) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  children: [
                    SyncStatusBanner(isOffline: state.showOfflineBanner),
                    Expanded(child: EmptyProductsView(lowStockOnly: lowStockOnly)),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                SyncStatusBanner(isOffline: state.showOfflineBanner),
                if (!lowStockOnly) ...[
                  InventorySummary(
                    products: state.products,
                    lowStockCount: state.lowStockCount,
                  ),
                  const SizedBox(height: 12),
                  LowStockBanner(count: state.lowStockCount),
                ],
                for (final product in products)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ProductListTile(product: product),
                  ),
              ],
            );
          },
          retry: () => context.read<ProductListCubit>().watch(),
        ),
      ),
    );
  }
}
