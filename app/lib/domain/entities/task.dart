/// OrBeit Domain - Task Entity
///
/// Represents a task or action item within the Sovereign Sanctum.
/// Tasks can be linked to buildings and have priorities, due dates,
/// and completion status.

/// Priority levels for tasks
enum TaskPriority { low, medium, high, urgent }

/// Status of a task
enum TaskStatus { pending, inProgress, completed, cancelled }

/// Core domain entity for a Task
class Task {
  final int id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskStatus status;
  final int? buildingId;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.buildingId,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
  });

  /// Creates a copy with modified fields
  Task copyWith({
    int? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    int? buildingId,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      buildingId: buildingId ?? this.buildingId,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Marks task as completed
  Task complete() {
    return copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now(),
    );
  }

  @override
  String toString() => 'Task($id: $title, $status)';
}
