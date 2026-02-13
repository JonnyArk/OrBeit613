/// OrBeit Spatial Layer - World Game
///
/// Main Flame game instance that orchestrates the isometric world.
/// Uses Flame's CameraComponent for panning and zooming.
///
/// **Rendering Order (bottom to top):**
/// 1. Sky-blue background
/// 2. Terrain tiles (grass, road, water, sand)
/// 3. Environment decorations (trees, bushes, rocks)
/// 4. User buildings (AI-generated or placed)
/// 5. The Or Lighthouse (always visible, center of world)

import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/entities/building.dart';
import 'isometric_grid.dart';
import 'building_component.dart';
import 'world_terrain_data.dart';
import 'environment_decorations.dart';
import '../domain/repositories/building_repository.dart';

/// Main game instance for the OrBeit world
class WorldGame extends FlameGame with PanDetector, ScaleDetector, HasCollisionDetection {
  /// Repository for loading and saving buildings
  final BuildingRepository buildingRepository;

  StreamSubscription<List<Building>>? _buildingSubscription;

  /// Terrain data for the world
  late final WorldTerrainData terrainData;

  /// The root world component that everything is added to
  late final World _world;

  /// Camera for panning/zooming
  late final CameraComponent _cam;

  /// Tile dimensions
  static const double tileWidth = 64.0;
  static const double tileHeight = 32.0;

  WorldGame({required this.buildingRepository});

  @override
  Color backgroundColor() => const Color(0xFF87CEEB); // Sky blue

  @override
  Future<void> onLoad() async {
    // Create the world container
    _world = World();
    add(_world);

    // Create camera following the world
    _cam = CameraComponent(world: _world);
    add(_cam);

    // 1. Generate terrain
    terrainData = WorldTerrainData(
      columns: 20,
      rows: 20,
      seed: 42,
    );

    // 2. Add the terrain grid renderer (priority: 0 = back)
    final grid = IsometricGrid(terrainData: terrainData);
    grid.priority = 0;
    _world.add(grid);

    // 3. Generate and add environment decorations
    final decorations = EnvironmentDecorationGenerator.generate(
      terrainData,
      seed: 99,
      density: 0.10,
    );

    for (final placement in decorations) {
      _world.add(DecorationComponent(placement: placement));
    }

    // 4. Add the Or Lighthouse at the center of the world
    final lighthouse = OrLighthouseComponent(gridCol: 10, gridRow: 10);
    lighthouse.priority = 90;
    _world.add(lighthouse);

    // 5. Subscribe to building updates
    _buildingSubscription = buildingRepository
        .watchAllBuildings()
        .listen(_syncBuildings);

    // 6. Center camera on the world center
    // Iso center for tile (10,10): x = (10-10)*32 = 0, y = (10+10)*16 = 320
    _cam.viewfinder.position = Vector2(0, 280);
    _cam.viewfinder.zoom = 1.2;

    // 7. Add HUD overlay (renders on top of camera, not affected by camera transform)
    _cam.viewport.add(HudOverlayComponent());
  }

  // ── Pan and Zoom ───────────────────────────────────────────

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _cam.viewfinder.position -= info.delta.global / _cam.viewfinder.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final newZoom = (_cam.viewfinder.zoom * info.scale.global.y).clamp(0.4, 3.0);
    _cam.viewfinder.zoom = newZoom;
  }

  @override
  void onRemove() {
    _buildingSubscription?.cancel();
    super.onRemove();
  }

  /// Syncs the game components with the latest database state
  void _syncBuildings(List<Building> buildings) {
    final currentComponents = _world.children.whereType<BuildingComponent>().toList();
    final currentIds = currentComponents.map((c) => c.building.id).toSet();
    final newIds = buildings.map((b) => b.id).toSet();

    // Remove deleted buildings
    for (final component in currentComponents) {
      if (!newIds.contains(component.building.id)) {
        component.removeFromParent();
      }
    }

    // Add new buildings
    for (final building in buildings) {
      if (!currentIds.contains(building.id)) {
        final comp = BuildingComponent(building: building);
        comp.priority = 50 + building.x.toInt() + building.y.toInt();
        _world.add(comp);
      }
    }
  }

  /// Adds a new building component to the game manually
  void addBuilding(BuildingComponent component) {
    component.priority = 50 + component.building.x.toInt() + component.building.y.toInt();
    _world.add(component);
  }

  /// Forces a refresh of buildings from the database
  Future<void> refreshBuildings() async {
    final buildings = await buildingRepository.getAllBuildings();
    _syncBuildings(buildings);
  }
}

// ════════════════════════════════════════════════════════════
// HUD OVERLAY — Title, Fulfillment Bar, etc.
// ════════════════════════════════════════════════════════════

