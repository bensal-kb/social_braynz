import 'package:go_router/go_router.dart';

import '../../../core/base/base_ui/base_page.dart';
import '../../../core/base/base_ui/base_ui.dart';
import '../../../core/base/base_ui/state_widget.dart';
import '../../../core/router/app_routes.dart';
import '../../../widgets/dialogs/confirm_dialog.dart';
import '../bloc/product_detail_cubit/product_detail_cubit.dart';
import '../bloc/product_detail_cubit/product_detail_state.dart';
import '../widgets/product_detail_header.dart';
import '../widgets/recent_sales_list.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductDetailCubit(productRepo, saleRepo, productId: productId)..watch(),
      child: BasePage(
        appBar: AppBar(
          title: const Text('Product Details'),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.push(Routes.editProductPath(productId)),
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _onDelete(context),
              ),
            ),
          ],
        ),
        child: StateWidget<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            final product = state.product;
            if (product == null) {
              return const Center(child: Text('This product no longer exists.'));
            }
            return ListView(
              children: [
                ProductDetailHeader(product: product),
                RecentSalesList(sales: state.recentSales),
              ],
            );
          },
          retry: () => context.read<ProductDetailCubit>().watch(),
        ),
      ),
    );
  }

  Future<void> _onDelete(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete product?',
      message: 'This cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await context.read<ProductDetailCubit>().deleteProduct();
      if (context.mounted) context.pop();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
      }
    }
  }
}
