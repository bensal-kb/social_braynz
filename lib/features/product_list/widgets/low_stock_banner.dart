import 'package:go_router/go_router.dart';

import '../../../core/base/base_ui/base_ui.dart';
import '../../../core/router/app_routes.dart';

class LowStockBanner extends StatelessWidget {
  const LowStockBanner({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: context.theme.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => context.push(Routes.lowStock),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: context.theme.warning),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$count product${count == 1 ? '' : 's'} running low on stock',
                    style: TextStyle(
                      color: context.theme.text,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: context.theme.warning),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
