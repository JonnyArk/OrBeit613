import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/ui/task_list_panel.dart';
import 'package:app/domain/entities/task.dart';
import 'package:app/providers/task_provider.dart';
import 'package:app/domain/entities/task_repository.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
  });

  testWidgets('TaskListPanel renders tasks correctly', (tester) async {
    // Arrange
    final tasks = [
      Task(
        id: 1,
        title: 'Task 1',
        description: 'Description 1',
        priority: TaskPriority.high,
        status: TaskStatus.pending,
        createdAt: DateTime.now(),
      ),
      Task(
        id: 2,
        title: 'Task 2',
        description: 'Description 2',
        priority: TaskPriority.medium,
        status: TaskStatus.completed,
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
      ),
    ];

    when(() => mockRepository.getAllTasks()).thenAnswer((_) async => tasks);

    // Act
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: TaskListPanel(),
          ),
        ),
      ),
    );

    // Wait for the async load
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Task 1'), findsOneWidget);

    // Check if "Completed (1)" is visible
    expect(find.textContaining('Completed (1)'), findsOneWidget);

    // Tap to expand completed
    await tester.tap(find.textContaining('Completed (1)'));
    await tester.pumpAndSettle();

    expect(find.text('Task 2'), findsOneWidget);
  });
}
