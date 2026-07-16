import '../../../core/base/base_ui/base_ui.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/sale_model.dart';

class RecentSalesList extends StatelessWidget {
  const RecentSalesList({super.key, required this.sales});

  final List<SaleModel> sales;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Sales',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: context.theme.text,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.theme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.theme.divider),
          ),
          child: sales.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'No sales logged yet.',
                    style: TextStyle(color: context.theme.hint),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < sales.length; i++) ...[
                      if (i > 0)
                        Divider(height: 1, color: context.theme.divider),
                      _SaleRow(sale: sales[i]),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _SaleRow extends StatelessWidget {
  const _SaleRow({required this.sale});

  final SaleModel sale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.theme.success.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.point_of_sale,
              size: 18,
              color: context.theme.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${sale.quantitySold} sold',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.theme.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatDateTime(sale.timestamp),
                  style: TextStyle(fontSize: 12, color: context.theme.hint),
                ),
              ],
            ),
          ),
          Text(
            formatCurrency(sale.total),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: context.theme.text,
            ),
          ),
        ],
      ),
    );
  }
}
