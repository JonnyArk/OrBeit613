import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/entities/building.dart';
import 'isometric_grid.dart';
import 'building_component.dart';
import '../domain/repositories/building_repository.dart';

/// Main game instance for the OrBeit Sovereign Sanctum
///
/// Renders the isometric world and handles all game logic.
class WorldGame extends FlameGame {
  /// Repository for loading and saving buildings
  final BuildingRepository buildingRepository;

  StreamSubscription<List<Building>>? _buildingSubscription;

  WorldGame({required this.buildingRepository});

  @override
  Color backgroundColor() => const Color(0xFF1A1A2E); // Dark Slate from Sovereign Sanctum

  @override
  Future<void> onLoad() async {
    // Add the isometric grid
    add(IsometricGrid());
    
    // Subscribe to building updates
    _buildingSubscription = buildingRepository.watchAllBuildings().listen(_syncBuildings);
    
    add(TextComponent(
      text: 'OrBeit: Sovereign Sanctum',
      position: Vector2(50, 50),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFD4AF37), // Gold
          fontSize: 24,
          fontFamily: 'Roboto', // Default for now
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

    // Add new buildings
    for (final building in buildings) {
      if (!currentIds.contains(building.id)) {
        add(BuildingComponent(building: building));
      }
    }
  }

  /// Adds a new building component to the game manually
  void addBuilding(BuildingComponent component) {
    add(component);
  }
}
