/// OrBeit Spatial Layer - Isometric Terrain Grid
///
/// Renders the world terrain as sprite-based isometric tiles.
/// Each tile is loaded from the terrain data and rendered with
/// proper isometric projection.
///
/// **Visual Design:**
/// - Sprite-based terrain tiles (grass, road, water, sand, dirt)
/// - Natural variety with dark/light grass patches
/// - Procedurally generated landscape features
///
/// **For Future Agents:**
/// - Tile dimensions: 64x32 (width x height)
/// - Grid size: 20x20 (configurable)
/// - Coordinate system: Standard isometric (x = col - row, y = col + row)

import 'dart:ui';
import 'package:flame/components.dart';
import 'terrain_tile.dart';
import 'world_terrain_data.dart';

/// Sprite-based isometric terrain renderer
///
/// Loads terrain tile sprites and renders them in correct
/// isometric order for proper visual layering.
class IsometricGrid extends PositionComponent {
  /// Terrain data defining what tile is at each position
  final WorldTerrainData terrainData;

  /// Width of each tile in pixels
  final double tileWidth;

  /// Height of each tile in pixels
  final double tileHeight;

  /// Cached sprites for each terrain type
  final Map<TerrainType, Sprite> _spriteCache = {};

  IsometricGrid({
    required this.terrainData,
    this.tileWidth = 64.0,
    this.tileHeight = 32.0,
  });

  @override
  Future<void> onLoad() async {
    // Pre-load all terrain sprites
    for (final type in TerrainType.values) {
      if (type == TerrainType.empty) continue;
      _spriteCache[type] = await Sprite.load(type.spritePath);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Render tiles in isometric order (back to front) for proper overlap
    for (int col = 0; col < terrainData.columns; col++) {
      for (int row = 0; row < terrainData.rows; row++) {
        _renderTile(canvas, col, row);
      }
    }
  }

  /// Renders a single terrain tile at the specified grid position
  void _renderTile(Canvas canvas, int col, int row) {
    final terrainType = terrainData.getTile(col, row);
    final sprite = _spriteCache[terrainType] ?? _spriteCache[TerrainType.grass];
    if (sprite == null) return;

    // Calculate isometric position
    final double screenX = (col - row) * (tileWidth / 2);
    final double screenY = (col + row) * (tileHeight / 2);

    // Render the sprite centered on the tile position
    sprite.render(
      canvas,
      position: Vector2(screenX - tileWidth / 2, screenY - tileHeight / 2),
      size: Vector2(tileWidth, tileHeight),
    );
  }
}
