/// OrBeit Spatial Layer - World Game
///
/// Main Flame game instance that orchestrates the isometric world.
/// Renders terrain, environment decorations, and user buildings.
///
/// **Rendering Order (bottom to top):**
/// 1. Sky-blue background
/// 2. Terrain tiles (grass, road, water, sand)
/// 3. Environment decorations (trees, bushes, rocks)
/// 4. User buildings (AI-generated or placed)
/// 5. UI overlays (title, HUD)

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/entities/building.dart';
import 'isometric_grid.dart';
import 'building_component.dart';
import 'world_terrain_data.dart';
import 'environment_decorations.dart';
import '../domain/repositories/building_repository.dart';

/// Main game instance for the OrBeit world
///
/// Creates a living isometric landscape with procedural terrain,
/// scattered environment props, and user-placed buildings.
class WorldGame extends FlameGame {
  /// Repository for loading and saving buildings
  final BuildingRepository buildingRepository;

  StreamSubscription<List<Building>>? _buildingSubscription;

  /// Terrain data for the world
  late final WorldTerrainData terrainData;

  WorldGame({required this.buildingRepository});

  @override
  Color backgroundColor() => const Color(0xFF87CEEB); // Sky blue

  @override
  Future<void> onLoad() async {
    // 1. Generate terrain
    terrainData = WorldTerrainData(
      columns: 20,
      rows: 20,
      seed: 42,
    );

    // 2. Add the terrain grid renderer (priority: 0 = back)
    final grid = IsometricGrid(terrainData: terrainData);
    grid.priority = 0;
    add(grid);

    // 3. Generate and add environment decorations (priority: 1-40)
    final decorations = EnvironmentDecorationGenerator.generate(
      terrainData,
      seed: 99,
      density: 0.10,
    );

    for (final placement in decorations) {
      add(DecorationComponent(placement: placement));
    }

    // 4. Subscribe to building updates (buildings render on top)
    _buildingSubscription = buildingRepository
        .watchAllBuildings()
        .listen(_syncBuildings);

    // 5. Add world title overlay
    add(TextComponent(
      text: 'OrBeit: Sovereign Sanctum',
      position: Vector2(50, 20),
      priority: 100, // Always on top
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFD4AF37), // Gold
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Color(0x88000000),
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void onRemove() {
    _buildingSubscription?.cancel();
    super.onRemove();
  }

  /// Syncs the game components with the latest database state
  void _syncBuildings(List<Building> buildings) {
    // Get currently rendered building IDs
    final currentComponents = children.whereType<BuildingComponent>().toList();
    final currentIds = currentComponents.map((c) => c.building.id).toSet();
    final newIds = buildings.map((b) => b.id).toSet();

    // Remove deleted buildings
    for (final component in currentComponents) {
      if (!newIds.contains(component.building.id)) {
        component.removeFromParent();
      }
    }

    // Add new buildings (with high priority so they render above terrain)
    for (final building in buildings) {
      if (!currentIds.contains(building.id)) {
        final comp = BuildingComponent(building: building);
        comp.priority = 50 + building.x.toInt() + building.y.toInt();
        add(comp);
      }
    }
  }

  /// Adds a new building component to the game manually
  void addBuilding(BuildingComponent component) {
    component.priority = 50 + component.building.x.toInt() + component.building.y.toInt();
    add(component);
  }
}
