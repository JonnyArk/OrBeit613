/// OrBeit Spatial Layer - Environment Decorations
///
/// Procedurally places trees, bushes, and rocks on the world map
/// to create a natural-feeling landscape. Decorations are placed
/// only on grass tiles, avoiding roads, water, and buildings.
///
/// If sprites fail to load, each decoration type renders as a
/// stylized vector shape (triangle trees, circle bushes, polygon rocks).

import 'dart:math';
import 'dart:ui';
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
        return Vector2(36, 48);
      case DecorationType.pineTree:
        return Vector2(28, 44);
      case DecorationType.bush:
        return Vector2(22, 16);
      case DecorationType.rocks:
        return Vector2(20, 14);
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
/// Falls back to vector shapes if sprites fail to load.
class DecorationComponent extends PositionComponent {
  final DecorationPlacement placement;
  Sprite? _sprite;
  bool _spriteLoaded = false;

  DecorationComponent({required this.placement}) : super(
    size: placement.type.spriteSize,
    anchor: Anchor.bottomCenter,
  );

  @override
  Future<void> onLoad() async {
    try {
      _sprite = await Sprite.load(placement.type.spritePath);
      _spriteLoaded = true;
    } catch (e) {
      _spriteLoaded = false;
    }

    // Convert grid position to isometric screen coordinates
    const tileWidth = 64.0;
    const tileHeight = 32.0;
    final isoX = (placement.col - placement.row) * (tileWidth / 2);
    final isoY = (placement.col + placement.row) * (tileHeight / 2);

    position = Vector2(isoX, isoY);

    // Set priority based on row for proper depth sorting
    priority = placement.col + placement.row;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_spriteLoaded && _sprite != null) {
      _sprite!.render(canvas, size: size);
    } else {
      _renderFallback(canvas);
    }
  }

  /// Renders a vector fallback shape for each decoration type
  void _renderFallback(Canvas canvas) {
    switch (placement.type) {
      case DecorationType.oakTree:
        _renderOakTree(canvas);
        break;
      case DecorationType.pineTree:
        _renderPineTree(canvas);
        break;
      case DecorationType.bush:
        _renderBush(canvas);
        break;
      case DecorationType.rocks:
        _renderRocks(canvas);
        break;
    }
  }

  void _renderOakTree(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Trunk
    canvas.drawRect(
      Rect.fromLTWH(w * 0.4, h * 0.55, w * 0.2, h * 0.45),
      Paint()..color = const Color(0xFF5D4037),
    );

    // Crown (circle)
    canvas.drawCircle(
      Offset(w / 2, h * 0.35),
      w * 0.45,
      Paint()..color = const Color(0xFF2E7D32),
    );

    // Highlight
    canvas.drawCircle(
      Offset(w * 0.4, h * 0.28),
      w * 0.25,
      Paint()..color = const Color(0xFF43A047),
    );
  }

  void _renderPineTree(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Trunk
    canvas.drawRect(
      Rect.fromLTWH(w * 0.38, h * 0.7, w * 0.24, h * 0.3),
      Paint()..color = const Color(0xFF4E342E),
    );

    // Three triangle layers
    for (int i = 0; i < 3; i++) {
      final layerY = h * (0.15 + i * 0.2);
      final layerW = w * (0.35 + i * 0.15);
      final path = Path()
        ..moveTo(w / 2, layerY)
        ..lineTo(w / 2 + layerW, layerY + h * 0.25)
        ..lineTo(w / 2 - layerW, layerY + h * 0.25)
        ..close();
      canvas.drawPath(
        path,
        Paint()..color = Color.fromARGB(255, 27, 94, 32 + i * 20),
      );
    }
  }

  void _renderBush(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    canvas.drawOval(
      Rect.fromLTWH(0, h * 0.1, w, h * 0.9),
      Paint()..color = const Color(0xFF558B2F),
    );
    canvas.drawOval(
      Rect.fromLTWH(w * 0.15, h * 0.0, w * 0.6, h * 0.7),
      Paint()..color = const Color(0xFF689F38),
    );
  }

  void _renderRocks(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Main rock
    final rockPath = Path()
      ..moveTo(w * 0.1, h * 0.9)
      ..lineTo(w * 0.0, h * 0.5)
      ..lineTo(w * 0.3, h * 0.1)
      ..lineTo(w * 0.7, h * 0.0)
      ..lineTo(w * 1.0, h * 0.4)
      ..lineTo(w * 0.9, h * 0.9)
      ..close();

    canvas.drawPath(
      rockPath,
      Paint()..color = const Color(0xFF78909C),
    );
    canvas.drawPath(
      rockPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFF546E7A)
        ..strokeWidth = 0.5,
    );
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
