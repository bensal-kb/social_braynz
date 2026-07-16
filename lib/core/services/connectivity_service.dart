import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../dependencies/get_dependencies.dart';

/// Bridges OS-level connectivity changes into Firestore's network state.
///
/// Firestore's own `snapshot.metadata.isFromCache` only flips once its
/// listener notices its stream has failed — on a real device that's usually
/// prompt (the SDK watches OS network-change callbacks), but on emulators
/// toggling airplane mode often doesn't fire that callback at all, so the
/// SDK has to wait for an in-flight operation to time out (tens of seconds)
/// before it realizes it's offline. Actively calling disableNetwork()/
/// enableNetwork() in response to connectivity_plus's own OS signal makes
/// that transition immediate instead of passive.
class ConnectivityService {
  ConnectivityService(this._firestore, this._connectivity);

  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _sub;
  bool? _lastIsOnline;
  final _onlineController = StreamController<bool>.broadcast();

  /// Live, OS-reported connectivity — independent of (and faster than)
  /// Firestore's own `isFromCache` signal, since it doesn't wait for a
  /// round trip through `enableNetwork()`/`disableNetwork()` and a fresh
  /// snapshot. UI that wants the fastest possible offline indicator should
  /// listen here directly.
  Stream<bool> get onlineStatus => _onlineController.stream;

  /// The last known state, for seeding UI that subscribes to [onlineStatus]
  /// after the first change event already fired (it's a broadcast stream
  /// and won't replay). `null` until the first check completes.
  bool? get lastKnownOnline => _lastIsOnline;

  void start() {
    _sub = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
      onError: (Object e, StackTrace st) =>
          logger.e('ConnectivityService stream failed', error: e, stackTrace: st),
    );
    // Seed the initial state rather than waiting for the first change event,
    // which may not arrive for a while if connectivity doesn't change.
    _connectivity.checkConnectivity().then(_onConnectivityChanged);
  }

  Future<void> _onConnectivityChanged(List<ConnectivityResult> results) async {
    final isOnline = results.any((r) => r != ConnectivityResult.none);
    if (isOnline == _lastIsOnline) return;
    _lastIsOnline = isOnline;
    _onlineController.add(isOnline);
    try {
      if (isOnline) {
        await _firestore.enableNetwork();
      } else {
        await _firestore.disableNetwork();
      }
    } catch (e, st) {
      logger.e('ConnectivityService network toggle failed', error: e, stackTrace: st);
    }
  }

  void dispose() {
    _sub?.cancel();
    _onlineController.close();
  }
}