/// HUD elements rendered on top of the camera viewport
class HudOverlayComponent extends PositionComponent with HasGameReference<WorldGame> {
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _renderTitle(canvas);
    _renderFulfillmentBar(canvas);
  }

  void _renderTitle(Canvas canvas) {
    final gameSize = game.size;
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'OrBeit: Sovereign Sanctum',
        style: TextStyle(
          color: Color(0xFFD4AF37),
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          shadows: [
            Shadow(blurRadius: 6, color: Color(0xAA000000), offset: Offset(1, 1)),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(gameSize.x / 2 - textPainter.width / 2, 16));
  }

  void _renderFulfillmentBar(Canvas canvas) {
    final gameSize = game.size;
    final barWidth = gameSize.x * 0.4;
    final barHeight = 8.0;
    final barX = (gameSize.x - barWidth) / 2;
    final barY = gameSize.y - 75;

    // Background track
    canvas.drawRRect(
      RRect.fromLTRBR(barX, barY, barX + barWidth, barY + barHeight, const Radius.circular(4)),
      Paint()..color = const Color(0x44FFFFFF),
    );

    // Fill (placeholder 35%)
    canvas.drawRRect(
      RRect.fromLTRBR(barX, barY, barX + barWidth * 0.35, barY + barHeight, const Radius.circular(4)),
      Paint()..color = const Color(0xFFD4AF37),
    );

    // Label
    final labelPainter = TextPainter(
      text: const TextSpan(
        text: 'FULFILLMENT LEVEL: 35% COMPLETE',
        style: TextStyle(
          color: Color(0xCCFFFFFF),
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();
    labelPainter.paint(canvas, Offset(gameSize.x / 2 - labelPainter.width / 2, barY - 16));
  }
}

// ════════════════════════════════════════════════════════════
// THE OR LIGHTHOUSE — Center of the World
// ════════════════════════════════════════════════════════════

/// The Or Lighthouse component — the spiritual center of the user's world.
/// Renders as a glowing teal/blue beacon with golden orbital rings
/// and pulsing light rings. Always visible. Always watching.
class OrLighthouseComponent extends PositionComponent {
  final int gridCol;
  final int gridRow;

  double _pulsePhase = 0.0;
  double _beamAngle = 0.0;

  OrLighthouseComponent({
    required this.gridCol,
    required this.gridRow,
  });

  @override
  Future<void> onLoad() async {
    // Position at isometric coordinates, raised above ground
    final isoX = (gridCol - gridRow) * (WorldGame.tileWidth / 2);
    final isoY = (gridCol + gridRow) * (WorldGame.tileHeight / 2);
    position = Vector2(isoX, isoY - 60);
    size = Vector2(120, 180);
    anchor = Anchor.bottomCenter;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _pulsePhase += dt * 1.5;
    _beamAngle += dt * 0.3;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final centerX = size.x / 2;
    final baseY = size.y;
    final pulse = (sin(_pulsePhase) + 1) / 2;

    // ── Ground shadow ──
    canvas.drawOval(
      Rect.fromCenter(center: Offset(centerX, baseY + 5), width: 50, height: 14),
      Paint()
        ..color = const Color(0x33000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // ── Tower base (tapered dark rectangle) ──
    final basePath = Path()
      ..moveTo(centerX - 16, baseY)
      ..lineTo(centerX - 10, baseY - 85)
      ..lineTo(centerX + 10, baseY - 85)
      ..lineTo(centerX + 16, baseY)
      ..close();

    canvas.drawPath(
      basePath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A2A4E), Color(0xFF1A1A2E)],
        ).createShader(Rect.fromLTWH(centerX - 16, baseY - 85, 32, 85)),
    );

    // Tower stroke
    canvas.drawPath(
      basePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0x44D4AF37)
        ..strokeWidth = 1,
    );

    // ── Lamp housing ──
    final lampY = baseY - 90;

    // Outer glow
    canvas.drawCircle(
      Offset(centerX, lampY),
      22 + pulse * 8,
      Paint()
        ..color = Color.fromARGB((40 + pulse * 40).toInt(), 79, 209, 197)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );

    // Mid glow
    canvas.drawCircle(
      Offset(centerX, lampY),
      14 + pulse * 4,
      Paint()
        ..color = Color.fromARGB((80 + pulse * 60).toInt(), 79, 209, 197)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Core light
    canvas.drawCircle(
      Offset(centerX, lampY),
      8,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white,
            const Color(0xFF4FD1C5),
            const Color(0xFF26A69A),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(centerX, lampY), radius: 8)),
    );

    // ── Orbital rings ──
    _drawOrbitalRing(canvas, centerX, lampY, 20 + pulse * 3, _beamAngle);
    _drawOrbitalRing(canvas, centerX, lampY, 26 + pulse * 5, -_beamAngle * 0.7);

    // ── Pulsing beacon rings ──
    for (int i = 0; i < 3; i++) {
      final ringPhase = (_pulsePhase + i * 2.1) % (pi * 2);
      final ringProgress = (sin(ringPhase) + 1) / 2;
      final ringRadius = 30 + ringProgress * 40;
      final ringAlpha = ((1 - ringProgress) * 50).toInt().clamp(0, 255);

      canvas.drawCircle(
        Offset(centerX, lampY),
        ringRadius,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Color.fromARGB(ringAlpha, 212, 175, 55)
          ..strokeWidth = 1.5,
      );
    }

    // ── Light beam downward ──
    final beamPath = Path()
      ..moveTo(centerX - 6, lampY + 8)
      ..lineTo(centerX - 22, baseY + 10)
      ..lineTo(centerX + 22, baseY + 10)
      ..lineTo(centerX + 6, lampY + 8)
      ..close();

    canvas.drawPath(
      beamPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB((50 + pulse * 30).toInt(), 79, 209, 197),
            const Color(0x004FD1C5),
          ],
        ).createShader(Rect.fromLTWH(centerX - 22, lampY, 44, baseY - lampY + 10)),
    );
  }

  void _drawOrbitalRing(Canvas canvas, double cx, double cy, double radius, double angle) {
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(angle);

    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: radius * 2, height: radius * 0.6),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0x66D4AF37)
        ..strokeWidth = 1.5,
    );

    // Small orb on ring
    final orbX = cos(angle * 3) * radius;
    final orbY = sin(angle * 3) * radius * 0.3;
    canvas.drawCircle(
      Offset(orbX, orbY),
      3,
      Paint()..color = const Color(0xFFD4AF37),
    );

    canvas.restore();
  }
}
