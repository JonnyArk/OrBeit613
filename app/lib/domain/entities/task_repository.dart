/// OrBeit Domain - Task Repository Interface
///
/// Defines the contract for task persistence operations.
/// Implementation will use Drift for local storage.

import 'task.dart';

/// Abstract repository interface for Task operations
abstract class TaskRepository {
  /// Gets all tasks
  Future<List<Task>> getAllTasks();

  /// Gets tasks by status
  Future<List<Task>> getTasksByStatus(TaskStatus status);

  /// Gets tasks linked to a building
  Future<List<Task>> getTasksForBuilding(int buildingId);

  /// Gets a task by ID
  Future<Task?> getTaskById(int id);

  /// Creates a new task
  Future<Task> createTask({
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.medium,
    int? buildingId,
    DateTime? dueDate,
  });

  /// Updates an existing task
  Future<Task> updateTask(Task task);

  /// Marks a task as completed
  Future<Task> completeTask(int id);

  /// Deletes a task
  Future<bool> deleteTask(int id);

  /// Gets overdue tasks
  Future<List<Task>> getOverdueTasks();

  /// Gets tasks due today
  Future<List<Task>> getTasksDueToday();
}
