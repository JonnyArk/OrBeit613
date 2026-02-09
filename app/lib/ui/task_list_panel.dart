/// OrBeit UI - Task List Panel (Polished)
///
/// Sovereign Sanctum-styled task manager with:
/// - Priority-grouped sections (Urgent → Low)
/// - Swipe-to-complete and swipe-to-delete gestures
/// - Rich creation form (priority, due date, description)
/// - Overdue highlighting and count badges
/// - Completed tasks collapsed at the bottom

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  bool _showCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final repo = ref.read(taskRepositoryProvider);
    final tasks = await repo.getAllTasks();
    if (mounted) {
      setState(() {
        _tasks = tasks;
        _loading = false;
      });
    }
  }

  // ── Grouping Logic ────────────────────────────────────────

  List<domain.Task> get _activeTasks =>
      _tasks.where((t) => t.status != domain.TaskStatus.completed).toList();

  List<domain.Task> get _completedTasks =>
      _tasks.where((t) => t.status == domain.TaskStatus.completed).toList();

  Map<domain.TaskPriority, List<domain.Task>> get _groupedActive {
    final groups = <domain.TaskPriority, List<domain.Task>>{};
    for (final priority in [
      domain.TaskPriority.urgent,
      domain.TaskPriority.high,
      domain.TaskPriority.medium,
      domain.TaskPriority.low,
    ]) {
      final tasks = _activeTasks.where((t) => t.priority == priority).toList();
      if (tasks.isNotEmpty) {
        groups[priority] = tasks;
      }
    }
    return groups;
  }

  int get _overdueCount => _activeTasks
      .where((t) => t.dueDate != null && t.dueDate!.isBefore(DateTime.now()))
      .length;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A12).withAlpha(245),
        border: const Border(
          left: BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withAlpha(20),
            blurRadius: 20,
            offset: const Offset(-5, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          if (_overdueCount > 0) _buildOverdueBanner(),
          Expanded(child: _buildBody()),
          _buildAddButton(),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF1A1A2E), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.task_alt,
              color: Color(0xFFD4AF37),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '${_activeTasks.length} active · ${_completedTasks.length} done',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Active count badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF134E5E).withAlpha(60),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_activeTasks.length}',
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Overdue Banner ────────────────────────────────────────

  Widget _buildOverdueBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF9B1B30).withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF9B1B30).withAlpha(60)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFF9B1B30), size: 18),
          const SizedBox(width: 8),
          Text(
            '$_overdueCount overdue',
            style: const TextStyle(
              color: Color(0xFFE57373),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).shake(hz: 2, rotation: 0.01);
  }

  // ── Body ──────────────────────────────────────────────────

  Widget _buildBody() {
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
            Icon(Icons.inbox_outlined, size: 56, color: Colors.white.withAlpha(40)),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: TextStyle(
                color: Colors.white.withAlpha(80),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap below to create your first task',
              style: TextStyle(
                color: Colors.white.withAlpha(40),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    final grouped = _groupedActive;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // Priority groups
        for (final entry in grouped.entries) ...[
          _buildPriorityHeader(entry.key, entry.value.length),
          for (var i = 0; i < entry.value.length; i++)
            _SwipeableTaskTile(
              task: entry.value[i],
              onComplete: () => _completeTask(entry.value[i].id),
              onDelete: () => _deleteTask(entry.value[i].id),
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: Duration(milliseconds: i * 40))
                .slideX(begin: 0.05, end: 0, duration: 300.ms),
        ],

        // Completed section (collapsible)
        if (_completedTasks.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildCompletedHeader(),
          if (_showCompleted)
            for (final task in _completedTasks)
              _CompletedTaskTile(task: task),
        ],
      ],
    );
  }

  // ── Priority Section Header ───────────────────────────────

  Widget _buildPriorityHeader(domain.TaskPriority priority, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: _priorityColor(priority),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _priorityLabel(priority).toUpperCase(),
            style: TextStyle(
              color: _priorityColor(priority),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: _priorityColor(priority).withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: _priorityColor(priority),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Completed Section Header ──────────────────────────────

  Widget _buildCompletedHeader() {
    return GestureDetector(
      onTap: () => setState(() => _showCompleted = !_showCompleted),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withAlpha(10)),
        ),
        child: Row(
          children: [
            Icon(
              _showCompleted ? Icons.expand_less : Icons.expand_more,
              color: Colors.white38,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Completed (${_completedTasks.length})',
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.check_circle_outline,
              color: Colors.green.withAlpha(80),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // ── Add Button ────────────────────────────────────────────

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF1A1A2E), width: 1),
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: _showAddTaskSheet,
        icon: const Icon(Icons.add_circle_outline, size: 20),
        label: const Text(
          'New Task',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4AF37).withAlpha(20),
          foregroundColor: const Color(0xFFD4AF37),
          side: const BorderSide(color: Color(0xFFD4AF37), width: 1),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  // ── Actions ───────────────────────────────────────────────

  Future<void> _completeTask(int id) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.completeTask(id);
    _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.deleteTask(id);
    _loadTasks();
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddTaskSheet(
        onSave: (title, description, priority, dueDate) async {
          final repo = ref.read(taskRepositoryProvider);
          await repo.createTask(
            title: title,
            description: description,
            priority: priority,
            dueDate: dueDate,
          );
          Navigator.pop(ctx);
          _loadTasks();
        },
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────

  Color _priorityColor(domain.TaskPriority priority) {
    switch (priority) {
      case domain.TaskPriority.urgent:
        return const Color(0xFFE53935); // Red
      case domain.TaskPriority.high:
        return const Color(0xFFFF9800); // Orange
      case domain.TaskPriority.medium:
        return const Color(0xFFD4AF37); // Gold
      case domain.TaskPriority.low:
        return const Color(0xFF78909C); // Grey-blue
    }
  }

  String _priorityLabel(domain.TaskPriority priority) {
    switch (priority) {
      case domain.TaskPriority.urgent:
        return 'Urgent';
      case domain.TaskPriority.high:
        return 'High';
      case domain.TaskPriority.medium:
        return 'Medium';
      case domain.TaskPriority.low:
        return 'Low';
    }
  }
}

// ════════════════════════════════════════════════════════════
// SWIPEABLE TASK TILE
// ════════════════════════════════════════════════════════════

class _SwipeableTaskTile extends StatelessWidget {
  final domain.Task task;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  const _SwipeableTaskTile({
    required this.task,
    required this.onComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      // Swipe right → complete
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.green.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 22),
            const SizedBox(width: 8),
            Text(
              'Complete',
              style: TextStyle(color: Colors.green.withAlpha(200), fontSize: 13),
            ),
          ],
        ),
      ),
      // Swipe left → delete
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF9B1B30).withAlpha(30),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: TextStyle(
                color: const Color(0xFFE57373).withAlpha(200),
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.delete_outline, color: Color(0xFFE57373), size: 22),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onComplete();
          return false; // Don't dismiss — let reload handle it
        } else {
          return true; // Delete on swipe left
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        }
      },
      child: _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    final isOverdue = task.dueDate != null && task.dueDate!.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isOverdue
              ? const Color(0xFF9B1B30).withAlpha(50)
              : _priorityBorderColor.withAlpha(30),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Priority indicator dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _priorityDotColor,
              boxShadow: [
                BoxShadow(
                  color: _priorityDotColor.withAlpha(60),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (task.description != null && task.description!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    task.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withAlpha(60),
                      fontSize: 12,
                    ),
                  ),
                ],
                if (task.dueDate != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 12,
                        color: isOverdue ? const Color(0xFFE57373) : Colors.white.withAlpha(60),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDueDate(task.dueDate!),
                        style: TextStyle(
                          color: isOverdue ? const Color(0xFFE57373) : Colors.white.withAlpha(60),
                          fontSize: 11,
                          fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Tap to complete
          GestureDetector(
            onTap: onComplete,
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.radio_button_unchecked,
                color: Colors.white.withAlpha(40),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color get _priorityDotColor {
    switch (task.priority) {
      case domain.TaskPriority.urgent:
        return const Color(0xFFE53935);
      case domain.TaskPriority.high:
        return const Color(0xFFFF9800);
      case domain.TaskPriority.medium:
        return const Color(0xFFD4AF37);
      case domain.TaskPriority.low:
        return const Color(0xFF78909C);
    }
  }

  Color get _priorityBorderColor {
    switch (task.priority) {
      case domain.TaskPriority.urgent:
        return const Color(0xFFE53935);
      case domain.TaskPriority.high:
        return const Color(0xFFFF9800);
      case domain.TaskPriority.medium:
        return const Color(0xFFD4AF37);
      case domain.TaskPriority.low:
        return const Color(0xFF78909C);
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(date.year, date.month, date.day);

    if (dueDay == today) return 'Due today';
    if (dueDay == today.add(const Duration(days: 1))) return 'Due tomorrow';
    if (dueDay.isBefore(today)) {
      final diff = today.difference(dueDay).inDays;
      return '${diff}d overdue';
    }

    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }
}

// ════════════════════════════════════════════════════════════
// COMPLETED TASK TILE
// ════════════════════════════════════════════════════════════

class _CompletedTaskTile extends StatelessWidget {
  final domain.Task task;

  const _CompletedTaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green.withAlpha(60),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                color: Colors.white.withAlpha(40),
                fontSize: 13,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.white.withAlpha(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// ADD TASK SHEET
// ════════════════════════════════════════════════════════════

class _AddTaskSheet extends StatefulWidget {
  final Future<void> Function(
    String title,
    String? description,
    domain.TaskPriority priority,
    DateTime? dueDate,
  ) onSave;

  const _AddTaskSheet({required this.onSave});

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  domain.TaskPriority _priority = domain.TaskPriority.medium;
  DateTime? _dueDate;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A12),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24, 20, 24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'New Task',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),

              // Title input
              _buildLabel('TITLE', required: true),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                autofocus: true,
                decoration: _inputDecoration('What needs to be done?'),
              ),
              const SizedBox(height: 16),

              // Description input
              _buildLabel('DESCRIPTION'),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: 2,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: _inputDecoration('Add details... (optional)'),
              ),
              const SizedBox(height: 20),

              // Priority selector
              _buildLabel('PRIORITY'),
              const SizedBox(height: 8),
              _buildPrioritySelector(),
              const SizedBox(height: 20),

              // Due date picker
              _buildLabel('DUE DATE'),
              const SizedBox(height: 8),
              _buildDueDatePicker(),
              const SizedBox(height: 28),

              // Save / Cancel
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white54,
                        minimumSize: const Size(0, 48),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: const Color(0xFF0A0A12),
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF0A0A12),
                              ),
                            )
                          : const Text(
                              'Create Task',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(color: Color(0xFF9B1B30), fontSize: 11),
          ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withAlpha(40)),
      filled: true,
      fillColor: Colors.white.withAlpha(8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withAlpha(20)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withAlpha(20)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD4AF37)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: domain.TaskPriority.values.map((p) {
        final isSelected = _priority == p;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _priority = p),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? _colorForPriority(p).withAlpha(30)
                    : Colors.white.withAlpha(5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? _colorForPriority(p).withAlpha(120)
                      : Colors.white.withAlpha(15),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.flag,
                    size: 18,
                    color: isSelected
                        ? _colorForPriority(p)
                        : Colors.white.withAlpha(60),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _labelForPriority(p),
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? _colorForPriority(p)
                          : Colors.white.withAlpha(60),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDueDatePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withAlpha(20)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: Colors.white.withAlpha(100),
            ),
            const SizedBox(width: 10),
            Text(
              _dueDate != null ? _formatDate(_dueDate!) : 'No due date (optional)',
              style: TextStyle(
                color: _dueDate != null ? Colors.white : Colors.white.withAlpha(40),
                fontSize: 15,
              ),
            ),
            const Spacer(),
            if (_dueDate != null)
              GestureDetector(
                onTap: () => setState(() => _dueDate = null),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white.withAlpha(60),
                ),
              )
            else
              Icon(
                Icons.edit_outlined,
                size: 16,
                color: Colors.white.withAlpha(60),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFD4AF37),
              surface: Color(0xFF1A1A2E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _handleSave() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task title'),
          backgroundColor: Color(0xFF9B1B30),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    await widget.onSave(
      _titleController.text.trim(),
      _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      _priority,
      _dueDate,
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _colorForPriority(domain.TaskPriority p) {
    switch (p) {
      case domain.TaskPriority.urgent:
        return const Color(0xFFE53935);
      case domain.TaskPriority.high:
        return const Color(0xFFFF9800);
      case domain.TaskPriority.medium:
        return const Color(0xFFD4AF37);
      case domain.TaskPriority.low:
        return const Color(0xFF78909C);
    }
  }

  String _labelForPriority(domain.TaskPriority p) {
    switch (p) {
      case domain.TaskPriority.urgent:
        return 'Urgent';
      case domain.TaskPriority.high:
        return 'High';
      case domain.TaskPriority.medium:
        return 'Medium';
      case domain.TaskPriority.low:
        return 'Low';
    }
  }
}
