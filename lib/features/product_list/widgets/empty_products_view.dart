import '../../../core/base/base_ui/base_ui.dart';

class EmptyProductsView extends StatelessWidget {
  const EmptyProductsView({super.key, this.lowStockOnly = false});

  final bool lowStockOnly;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              lowStockOnly ? Icons.check_circle_outline : Icons.inventory_2_outlined,
              size: 56,
              color: context.theme.hint,
            ),
            const SizedBox(height: 12),
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
