/// OrBeit Spatial Layer - Isometric Terrain Grid
///
/// Renders the world terrain as sprite-based isometric tiles.
/// Each tile is loaded from the terrain data and rendered with
/// proper isometric projection.
///
/// **Rendering Notes:**
/// - Tile dimensions: 64x32 (width x height)
/// - Grid size: 20x20 (configurable)
/// - Coordinate system: Standard isometric (x = col - row, y = col + row)
/// - Falls back to colored diamonds if sprites fail to load

import 'dart:ui';
import 'package:flame/components.dart';

import 'terrain_tile.dart';
import 'world_terrain_data.dart';

/// Sprite-based isometric terrain renderer with fallback coloring
class IsometricGrid extends PositionComponent {
  /// Terrain data defining what tile is at each position
  final WorldTerrainData terrainData;

  /// Width of each tile in pixels
  final double tileWidth;

  /// Height of each tile in pixels
  final double tileHeight;

  /// Cached sprites for each terrain type
  final Map<TerrainType, Sprite?> _spriteCache = {};


  IsometricGrid({
    required this.terrainData,
    this.tileWidth = 64.0,
    this.tileHeight = 32.0,
  });

  @override
  Future<void> onLoad() async {
    // Try to pre-load all terrain sprites
    try {
      for (final type in TerrainType.values) {
        if (type == TerrainType.empty) continue;
        try {
          _spriteCache[type] = await Sprite.load(type.spritePath);
        } catch (e) {
          _spriteCache[type] = null; // Will use fallback color
        }
      }
      // Sprites loaded
    } catch (e) {
      // Sprites failed to load, will use fallback
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Render tiles in isometric order (back to front)
    for (int col = 0; col < terrainData.columns; col++) {
      for (int row = 0; row < terrainData.rows; row++) {
        _renderTile(canvas, col, row);
      }
    }
  }

  /// Renders a single terrain tile at the specified grid position
  void _renderTile(Canvas canvas, int col, int row) {
    final terrainType = terrainData.getTile(col, row);

    // Calculate isometric position
    final double screenX = (col - row) * (tileWidth / 2);
    final double screenY = (col + row) * (tileHeight / 2);

    final sprite = _spriteCache[terrainType] ?? _spriteCache[TerrainType.grass];
    if (sprite != null) {
      // Render the sprite
      sprite.render(
        canvas,
        position: Vector2(screenX - tileWidth / 2, screenY - tileHeight / 2),
        size: Vector2(tileWidth, tileHeight),
      );
    } else {
      // Fallback: draw a colored diamond
      _renderFallbackTile(canvas, screenX, screenY, terrainType);
    }
  }

  /// Renders a colored diamond tile as fallback when sprites aren't available
  void _renderFallbackTile(Canvas canvas, double x, double y, TerrainType type) {
    final path = Path()
      ..moveTo(x, y - tileHeight / 2)                 // top
      ..lineTo(x + tileWidth / 2, y)                   // right
      ..lineTo(x, y + tileHeight / 2)                  // bottom
      ..lineTo(x - tileWidth / 2, y)                   // left
      ..close();

    final Color fillColor;
    switch (type) {
      case TerrainType.grass:
        fillColor = const Color(0xFF4CAF50);
        break;
      case TerrainType.grassDark:
        fillColor = const Color(0xFF388E3C);
        break;
      case TerrainType.road:
        fillColor = const Color(0xFF757575);
        break;
      case TerrainType.water:
        fillColor = const Color(0xFF42A5F5);
        break;
      case TerrainType.dirtPath:
        fillColor = const Color(0xFF8D6E63);
        break;
      case TerrainType.sand:
        fillColor = const Color(0xFFFFE082);
        break;
      case TerrainType.empty:
        fillColor = const Color(0xFF4CAF50);
        break;
    }

    // Fill
    canvas.drawPath(path, Paint()..color = fillColor);
    // Border
    canvas.drawPath(
      path,
      Paint()
        ..color = fillColor.withAlpha(100)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }
}
