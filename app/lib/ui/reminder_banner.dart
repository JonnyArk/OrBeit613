/// OrBeit Phase 3 — Reminder Banner Widget
///
/// A non-intrusive banner that slides in from the top when the
/// ReminderService emits a new reminder. Supports tap actions
/// to navigate to tasks or timeline.
///
/// Design: Dark glass with gold accent, auto-dismisses after 8s.

import 'dart:async';
import 'package:flutter/material.dart';
import '../services/reminder_service.dart';

/// Top-positioned banner that shows contextual reminders
class ReminderBanner extends StatefulWidget {
  final Stream<Reminder> reminderStream;
  final VoidCallback? onTapTasks;
  final VoidCallback? onTapTimeline;
  final void Function(String id)? onDismiss;

  const ReminderBanner({
    super.key,
    required this.reminderStream,
    this.onTapTasks,
    this.onTapTimeline,
    this.onDismiss,
  });

  @override
  State<ReminderBanner> createState() => _ReminderBannerState();
}

class _ReminderBannerState extends State<ReminderBanner>
    with SingleTickerProviderStateMixin {
  Reminder? _currentReminder;
  StreamSubscription<Reminder>? _subscription;
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _subscription = widget.reminderStream.listen(_onReminder);
  }

  void _onReminder(Reminder reminder) {
    setState(() => _currentReminder = reminder);
    _animController.forward(from: 0);

    // Auto-dismiss after 8 seconds
    _autoDismissTimer?.cancel();
    _autoDismissTimer = Timer(const Duration(seconds: 8), _dismiss);
  }

  void _dismiss() {
    _animController.reverse().then((_) {
      if (mounted) {
        final id = _currentReminder?.id;
        setState(() => _currentReminder = null);
        if (id != null) widget.onDismiss?.call(id);
      }
    });
  }

  void _onTap() {
    if (_currentReminder == null) return;

    switch (_currentReminder!.type) {
      case ReminderType.overdueTask:
        widget.onTapTasks?.call();
        break;
      case ReminderType.upcomingEvent:
        widget.onTapTimeline?.call();
        break;
      default:
        break;
    }
    _dismiss();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _animController.dispose();
    _autoDismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentReminder == null) return const SizedBox.shrink();

    return Positioned(
      top: 48,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTap: _onTap,
          onHorizontalDragEnd: (_) => _dismiss(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E).withAlpha(230),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFD4AF37).withAlpha(80),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  _iconForType(_currentReminder!.type),
                  color: const Color(0xFFD4AF37),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentReminder!.title,
                        style: const TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _currentReminder!.body,
                        style: const TextStyle(
                          color: Color(0xFF808080),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _dismiss,
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF808080),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForType(ReminderType type) {
    switch (type) {
      case ReminderType.overdueTask:
        return Icons.warning_amber;
      case ReminderType.upcomingEvent:
        return Icons.event;
      case ReminderType.neglectedBuilding:
        return Icons.home_work;
      case ReminderType.dailyReflection:
        return Icons.auto_awesome;
    }
  }
}
