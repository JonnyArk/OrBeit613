import 'package:drift/drift.dart';
import '../../domain/entities/building.dart' as domain;
import '../../domain/repositories/building_repository.dart';
import '../database.dart';

/// Drift-based implementation of [BuildingRepository].
///
/// This class bridges the domain layer with the Drift database,
/// converting between database models and domain entities.
///
/// **Implementation Details:**
/// - Uses [AppDatabase] for persistence
/// - Automatically handles ID generation
/// - Converts Drift [Building] rows to domain [Building] entities
class BuildingRepositoryImpl implements BuildingRepository {
  final AppDatabase _database;

  BuildingRepositoryImpl(this._database);

  @override
  Future<List<domain.Building>> getAllBuildings() async {
    final rows = await _database.select(_database.buildings).get();
    return rows.map(_toDomainBuilding).toList();
  }

  @override
  Stream<List<domain.Building>> watchAllBuildings() {
    return _database.select(_database.buildings).watch().map(
      (rows) => rows.map(_toDomainBuilding).toList(),
    );
  }

  @override
  Future<domain.Building?> getBuildingById(int id) async {
    final query = _database.select(_database.buildings)
      ..where((tbl) => tbl.id.equals(id));
    
    final row = await query.getSingleOrNull();
    return row != null ? _toDomainBuilding(row) : null;
  }

  @override
  Future<domain.Building> createBuilding({
    required String type,
    required double x,
    required double y,
    int rotation = 0,
  }) async {
    final id = await _database.into(_database.buildings).insert(
      BuildingsCompanion.insert(
        type: type,
        x: x,
        y: y,
        rotation: Value(rotation),
      ),
    );

    return domain.Building(
      id: id,
      type: type,
      x: x,
      y: y,
      rotation: rotation,
      placedAt: DateTime.now(),
    );
  }

  @override
  Future<domain.Building> updateBuilding(domain.Building building) async {
    await (_database.update(_database.buildings)
          ..where((tbl) => tbl.id.equals(building.id)))
        .write(
      BuildingsCompanion(
        type: Value(building.type),
        x: Value(building.x),
        y: Value(building.y),
        rotation: Value(building.rotation),
      ),
    );

    return building;
  }

  @override
  Future<bool> deleteBuilding(int id) async {
    final count = await (_database.delete(_database.buildings)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
    return count > 0;
  }

  @override
  Future<void> deleteAllBuildings() async {
    await _database.delete(_database.buildings).go();
  }

  /// Converts a Drift database row to a domain entity
  domain.Building _toDomainBuilding(Building row) {
    return domain.Building(
      id: row.id,
      type: row.type,
      x: row.x,
      y: row.y,
      rotation: row.rotation,
      placedAt: row.placedAt,
    );
  }
}
