import 'package:go_router/go_router.dart';

import '../../../core/base/base_ui/base_ui.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/product_model.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final stockColor =
        product.isLowStock ? context.theme.warning : context.theme.success;
    final initial =
        product.name.isEmpty ? '?' : product.name.characters.first.toUpperCase();

    return Material(
      color: context.theme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => context.push(Routes.productDetailPath(product.id)),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.theme.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.theme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  initial,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: context.theme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: context.theme.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatCurrency(product.price),
                      style: TextStyle(fontSize: 13, color: context.theme.hint),
                    ),
                  ],
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
                  '${product.quantity} in stock',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: stockColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
