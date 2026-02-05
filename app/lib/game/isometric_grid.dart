/// OrBeit Spatial Layer - Isometric Grid Component
///
/// Renders a procedural 2.5D isometric grid using the Sovereign Sanctum
/// aesthetic (geometric gold lines on dark slate background).
///
/// **Visual Design:**
/// - Diamond-shaped tiles for isometric projection
/// - Gold (#D4AF37) gridlines with transparency
/// - Deep teal (#134E5E) for tile highlights
/// - Dark slate (#1A1A2E) background
///
/// **For Future Agents:**
/// - Tile dimensions: 64x32 (width x height)
/// - Grid size: 20x20 (configurable)
/// - Coordinate system: Standard isometric (x = col - row, y = col + row)
/// - Extend this component to add interaction handlers (tap, drag)

import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Procedural isometric grid renderer
///
/// Creates a visual grid without requiring sprite assets.
/// Renders in Flame's game loop for high performance.
class IsometricGrid extends PositionComponent {
  /// Number of columns in the grid
  final int columns;
  
  /// Number of rows in the grid
  final int rows;
  
  /// Width of each tile in pixels
  final double tileWidth;
  
  /// Height of each tile in pixels
  final double tileHeight;
  
  // Sovereign Sanctum Colors
  final Paint _linePaint = Paint()
    ..color = const Color(0xFFD4AF37).withValues(alpha: 0.3) // Geometric Gold (faint)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  IsometricGrid({
    this.columns = 20,
    this.rows = 20,
    this.tileWidth = 64.0,
    this.tileHeight = 32.0,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the grid
    for (int col = 0; col < columns; col++) {
      for (int row = 0; row < rows; row++) {
        _drawTile(canvas, col, row);
      }
    }
  }

  /// Draws a single isometric tile at the specified grid position
  ///
  /// Uses diamond shape calculated from isometric projection formulas.
  void _drawTile(Canvas canvas, int col, int row) {
    final Path path = Path();
    
    // Calculate vertices for isometric tile
    // x = (col - row) * (width / 2)
    // y = (col + row) * (height / 2)
    final double centerX = (col - row) * (tileWidth / 2);
    final double centerY = (col + row) * (tileHeight / 2);

    path.moveTo(centerX, centerY - tileHeight / 2); // Top
    path.lineTo(centerX + tileWidth / 2, centerY);   // Right
    path.lineTo(centerX, centerY + tileHeight / 2); // Bottom
    path.lineTo(centerX - tileWidth / 2, centerY);   // Left
    path.close();

    canvas.drawPath(path, _linePaint);
  }
}
