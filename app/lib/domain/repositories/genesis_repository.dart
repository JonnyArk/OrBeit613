import '../entities/genesis_kit.dart';

/// Repository for spawning complex multi-node structures (Genesis Kits).
///
/// This handles the "Big Bang" creation logic where multiple database rows
/// (buildings, tasks, relationships) must be created atomically.
abstract class GenesisRepository {
  /// Instantiates a full Genesis Kit at the given grid coordinates.
  ///
  /// This operation must be atomic (transactional): either the whole
  /// kit spawns, or nothing does.
  ///
  /// [kit] The archetype definition (nodes + tasks).
  /// [originX] The center X coordinate on the grid.
  /// [originY] The center Y coordinate on the grid.
  Future<void> spawnKit(GenesisKit kit, double originX, double originY);
}
