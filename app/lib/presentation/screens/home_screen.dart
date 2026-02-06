/// OrBeit UI - Home Screen
///
/// Main screen displaying buildings list and associated tasks.
/// Uses Riverpod for state management.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/building_provider.dart';
import '../../providers/task_provider.dart';
import '../widgets/building_list_tile.dart';
import '../widgets/task_card.dart';

/// Home screen with buildings list and task panel
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrBeit Sanctum'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Row(
        children: [
          // Buildings sidebar
          SizedBox(
            width: 320,
            child: _BuildingsPanel(),
          ),
          
          // Divider
          const VerticalDivider(width: 1),
          
          // Tasks main area
          Expanded(
            child: _TasksPanel(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final selectedBuildingId = ref.read(selectedBuildingIdProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Task title',
                hintText: 'What needs to be done?',
              ),
            ),
            if (selectedBuildingId != null) ...[
              const SizedBox(height: 8),
              Text(
                'Will be linked to selected building',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                final repo = ref.read(taskRepositoryProvider);
                await repo.createTask(
                  title: titleController.text,
                  buildingId: selectedBuildingId,
                );
                // Refresh the task lists
                ref.invalidate(allTasksProvider);
                ref.invalidate(tasksForSelectedBuildingProvider);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _BuildingsPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildingsAsync = ref.watch(buildingsProvider);
    final selectedId = ref.watch(selectedBuildingIdProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Buildings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: buildingsAsync.when(
            data: (buildings) {
              if (buildings.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_city, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No buildings yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Place buildings in the game view',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return ListView.builder(
                itemCount: buildings.length,
                itemBuilder: (context, index) {
                  final building = buildings[index];
                  return BuildingListTile(
                    building: building,
                    isSelected: building.id == selectedId,
                    onTap: () {
                      ref.read(selectedBuildingIdProvider.notifier).state = 
                          building.id == selectedId ? null : building.id;
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text('Error: $err'),
            ),
          ),
        ),
      ],
    );
  }
}

class _TasksPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedBuildingIdProvider);
    final selectedBuilding = ref.watch(selectedBuildingProvider);
    
    // Show tasks for selected building, or all tasks if none selected
    final tasksAsync = selectedId != null
        ? ref.watch(tasksForSelectedBuildingProvider)
        : ref.watch(allTasksProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                selectedId != null ? 'Building Tasks' : 'All Tasks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (selectedId != null) ...[
                const SizedBox(width: 8),
                selectedBuilding.when(
                  data: (b) => b != null 
                      ? Chip(label: Text(b.type))
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ref.read(selectedBuildingIdProvider.notifier).state = null;
                  },
                  child: const Text('Show All'),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: tasksAsync.when(
            data: (tasks) {
              if (tasks.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_outline, 
                            size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          selectedId != null 
                              ? 'No tasks for this building' 
                              : 'No tasks yet',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap + to create a task',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    task: task,
                    onComplete: () async {
                      final repo = ref.read(taskRepositoryProvider);
                      await repo.completeTask(task.id);
                      ref.invalidate(allTasksProvider);
                      ref.invalidate(tasksForSelectedBuildingProvider);
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text('Error: $err'),
            ),
          ),
        ),
      ],
    );
  }
}
