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
    return ListTile(
      onTap: () => context.push(Routes.productDetailPath(product.id)),
      title: Text(product.name),
      subtitle: Text(formatCurrency(product.price)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${product.quantity} in stock',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: product.isLowStock ? context.theme.warning : context.theme.text,
            ),
          ),
          if (product.isLowStock)
            Text(
              'Low stock',
              style: TextStyle(fontSize: 12, color: context.theme.warning),
            ),
        ],
      ),
    );
  }
}
