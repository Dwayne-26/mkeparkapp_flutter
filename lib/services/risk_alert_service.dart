import 'dart:async';
import 'dart:developer';

import '../providers/user_provider.dart';

/// Lightweight in-app risk watcher. In background, this should be replaced by
/// a push-based solution (FCM/APNs) driven by the backend.
class RiskAlertService {
  RiskAlertService._();

  static final RiskAlertService instance = RiskAlertService._();

  Timer? _timer;
  bool _running = false;
  DateTime? _lastHighAlert;

  void start(UserProvider provider) {
    if (_running) return;
    _running = true;
    _timer ??= Timer.periodic(const Duration(minutes: 5), (_) {
      _check(provider);
    });
    // Initial eager check
    _check(provider);
  }

  void _check(UserProvider provider) {
    final score = provider.towRiskIndex;
    if (score >= 70) {
      final now = DateTime.now();
      if (_lastHighAlert == null ||
          now.difference(_lastHighAlert!).inMinutes >= 60) {
        _lastHighAlert = now;
        // TODO: replace with local notification or push trigger.
        log('High tow risk detected ($score). Consider notifying user.');
      }
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _running = false;
  }
}
