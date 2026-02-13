import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/ui/task_list_panel.dart';
import 'package:app/domain/entities/task.dart';
import 'package:app/domain/entities/task_repository.dart';
import 'package:app/providers/task_provider.dart';

class MockTaskRepository implements TaskRepository {
  List<Task> tasks = [];

  @override
  Future<List<Task>> getAllTasks() async {
    return tasks;
  }

  @override
  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    return tasks.where((t) => t.status == status).toList();
  }

  @override
  Future<Task> completeTask(int id) async {
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      tasks[index] = tasks[index].complete();
      return tasks[index];
    }
    throw Exception('Task not found');
  }

  @override
  Future<Task> createTask({
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.medium,
    int? buildingId,
    DateTime? dueDate,
  }) async {
    final task = Task(
      id: tasks.length + 1,
      title: title,
      description: description,
      priority: priority,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
      dueDate: dueDate,
    );
    tasks.add(task);
    return task;
  }

  @override
  Future<bool> deleteTask(int id) async {
    tasks.removeWhere((t) => t.id == id);
    return true;
  }

  @override
  Future<List<Task>> getOverdueTasks() async => [];

  @override
  Future<Task?> getTaskById(int id) async => null;

  @override
  Future<List<Task>> getTasksDueToday() async => [];

  @override
  Future<List<Task>> getTasksForBuilding(int buildingId) async => [];

  @override
  Future<Task> updateTask(Task task) async {
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
    }
    return task;
  }
}

void main() {
  testWidgets('TaskListPanel displays active tasks and groups them', (WidgetTester tester) async {
    final mockRepo = MockTaskRepository();
    mockRepo.tasks = [
      Task(
        id: 1,
        title: 'Urgent Task',
        priority: TaskPriority.urgent,
        status: TaskStatus.pending,
        createdAt: DateTime.now(),
      ),
      Task(
        id: 2,
        title: 'Medium Task',
        priority: TaskPriority.medium,
        status: TaskStatus.pending,
        createdAt: DateTime.now(),
      ),
      Task(
        id: 3,
        title: 'Completed Task',
        priority: TaskPriority.low,
        status: TaskStatus.completed,
        createdAt: DateTime.now(),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: TaskListPanel(),
          ),
        ),
      ),
    );

    // Initial pump (shows loading)
    await tester.pump();

    // Pump again to allow FutureBuilder/async logic to complete and animations to settle
    await tester.pumpAndSettle();

    // Verify loading is done
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Verify Urgent Task is shown
    expect(find.text('Urgent Task'), findsOneWidget);
    // Verify Medium Task is shown
    expect(find.text('Medium Task'), findsOneWidget);

    // Verify Completed Task is NOT shown initially (collapsed)
    expect(find.text('Completed Task'), findsNothing);

    // Verify "Completed (1)" header is present
    expect(find.text('Completed (1)'), findsOneWidget);

    // Verify Header "2 active · 1 done"
    expect(find.text('2 active · 1 done'), findsOneWidget);
  });
}
