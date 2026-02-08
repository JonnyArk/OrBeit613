/// OrBeit Spatial Layer - Terrain Tile Types
///
/// Defines the terrain types available in the world.
/// Each type maps to a sprite asset for rendering.

/// Available terrain types for the isometric world
enum TerrainType {
  grass,
  grassDark,
  road,
  water,
  dirtPath,
  sand,
  empty,
}

/// Maps terrain types to their sprite asset paths
extension TerrainTypeSprite on TerrainType {
  String get spritePath {
    switch (this) {
      case TerrainType.grass:
        return 'sprites/grass.png';
      case TerrainType.grassDark:
        return 'sprites/grass_dark.png';
      case TerrainType.road:
        return 'sprites/road.png';
      case TerrainType.water:
        return 'sprites/water.png';
      case TerrainType.dirtPath:
        return 'sprites/dirt_path.png';
      case TerrainType.sand:
        return 'sprites/sand.png';
      case TerrainType.empty:
        return 'sprites/grass.png'; // Fallback
    }
  }
}
