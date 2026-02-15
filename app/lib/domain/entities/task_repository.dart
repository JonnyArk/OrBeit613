/// OrBeit Domain - Task Repository Interface
///
/// Abstract definition of task data access operations.

import 'task.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTasks();

  Future<List<Task>> getTasksByStatus(TaskStatus status);

  Future<List<Task>> getTasksForBuilding(int buildingId);

  Future<Task?> getTaskById(int id);

  Future<Task> createTask({
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.medium,
    int? buildingId,
    DateTime? dueDate,
  });

  Future<Task> updateTask(Task task);

  Future<Task> completeTask(int id);

  Future<bool> deleteTask(int id);

  Future<List<Task>> getOverdueTasks();

  Future<List<Task>> getTasksDueToday();
}
