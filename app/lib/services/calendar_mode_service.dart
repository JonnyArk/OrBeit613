/// OrBeit Services - Calendar Mode Service
///
/// Manages the user's cultural calendar preference and Shabbat state.
///
/// **Responsibilities:**
/// - Persists the chosen calendar mode (Western / Hebrew)
/// - Calculates whether it's currently Shabbat
/// - Provides Shabbat-aware notification policy
/// - Exposes the "Hebrew tint" visual palette when active
///
/// **Shabbat Calculation:**
/// Shabbat begins at sunset on Friday and ends at sunset on Saturday.
/// For simplicity, we approximate sunset as 6:00 PM local time.
/// A future version could use location-based sunset calculations.

import 'package:flutter/material.dart';
import 'secure_storage_service.dart';
import '../domain/entities/calendar_mode.dart';

/// Storage key for calendar mode
const String _calendarModeKey = 'calendar_mode';

/// Service managing cultural calendar preferences and Shabbat state
class CalendarModeService extends ChangeNotifier {
  final SecureStorageService _storage;
  CalendarMode _mode = CalendarMode.western;
  bool _initialized = false;

  CalendarModeService({required SecureStorageService storage})
      : _storage = storage;

  // ── Getters ──────────────────────────────────────────────

  /// The currently active calendar mode
  CalendarMode get mode => _mode;

  /// Whether the service has loaded persisted state
  bool get isInitialized => _initialized;

  /// Whether the user is on Hebrew calendar
  bool get isHebrew => _mode == CalendarMode.hebrew;

  /// Whether the user is on Western calendar
  bool get isWestern => _mode == CalendarMode.western;

  /// Whether Shabbat is currently being observed
  /// (Only relevant in Hebrew mode)
  bool get isShabbatActive => _mode.observesShabbat && _isCurrentlyShabbat();

  /// Whether notifications should be suppressed right now
  bool get shouldSuppressNotifications => isShabbatActive;

  /// Whether the Tabernacle should appear in the world
  bool get showTabernacle => _mode.hasTabernacle;

  // ── Initialization ──────────────────────────────────────

  /// Load persisted calendar mode from secure storage
  Future<void> initialize() async {
    final stored = await _storage.read(_calendarModeKey);
    _mode = CalendarModeExtension.fromStorage(stored);
    _initialized = true;
    notifyListeners();
  }

  // ── Actions ─────────────────────────────────────────────

  /// Set the calendar mode (called during onboarding or settings)
  Future<void> setMode(CalendarMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    await _storage.write(_calendarModeKey, mode.storageValue);
    debugPrint('[OrBeit] Calendar mode set to: ${mode.displayName}');
    notifyListeners();
  }

  // ── Hebrew Calendar Awareness ───────────────────────────

  /// Approximate Shabbat detection
  ///
  /// Shabbat starts: Friday at ~6:00 PM (sunset approximation)
  /// Shabbat ends:   Saturday at ~7:00 PM (nightfall approximation)
  ///
  /// For v1, we use fixed times. Future: GPS-based sunset calculation.
  bool _isCurrentlyShabbat() {
    final now = DateTime.now();
    final weekday = now.weekday; // 1=Monday ... 7=Sunday

    // Friday after 6 PM
    if (weekday == DateTime.friday && now.hour >= 18) {
      return true;
    }

    // All day Saturday until 7 PM
    if (weekday == DateTime.saturday && now.hour < 19) {
      return true;
    }

    return false;
  }

  /// Get the current Hebrew date as a display string
  ///
  /// For v1, returns a formatted Gregorian date with Hebrew day markers.
  /// Future: integrate a proper Hebrew calendar library (hebcal).
  String get hebrewDateDisplay {
    if (!isHebrew) return '';

    final now = DateTime.now();
    final weekday = now.weekday;

    // Hebrew day names (Yom Rishon through Shabbat)
    const hebrewDays = [
      'Yom Sheni',    // Monday
      'Yom Shlishi',  // Tuesday
      'Yom Revi\'i',  // Wednesday
      'Yom Chamishi', // Thursday
      'Yom Shishi',   // Friday
      'Shabbat',      // Saturday
      'Yom Rishon',   // Sunday
    ];

    final dayName = hebrewDays[weekday - 1];

    if (isShabbatActive) {
      return '🕯️ $dayName — Shabbat Shalom';
    }

    return dayName;
  }

  // ── Visual Theming ──────────────────────────────────────

  /// The color palette adjustment for Hebrew mode
  ///
  /// Returns a "Hebrew tint" that subtly warms the entire visual palette
  /// with desert golds and deeper blues, distinct from the standard theme.
  HebrewTint? get hebrewTint {
    if (!isHebrew) return null;

    if (isShabbatActive) {
      return const HebrewTint(
        backgroundPrimary: Color(0xFF0D0D1A),   // Deep Shabbat blue
        backgroundSecondary: Color(0xFF141428),  // Slightly lighter
        accentGold: Color(0xFFE5C06B),           // Warm candle gold
        textPrimary: Color(0xFFF0E8D8),          // Warm parchment
        textSecondary: Color(0xFF8B7D6B),        // Muted earth
        particleColor: Color(0xFFE5C06B),        // Candlelight particles
        shimmerIntensity: 0.3,                   // Subdued — rest mode
      );
    }

    return const HebrewTint(
      backgroundPrimary: Color(0xFF12101E),    // Desert night
      backgroundSecondary: Color(0xFF1E1A30),  // Warm deep purple
      accentGold: Color(0xFFD4AF37),           // Sovereign gold
      textPrimary: Color(0xFFF5EDD8),          // Sandstone parchment
      textSecondary: Color(0xFFA09070),         // Desert sand
      particleColor: Color(0xFFD4AF37),         // Gold dust
      shimmerIntensity: 0.6,                    // Active glow
    );
  }
}

/// Visual palette for Hebrew mode
///
/// Applied as an overlay/adjustment to the base theme.
/// The Shabbat variant is more subdued (candle-lit).
class HebrewTint {
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color accentGold;
  final Color textPrimary;
  final Color textSecondary;
  final Color particleColor;
  final double shimmerIntensity;

  const HebrewTint({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.accentGold,
    required this.textPrimary,
    required this.textSecondary,
    required this.particleColor,
    required this.shimmerIntensity,
  });
}
