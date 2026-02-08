/// OrBeit Spatial Layer - Environment Decorations
///
/// Procedurally places trees, bushes, and rocks on the world map
/// to create a natural-feeling landscape. Decorations are placed
/// only on grass tiles, avoiding roads, water, and buildings.

import 'dart:math';
import 'package:flame/components.dart';
import 'terrain_tile.dart';
import 'world_terrain_data.dart';

/// Types of environment decorations
enum DecorationType {
  oakTree,
  pineTree,
  bush,
  rocks,
}

/// Sprite paths for each decoration type
extension DecorationSprite on DecorationType {
  String get spritePath {
    switch (this) {
      case DecorationType.oakTree:
        return 'sprites/oak_tree.png';
      case DecorationType.pineTree:
        return 'sprites/pine_tree.png';
      case DecorationType.bush:
        return 'sprites/bush.png';
      case DecorationType.rocks:
        return 'sprites/rocks.png';
    }
  }

  /// Size multiplier for each decoration type
  Vector2 get spriteSize {
    switch (this) {
      case DecorationType.oakTree:
        return Vector2(80, 80);
      case DecorationType.pineTree:
        return Vector2(48, 72);
      case DecorationType.bush:
        return Vector2(40, 32);
      case DecorationType.rocks:
        return Vector2(36, 28);
    }
  }
}

/// A single decoration placed on the map
class DecorationPlacement {
  final DecorationType type;
  final int col;
  final int row;

  const DecorationPlacement({
    required this.type,
    required this.col,
    required this.row,
  });
}

/// A Flame component that renders a single environment decoration
class DecorationComponent extends SpriteComponent {
  final DecorationPlacement placement;

  DecorationComponent({required this.placement}) : super(
    size: placement.type.spriteSize,
    anchor: Anchor.bottomCenter,
  );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(placement.type.spritePath);

    // Convert grid position to isometric screen coordinates
    final tileWidth = 64.0;
    final tileHeight = 32.0;
    final isoX = (placement.col - placement.row) * (tileWidth / 2);
    final isoY = (placement.col + placement.row) * (tileHeight / 2);

    position = Vector2(isoX, isoY);

    // Set priority based on row for proper depth sorting
    // Items further down (higher Y) should render on top
    priority = placement.col + placement.row;
  }
}

/// Generates decoration placements for a terrain map
class EnvironmentDecorationGenerator {
  /// Generate decoration placements that avoid non-grass tiles
  static List<DecorationPlacement> generate(
    WorldTerrainData terrain, {
    int? seed,
    double density = 0.12,
  }) {
    final random = Random(seed ?? 99);
    final placements = <DecorationPlacement>[];

    for (int col = 0; col < terrain.columns; col++) {
      for (int row = 0; row < terrain.rows; row++) {
        final tile = terrain.getTile(col, row);

        // Only place decorations on grass tiles
        if (tile != TerrainType.grass && tile != TerrainType.grassDark) {
          continue;
        }

        // Random chance to place a decoration
        if (random.nextDouble() > density) continue;

        // Choose decoration type with weighted probabilities
        final roll = random.nextDouble();
        DecorationType type;
        if (roll < 0.35) {
          type = DecorationType.oakTree;
        } else if (roll < 0.60) {
          type = DecorationType.pineTree;
        } else if (roll < 0.85) {
          type = DecorationType.bush;
        } else {
          type = DecorationType.rocks;
        }

        placements.add(DecorationPlacement(
          type: type,
          col: col,
          row: row,
        ));
      }
    }

    return placements;
  }
}
