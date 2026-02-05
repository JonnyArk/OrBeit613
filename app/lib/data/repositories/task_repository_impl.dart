import 'package:drift/drift.dart';
import '../../domain/entities/task.dart' as domain;
import '../../domain/repositories/task_repository.dart';
import '../database.dart';

/// Drift-based implementation of [TaskRepository].
///
/// Bridges the domain layer with the Drift database,
/// converting between database models and domain entities.
class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase _database;

  TaskRepositoryImpl(this._database);

  @override
  Future<List<domain.Task>> getAllTasks() async {
    final query = _database.select(_database.tasks)
      ..orderBy([
        (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(_toDomainTask).toList();
  }

  @override
  Future<List<domain.Task>> getIncompleteTasks() async {
    final query = _database.select(_database.tasks)
      ..where((t) => t.completedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.asc),
      ]);
    final rows = await query.get();
    return rows.map(_toDomainTask).toList();
  }

  @override
  Future<List<domain.Task>> getTasksByBuilding(int buildingId) async {
    final query = _database.select(_database.tasks)
      ..where((t) => t.buildingId.equals(buildingId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
      ]);
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
    int? buildingId,
    double? gridX,
    double? gridY,
    DateTime? dueDate,
    int priority = 1,
  }) async {
    final now = DateTime.now();
    final id = await _database.into(_database.tasks).insert(
      TasksCompanion.insert(
        title: title,
        description: Value(description),
        buildingId: Value(buildingId),
        gridX: Value(gridX),
        gridY: Value(gridY),
        dueDate: Value(dueDate),
        priority: Value(priority),
      ),
    );

    return domain.Task(
      id: id,
      title: title,
      description: description,
      buildingId: buildingId,
      gridX: gridX,
      gridY: gridY,
      dueDate: dueDate,
      completedAt: null,
      priority: priority,
      createdAt: now,
      updatedAt: now,
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
        buildingId: Value(task.buildingId),
        gridX: Value(task.gridX),
        gridY: Value(task.gridY),
        dueDate: Value(task.dueDate),
        completedAt: Value(task.completedAt),
        priority: Value(task.priority),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return task.copyWith(updatedAt: DateTime.now());
  }

  @override
  Future<domain.Task> completeTask(int id) async {
    final now = DateTime.now();
    await (_database.update(_database.tasks)..where((t) => t.id.equals(id)))
        .write(TasksCompanion(
      completedAt: Value(now),
      updatedAt: Value(now),
    ));
    final updated = await getTaskById(id);
    return updated!;
  }

  @override
  Future<domain.Task> uncompleteTask(int id) async {
    await (_database.update(_database.tasks)..where((t) => t.id.equals(id)))
        .write(TasksCompanion(
      completedAt: const Value(null),
      updatedAt: Value(DateTime.now()),
    ));
    final updated = await getTaskById(id);
    return updated!;
  }

  @override
  Future<bool> deleteTask(int id) async {
    final count = await (_database.delete(_database.tasks)
          ..where((t) => t.id.equals(id)))
        .go();
    return count > 0;
  }

  @override
  Future<int> deleteCompletedTasks() async {
    return await (_database.delete(_database.tasks)
          ..where((t) => t.completedAt.isNotNull()))
        .go();
  }

  domain.Task _toDomainTask(Task row) {
    return domain.Task(
      id: row.id,
      title: row.title,
      description: row.description,
      buildingId: row.buildingId,
      gridX: row.gridX,
      gridY: row.gridY,
      dueDate: row.dueDate,
      completedAt: row.completedAt,
      priority: row.priority,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
