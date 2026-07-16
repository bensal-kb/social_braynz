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
    final stockColor =
        product.isLowStock ? context.theme.warning : context.theme.success;
    final initial =
        product.name.isEmpty ? '?' : product.name.characters.first.toUpperCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.theme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.theme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  initial,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: context.theme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: context.theme.text,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: stockColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  product.isLowStock ? 'Low stock' : 'In stock',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: stockColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatBlock(
                  label: 'Stock',
                  value: '${product.quantity}',
                  color: stockColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBlock(
                  label: 'Price',
                  value: formatCurrency(product.price),
                  color: context.theme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBlock(
                  label: 'Threshold',
                  value: '${product.lowStockThreshold}',
                  color: context.theme.hint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.push(Routes.logSalePath(product.id)),
            icon: const Icon(Icons.point_of_sale),
            label: const Text('Log a Sale'),
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.theme.text,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: context.theme.hint),
          ),
        ],
      ),
    );
  }
}
