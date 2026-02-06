/// OrBeit Providers - Database Provider
///
/// Root Riverpod provider for the Drift database.
/// All repository providers depend on this.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';

/// Global database instance provider
///
/// This is the root of the data layer dependency tree.
/// Use `ref.watch(databaseProvider)` to access the database.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
