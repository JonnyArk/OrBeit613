/// OrBeit Spatial Layer - Building Component
///
/// Represents a single building placed on the isometric grid.
/// Renders as a sprite (if available) or as a vector-drawn building.
///
/// **Design:**
/// - Each building type has a distinct color and shape
/// - Buildings have a warm glow at night
/// - Tappable for interaction

import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

import '../domain/entities/building.dart';

/// Visual representation of a building on the isometric grid
class BuildingComponent extends PositionComponent with TapCallbacks {
  /// Domain entity this component represents
  final Building building;

  /// Building visual size
  static const double buildingWidth = 48.0;
  static const double buildingHeight = 56.0;

  Sprite? _sprite;
  bool _spriteLoaded = false;

  BuildingComponent({required this.building}) : super(
    size: Vector2(buildingWidth, buildingHeight),
    anchor: Anchor.bottomCenter,
  ) {
    // Convert grid coordinates to isometric screen position
    final isoX = (building.x - building.y) * 32.0;
    final isoY = (building.x + building.y) * 16.0;
    
    position = Vector2(isoX, isoY);
  }

  @override
  Future<void> onLoad() async {
    // Determine sprite path based on building type
    String spritePath;
    final type = building.type.toLowerCase();
    
    if (type.contains('house') || type.contains('cottage') || type.contains('mansion')) {
      spritePath = 'sprites/house.png';
    } else if (type.contains('well') || type.contains('silo') || type.contains('barn')) {
      spritePath = 'sprites/well.png';
    } else if (type.contains('sanctum') || type.contains('windmill')) {
      spritePath = 'sprites/sanctum.png';
    } else {
      spritePath = 'sprites/house.png'; // Default
    }

    try {
      _sprite = await Sprite.load(spritePath);
      _spriteLoaded = true;
    } catch (e) {
      debugPrint('[OrBeit] Failed to load building sprite: $spritePath → $e');
      _spriteLoaded = false;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_spriteLoaded && _sprite != null) {
      _sprite!.render(canvas, size: size);
    } else {
      _renderFallbackBuilding(canvas);
    }
  }

  /// Renders a vector building when sprite isn't available
  void _renderFallbackBuilding(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final type = building.type.toLowerCase();

    // Choose color based on building type
    Color wallColor;
    Color roofColor;
    if (type.contains('red') || type.contains('barn')) {
      wallColor = const Color(0xFFB22222);
      roofColor = const Color(0xFF8B1A1A);
    } else if (type.contains('cottage')) {
      wallColor = const Color(0xFF98FB98);
      roofColor = const Color(0xFF556B2F);
    } else if (type.contains('mansion')) {
      wallColor = const Color(0xFFF5F0E8);
      roofColor = const Color(0xFF4A4A6A);
    } else if (type.contains('sanctum')) {
      wallColor = const Color(0xFFD4AF37);
      roofColor = const Color(0xFF8B7D3B);
    } else {
      wallColor = const Color(0xFFF5F5F5);
      roofColor = const Color(0xFF5D4037);
    }

    // Wall (rectangle)
    canvas.drawRect(
      Rect.fromLTWH(w * 0.15, h * 0.4, w * 0.7, h * 0.6),
      Paint()..color = wallColor,
    );

    // Wall border
    canvas.drawRect(
      Rect.fromLTWH(w * 0.15, h * 0.4, w * 0.7, h * 0.6),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = wallColor.withAlpha(150)
        ..strokeWidth = 1,
    );

    // Roof (triangle)
    final roofPath = Path()
      ..moveTo(w * 0.5, h * 0.1)
      ..lineTo(w * 0.9, h * 0.42)
      ..lineTo(w * 0.1, h * 0.42)
      ..close();
    
    canvas.drawPath(roofPath, Paint()..color = roofColor);
    canvas.drawPath(
      roofPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = roofColor.withAlpha(200)
        ..strokeWidth = 0.5,
    );

    // Door
    canvas.drawRect(
      Rect.fromLTWH(w * 0.4, h * 0.7, w * 0.2, h * 0.3),
      Paint()..color = const Color(0xFF3E2723),
    );

    // Window
    canvas.drawRect(
      Rect.fromLTWH(w * 0.6, h * 0.5, w * 0.15, h * 0.12),
      Paint()..color = const Color(0xFFFFF9C4),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.25, h * 0.5, w * 0.15, h * 0.12),
      Paint()..color = const Color(0xFFFFF9C4),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    debugPrint('Tapped on building: ${building.type} at (${building.x}, ${building.y})');
  }

  @override
  String toString() => 'BuildingComponent(${building.type} at ${building.x},${building.y})';
}
