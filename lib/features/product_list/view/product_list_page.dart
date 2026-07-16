import 'package:go_router/go_router.dart';

import '../../../core/base/base_ui/base_page.dart';
import '../../../core/base/base_ui/base_ui.dart';
import '../../../core/base/base_ui/state_widget.dart';
import '../../../core/router/app_routes.dart';
import '../../../widgets/sync_status_banner.dart';
import '../bloc/product_list_cubit/product_list_cubit.dart';
import '../bloc/product_list_cubit/product_list_state.dart';
import '../widgets/empty_products_view.dart';
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
            : FloatingActionButton(
                onPressed: () => context.push(Routes.addProduct),
                child: const Icon(Icons.add),
              ),
        child: StateWidget<ProductListCubit, ProductListState>(
          builder: (context, state) {
            final products = state.visibleProducts;
            return Column(
              children: [
                SyncStatusBanner(isOffline: state.showOfflineBanner),
                if (!lowStockOnly) LowStockBanner(count: state.lowStockCount),
                Expanded(
                  child: products.isEmpty
                      ? EmptyProductsView(lowStockOnly: lowStockOnly)
                      : ListView.separated(
                          itemCount: products.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) =>
                              ProductListTile(product: products[index]),
                        ),
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
