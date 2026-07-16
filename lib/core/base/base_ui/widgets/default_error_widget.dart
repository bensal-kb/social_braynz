import '../base_ui.dart';

class DefaultErrorWidget extends StatelessWidget {
  const DefaultErrorWidget({super.key, required this.state, this.retry});

  final BaseState state;
  final VoidCallback? retry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: context.theme.error, size: 48),
            const SizedBox(height: 12),
            Text(
              state.error?.message ?? 'Something went wrong.',
              textAlign: TextAlign.center,
            ),
            if (retry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: retry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
