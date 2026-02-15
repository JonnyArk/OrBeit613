import 'package:app/domain/entities/task.dart';
import 'package:app/domain/entities/task_repository.dart';
import 'package:app/providers/task_provider.dart';
import 'package:app/ui/task_list_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTaskRepository implements TaskRepository {
  @override
  Future<List<Task>> getAllTasks() async => [
    Task(
      id: 1,
      title: 'Task 1',
      priority: TaskPriority.high,
      createdAt: DateTime.now(),
    ),
    Task(
      id: 2,
      title: 'Task 2',
      priority: TaskPriority.medium,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<Task> completeTask(int id) async => throw UnimplementedError();

  @override
  Future<Task> createTask({required String title, String? description, TaskPriority priority = TaskPriority.medium, int? buildingId, DateTime? dueDate}) async => throw UnimplementedError();

  @override
  Future<bool> deleteTask(int id) async => throw UnimplementedError();

  @override
  Future<List<Task>> getOverdueTasks() async => [];

  @override
  Future<Task?> getTaskById(int id) async => throw UnimplementedError();

  @override
  Future<List<Task>> getTasksByStatus(TaskStatus status) async => throw UnimplementedError();

  @override
  Future<List<Task>> getTasksDueToday() async => [];

  @override
  Future<List<Task>> getTasksForBuilding(int buildingId) async => throw UnimplementedError();

  @override
  Future<Task> updateTask(Task task) async => throw UnimplementedError();
}

void main() {
  testWidgets('TaskListPanel shows tasks', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWithValue(MockTaskRepository()),
        ],
        child: const MaterialApp(
          home: Scaffold(body: TaskListPanel()),
        ),
      ),
    );

    // Initial loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    // Loaded state
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
    expect(find.text('HIGH'), findsOneWidget); // Priority header
    expect(find.text('MEDIUM'), findsOneWidget); // Priority header
  });
}
