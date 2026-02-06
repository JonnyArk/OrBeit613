/// OrBeit Providers - Building Provider
///
/// Riverpod providers for building data access.
/// Exposes repository and async state for buildings.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/building_repository_impl.dart';
import '../domain/entities/building.dart';
import '../domain/repositories/building_repository.dart';
import 'database_provider.dart';

/// Building repository provider
final buildingRepositoryProvider = Provider<BuildingRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BuildingRepositoryImpl(db);
});

/// Async list of all buildings
final buildingsProvider = FutureProvider<List<Building>>((ref) async {
  final repo = ref.watch(buildingRepositoryProvider);
  return repo.getAllBuildings();
});

/// Selected building ID state
final selectedBuildingIdProvider = StateProvider<int?>((ref) => null);

/// Selected building data (derived from ID)
final selectedBuildingProvider = FutureProvider<Building?>((ref) async {
  final selectedId = ref.watch(selectedBuildingIdProvider);
  if (selectedId == null) return null;
  
  final repo = ref.watch(buildingRepositoryProvider);
  return repo.getBuildingById(selectedId);
});
