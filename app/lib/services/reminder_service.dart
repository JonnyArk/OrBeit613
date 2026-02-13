/// OrBeit Phase 3 — Contextual Reminder Service
///
/// Periodically checks for:
///  - Overdue tasks
///  - Upcoming life events
///  - Buildings that haven't been "visited" in a while
///
/// Emits [Reminder] objects through a stream that the UI
/// can subscribe to (e.g., a top-banner or push notification).
///
/// Privacy: All logic is LOCAL. No data leaves the device.

import 'dart:async';
import 'package:flutter/foundation.dart';

/// A contextual reminder from the Or
class Reminder {
  final String id;
  final String title;
  final String body;
  final ReminderType type;
  final DateTime createdAt;
  bool dismissed;

  Reminder({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    DateTime? createdAt,
    this.dismissed = false,
  }) : createdAt = createdAt ?? DateTime.now();
}

/// Categories of reminders
enum ReminderType {
  overdueTask,
  upcomingEvent,
  neglectedBuilding,
  dailyReflection,
}

/// Service that can be started/stopped and emits reminders
class ReminderService {
  Timer? _timer;
  final _controller = StreamController<Reminder>.broadcast();

  /// Stream of reminders — subscribe in the UI layer
  Stream<Reminder> get reminders => _controller.stream;

  /// Start the periodic reminder check
  void start({Duration interval = const Duration(minutes: 15)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => _check());
    // Also run once immediately
    _check();
    debugPrint('[ReminderService] Started (interval: ${interval.inMinutes}m)');
  }

  /// Stop the periodic check
  void stop() {
    _timer?.cancel();
    _timer = null;
    debugPrint('[ReminderService] Stopped');
  }

  /// Dismiss a reminder by ID
  void dismiss(String id) {
    debugPrint('[ReminderService] Dismissed: $id');
    // In a full implementation this would mark it in the DB
  }

  /// The actual check logic — scans local DB for actionable items
  void _check() {
    // MVP: no-op — this will be wired to real DB queries in the next sprint
    // Future implementation will:
    //   1. Query TaskRepository for overdue tasks
    //   2. Query LifeEventRepository for upcoming events
    //   3. Check BuildingRepository for neglected buildings
    //   4. Emit appropriate Reminder objects
    debugPrint('[ReminderService] Check cycle (stub — no DB wired yet)');
  }

  /// Clean up
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
