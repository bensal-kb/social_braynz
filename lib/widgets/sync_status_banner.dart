import '../core/base/base_ui/base_ui.dart';

class SyncStatusBanner extends StatelessWidget {
  const SyncStatusBanner({super.key, required this.isOffline});

  /// True if either the OS reports no connectivity, or Firestore is still
  /// serving cached (not live-synced) data — whichever notices first.
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: context.theme.hint.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.cloud_off, size: 16, color: context.theme.hint),
          const SizedBox(width: 8),
          Text(
            'Offline — showing saved data. Will sync when back online.',
            style: TextStyle(fontSize: 12, color: context.theme.hint),
          ),
        ],
      ),
    );
  }
}
