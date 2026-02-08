import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/genesis_repository_impl.dart';
import '../domain/repositories/genesis_repository.dart';
import 'database_provider.dart';

/// Provider for the GenesisRepository
///
/// Use this to access the atomic spawning logic for Genesis Kits.
final genesisRepositoryProvider = Provider<GenesisRepository>((ref) {
  // Dependency injection: Get the database instance
  final db = ref.watch(databaseProvider);
  return GenesisRepositoryImpl(db);
});
