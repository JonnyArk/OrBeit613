/// OrBeit UI - Task List Panel
///
/// Overlay panel showing tasks from the local database.
/// Can be opened from the game screen to view and manage tasks.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/task.dart' as domain;
import '../providers/task_provider.dart';

/// Task list panel widget
class TaskListPanel extends ConsumerStatefulWidget {
  const TaskListPanel({super.key});

  @override
  ConsumerState<TaskListPanel> createState() => _TaskListPanelState();
}

class _TaskListPanelState extends ConsumerState<TaskListPanel> {
  List<domain.Task> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final repo = ref.read(taskRepositoryProvider);
    final tasks = await repo.getAllTasks();
    setState(() {
      _tasks = tasks;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withValues(alpha: 0.95),
        border: const Border(
          left: BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildTaskList()),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF134E5E), width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.task_alt, color: Color(0xFFD4AF37)),
          const SizedBox(width: 12),
          const Text(
            'Tasks',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            '${_tasks.where((t) => t.status != domain.TaskStatus.completed).length}',
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
      );
    }

    if (_tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 48, color: Colors.white.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return _TaskTile(
          task: task,
          onComplete: () => _completeTask(task.id),
        );
      },
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF134E5E),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }

  Future<void> _completeTask(int id) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.completeTask(id);
    _loadTasks();
  }

  void _showAddTaskDialog() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('New Task', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter task title...',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF134E5E)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD4AF37)),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final repo = ref.read(taskRepositoryProvider);
                await repo.createTask(title: controller.text);
                Navigator.pop(ctx);
                _loadTasks();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final domain.Task task;
  final VoidCallback onComplete;

  const _TaskTile({required this.task, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == domain.TaskStatus.completed;
    
    return ListTile(
      leading: IconButton(
        icon: Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? Colors.green : const Color(0xFFD4AF37),
        ),
        onPressed: isCompleted ? null : onComplete,
      ),
      title: Text(
        task.title,
        style: TextStyle(
          color: isCompleted ? Colors.white38 : Colors.white,
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: task.dueDate != null
        ? Text(
            'Due: ${_formatDate(task.dueDate!)}',
            style: TextStyle(
              color: _isOverdue(task.dueDate!) ? Colors.red : Colors.white54,
              fontSize: 12,
            ),
          )
        : null,
      trailing: _priorityIcon(task.priority),
    );
  }

  Widget _priorityIcon(domain.TaskPriority priority) {
    Color color;
    switch (priority) {
      case domain.TaskPriority.urgent: color = Colors.red;
      case domain.TaskPriority.high: color = Colors.orange;
      case domain.TaskPriority.medium: color = const Color(0xFFD4AF37);
      case domain.TaskPriority.low: color = Colors.grey;
    }
    return Icon(Icons.flag, color: color, size: 16);
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  bool _isOverdue(DateTime date) {
    return date.isBefore(DateTime.now()) && task.status != domain.TaskStatus.completed;
  }
}
