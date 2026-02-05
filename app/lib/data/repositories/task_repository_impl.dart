/// OrBeit Data Layer - Task Repository Implementation
///
/// Drift-based implementation of TaskRepository.
/// Converts between Drift models and domain entities.

import 'package:drift/drift.dart';
import '../../domain/entities/task.dart' as domain;
import '../../domain/entities/task_repository.dart';
import '../database.dart';

/// Drift implementation of TaskRepository
class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase _database;

  TaskRepositoryImpl(this._database);

  @override
  Future<List<domain.Task>> getAllTasks() async {
    final rows = await _database.select(_database.tasks).get();
    return rows.map(_toDomainTask).toList();
  }

  @override
  Future<List<domain.Task>> getTasksByStatus(domain.TaskStatus status) async {
    final statusStr = _statusToString(status);
    final query = _database.select(_database.tasks)
      ..where((t) => t.completedAt.isNull());
    final rows = await query.get();
    return rows.map(_toDomainTask).where((t) => t.status == status).toList();
  }

  @override
  Future<List<domain.Task>> getTasksForBuilding(int buildingId) async {
    final query = _database.select(_database.tasks)
      ..where((t) => t.buildingId.equals(buildingId));
    final rows = await query.get();
    return rows.map(_toDomainTask).toList();
  }

  @override
  Future<domain.Task?> getTaskById(int id) async {
    final query = _database.select(_database.tasks)
      ..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _toDomainTask(row) : null;
  }

  @override
  Future<domain.Task> createTask({
    required String title,
    String? description,
    domain.TaskPriority priority = domain.TaskPriority.medium,
    int? buildingId,
    DateTime? dueDate,
  }) async {
    final id = await _database.into(_database.tasks).insert(
      TasksCompanion.insert(
        title: title,
        description: Value(description),
        priority: Value(_priorityToInt(priority)),
        buildingId: Value(buildingId),
        dueDate: Value(dueDate),
      ),
    );

    return domain.Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: domain.TaskStatus.pending,
      buildingId: buildingId,
      createdAt: DateTime.now(),
      dueDate: dueDate,
    );
  }

  @override
  Future<domain.Task> updateTask(domain.Task task) async {
    await (_database.update(_database.tasks)
          ..where((t) => t.id.equals(task.id)))
        .write(
      TasksCompanion(
        title: Value(task.title),
        description: Value(task.description),
        priority: Value(_priorityToInt(task.priority)),
        buildingId: Value(task.buildingId),
        dueDate: Value(task.dueDate),
        completedAt: Value(task.completedAt),
      ),
    );
    return task;
  }

  @override
  Future<domain.Task> completeTask(int id) async {
    final task = await getTaskById(id);
    if (task == null) throw Exception('Task not found');

    final completed = task.complete();
    return updateTask(completed);
  }

  @override
  Future<bool> deleteTask(int id) async {
    final count = await (_database.delete(_database.tasks)
          ..where((t) => t.id.equals(id)))
        .go();
    return count > 0;
  }

  @override
  Future<List<domain.Task>> getOverdueTasks() async {
    final now = DateTime.now();
    final query = _database.select(_database.tasks)
      ..where((t) => t.dueDate.isSmallerThanValue(now) & t.completedAt.isNull());
    final rows = await query.get();
    return rows.map(_toDomainTask).toList();
  }

  @override
  Future<List<domain.Task>> getTasksDueToday() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final query = _database.select(_database.tasks)
      ..where((t) => 
        t.dueDate.isBiggerOrEqualValue(startOfDay) & 
        t.dueDate.isSmallerThanValue(endOfDay) &
        t.completedAt.isNull());
    final rows = await query.get();
    return rows.map(_toDomainTask).toList();
  }

  domain.Task _toDomainTask(Task row) {
    return domain.Task(
      id: row.id,
      title: row.title,
      description: row.description,
      priority: _intToPriority(row.priority),
      status: row.completedAt != null 
        ? domain.TaskStatus.completed 
        : domain.TaskStatus.pending,
      buildingId: row.buildingId,
      createdAt: row.createdAt,
      dueDate: row.dueDate,
      completedAt: row.completedAt,
    );
  }

  String _statusToString(domain.TaskStatus status) {
    switch (status) {
      case domain.TaskStatus.pending: return 'pending';
      case domain.TaskStatus.inProgress: return 'in_progress';
      case domain.TaskStatus.completed: return 'completed';
      case domain.TaskStatus.cancelled: return 'cancelled';
    }
  }

  int _priorityToInt(domain.TaskPriority priority) {
    switch (priority) {
      case domain.TaskPriority.low: return 0;
      case domain.TaskPriority.medium: return 1;
      case domain.TaskPriority.high: return 2;
      case domain.TaskPriority.urgent: return 3;
    }
  }

  domain.TaskPriority _intToPriority(int priority) {
    switch (priority) {
      case 0: return domain.TaskPriority.low;
      case 2: return domain.TaskPriority.high;
      case 3: return domain.TaskPriority.urgent;
      default: return domain.TaskPriority.medium;
    }
  }
}
