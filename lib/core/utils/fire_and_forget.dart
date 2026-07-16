import 'dart:async';

import '../../dependencies/get_dependencies.dart';

/// Issues [future] without waiting for it to complete.
///
/// Firestore write futures only resolve on server acknowledgment, even
/// though the local cache (and any active listener) updates instantly —
/// awaiting them would hang indefinitely while offline. Repo write methods
/// use this so callers can safely `await` a "local write issued" result.
void fireAndForget(Future<void> future, {required String label}) {
  unawaited(
    future.catchError((Object e, StackTrace st) {
      logger.e('$label failed', error: e, stackTrace: st);
    }),
  );
}
