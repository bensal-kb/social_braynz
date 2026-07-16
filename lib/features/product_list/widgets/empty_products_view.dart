import '../../../core/base/base_ui/base_ui.dart';

class EmptyProductsView extends StatelessWidget {
  const EmptyProductsView({super.key, this.lowStockOnly = false});

  final bool lowStockOnly;

  @override
  Widget build(BuildContext context) {
    final color = lowStockOnly ? context.theme.success : context.theme.primary;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                lowStockOnly
                    ? Icons.check_circle_outline
                    : Icons.inventory_2_outlined,
                size: 44,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              lowStockOnly ? 'All stocked up!' : 'Your inventory is empty',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.theme.text,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              lowStockOnly
                  ? 'No products are running low right now.'
                  : 'No products yet. Tap + to add your first one.',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.theme.hint),
            ),
          ],
        ),
      ),
    );
  }
}
