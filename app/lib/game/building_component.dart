/// OrBeit Spatial Layer - Building Component
///
/// Represents a single building placed on the isometric grid.
/// Renders as a visual game entity using Flame's sprite system.

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';
import '../domain/entities/building.dart';

/// Visual representation of a building on the isometric grid
class BuildingComponent extends SpriteComponent with TapCallbacks {
  /// Domain entity this component represents
  final Building building;

  /// Building visual size
  static const double buildingWidth = 64.0;
  static const double buildingHeight = 64.0;

  BuildingComponent({required this.building}) : super(
    size: Vector2(buildingWidth, buildingHeight),
    anchor: Anchor.center,
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
    
    // Mapping more exhaustive list from sprite_manager.dart
    if (type.contains('house') || type.contains('cottage') || type.contains('mansion')) {
      spritePath = 'sprites/house.png';
    } else if (type.contains('well') || type.contains('silo') || type.contains('barn')) {
      spritePath = 'sprites/well.png';
    } else if (type.contains('sanctum') || type.contains('windmill')) {
      spritePath = 'sprites/sanctum.png';
    } else {
      spritePath = 'sprites/house.png'; // Default
    }

    sprite = await Sprite.load(spritePath);
  }

  @override
  void onTapDown(TapDownEvent event) {
    debugPrint('Tapped on building: ${building.type} at (${building.x}, ${building.y})');
    // Future: Add selection logic here
  }

  @override
  String toString() => 'BuildingComponent(${building.type} at ${building.x},${building.y})';
}
