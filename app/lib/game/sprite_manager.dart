/// OrBeit Game - Building Sprites Manager
///
/// Manages loading and caching of building sprites.
/// Currently uses placeholder graphics, will integrate with
/// AI-generated assets via Whisk service.

import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Manages building sprite assets
class BuildingSpriteManager {
  static final BuildingSpriteManager _instance = BuildingSpriteManager._();
  factory BuildingSpriteManager() => _instance;
  BuildingSpriteManager._();

  final Map<String, ui.Image?> _cache = {};

  /// Building type to color mapping for placeholder sprites
  static const Map<String, Color> buildingColors = {
    'farmhouse_white': Color(0xFFF5F5F5),
    'farmhouse_red': Color(0xFFB22222),
    'barn': Color(0xFF8B4513),
    'silo': Color(0xFF708090),
    'windmill': Color(0xFFDEB887),
    'cottage': Color(0xFF98FB98),
    'mansion': Color(0xFFD4AF37),
    // Genesis Kit: Steward
    'farmhouse_base': Color(0xFFF5F5F5),
    'barn_red_big': Color(0xFFA52A2A),
    'pickup_truck_white': Color(0xFFE0E0E0),
    'feed_log_station': Color(0xFF8B4513),
    // Genesis Kit: Town
    'pharmacy_small': Color(0xFFFFFFFF),
    'doctor_office': Color(0xFF87CEEB),
    'garden_plot': Color(0xFF228B22),
    'oak_tree': Color(0xFF006400),
    'pine_tree': Color(0xFF004d00),
  };

  /// Gets the color for a building type
  Color getColorForType(String type) {
    return buildingColors[type] ?? const Color(0xFF134E5E);
  }

  /// Checks if a sprite is cached
  bool isCached(String assetId) => _cache.containsKey(assetId);

  /// Gets cached sprite
  ui.Image? getCached(String assetId) => _cache[assetId];

  /// Caches a sprite
  void cache(String assetId, ui.Image image) {
    _cache[assetId] = image;
  }

  /// Clears the cache
  void clearCache() => _cache.clear();
}
