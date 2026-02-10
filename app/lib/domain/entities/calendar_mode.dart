/// OrBeit Domain - Calendar Mode
///
/// Defines the cultural identity of a user's world.
///
/// **Two Modes:**
/// - Western: Standard Gregorian calendar, no Shabbat observance
/// - Hebrew: Hebrew calendar, Shabbat-aware, Tabernacle in world,
///           distinct visual tone ("Hebrew tint")
///
/// The choice is made once during onboarding but can be changed
/// in settings. It affects:
/// - World structures (Tabernacle vs. standard)
/// - Notification behavior (Shabbat silence)
/// - Visual palette (Hebrew tint vs. standard)
/// - Calendar display format

/// The cultural calendar mode for the user's world
enum CalendarMode {
  /// Standard Western/Gregorian calendar
  /// - Sunday–Saturday week
  /// - Standard notifications
  /// - No Tabernacle structure
  western,

  /// Hebrew/Biblical calendar
  /// - Shabbat observance (Friday sunset → Saturday sunset)
  /// - Tabernacle permanently in world
  /// - Hebrew visual tint
  /// - No notifications during Shabbat
  /// - Hebrew date display
  hebrew,
}

/// Extension methods for CalendarMode
extension CalendarModeExtension on CalendarMode {
  /// Display name for the mode
  String get displayName {
    switch (this) {
      case CalendarMode.western:
        return 'Western';
      case CalendarMode.hebrew:
        return 'Hebrew';
    }
  }

  /// Short description for onboarding
  String get tagline {
    switch (this) {
      case CalendarMode.western:
        return 'Gregorian calendar\nStandard notifications';
      case CalendarMode.hebrew:
        return 'Hebrew calendar\nShabbat observance';
    }
  }

  /// Full description for onboarding
  String get description {
    switch (this) {
      case CalendarMode.western:
        return 'Your world follows the standard Gregorian calendar. '
            'Notifications and updates operate on a regular schedule. '
            'Build your sanctum with modern structures.';
      case CalendarMode.hebrew:
        return 'Your world follows the Hebrew calendar. '
            'A Tabernacle stands at the heart of your world. '
            'During Shabbat, the app dims and falls silent — '
            'no notifications, no updates, just rest.';
    }
  }

  /// Whether this mode observes Shabbat
  bool get observesShabbat => this == CalendarMode.hebrew;

  /// Whether this mode includes a Tabernacle in the world
  bool get hasTabernacle => this == CalendarMode.hebrew;

  /// The unique icon for the mode
  String get iconAsset {
    switch (this) {
      case CalendarMode.western:
        return 'assets/icons/calendar_western.png';
      case CalendarMode.hebrew:
        return 'assets/icons/calendar_hebrew.png';
    }
  }

  /// Serialization key for secure storage
  String get storageValue {
    switch (this) {
      case CalendarMode.western:
        return 'western';
      case CalendarMode.hebrew:
        return 'hebrew';
    }
  }

  /// Deserialize from storage
  static CalendarMode fromStorage(String? value) {
    if (value == 'hebrew') return CalendarMode.hebrew;
    return CalendarMode.western; // Default
  }
}
