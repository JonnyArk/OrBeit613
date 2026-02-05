import '../entities/building.dart';

/// Repository interface for Building persistence operations.
///
/// This interface defines the contract for any data source that can
/// store and retrieve Buildings. Implementations can use Drift, Firebase,
/// or any other persistence mechanism.
///
/// **Clean Architecture:**
/// This interface belongs to the domain layer and has NO dependencies
/// on specific implementations. It allows the domain logic to remain
/// independent of data source details.
abstract class BuildingRepository {
  /// Retrieves all buildings from the data source.
  ///
  /// Returns a list of [Building] entities ordered by placement time.
  /// Returns an empty list if no buildings exist.
  Future<List<Building>> getAllBuildings();

  /// Retrieves a specific building by its unique identifier.
  ///
  /// Returns `null` if no building with the given [id] exists.
  Future<Building?> getBuildingById(int id);

  /// Persists a new building to the data source.
  ///
  /// The [type], [x], [y] coordinates are required. The [rotation]
  /// defaults to 0 degrees if not specified.
  ///
  /// Returns the persisted [Building] with its generated ID.
  Future<Building> createBuilding({
    required String type,
    required double x,
    required double y,
    int rotation = 0,
  });

  /// Updates an existing building's position or rotation.
  ///
  /// Returns the updated [Building] or throws if the building doesn't exist.
  Future<Building> updateBuilding(Building building);

  /// Removes a building from the data source.
  ///
  /// Returns `true` if the building was successfully deleted,
  /// `false` if it didn't exist.
  Future<bool> deleteBuilding(int id);

  /// Removes all buildings from the data source.
  ///
  /// Use with caution - this is typically only used for testing or
  /// user-initiated "reset world" actions.
  Future<void> deleteAllBuildings();
}
