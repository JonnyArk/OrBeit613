/// OrBeit Storage Layer - Hive Cache Service
///
/// Ultra-fast key-value store for non-sensitive ephemeral data.
/// Use this for quick lookups that don't need relational queries.
///
/// **Use Hive for:**
/// - Or's recent insights / conversation snippets
/// - Cached image paths and sprite metadata
/// - User preferences and UI state
/// - Temporary computation results
///
/// **Use Drift for:**
/// - Buildings, tasks, people, life events (relational)
///
/// **Use SecureStorage for:**
/// - API keys, PINs, tokens (sensitive)

import 'package:hive_flutter/hive_flutter.dart';

/// Box names — single source of truth for all Hive boxes
abstract class CacheBoxes {
  static const orInsights = 'or_insights';
  static const userPreferences = 'user_preferences';
  static const spriteCache = 'sprite_cache';
  static const sessionState = 'session_state';
}

/// Service for fast key-value caching using Hive
class CacheService {
  bool _initialized = false;

  /// Initialize Hive and open all boxes
  Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Open all boxes eagerly for fast access
    await Future.wait([
      Hive.openBox(CacheBoxes.orInsights),
      Hive.openBox(CacheBoxes.userPreferences),
      Hive.openBox(CacheBoxes.spriteCache),
      Hive.openBox(CacheBoxes.sessionState),
    ]);

    _initialized = true;
  }

  // ── Generic Access ────────────────────────────────────────

  /// Get a value from a specific box
  T? get<T>(String boxName, String key, {T? defaultValue}) {
    final box = Hive.box(boxName);
    return box.get(key, defaultValue: defaultValue) as T?;
  }

  /// Put a value into a specific box
  Future<void> put(String boxName, String key, dynamic value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  /// Delete a key from a specific box
  Future<void> delete(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  /// Clear an entire box
  Future<void> clearBox(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  // ── Or's Insights ─────────────────────────────────────────

  /// Store an insight from the Or
  Future<void> storeInsight(String key, String insight) async {
    await put(CacheBoxes.orInsights, key, {
      'text': insight,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Get the Or's most recent insight for a topic
  Map<String, dynamic>? getInsight(String key) {
    final raw = get<Map>(CacheBoxes.orInsights, key);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw);
  }

  /// Get all cached insights
  Map<String, dynamic> getAllInsights() {
    final box = Hive.box(CacheBoxes.orInsights);
    final result = <String, dynamic>{};
    for (final key in box.keys) {
      result[key.toString()] = box.get(key);
    }
    return result;
  }

  // ── User Preferences ─────────────────────────────────────

  /// Store a user preference
  Future<void> setPreference(String key, dynamic value) async {
    await put(CacheBoxes.userPreferences, key, value);
  }

  /// Get a user preference with optional default
  T? getPreference<T>(String key, {T? defaultValue}) {
    return get<T>(CacheBoxes.userPreferences, key, defaultValue: defaultValue);
  }

  // ── Sprite Cache ──────────────────────────────────────────

  /// Cache a sprite's local path for quick lookup
  Future<void> cacheSpriteUrl(String spriteId, String localPath) async {
    await put(CacheBoxes.spriteCache, spriteId, localPath);
  }

  /// Get a cached sprite path
  String? getCachedSpritePath(String spriteId) {
    return get<String>(CacheBoxes.spriteCache, spriteId);
  }

  // ── Session State ─────────────────────────────────────────

  /// Save session state (survives hot restarts)
  Future<void> saveSessionState(String key, dynamic value) async {
    await put(CacheBoxes.sessionState, key, value);
  }

  /// Load session state
  T? loadSessionState<T>(String key) {
    return get<T>(CacheBoxes.sessionState, key);
  }

  /// Nuke everything — full cache reset
  Future<void> clearAll() async {
    await Future.wait([
      clearBox(CacheBoxes.orInsights),
      clearBox(CacheBoxes.userPreferences),
      clearBox(CacheBoxes.spriteCache),
      clearBox(CacheBoxes.sessionState),
    ]);
  }
}
