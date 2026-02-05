import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'isometric_grid.dart';
import 'building_component.dart';
import '../domain/repositories/building_repository.dart';

/// Main game instance for the OrBeit Sovereign Sanctum
///
/// Renders the isometric world and handles all game logic.
class WorldGame extends FlameGame {
  /// Repository for loading and saving buildings
  final BuildingRepository buildingRepository;

  WorldGame({required this.buildingRepository});

  @override
  Color backgroundColor() => const Color(0xFF1A1A2E); // Dark Slate from Sovereign Sanctum

  @override
  Future<void> onLoad() async {
    // Add the isometric grid
    add(IsometricGrid());
    
    // Load all buildings from database
    await _loadBuildings();
    
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

  /// Loads all buildings from the repository and adds them to the game
  Future<void> _loadBuildings() async {
    try {
      final buildings = await buildingRepository.getAllBuildings();
      
      for (final building in buildings) {
        final component = BuildingComponent(building: building);
        add(component);
      }
      
      print('Loaded ${buildings.length} buildings from database');
    } catch (e) {
      print('Error loading buildings: $e');
    }
  }

  /// Adds a new building component to the game
  ///
  /// Call this after creating a building via the repository to immediately
  /// render it without restarting the game.
  void addBuilding(BuildingComponent component) {
    add(component);
  }
}
