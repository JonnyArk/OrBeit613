/// OrBeit Security — Duress Mode Service
///
/// Implements the "Panic PIN" protocol:
/// - Normal PIN → loads real world with all user data
/// - Duress PIN → loads a convincing dummy world with NO real data
///
/// The dummy world looks like a legitimate app that was just installed
/// or barely used, so the attacker sees nothing of value.
///
/// CRITICAL: No real data must ever leak in duress mode.
/// The Or itself must behave differently — friendly but shallow,
/// with no memory of real conversations or tasks.

import 'package:flutter/foundation.dart';

/// The current access mode of the application
enum AccessMode {
  /// User has not yet authenticated
  locked,

  /// Authenticated with real PIN — full access to real data
  normal,

  /// Authenticated with duress PIN — show dummy world, hide all real data
  duress,
}

/// Manages the application's security/access state
///
/// This service is the single source of truth for whether
/// the app is in normal or duress mode. Every data-accessing
/// component should check this before loading real data.
class DuressModeService extends ChangeNotifier {
  AccessMode _mode = AccessMode.locked;

  /// Current access mode
  AccessMode get mode => _mode;

  /// Whether the app is in duress (panic) mode
  bool get isDuressActive => _mode == AccessMode.duress;

  /// Whether the app is in normal authenticated mode
  bool get isNormalMode => _mode == AccessMode.normal;

  /// Whether the user is still locked out
  bool get isLocked => _mode == AccessMode.locked;

  /// Activate normal mode (correct PIN entered)
  void activateNormalMode() {
    _mode = AccessMode.normal;
    debugPrint('[Security] ✅ Normal mode activated');
    notifyListeners();
  }

  /// Activate duress mode (panic PIN entered)
  ///
  /// Once active, the entire app will:
  /// - Show a dummy world with generic buildings
  /// - Hide all real tasks, events, and files
  /// - The Or will respond generically (no real memory)
  /// - No real data is loaded from the database
  void activateDuressMode() {
    _mode = AccessMode.duress;
    // Intentionally NO debug print in duress mode
    // to avoid leaving forensic traces in logs
    notifyListeners();
  }

  /// Lock the app (sign out or timeout)
  void lock() {
    _mode = AccessMode.locked;
    notifyListeners();
  }
}
