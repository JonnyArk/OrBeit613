/// OrBeit Providers - Life Event Provider
///
/// Riverpod provider for life event data access.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/life_event_repository_impl.dart';
import 'database_provider.dart';

/// Life event repository provider
final lifeEventRepositoryProvider = Provider<LifeEventRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return LifeEventRepositoryImpl(db);
});
