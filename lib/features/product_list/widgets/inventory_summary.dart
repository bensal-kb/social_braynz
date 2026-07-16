import 'package:go_router/go_router.dart';

import '../../../core/base/base_ui/base_ui.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/product_model.dart';

/// Stat cards shown at the top of the home page: product count, total stock
/// value, and low-stock count (tappable when non-zero).
class InventorySummary extends StatelessWidget {
  const InventorySummary({
    super.key,
    required this.products,
    required this.lowStockCount,
  });

  final List<ProductModel> products;
  final int lowStockCount;

  @override
  Widget build(BuildContext context) {
    final totalValue = products.fold<double>(
      0,
      (sum, p) => sum + p.quantity * p.price,
    );
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.inventory_2_outlined,
            color: context.theme.primary,
            value: '${products.length}',
            label: 'Products',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.payments_outlined,
            color: context.theme.success,
            value: formatCurrency(totalValue),
            label: 'Stock value',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.warning_amber_rounded,
            color: lowStockCount > 0 ? context.theme.warning : context.theme.hint,
            value: '$lowStockCount',
            label: 'Low stock',
            onTap: lowStockCount > 0 ? () => context.push(Routes.lowStock) : null,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.theme.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 17,
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
        ),
      ),
    );
  }
}
