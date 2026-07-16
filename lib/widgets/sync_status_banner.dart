import '../core/base/base_ui/base_ui.dart';

class SyncStatusBanner extends StatelessWidget {
  const SyncStatusBanner({super.key, required this.isOffline});

  /// True if either the OS reports no connectivity, or Firestore is still
  /// serving cached (not live-synced) data — whichever notices first.
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: context.theme.hint.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(Icons.cloud_off, size: 16, color: context.theme.hint),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Offline — showing saved data. Will sync when back online.',
                style: TextStyle(fontSize: 12, color: context.theme.hint),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
