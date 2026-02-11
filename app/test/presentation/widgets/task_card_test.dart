import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/presentation/widgets/task_card.dart';
import 'package:app/domain/entities/task.dart';

void main() {
  testWidgets('TaskCard displays task information', (WidgetTester tester) async {
    final task = Task(
      id: 1,
      title: 'Test Task',
      priority: TaskPriority.high,
      createdAt: DateTime.now(),
      status: TaskStatus.pending,
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TaskCard(task: task),
      ),
    ));

    expect(find.text('Test Task'), findsOneWidget);
    expect(find.text('H'), findsOneWidget);
  });

  testWidgets('TaskCard has accessible checkbox', (WidgetTester tester) async {
    final task = Task(
      id: 1,
      title: 'Accessible Task',
      priority: TaskPriority.medium,
      createdAt: DateTime.now(),
      status: TaskStatus.pending,
    );

    bool completed = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TaskCard(
          task: task,
          onComplete: () => completed = true,
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Verify Semantics (Exact match works here because it's a distinct node)
    expect(find.bySemanticsLabel('Mark as complete'), findsOneWidget);

    // Verify tap
    await tester.tap(find.bySemanticsLabel('Mark as complete'));
    expect(completed, isTrue);
  });

  testWidgets('TaskCard has accessible priority badge', (WidgetTester tester) async {
    final task = Task(
      id: 2,
      title: 'High Priority Task',
      priority: TaskPriority.urgent,
      createdAt: DateTime.now(),
      status: TaskStatus.pending,
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TaskCard(task: task),
      ),
    ));

    await tester.pumpAndSettle();

    // Verify visual presence
    expect(find.text('!'), findsOneWidget);

    // Verify semantics presence
    // It might be merged into the card label, or be a separate node.
    // We check if it exists or is part of a label.
    // Using RegExp to find substring if merged.
    expect(find.bySemanticsLabel(RegExp(r'Urgent Priority')), findsOneWidget);
  });
}
