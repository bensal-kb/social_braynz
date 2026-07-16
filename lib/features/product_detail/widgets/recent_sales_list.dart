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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recent Sales',
            style: TextStyle(fontWeight: FontWeight.bold, color: context.theme.text),
          ),
        ),
        if (sales.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('No sales logged yet.', style: TextStyle(color: context.theme.hint)),
          )
        else
          ...sales.map(
            (sale) => ListTile(
              title: Text('${sale.quantitySold} sold'),
              subtitle: Text(formatDateTime(sale.timestamp)),
              trailing: Text(formatCurrency(sale.total)),
            ),
          ),
      ],
    );
  }
}
