/// OrBeit Providers - Task Provider
///
/// Riverpod providers for task data access.
/// Supports filtering by building and status.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/task_repository_impl.dart';
import '../domain/entities/task.dart';
import '../domain/entities/task_repository.dart';
import 'database_provider.dart';
import 'building_provider.dart';

/// Task repository provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TaskRepositoryImpl(db);
});

/// All tasks (unfiltered)
final allTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getAllTasks();
});

/// Tasks for the currently selected building
final tasksForSelectedBuildingProvider = FutureProvider<List<Task>>((ref) async {
  final buildingId = ref.watch(selectedBuildingIdProvider);
  if (buildingId == null) return [];
  
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasksForBuilding(buildingId);
});

/// Pending tasks only
final pendingTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasksByStatus(TaskStatus.pending);
});

/// Overdue tasks
final overdueTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getOverdueTasks();
});

/// Tasks due today
final todayTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasksDueToday();
});
