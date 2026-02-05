import '../entities/task.dart';

/// Repository interface for Task persistence operations.
///
/// This interface defines the contract for managing spatial task markers
/// in the Sovereign Sanctum. Tasks can be anchored to buildings or
/// placed freely on the isometric grid.
///
/// **Clean Architecture:**
/// Domain layer interface - no implementation dependencies.
abstract class TaskRepository {
  /// Retrieves all tasks from the data source.
  ///
  /// Returns tasks ordered by priority (highest first), then by creation time.
  Future<List<Task>> getAllTasks();

  /// Retrieves incomplete tasks only.
  ///
  /// Filters out tasks where [completedAt] is set.
  Future<List<Task>> getIncompleteTasks();

  /// Retrieves tasks anchored to a specific building.
  ///
  /// Returns tasks where [buildingId] matches, ordered by priority.
  Future<List<Task>> getTasksByBuilding(int buildingId);

  /// Retrieves a specific task by its unique identifier.
  ///
  /// Returns `null` if no task with the given [id] exists.
  Future<Task?> getTaskById(int id);

  /// Creates a new task.
  ///
  /// Specify either [buildingId] for anchored tasks, or [gridX]/[gridY]
  /// for freestanding task markers.
  ///
  /// Returns the persisted [Task] with its generated ID.
  Future<Task> createTask({
    required String title,
    String? description,
    int? buildingId,
    double? gridX,
    double? gridY,
    DateTime? dueDate,
    int priority = 1,
  });

  /// Updates an existing task.
  ///
  /// Returns the updated [Task].
  Future<Task> updateTask(Task task);

  /// Marks a task as completed with current timestamp.
  ///
  /// Returns the updated [Task] with [completedAt] set.
  Future<Task> completeTask(int id);

  /// Removes completion status from a task.
  ///
  /// Returns the updated [Task] with [completedAt] cleared.
  Future<Task> uncompleteTask(int id);

  /// Removes a task from the data source.
  ///
  /// Returns `true` if deleted, `false` if it didn't exist.
  Future<bool> deleteTask(int id);

  /// Removes all completed tasks.
  ///
  /// Used for "clear completed" functionality.
  Future<int> deleteCompletedTasks();
}
