import 'package:go_router/go_router.dart';

import '../../../core/base/base_ui/base_ui.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/product_model.dart';

class ProductDetailHeader extends StatelessWidget {
  const ProductDetailHeader({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _stat(context, 'Stock', '${product.quantity}'),
                _stat(context, 'Price', formatCurrency(product.price)),
                _stat(context, 'Threshold', '${product.lowStockThreshold}'),
              ],
            ),
            if (product.isLowStock) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: context.theme.warning, size: 18),
                  const SizedBox(width: 6),
                  Text('Low stock', style: TextStyle(color: context.theme.warning)),
                ],
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.push(Routes.logSalePath(product.id)),
              icon: const Icon(Icons.point_of_sale),
              label: const Text('Log a Sale'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(BuildContext context, String label, String value) => Column(
    children: [
      Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      Text(label, style: TextStyle(fontSize: 12, color: context.theme.hint)),
    ],
  );
}
