import '../entities/task.dart';

/// Repository interface for Task persistence operations.
///
/// This interface defines the contract for any data source that can
/// store and retrieve Tasks.
abstract class TaskRepository {
  /// Retrieves all tasks from the data source.
  Future<List<Task>> getAllTasks();

  /// Retrieves tasks filtered by status.
  Future<List<Task>> getTasksByStatus(TaskStatus status);

  /// Retrieves tasks associated with a specific building.
  Future<List<Task>> getTasksForBuilding(int buildingId);

  /// Retrieves a specific task by its unique identifier.
  Future<Task?> getTaskById(int id);

  /// Creates a new task.
  Future<Task> createTask({
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.medium,
    int? buildingId,
    DateTime? dueDate,
  });

  /// Updates an existing task.
  Future<Task> updateTask(Task task);

  /// Marks a task as completed.
  Future<Task> completeTask(int id);

  /// Deletes a task by its ID.
  Future<bool> deleteTask(int id);

  /// Retrieves tasks that are overdue.
  Future<List<Task>> getOverdueTasks();

  /// Retrieves tasks that are due today.
  Future<List<Task>> getTasksDueToday();
}
