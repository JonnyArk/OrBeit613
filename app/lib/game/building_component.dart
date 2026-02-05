/// OrBeit Spatial Layer - Building Component
///
/// Represents a single building placed on the isometric grid.
/// Renders as a visual game entity using Flame's component system.
///
/// **Sovereign Sanctum Aesthetic:**
/// - Gold outline for structure
/// - Deep teal fill
/// - Positioned using isometric coordinates
///
/// **For Future Agents:**
/// - Replace placeholder rendering with AI-generated sprites (Whisk)
/// - Add interaction handlers (tap to select, drag to move)
/// - Implement rotation animations
/// - Add building type-specific visuals

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../domain/entities/building.dart';

/// Visual representation of a building on the isometric grid
class BuildingComponent extends PositionComponent {
  /// Domain entity this component represents
  final Building building;

  /// Building visual size (will be replaced by sprite dimensions)
  static const double buildingWidth = 48.0;
  static const double buildingHeight = 64.0;

  // Sovereign Sanctum colors
  final Paint _outlinePaint = Paint()
    ..color = const Color(0xFFD4AF37) // Sovereign Gold
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  final Paint _fillPaint = Paint()
    ..color = const Color(0xFF134E5E).withValues(alpha: 0.7); // Deep Teal

  BuildingComponent({required this.building}) {
    // Convert grid coordinates to isometric screen position
    final isoX = (building.x - building.y) * 32.0;
    final isoY = (building.x + building.y) * 16.0;
    
    position = Vector2(isoX, isoY);
    size = Vector2(buildingWidth, buildingHeight);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Placeholder rendering: simple house shape
    final Path housePath = Path();
    
    // Roof (triangle)
    housePath.moveTo(-buildingWidth / 2, -buildingHeight / 2 + 16); // Left
    housePath.lineTo(0, -buildingHeight / 2); // Top
    housePath.lineTo(buildingWidth / 2, -buildingHeight / 2 + 16); // Right
    housePath.lineTo(buildingWidth / 2, buildingHeight / 2); // Bottom right
    housePath.lineTo(-buildingWidth / 2, buildingHeight / 2); // Bottom left
    housePath.close();

    canvas.drawPath(housePath, _fillPaint);
    canvas.drawPath(housePath, _outlinePaint);

    // Building type label (for debugging)
    final textPainter = TextPainter(
      text: TextSpan(
        text: building.type.split('_').first,
        style: const TextStyle(
          color: Color(0xFFF5F5F5),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -buildingHeight / 2 - 12),
    );
  }

  @override
  String toString() => 'BuildingComponent(${building.type} at ${building.x},${building.y})';
}
