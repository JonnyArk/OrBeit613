/// OrBeit Security — Dummy World Game
///
/// A convincing but completely empty game world shown during duress mode.
/// 
/// Design goals:
/// - Looks like a real app that's barely been used
/// - Has generic terrain, a few generic buildings
/// - NO real user data, tasks, events, or files
/// - The Or responds generically with no real memory
/// - Must look natural enough that an attacker believes it
///
/// CRITICAL: This file must NEVER import or reference real user data.

import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

/// A minimal, convincing game world with no real data
class DummyWorldGame extends FlameGame
    with PanDetector, ScaleDetector {
  late CameraComponent _cam;

  @override
  Future<void> onLoad() async {
    // Create a simple world with generic content
    final gameWorld = World();
    
    // Add generic terrain
    gameWorld.add(_DummyTerrain());
    
    // Add a couple of generic placeholder buildings
    gameWorld.add(_DummyBuilding(
      position: Vector2(100, 80),
      label: 'Home',
      color: const Color(0xFF4A6741),
    ));
    
    // Camera setup — centered on the small world
    _cam = CameraComponent(world: gameWorld);
    _cam.viewfinder.zoom = 1.0;
    _cam.viewfinder.position = Vector2(200, 150);

    addAll([gameWorld, _cam]);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _cam.viewfinder.position -= info.delta.global / _cam.viewfinder.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final newZoom = (_cam.viewfinder.zoom * info.scale.global.y).clamp(0.5, 2.5);
    _cam.viewfinder.zoom = newZoom;
  }
}

/// Simple colored terrain grid — no sprites, just flat colored tiles
class _DummyTerrain extends PositionComponent {
  static const int _cols = 8;
  static const int _rows = 8;
  static const double _tileW = 64;
  static const double _tileH = 32;

  final _rng = Random(42); // Fixed seed for consistent look

  _DummyTerrain() : super(priority: 0);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    for (int col = 0; col < _cols; col++) {
      for (int row = 0; row < _rows; row++) {
        final isoX = (col - row) * _tileW / 2 + 200;
        final isoY = (col + row) * _tileH / 2 + 50;

        // Mostly grass, occasional dirt
        final isGrass = _rng.nextDouble() > 0.15;
        final color = isGrass
            ? Color.lerp(
                const Color(0xFF3D7A3D),
                const Color(0xFF5A9A5A),
                _rng.nextDouble(),
              )!
            : const Color(0xFF8B7355);

        final path = Path()
          ..moveTo(isoX, isoY - _tileH / 2)
          ..lineTo(isoX + _tileW / 2, isoY)
          ..lineTo(isoX, isoY + _tileH / 2)
          ..lineTo(isoX - _tileW / 2, isoY)
          ..close();

        canvas.drawPath(path, Paint()..color = color);
        canvas.drawPath(
          path,
          Paint()
            ..color = const Color(0xFF000000).withValues(alpha: 0.1)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
      }
    }
  }
}

/// A generic building shape — looks real but contains nothing
class _DummyBuilding extends PositionComponent {
  final String label;
  final Color color;

  _DummyBuilding({
    required Vector2 position,
    required this.label,
    required this.color,
  }) : super(
    position: position,
    size: Vector2(60, 50),
    priority: 10,
  );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Simple house shape
    final wallPaint = Paint()..color = color;
    final roofPaint = Paint()..color = Color.lerp(color, const Color(0xFF000000), 0.3)!;

    // Walls
    canvas.drawRect(
      Rect.fromLTWH(5, 20, 50, 30),
      wallPaint,
    );

    // Roof triangle
    final roofPath = Path()
      ..moveTo(0, 22)
      ..lineTo(30, 0)
      ..lineTo(60, 22)
      ..close();
    canvas.drawPath(roofPath, roofPaint);

    // Door
    canvas.drawRect(
      Rect.fromLTWH(22, 32, 16, 18),
      Paint()..color = const Color(0xFF3E2723),
    );
  }
}
