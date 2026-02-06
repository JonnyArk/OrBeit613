/// OrBeit UI - Task Card Widget
///
/// Displays a task with priority indicator, status, and due date.
/// Supports tap actions for completion and editing.

import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

/// Card widget for displaying a task
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = task.status == TaskStatus.completed;
    final isOverdue = task.dueDate != null && 
        task.dueDate!.isBefore(DateTime.now()) && 
        !isCompleted;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Completion checkbox
              _buildCheckbox(theme, isCompleted),
              const SizedBox(width: 12),
              
              // Task content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        decoration: isCompleted 
                            ? TextDecoration.lineThrough 
                            : null,
                        color: isCompleted 
                            ? theme.disabledColor 
                            : null,
                      ),
                    ),
                    if (task.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withAlpha(179),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 4),
                      _buildDueDateChip(theme, isOverdue),
                    ],
                  ],
                ),
              ),
              
              // Priority indicator
              _buildPriorityBadge(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(ThemeData theme, bool isCompleted) {
    return GestureDetector(
      onTap: onComplete,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isCompleted 
                ? theme.colorScheme.primary 
                : theme.dividerColor,
            width: 2,
          ),
          color: isCompleted 
              ? theme.colorScheme.primary 
              : Colors.transparent,
        ),
        child: isCompleted
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildDueDateChip(ThemeData theme, bool isOverdue) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.schedule,
          size: 14,
          color: isOverdue ? Colors.red : theme.hintColor,
        ),
        const SizedBox(width: 4),
        Text(
          _formatDate(task.dueDate!),
          style: theme.textTheme.labelSmall?.copyWith(
            color: isOverdue ? Colors.red : theme.hintColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityBadge(ThemeData theme) {
    Color color;
    String label;
    
    switch (task.priority) {
      case TaskPriority.low:
        color = Colors.grey;
        label = 'L';
        break;
      case TaskPriority.medium:
        color = Colors.blue;
        label = 'M';
        break;
      case TaskPriority.high:
        color = Colors.orange;
        label = 'H';
        break;
      case TaskPriority.urgent:
        color = Colors.red;
        label = '!';
        break;
    }
    
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color.withAlpha(51),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (dateOnly == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}
